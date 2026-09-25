import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/explore_page.dart';
import 'pages/favorite_page.dart';
import 'widgets/bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

    Widget favoritePage = FavoritePage(
    key: UniqueKey(),
    dariNavbar: true,
  );

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const ExplorePage(),
      favoritePage,
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            if (index == 2) {
              favoritePage = FavoritePage(
                key: UniqueKey(),
                dariNavbar: true,
              );
            }

            currentIndex = index;
          });
        },
      ),
    );
  }
}