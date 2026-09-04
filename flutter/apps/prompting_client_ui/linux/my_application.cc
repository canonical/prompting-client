#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <unistd.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// Signal the Shell about a permission prompting is in progress.
void signal_prompting_to_gnome_shell(char *snap_name, guint64 app_pid) {
  // If snap_name or app_pid is not set, we cannot signal the GNOME Shell.
  if (snap_name == NULL || app_pid == 0) {
    g_warning("Failed to extract snap name or app PID from the arguments to signal it to GNOME Shell");
    return;
  }

  g_autoptr(GDBusConnection) bus = NULL;
  g_autoptr(GError) error = NULL;
  bus = g_bus_get_sync(G_BUS_TYPE_SESSION, NULL, &error);
  if (!bus) {
    g_warning("Failed to contact to the session bus: %s", error->message);
    return;
  }

  if (!g_dbus_connection_call_sync (bus,
                                    "com.canonical.Shell.PermissionPrompting",
                                    "/com/canonical/Shell/PermissionPrompting",
                                    "com.canonical.Shell.PermissionPrompting",
                                    "Prompt",
                                    g_variant_new ("(st)", snap_name, app_pid),
                                    NULL,
                                    G_DBUS_CALL_FLAGS_NONE,
                                    -1,
                                    NULL,
                                    &error)) {
      g_warning("Failed to signal GNOME Shell about in progress prompting: %s",
                error->message);
  }
}

// handy_window shows the window from inside fl_register_plugins(), and refuses
// to set itself up at all if the window was already visible before that call,
// so we cannot simply postpone showing it ourselves. It also shows the FlView
// last, and showing the view is what boots the Flutter engine -- meaning the
// window would otherwise sit on screen at the bootstrap size for the whole of
// engine startup and then visibly jump once Dart has measured the prompt.
//
// PromptPage shows the window again once it has resized it to fit its content.
static void hide_on_first_map(GtkWidget* window, gpointer user_data) {
  g_signal_handlers_disconnect_by_func(window, (gpointer)hide_on_first_map,
                                       user_data);
  gtk_widget_hide(window);
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Must be connected before the first map, which fl_register_plugins() below
  // triggers by way of handy_window.
  g_signal_connect(window, "map", G_CALLBACK(hide_on_first_map), nullptr);

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "Security notification");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "Security notification");
  }

  // Retrieve parsed arguments
  char *snap_name = (char*)g_object_get_data(G_OBJECT(application), "snap_name");
  guint64 app_pid = GPOINTER_TO_UINT(g_object_get_data(G_OBJECT(application), "app_pid"));

  // Bootstrap size only. The Dart side measures the prompt content and resizes
  // the window to fit it before revealing the window, so this is never seen on
  // screen -- it only has to give the first frame a sane width to lay out
  // against. Keep the width in sync with kWindowWidth in lib/theme.dart.
  gtk_window_set_default_size(window, 382, 230);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  const char *session = g_getenv ("XDG_CURRENT_DESKTOP");
  if (session && strstr (session, "GNOME"))
      signal_prompting_to_gnome_shell(snap_name, app_pid);

  gtk_widget_show(GTK_WIDGET(view));

  // Boots the Flutter engine. handy_window would have done this by showing the
  // view while the window was still mapped; doing it by hand keeps the startup
  // cost off screen.
  gtk_widget_realize(GTK_WIDGET(view));

  gtk_window_set_skip_taskbar_hint(window, TRUE);
  gtk_window_set_skip_pager_hint(window, TRUE);
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);

  // Make a copy of arguments for GOption parsing (which mutates the array)
  g_auto(GStrv) args_copy = g_strdupv(*arguments);

  // Parse command line arguments
  g_autofree char *snap_name = NULL;
  guint64 app_pid = 0;

  // --interface-name is parsed on the Dart side only; unknown options are
  // ignored here and the full argv is forwarded below either way.
  static const GOptionEntry entries[] = {
    { "snap", 0, 0, G_OPTION_ARG_STRING, &snap_name, "Snap name", NULL },
    { "app-pid", 0, 0, G_OPTION_ARG_INT64, &app_pid, "Application PID", NULL },
    { NULL }
  };

  g_autoptr(GOptionContext) context = g_option_context_new(NULL);
  g_option_context_add_main_entries(context, entries, NULL);
  g_option_context_set_ignore_unknown_options(context, TRUE);

  // Parse the copied arguments (this will mutate args_copy)
  if (!g_option_context_parse_strv(context, &args_copy, NULL)) {
    g_warning("Failed to parse arguments");
    *exit_status = 1;
    return TRUE;
  }

  // Pass the original arguments to Flutter (strip out the first argument as it is the binary name)
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  // Store parsed values for activate callback
  g_object_set_data_full(G_OBJECT(application), "snap_name", g_steal_pointer(&snap_name), g_free);
  g_object_set_data(G_OBJECT(application), "app_pid", GUINT_TO_POINTER(app_pid));

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
     g_warning("Failed to register: %s", error->message);
     *exit_status = 1;
     return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::startup.
static void my_application_startup(GApplication* application) {
  //MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  //MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     "flags", G_APPLICATION_NON_UNIQUE,
                                     nullptr));
}
