
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/navigation_bar_item.dart';
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/tab_item.dart';

import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    this.onSelectTab,
    this.tabs,
  });
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {


    return  FABBottomAppBar(
      color: Colors.grey.shade500,
      backgroundColor: Colors.white,
      selectedColor: Colors.grey.shade600,
      unselectedItemColor: Colors.grey.shade400,
      selectedLabelStyle: Theme.of(context).textTheme.caption,
      unselectedLabelStyle: Theme.of(context).textTheme.caption,
      centerItemText: 'Add',
      notchedShape: CircularNotchedRectangle(),
      onTabSelected: (index) => onSelectTab(
        index,
      ),
      items:  tabs
          .map(
            (e) => _buildItem(
          index: e.getIndex(),
          icon: e.icon,
          tabName: e.tabName,
        ),
      )
          .toList(),
    );
    //   BottomNavigationBar(
    //
    //   type: BottomNavigationBarType.fixed,
    //   items: tabs
    //       .map(
    //         (e) => _buildItem(
    //       index: e.getIndex(),
    //       icon: e.icon,
    //       tabName: e.tabName,
    //     ),
    //   )
    //       .toList(),
    //   onTap: (index) => onSelectTab(
    //     index,
    //   ),
    // );
  }
  // FABBottomAppBarItem(iconData: Icons.schedule, text: 'Schedule'),
  FABBottomAppBarItem _buildItem(
      {int index, IconData icon, String tabName}) {
    return FABBottomAppBarItem(
      iconData:
      icon,
      text:
      tabName,

    );
  }


}