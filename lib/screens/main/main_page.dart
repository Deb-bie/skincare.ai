import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:myskiin/screens/routine/routine_history.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../home/home.dart';
import '../profile/profile2.dart';
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
    Future.microtask(
            () => context.read<ProductProvider>().fetchProducts()
    );
  }

  List<Widget> _pages() {
    return [
      Home(),
      RoutinePage(),
      RoutineHistoryScreen(),
      ProfilePage2(),
    ];
  }


  List<PersistentBottomNavBarItem> _navBarsItems() {
    final theme = Theme.of(context);

    return [
      PersistentBottomNavBarItem(
          icon: Icon(LucideIcons.house),
          title: "Home",
          textStyle: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12
          ),
          activeColorPrimary: theme.primaryColor,
          inactiveColorPrimary: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5) ?? Colors.grey,
          contentPadding: 8
      ),

      PersistentBottomNavBarItem(
        icon: Icon(LucideIcons.listChecks),
        title: "Routine",
        textStyle: TextStyle(
            fontFamily: "Poppins",
            fontSize: 12
        ),
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5) ?? Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: Icon(LucideIcons.chartNoAxesCombined),
        title: "Progress",
        textStyle: TextStyle(
            fontFamily: "Poppins",
            fontSize: 12
        ),
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5) ?? Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: Icon(LucideIcons.userRound),
        title: "Profile",
        textStyle: TextStyle(
            fontFamily: "Poppins",
            fontSize: 12
        ),
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5) ?? Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PersistentTabView(
        context,
        controller: _controller,
        screens: _pages(),
        items: _navBarsItems(),
        padding: const EdgeInsets.only(top: 12),
        confineToSafeArea: true,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor!,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: 55,
        navBarStyle: NavBarStyle.style2
    );
  }
}
