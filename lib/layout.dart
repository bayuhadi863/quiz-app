import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:quiz_app/pages/profile/profile_page.dart';
import 'package:quiz_app/pages/quiz/add_quiz_page.dart';
import 'package:quiz_app/pages/quiz/categories_page.dart';
import 'package:quiz_app/pages/quiz/home_page.dart';
import 'package:quiz_app/pages/quiz/leaderboard_page.dart';
import 'package:quiz_app/utils/constants/colors.dart';

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: false,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style5, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const CategoriesPage(),
      const LeaderboardPage(),
      const ProfilePage(),
      // const AddQuizPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.house_fill),
        title: ("Home"),
        activeColorPrimary: MyColors.secondary,
        inactiveColorPrimary: MyColors.primary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.category_rounded),
        title: ("Categories"),
        activeColorPrimary: MyColors.secondary,
        inactiveColorPrimary: MyColors.primary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.leaderboard_rounded),
        title: ("Leaderboard"),
        activeColorPrimary: MyColors.secondary,
        inactiveColorPrimary: MyColors.primary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_fill),
        title: ("Profile"),
        activeColorPrimary: MyColors.secondary,
        inactiveColorPrimary: MyColors.primary,
      ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(CupertinoIcons.person_fill),
      //   title: ("Profile"),
      //   activeColorPrimary: MyColors.secondary,
      //   inactiveColorPrimary: MyColors.primary,
      // ),
    ];
  }
}
