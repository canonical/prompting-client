import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompting_client_ui/widgets/adaptive_button_bar.dart';

const _spacing = 16.0;
const _childWidth = 100.0;
const _childHeight = 20.0;

/// Children of a known intrinsic width, so that the row/column decision under
/// test does not depend on font metrics.
Widget _child(String key) => SizedBox(
      key: ValueKey(key),
      width: _childWidth,
      height: _childHeight,
    );

Future<void> _pump(
  WidgetTester tester, {
  double? barWidth,
  TextDirection textDirection = TextDirection.ltr,
}) {
  const bar = AdaptiveButtonBar(
    spacing: _spacing,
    children: [_ChildStub('first'), _ChildStub('second')],
  );
  return tester.pumpWidget(
    Directionality(
      textDirection: textDirection,
      child: Center(
        child: barWidth == null
            ? const UnconstrainedBox(child: bar)
            : SizedBox(width: barWidth, child: bar),
      ),
    ),
  );
}

class _ChildStub extends StatelessWidget {
  const _ChildStub(this.name);

  final String name;

  @override
  Widget build(BuildContext context) => _child(name);
}

Rect _rectOf(WidgetTester tester, String key) =>
    tester.getRect(find.byKey(ValueKey(key)));

void main() {
  testWidgets('splits the width evenly when both children fit', (tester) async {
    // Each child's share is exactly its natural width.
    const barWidth = _childWidth * 2 + _spacing;
    await _pump(tester, barWidth: barWidth);

    final first = _rectOf(tester, 'first');
    final second = _rectOf(tester, 'second');

    expect(first.top, second.top);
    expect(first.width, _childWidth);
    expect(second.width, _childWidth);
    expect(second.left, first.right + _spacing);
    expect(
      tester.getSize(find.byType(AdaptiveButtonBar)),
      const Size(barWidth, _childHeight),
    );
  });

  testWidgets('stacks at full width when a share would squeeze a child',
      (tester) async {
    // One pixel short of a row: the share drops below the natural width.
    const barWidth = _childWidth * 2 + _spacing - 1;
    await _pump(tester, barWidth: barWidth);

    final first = _rectOf(tester, 'first');
    final second = _rectOf(tester, 'second');

    expect(first.width, barWidth);
    expect(second.width, barWidth);
    expect(second.top, first.bottom + _spacing);
    expect(
      tester.getSize(find.byType(AdaptiveButtonBar)),
      const Size(barWidth, _childHeight * 2 + _spacing),
    );
  });

  testWidgets('lays the first child out on the right in a RTL locale',
      (tester) async {
    const barWidth = _childWidth * 2 + _spacing;
    await _pump(
      tester,
      barWidth: barWidth,
      textDirection: TextDirection.rtl,
    );

    final first = _rectOf(tester, 'first');
    final second = _rectOf(tester, 'second');

    expect(first.left, greaterThan(second.left));
    expect(first.left, second.right + _spacing);
  });

  testWidgets('keeps children at their natural width when unbounded',
      (tester) async {
    await _pump(tester);

    expect(_rectOf(tester, 'first').width, _childWidth);
    expect(_rectOf(tester, 'second').width, _childWidth);
    expect(
      tester.getSize(find.byType(AdaptiveButtonBar)).width,
      _childWidth * 2 + _spacing,
    );
  });

  testWidgets('dry layout agrees with the size laid out', (tester) async {
    for (final barWidth in [
      _childWidth * 2 + _spacing, // row
      _childWidth * 2 + _spacing - 1, // column
    ]) {
      await _pump(tester, barWidth: barWidth);
      final bar = tester.renderObject<RenderBox>(
        find.byType(AdaptiveButtonBar),
      );

      expect(
        bar.getDryLayout(BoxConstraints.tightFor(width: barWidth)),
        bar.size,
        reason: 'dry layout differs from real layout at $barWidth',
      );
    }
  });

  testWidgets('reports intrinsics that match how it lays out', (tester) async {
    await _pump(tester);
    final bar = tester.renderObject<RenderBox>(
      find.byType(AdaptiveButtonBar),
    );

    // Widest useful size is a row of children at their natural width.
    expect(
      bar.getMaxIntrinsicWidth(double.infinity),
      _childWidth * 2 + _spacing,
    );
    // The column fallback means it is never narrower than its widest child.
    expect(bar.getMinIntrinsicWidth(double.infinity), _childWidth);
    // A row is as tall as its tallest child, a column the sum plus the gap.
    expect(
      bar.getMaxIntrinsicHeight(_childWidth * 2 + _spacing),
      _childHeight,
    );
    expect(
      bar.getMaxIntrinsicHeight(_childWidth * 2 + _spacing - 1),
      _childHeight * 2 + _spacing,
    );
  });
}
