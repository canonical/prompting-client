#include "my_application.h"

#include <gdk/gdk.h>
#include <glib.h>
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
void signal_prompting_to_gnome_shell(char *snap_name, guint64 app_id) {
  // Ensure we are running in the ubuntu session which should have our extension.
  if (!g_str_equal(g_environ_getenv(g_get_environ(), "GNOME_SHELL_SESSION_MODE"), "ubuntu")) {
    return;
  }

  // If snap_name or app_id is not set, we cannot signal the GNOME Shell.
  if (snap_name == NULL || app_id == 0) {
    g_warning("Failed to extract snap name or app ID from the arguments to signal it to GNOME Shell");
    return;
  }

  g_autoptr(GDBusConnection) bus = NULL;
  g_autoptr(GError) error = NULL;
  bus = g_bus_get_sync(G_BUS_TYPE_SESSION, NULL, &error);
  if (!bus) {
    g_warning("Failed to contact to the session bus: %s", error->message);
    return;
  }

  g_dbus_connection_call_sync (bus,
    "com.canonical.Shell.PermissionPrompting",
    "/com/canonical/Shell/PermissionPrompting",
    "com.canonical.Shell.PermissionPrompting",
    "Prompt",
    g_variant_new ("(st)", snap_name, app_id),
    NULL,
    G_DBUS_CALL_FLAGS_NONE,
    -1,
    NULL,
    &error);
  
    if (error != NULL) {
      g_warning("Failed to signal GNOME Shell about in progress prompting: %s", error->message);
      return;
    }
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

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

  gtk_window_set_default_size(window, 560, 200);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  // Extract the first two arguments that don't have leading dashes from dart_entrypoint_arguments.
  char *snap_name = NULL;
  guint64 app_id = 0;
  for (uint i = 0; self->dart_entrypoint_arguments[i] != NULL; i++) {
    char *arg = self->dart_entrypoint_arguments[i];
    if (g_str_has_prefix(arg, "-")) {
      continue;
    }

    if (snap_name == NULL) {
      snap_name = arg;
      continue;
    }

    app_id = g_ascii_strtoull(arg, NULL, 10);
    if (errno != 0 || app_id == 0) {
      app_id = 0;
      g_warning("failed to get PID from the application prompted for: %s is not a valid uint64", arg);
    }

    break;
  }
  
  signal_prompting_to_gnome_shell(snap_name, app_id);

  gtk_widget_show(GTK_WIDGET(window));
  gtk_widget_show(GTK_WIDGET(view));

  GdkWindow* gdk_window = gtk_widget_get_window(GTK_WIDGET(window));
  if (gdk_window == NULL) {
    g_warning("Failed to get gdk_window for setting skip flags.");
  } else {
    gdk_window_set_skip_taskbar_hint(gdk_window, TRUE);
    gdk_window_set_skip_pager_hint(gdk_window, TRUE);
  }

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

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
