import 'package:flutter/material.dart';
import 'package:goraku/Screens/AnimePage.dart';
import 'package:goraku/Screens/MangaPage.dart';

class HomePage extends StatelessWidget {
  late String title;
  HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePageView(),
    );
  }
}

class HomePageView extends StatelessWidget {
  HomePageView({super.key});
  final PageController pageController = PageController(initialPage: 0);

  void changePageOnClick(int pageNumber) {
    pageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView(
            controller: pageController,
            children: <Widget>[
              AnimePage(),
              MangaPage(),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const ImageIcon(
                AssetImage("assets/images/AnimeIcon.png"),
                color: Colors.white,
              ),
              onPressed: () => changePageOnClick(0),
            ),
            IconButton(
              icon: const ImageIcon(
                AssetImage("assets/images/MangaIcon.png"),
                color: Colors.white,
              ),
              onPressed: () => changePageOnClick(1),
            )
          ],
        )
      ],
    );
  }
}
