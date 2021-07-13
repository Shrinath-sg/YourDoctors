import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_pop_menu.dart';
import 'package:YOURDRS_FlutterAPP/provider/filter_button_provider.dart';
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/bottom_navBar.dart';
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/message.dart';
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/settings.dart';
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/tab_item.dart';
import 'package:YOURDRS_FlutterAPP/ui/demographic_page/patients_list.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_screen.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/user_profile/change_password.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/user_profile/change_pin.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/user_profile/change_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  static const String routeName = '/NavigationBar';

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  bool _show = false;
  static int currentTab = 0;

  String _lastSelected = 'TAB: 0';

//bool isInit=false;
  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      tabName: "schedule",
      icon: Icons.calendar_today,
      page: PatientAppointment(),
    ),
    TabItem(
      tabName: "patients",
      icon: Icons.person_outline_rounded,
      page: DemographicPage(),
    ),
    TabItem(
      tabName: "messages",
      icon: Icons.mail_outline_outlined,
      page: Message(),
    ),
    TabItem(
      tabName: "settings",
      icon: Icons.settings,
      page: Settings(),
    ),
  ];

  CustomBottomNavigationBarState() {
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

// @override
//   void initState() {
//   isInit=true;
//     super.initState();
//   }
  // sets current tab index
  // and update state
  //
  // void _selectedFab(int index) {
  //   setState(() {
  //     _lastSelected = 'FAB: $index';
  //     currentTab=index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    Future<Widget> _popUpMenue() async {
      int selected = await showMenu<int>(
        context: context,
        position:
            RelativeRect.fromLTRB(_size.width, _size.height * 0.68, 0.0, 0.0),
        items: <PopupMenuItem<int>>[
          new PopupMenuItem<int>(child: const Text('Change Profile'), value: 1),
          new PopupMenuItem<int>(child: const Text('Change PIN'), value: 2),
          new PopupMenuItem<int>(
              child: const Text('Change Password'), value: 3),
        ],
        elevation: 8.0,
      );
      if (selected == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Profile()));
      } else if (selected == 2) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChangeUserPIN()));
      } else if (selected == 3) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChangeUserPassword()));
      }
    }

    void _selectTab(int index) {
      // setState(() {
      //   isInit=false;
      // });
      if (index == currentTab) {
        // pop to first route
        // if the user taps on the active tab
        tabs[index].key.currentState.popUntil((route) => route.isFirst);
      } else {
        // update the state
        // in order to repaint
        setState(() => currentTab = index);
      }
      if (currentTab == 3) {
        _popUpMenue();
      }
    }

    void _clearStack() {
      setState(() {
        _selectTab(0);
      });
    }

    // WillPopScope handle android back btn
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await tabs[currentTab].key.currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (currentTab != 0) {
            // select 'main' tab
            _selectTab(0);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      // this is the base scaffold
      // don't put appbar in here otherwise you might end up
      // with multiple appbars on one screen
      // eventually breaking the app
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // indexed stack shows only one child
        body: IndexedStack(
          index: currentTab,
          children: tabs.map((e) => e.page).toList(),
        ),
        // Bottom navigation
        bottomNavigationBar: Consumer<FilterButtonProvider>(
          builder: (context, _isVisible, _) {
            return Visibility(
              visible: _isVisible.value,
              child: BottomNavigation(
                onSelectTab: _selectTab,
                tabs: tabs,
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Consumer<FilterButtonProvider>(
          builder: (ctx, _isVisible, _) {
            return Visibility(
                visible: _isVisible.value,
                child: _buildFab(context, _clearStack));
          },
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget _buildFab(BuildContext context, Function clearStack) {
    return FloatingActionButton(
      backgroundColor: CustomizedColors.clrCyanBlueColor,
      onPressed: () {},
      //tooltip: 'Add',
      child: Pop(
        clearStack: clearStack,
        initialValue: 1,
      ),
      elevation: 2.0,
    );
  }
}
