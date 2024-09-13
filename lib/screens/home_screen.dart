import 'package:flutter/material.dart';
import 'package:movies_app/screens/browse_tab.dart';
import 'package:movies_app/screens/home_tab.dart';
import 'package:movies_app/screens/search_tab.dart';
import 'package:movies_app/screens/watchlist_tab.dart';
import 'package:movies_app/style/app_colors.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'Home_screen';

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primaryColor,
      body: tabs[selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: MyAppColors.grayColor,
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/images/icon_home.png'),
                ),
                label: 'HOME'),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/icon_search.png'),
              ),
              label: 'SEARCH',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/icon_browse.png'),
              ),
              label: 'BROWSE',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/icon_watchlist.png'),
              ),
              label: 'WATCHLIST',
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> tabs = [
    HomeTab(),
    SearchTab(),
    BrowseTab(),
    WatchListTab(),
  ];
}
