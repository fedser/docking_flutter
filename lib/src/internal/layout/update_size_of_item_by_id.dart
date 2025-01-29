import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/internal/layout/layout_modifier.dart';
import 'package:meta/meta.dart';

@internal
class UpdateSizeOfItemById extends LayoutModifier {
  UpdateSizeOfItemById({
    required this.id,
    this.size,
    this.weight,
    required this.minimize,
  });

  final dynamic id;
  final double? size;
  final double? weight;
  final bool minimize;

  @override
  DockingArea? newLayout(DockingLayout layout) {
    if (layout.root != null) {
      return _buildLayout(layout.root!);
    }
    return null;
  }

  /// Builds a new root.
  DockingArea? _buildLayout(DockingArea area) {
    if (area is DockingItem) {
      DockingItem dockingItem = area;
      if (dockingItem.id == id) {
        if (weight != null) {
          dockingItem.resetToFlex(weight!);
        } else if (size != null) {
          if (minimize) {
            dockingItem.setFixedSize(size!);
          } else {
            //TODO:
          }
        }
      }
      return dockingItem;
    } else if (area is DockingTabs) {
      DockingTabs dockingTabs = area;
      final needChangeDockingTabs = dockingTabs.id == id;
      List<DockingItem> children = [];
      dockingTabs.forEach((child) {
        children.add(child);
      });
      if (children.length == 1) {
        return children.first;
      }
      DockingTabs newDockingTabs = DockingTabs(
        children,
        id: dockingTabs.id,
        flex: weight,
        size: needChangeDockingTabs ? (minimize ? size : null) : null,
        maximized: dockingTabs.maximized,
        maximizable: (needChangeDockingTabs && minimize)
            ? false
            : dockingTabs.maximizable,
      );
      newDockingTabs.selectedIndex = dockingTabs.selectedIndex;
      return newDockingTabs;
    } else if (area is DockingParentArea) {
      List<DockingArea> children = [];
      area.forEach((child) {
        DockingArea? newChild = _buildLayout(child);
        if (newChild != null) {
          children.add(newChild);
        }
      });
      if (children.isEmpty) {
        return null;
      } else if (children.length == 1) {
        return children.first;
      }
      if (area is DockingRow) {
        return DockingRow(children, id: area.id);
      } else if (area is DockingColumn) {
        return DockingColumn(children, id: area.id);
      }
      throw ArgumentError(
          'DockingArea class not recognized: ' + area.runtimeType.toString());
    }
    throw ArgumentError(
        'DockingArea class not recognized: ' + area.runtimeType.toString());
  }
}
