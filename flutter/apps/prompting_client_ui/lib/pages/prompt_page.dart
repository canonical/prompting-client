import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/app/prompt_model.dart';
import 'package:prompting_client_ui/pages/camera/camera_prompt_page.dart';
import 'package:prompting_client_ui/pages/home/home_standard_page.dart';
import 'package:prompting_client_ui/pages/microphone/microphone_prompt_page.dart';
import 'package:prompting_client_ui/theme.dart';
import 'package:ubuntu_logger/ubuntu_logger.dart';
import 'package:window_manager/window_manager.dart';

final _log = Logger('prompt_page');

class PromptPage extends ConsumerStatefulWidget {
  const PromptPage({super.key});

  @override
  ConsumerState<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends ConsumerState<PromptPage> {
  double? _appliedHeight;

  /// Settles in a single step because the content is measured at a fixed width
  /// under unbounded height, so its height cannot depend on the window size we
  /// derive from it.
  Future<void> _fitWindowTo(double contentHeight) async {
    final height = contentHeight.roundToDouble();
    if (height <= 0 || height == _appliedHeight) return;
    final isFirstFit = _appliedHeight == null;
    _appliedHeight = height;

    _log.debug('Sizing window to ($kWindowWidth, $height)');
    await windowManager.setSize(Size(kWindowWidth, height));

    if (isFirstFit) {
      // The window is off screen until now -- see hide_on_first_map() in
      // linux/my_application.cc -- so the resize above lands before it is ever
      // mapped and the first thing on screen is already the right size. We
      // cannot wait for a frame in between, because an unmapped window is never
      // sent one.
      await windowManager.show();
      await windowManager.focus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prompt = ref.watch(currentPromptProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: _MeasureHeight(
          width: kWindowWidth,
          onHeightChanged: _fitWindowTo,
          child: Padding(
            padding: const EdgeInsets.all(kPagePadding),
            child: switch (prompt) {
              PromptDetailsHome() => const HomeStandardPage(),
              PromptDetailsCamera() => const CameraPromptPage(),
              PromptDetailsMicrophone() => const MicrophonePromptPage(),
            },
          ),
        ),
      ),
    );
  }
}

/// Lays [child] out at [width] and reports the height it takes.
///
/// A render object rather than a [SizeChangedLayoutNotifier] so that measuring
/// costs no extra layout pass and never rebuilds the subtree being measured.
///
/// [width] is imposed rather than inherited because the window is off screen
/// until the first height is reported, and GTK allocates an unmapped window's
/// contents 1px wide. Inheriting that would wrap every line and measure a
/// height in the thousands.
class _MeasureHeight extends SingleChildRenderObjectWidget {
  const _MeasureHeight({
    required this.width,
    required this.onHeightChanged,
    required Widget super.child,
  });

  /// The width the child is laid out at, whatever width this widget is offered.
  final double width;

  /// Called after every layout that changes the child's height.
  final ValueChanged<double> onHeightChanged;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureHeight(width: width, onHeightChanged: onHeightChanged);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMeasureHeight renderObject,
  ) {
    renderObject
      ..width = width
      ..onHeightChanged = onHeightChanged;
  }
}

class _RenderMeasureHeight extends RenderProxyBox {
  _RenderMeasureHeight({
    required double width,
    required this.onHeightChanged,
  }) : _width = width;

  ValueChanged<double> onHeightChanged;

  double get width => _width;
  double _width;
  set width(double value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  double? _reported;

  @override
  void performLayout() {
    child!.layout(
      BoxConstraints.tightFor(width: width),
      parentUsesSize: true,
    );
    size = constraints.constrain(child!.size);

    final height = child!.size.height;
    if (height == _reported) return;
    _reported = height;

    // Resizing the window from inside layout would re-enter it, so hand the
    // height over once the frame is done.
    SchedulerBinding.instance
        .addPostFrameCallback((_) => onHeightChanged(height));
  }
}
