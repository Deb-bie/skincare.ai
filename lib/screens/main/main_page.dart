import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:myskiin/screens/ai_chat/ai_chat.dart';
import 'package:provider/provider.dart';

import '../../providers/browse_tab_provider.dart';
import '../browse/browse_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../routine/routine_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _pages() {
    return [
      HomePage(
          controller: _controller
      ),
      BrowsePage(
        controller: _controller,
        initialTab: Provider.of<BrowseTabProvider>(context, listen: false).selectedTab,
      ),
      RoutinePage(),
      AIChat(),
      ProfilePage(),
    ];
  }


  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        textStyle: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600
        ),
        // activeColorPrimary: const Color(0xFF00E5CC),
          activeColorPrimary: Colors.teal.shade500,
        inactiveColorPrimary: Colors.grey,
          contentPadding: 8
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.search),
        title: "Browse",
        textStyle: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600
        ),
        // activeColorPrimary: Colors.teal,
        activeColorPrimary: Colors.teal.shade500,
        inactiveColorPrimary: Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calendar_today),
        title: "Routine",
        textStyle: TextStyle(
            fontFamily: "Poppins",
          fontWeight: FontWeight.w600
        ),
        activeColorPrimary: Colors.teal.shade500,
        inactiveColorPrimary: Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.smart_toy_outlined),
        title: "AI Chatbot",
        textStyle: TextStyle(
            fontFamily: "Poppins",
          fontWeight: FontWeight.w600
        ),
        activeColorPrimary: Colors.teal.shade500,
        inactiveColorPrimary: Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: "Profile",
        textStyle: TextStyle(
            fontFamily: "Poppins",
          fontWeight: FontWeight.w600
        ),
        activeColorPrimary: Colors.teal.shade500,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _pages(),
      items: _navBarsItems(),
      confineToSafeArea: true, backgroundColor: const Color(0xFFF5F5F5),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: 50,
      navBarStyle: NavBarStyle.style2
    );
  }

















  // int _selectedIndex = 0;
  //
  // final List<Widget> _pages = [
  //   const HomePage(),
  //   const BrowsePage(),
  //   const RoutinePage(),
  //   const AIChat(),
  //   const ProfilePage(),
  // ];
  //
  // @override
  // Widget build(BuildContext context) {
  //   final navProvider = Provider.of<NavigationProvider>(context);
  //   final int currentIndex = navProvider.selectedIndex;
  //
  //
  //   // If on settings page, show that page instead
  //   Widget currentPage = _pages[currentIndex];
  //   if (navProvider.isInSettingsPage && currentIndex == 4) {
  //     currentPage = const SettingsPage();
  //   }
  //
  //
  //   return Scaffold(
  //     // body: _pages[_selectedIndex],
  //
  //     // body: IndexedStack(
  //     //   index: currentIndex,
  //     //   children: _pages,
  //     // ),
  //
  //     body: currentPage,
  //
  //     bottomNavigationBar: BottomNavigationBar(
  //       // currentIndex: _selectedIndex,
  //       currentIndex: currentIndex,
  //       // onTap: (index) {
  //       //   setState(() {
  //       //     _selectedIndex = index;
  //       //   });
  //       // },
  //       onTap: (index) => navProvider.setIndex(index),
  //
  //       type: BottomNavigationBarType.fixed,
  //
  //       selectedItemColor: const Color(0xFF00E5CC),
  //
  //       unselectedItemColor: Colors.grey,
  //
  //       selectedLabelStyle: const TextStyle(
  //         fontFamily: 'Poppins',
  //         fontSize: 12,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       unselectedLabelStyle: const TextStyle(
  //         fontFamily: 'Inter',
  //         fontSize: 12,
  //       ),
  //       items: const [
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.home),
  //           label: 'Home',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(CupertinoIcons.search),
  //           label: 'Browse',
  //         ),
  //         BottomNavigationBarItem(
  //           // icon: Icon(CupertinoIcons.calendar),
  //           icon: Icon(Icons.calendar_today),
  //           label: 'Routine',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.smart_toy_outlined),
  //           label: 'AI Chatbot',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(CupertinoIcons.person),
  //           label: 'Profile',
  //         ),
  //       ],
  //     ),
  //
  //
  //
  //
  //   );
  // }

}
