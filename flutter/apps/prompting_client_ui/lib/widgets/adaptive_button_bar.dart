import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A row of equal-width children that becomes a column of full-width children
/// when an equal share would squeeze any child below its natural width.
///
/// Exists because the children have to be stretched to the width they are
/// allotted, and neither stock widget does that: [Wrap] moves children onto a
/// new line once they stop fitting but lays each one out at its natural width,
/// and [OverflowBar] switches between a row and a column on the same condition
/// as this widget but loosens the constraints it passes down.
///
/// The decision reads each child's own [RenderBox.getMaxIntrinsicWidth] so that
/// this widget needs to know nothing about what its children contain.
class AdaptiveButtonBar extends MultiChildRenderObjectWidget {
  const AdaptiveButtonBar({
    super.key,
    this.spacing = 0.0,
    super.children,
  });

  /// The gap between adjacent children: horizontal in a row, vertical in a
  /// column.
  final double spacing;

  @override
  RenderAdaptiveButtonBar createRenderObject(BuildContext context) {
    return RenderAdaptiveButtonBar(
      spacing: spacing,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderAdaptiveButtonBar renderObject,
  ) {
    renderObject
      ..spacing = spacing
      ..textDirection = Directionality.of(context);
  }
}

class _AdaptiveButtonBarParentData extends ContainerBoxParentData<RenderBox> {}

class RenderAdaptiveButtonBar extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _AdaptiveButtonBarParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            _AdaptiveButtonBarParentData> {
  RenderAdaptiveButtonBar({
    required double spacing,
    required TextDirection textDirection,
  })  : _spacing = spacing,
        _textDirection = textDirection;

  double get spacing => _spacing;
  double _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  /// Screen reader and tab order are derived from the rects we hand out rather
  /// than from child order, so getting this wrong silently puts the last child
  /// first in a right-to-left locale.
  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _AdaptiveButtonBarParentData) {
      child.parentData = _AdaptiveButtonBarParentData();
    }
  }

  double get _totalSpacing => spacing * (childCount - 1);

  double? _rowShare(double maxWidth) {
    final share = (maxWidth - _totalSpacing) / childCount;
    if (share <= 0) return null;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      if (child.getMaxIntrinsicWidth(double.infinity) > share) return null;
    }
    return share;
  }

  BoxConstraints _childConstraints(BoxConstraints constraints, double? width) {
    return width == null
        ? BoxConstraints(maxHeight: constraints.maxHeight)
        : BoxConstraints(
            minWidth: width,
            maxWidth: width,
            maxHeight: constraints.maxHeight,
          );
  }

  Size _layout(
    BoxConstraints constraints,
    ChildLayouter layoutChild, {
    required bool assignOffsets,
  }) {
    if (childCount == 0) return constraints.smallest;

    if (!constraints.maxWidth.isFinite) {
      // Nothing a column could gain when there is no width to divide up.
      return _layoutRow(
        constraints,
        layoutChild,
        null,
        assignOffsets: assignOffsets,
      );
    }

    // Recomputed on every pass on purpose: caching the row/column decision in a
    // field would survive a text-scale change, which invalidates the children's
    // intrinsics without invalidating this object's layout.
    final share = _rowShare(constraints.maxWidth);
    return share != null
        ? _layoutRow(
            constraints,
            layoutChild,
            share,
            assignOffsets: assignOffsets,
          )
        : _layoutColumn(
            constraints,
            layoutChild,
            assignOffsets: assignOffsets,
          );
  }

  Size _layoutRow(
    BoxConstraints constraints,
    ChildLayouter layoutChild,
    double? share, {
    required bool assignOffsets,
  }) {
    final childConstraints = _childConstraints(constraints, share);
    var naturalWidth = _totalSpacing;
    var height = 0.0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      final childSize = layoutChild(child, childConstraints);
      naturalWidth += childSize.width;
      height = math.max(height, childSize.height);
    }
    // Prefer the constraint over the accumulated sum so rounding never leaves a
    // sliver of width unclaimed.
    final width = share == null ? naturalWidth : constraints.maxWidth;

    if (assignOffsets) {
      final rtl = textDirection == TextDirection.rtl;
      var x = rtl ? width : 0.0;
      for (var child = firstChild; child != null; child = childAfter(child)) {
        if (rtl) x -= child.size.width;
        // Centring keeps children of unequal height within one horizontal band,
        // which is what the semantics and focus sorts need in order to read the
        // row leading-to-trailing rather than top-to-bottom.
        (child.parentData! as BoxParentData).offset =
            Offset(x, (height - child.size.height) / 2);
        x += rtl ? -spacing : child.size.width + spacing;
      }
    }
    return constraints.constrain(Size(width, height));
  }

  Size _layoutColumn(
    BoxConstraints constraints,
    ChildLayouter layoutChild, {
    required bool assignOffsets,
  }) {
    final width = constraints.maxWidth;
    final childConstraints = _childConstraints(constraints, width);
    var y = 0.0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      final childSize = layoutChild(child, childConstraints);
      if (assignOffsets) {
        (child.parentData! as BoxParentData).offset = Offset(0, y);
      }
      y += childSize.height + spacing;
    }
    return constraints.constrain(Size(width, y - spacing));
  }

  @override
  void performLayout() {
    size = _layout(
      constraints,
      ChildLayoutHelper.layoutChild,
      assignOffsets: true,
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _layout(
      constraints,
      ChildLayoutHelper.dryLayoutChild,
      assignOffsets: false,
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    // The column fallback means we are never narrower than our widest child.
    var width = 0.0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      width = math.max(width, child.getMinIntrinsicWidth(height));
    }
    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (childCount == 0) return 0.0;
    // The widest we can usefully be is a row of children at natural width.
    var width = _totalSpacing;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      width += child.getMaxIntrinsicWidth(height);
    }
    return width;
  }

  double _intrinsicHeight(double width, {required bool min}) {
    if (childCount == 0) return 0.0;
    final share = width.isFinite ? _rowShare(width) : null;
    final childWidth = share ?? width;
    var height = share != null ? 0.0 : _totalSpacing;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      final childHeight = min
          ? child.getMinIntrinsicHeight(childWidth)
          : child.getMaxIntrinsicHeight(childWidth);
      height =
          share != null ? math.max(height, childHeight) : height + childHeight;
    }
    return height;
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      _intrinsicHeight(width, min: true);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _intrinsicHeight(width, min: false);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
