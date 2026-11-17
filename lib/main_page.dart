import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/favorite_page.dart';
import 'pages/trip_page.dart';
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

  Widget historyPage = TripPage(
    key: UniqueKey(),
    sebagaiRiwayat: true,
  );

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      historyPage,
      favoritePage,
    ];

    return Scaffold(
      extendBody: true, // PENTING: Agar body tembus ke belakang navbar
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
            if (index == 1) {
              historyPage = TripPage(
                key: UniqueKey(),
                sebagaiRiwayat: true,
              );
            }
            currentIndex = index;
          });
        },
      ),
    );
  }
}