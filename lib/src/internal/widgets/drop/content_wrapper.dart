import 'package:docking/src/internal/widgets/drop/drop_anchor_widget.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/drop_position.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
abstract class ContentWrapperBase extends StatelessWidget {
  const ContentWrapperBase(
      {Key? key,
      required this.layout,
      required this.listener,
      required this.child})
      : super(key: key);

  final DockingLayout layout;
  final Widget child;
  final DropWidgetListener listener;

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    // percentage of width reserved for detecting center area
    const double centerWidthRatio = 0.50;
    const double edgeWidthRatio = (1.0 - centerWidthRatio) / 2;

    List<Widget> children = [Positioned.fill(child: child)];

    // Left drop zone
    children.add(Positioned.fill(
        child: FractionallySizedBox(
            widthFactor: edgeWidthRatio,
            heightFactor: 1.0,
            alignment: Alignment.centerLeft,
            child: buildDropAnchor(DropPosition.left))));

    // Right drop zone
    children.add(Positioned.fill(
        child: FractionallySizedBox(
            widthFactor: edgeWidthRatio,
            heightFactor: 1.0,
            alignment: Alignment.centerRight,
            child: buildDropAnchor(DropPosition.right))));

    // Top drop zone
    children.add(Positioned.fill(
        child: FractionallySizedBox(
            widthFactor: centerWidthRatio,
            heightFactor: 0.5,
            alignment: Alignment.topCenter,
            child: buildDropAnchor(DropPosition.top))));

    // Bottom drop zone
    children.add(Positioned.fill(
        child: FractionallySizedBox(
            widthFactor: centerWidthRatio,
            heightFactor: 0.5,
            alignment: Alignment.bottomCenter,
            child: buildDropAnchor(DropPosition.bottom))));

    return Stack(children: children);
  }

  DropAnchorBaseWidget buildDropAnchor(DropPosition dropPosition);
}

@internal
class ItemContentWrapper extends ContentWrapperBase {
  ItemContentWrapper(
      {required DockingLayout layout,
      required DropWidgetListener listener,
      required DockingItem dockingItem,
      required Widget child})
      : _dockingItem = dockingItem,
        super(layout: layout, listener: listener, child: child);

  final DockingItem _dockingItem;

  @override
  DropAnchorBaseWidget buildDropAnchor(DropPosition dropPosition) {
    return ItemDropAnchorWidget(
        layout: layout,
        listener: listener,
        dropPosition: dropPosition,
        dockingItem: _dockingItem);
  }
}

@internal
class TabsContentWrapper extends ContentWrapperBase {
  TabsContentWrapper(
      {required DockingLayout layout,
      required DropWidgetListener listener,
      required DockingTabs dockingTabs,
      required Widget child})
      : _dockingTabs = dockingTabs,
        super(layout: layout, listener: listener, child: child);

  final DockingTabs _dockingTabs;

  @override
  DropAnchorBaseWidget buildDropAnchor(DropPosition dropPosition) {
    return TabsDropAnchorWidget(
        layout: layout,
        listener: listener,
        dropPosition: dropPosition,
        dockingTabs: _dockingTabs);
  }
}
