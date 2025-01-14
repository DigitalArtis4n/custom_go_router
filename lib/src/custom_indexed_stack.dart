// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

export 'package:flutter/animation.dart';
export 'package:flutter/foundation.dart' show ChangeNotifier, FlutterErrorDetails, Listenable, TargetPlatform, ValueNotifier;
export 'package:flutter/painting.dart';
export 'package:flutter/rendering.dart'
    show
        AlignmentGeometryTween,
        AlignmentTween,
        Axis,
        BoxConstraints,
        BoxConstraintsTransform,
        CrossAxisAlignment,
        CustomClipper,
        CustomPainter,
        CustomPainterSemantics,
        DecorationPosition,
        FlexFit,
        FlowDelegate,
        FlowPaintingContext,
        FractionalOffsetTween,
        HitTestBehavior,
        LayerLink,
        MainAxisAlignment,
        MainAxisSize,
        MouseCursor,
        MultiChildLayoutDelegate,
        PaintingContext,
        PointerCancelEvent,
        PointerCancelEventListener,
        PointerDownEvent,
        PointerDownEventListener,
        PointerEvent,
        PointerMoveEvent,
        PointerMoveEventListener,
        PointerUpEvent,
        PointerUpEventListener,
        RelativeRect,
        SemanticsBuilderCallback,
        ShaderCallback,
        ShapeBorderClipper,
        SingleChildLayoutDelegate,
        StackFit,
        SystemMouseCursors,
        TextOverflow,
        ValueChanged,
        ValueGetter,
        WrapAlignment,
        WrapCrossAlignment;
export 'package:flutter/services.dart' show AssetBundle;

/// A widget that positions its children relative to the edges of its box.
///
/// This class is useful if you want to overlap several children in a simple
/// way, for example having some text and an image, overlaid with a gradient and
/// a button attached to the bottom.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=liEGSeD3Zt8}
///
/// Each child of a [Stack] widget is either _positioned_ or _non-positioned_.
/// Positioned children are those wrapped in a [Positioned] widget that has at
/// least one non-null property. The stack sizes itself to contain all the
/// non-positioned children, which are positioned according to [alignment]
/// (which defaults to the top-left corner in left-to-right environments and the
/// top-right corner in right-to-left environments). The positioned children are
/// then placed relative to the stack according to their top, right, bottom, and
/// left properties.
///
/// The stack paints its children in order with the first child being at the
/// bottom. If you want to change the order in which the children paint, you
/// can rebuild the stack with the children in the new order. If you reorder
/// the children in this way, consider giving the children non-null keys.
/// These keys will cause the framework to move the underlying objects for
/// the children to their new locations rather than recreate them at their
/// new location.
///
/// For more details about the stack layout algorithm, see [RenderStack].
///
/// If you want to lay a number of children out in a particular pattern, or if
/// you want to make a custom layout manager, you probably want to use
/// [CustomMultiChildLayout] instead. In particular, when using a [Stack] you
/// can't position children relative to their size or the stack's own size.
///
/// {@tool snippet}
///
/// Using a [Stack] you can position widgets over one another.
///
/// ![The sample creates a blue box that overlaps a larger green box, which itself overlaps an even larger red box.](https://flutter.github.io/assets-for-api-docs/assets/widgets/stack.png)
///
/// ```dart
/// Stack(
///   children: <Widget>[
///     Container(
///       width: 100,
///       height: 100,
///       color: Colors.red,
///     ),
///     Container(
///       width: 90,
///       height: 90,
///       color: Colors.green,
///     ),
///     Container(
///       width: 80,
///       height: 80,
///       color: Colors.blue,
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// This example shows how [Stack] can be used to enhance text visibility
/// by adding gradient backdrops.
///
/// ![The gradient fades from transparent to dark grey at the bottom, with white text on top of the darker portion.](https://flutter.github.io/assets-for-api-docs/assets/widgets/stack_with_gradient.png)
///
/// ```dart
/// SizedBox(
///   width: 250,
///   height: 250,
///   child: Stack(
///     children: <Widget>[
///       Container(
///         width: 250,
///         height: 250,
///         color: Colors.white,
///       ),
///       Container(
///         padding: const EdgeInsets.all(5.0),
///         alignment: Alignment.bottomCenter,
///         decoration: BoxDecoration(
///           gradient: LinearGradient(
///             begin: Alignment.topCenter,
///             end: Alignment.bottomCenter,
///             colors: <Color>[
///               Colors.black.withAlpha(0),
///               Colors.black12,
///               Colors.black45
///             ],
///           ),
///         ),
///         child: const Text(
///           'Foreground Text',
///           style: TextStyle(color: Colors.white, fontSize: 20.0),
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Align], which sizes itself based on its child's size and positions
///    the child according to an [Alignment] value.
///  * [CustomSingleChildLayout], which uses a delegate to control the layout of
///    a single child.
///  * [CustomMultiChildLayout], which uses a delegate to position multiple
///    children.
///  * [Flow], which provides paint-time control of its children using transform
///    matrices.
///  * The [catalog of layout widgets](https://flutter.dev/widgets/layout/).
class Stack extends MultiChildRenderObjectWidget {
  /// Creates a stack layout widget.
  ///
  /// By default, the non-positioned children of the stack are aligned by their
  /// top left corners.
  const Stack({
    super.key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    super.children,
  });

  /// How to align the non-positioned and partially-positioned children in the
  /// stack.
  ///
  /// The non-positioned children are placed relative to each other such that
  /// the points determined by [alignment] are co-located. For example, if the
  /// [alignment] is [Alignment.topLeft], then the top left corner of
  /// each non-positioned child will be located at the same global coordinate.
  ///
  /// Partially-positioned children, those that do not specify an alignment in a
  /// particular axis (e.g. that have neither `top` nor `bottom` set), use the
  /// alignment to determine how they should be positioned in that
  /// under-specified axis.
  ///
  /// Defaults to [AlignmentDirectional.topStart].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// The text direction with which to resolve [alignment].
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection? textDirection;

  /// How to size the non-positioned children in the stack.
  ///
  /// The constraints passed into the [Stack] from its parent are either
  /// loosened ([StackFit.loose]) or tightened to their biggest size
  /// ([StackFit.expand]).
  final StackFit fit;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Stacks only clip children whose _geometry_ overflows the stack. A child
  /// that paints outside its bounds (e.g. a box with a shadow) will not be
  /// clipped, regardless of the value of this property. Similarly, a child that
  /// itself has a descendant that overflows the stack will not be clipped, as
  /// only the geometry of the stack's direct children are considered.
  /// [Transform] is an example of a widget that can cause its children to paint
  /// outside its geometry.
  ///
  /// To clip children whose geometry does not overflow the stack, consider
  /// using a [ClipRect] widget.
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  bool _debugCheckHasDirectionality(BuildContext context) {
    if (alignment is AlignmentDirectional && textDirection == null) {
      assert(debugCheckHasDirectionality(
        context,
        why: "to resolve the 'alignment' argument",
        hint: alignment == AlignmentDirectional.topStart
            ? "The default value for 'alignment' is AlignmentDirectional.topStart, which requires a text direction."
            : null,
        alternative:
            "Instead of providing a Directionality widget, another solution would be passing a non-directional 'alignment', or an explicit 'textDirection', to the $runtimeType.",
      ));
    }
    return true;
  }

  @override
  RenderStack createRenderObject(BuildContext context) {
    assert(_debugCheckHasDirectionality(context));
    return RenderStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      fit: fit,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderStack renderObject) {
    assert(_debugCheckHasDirectionality(context));
    renderObject
      ..alignment = alignment
      ..textDirection = textDirection ?? Directionality.maybeOf(context)
      ..fit = fit
      ..clipBehavior = clipBehavior;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection, defaultValue: null));
    properties.add(EnumProperty<StackFit>('fit', fit));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior, defaultValue: Clip.hardEdge));
  }
}

/// A [Stack] that shows a single child from a list of children.
///
/// The displayed child is the one with the given [index]. The stack is
/// always as big as the largest child.
///
/// If value is null, then nothing is displayed.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=_O0PPD1Xfbk}
///
/// {@tool dartpad}
/// This example shows a [IndexedStack] widget being used to lay out one card
/// at a time from a series of cards, each keeping their respective states.
///
/// ** See code in examples/api/lib/widgets/basic/indexed_stack.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [Stack], for more details about stacks.
///  * The [catalog of layout widgets](https://flutter.dev/widgets/layout/).
class CustomIndexedStack extends StatelessWidget {
  /// Creates a [Stack] widget that paints a single child.
  const CustomIndexedStack({
    super.key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.maintainFocusability = true,
    this.clipBehavior = Clip.hardEdge,
    this.sizing = StackFit.loose,
    this.index = 0,
    this.children = const <Widget>[],
  });

  /// How to align the non-positioned and partially-positioned children in the
  /// stack.
  ///
  /// Defaults to [AlignmentDirectional.topStart].
  ///
  /// See [Stack.alignment] for more information.
  final AlignmentGeometry alignment;

  /// The text direction with which to resolve [alignment].
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection? textDirection;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// How to size the non-positioned children in the stack.
  ///
  /// Defaults to [StackFit.loose].
  ///
  /// See [Stack.fit] for more information.
  final StackFit sizing;

  /// If hidden [children] should be able to receive focus.
  ///
  /// Defaults to true.
  final bool maintainFocusability;

  /// The index of the child to show.
  ///
  /// If this is null, none of the children will be shown.
  final int? index;

  /// The child widgets of the stack.
  ///
  /// Only the child at index [index] will be shown.
  ///
  /// See [Stack.children] for more information.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<Widget> wrappedChildren = List<Widget>.generate(children.length, (int i) {
      return Visibility(
        visible: i == index,
        maintainInteractivity: maintainFocusability,
        maintainSize: true,
        maintainState: true,
        maintainAnimation: true,
        child: children[i],
      );
    });
    return _RawIndexedStack(
      alignment: alignment,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      sizing: sizing,
      index: index,
      children: wrappedChildren,
    );
  }
}

/// The render object widget that backs [IndexedStack].
class _RawIndexedStack extends Stack {
  /// Creates a [Stack] widget that paints a single child.
  const _RawIndexedStack({
    super.alignment,
    super.textDirection,
    super.clipBehavior,
    StackFit sizing = StackFit.loose,
    this.index = 0,
    super.children,
  }) : super(fit: sizing);

  /// The index of the child to show.
  final int? index;

  @override
  RenderIndexedStack createRenderObject(BuildContext context) {
    assert(_debugCheckHasDirectionality(context));
    return RenderIndexedStack(
      index: index,
      fit: fit,
      clipBehavior: clipBehavior,
      alignment: alignment,
      textDirection: textDirection ?? Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderIndexedStack renderObject) {
    assert(_debugCheckHasDirectionality(context));
    renderObject
      ..index = index
      ..fit = fit
      ..clipBehavior = clipBehavior
      ..alignment = alignment
      ..textDirection = textDirection ?? Directionality.maybeOf(context);
  }

  @override
  MultiChildRenderObjectElement createElement() {
    return _IndexedStackElement(this);
  }
}

class _IndexedStackElement extends MultiChildRenderObjectElement {
  _IndexedStackElement(_RawIndexedStack super.widget);

  @override
  _RawIndexedStack get widget => super.widget as _RawIndexedStack;

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    final int? index = widget.index;
    // If the index is null, no child is onstage. Otherwise, only the child at
    // the selected index is.
    if (index != null && children.isNotEmpty) {
      visitor(children.elementAt(index));
    }
  }
}
