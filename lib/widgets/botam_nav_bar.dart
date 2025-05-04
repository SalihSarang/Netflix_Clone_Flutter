import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/home_screen.dart';
import 'package:netflix_clone/screens/more_screen.dart';
import 'package:netflix_clone/screens/search_screen.dart';

class BotamNavBar extends StatelessWidget {
  const BotamNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 70,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.search), text: 'Search'),
              Tab(icon: Icon(Icons.photo_library_outlined), text: 'New & Hot'),
            ],
            labelColor: Colors.white,
            indicatorColor: Colors.transparent,
            unselectedLabelColor: Color(0xff999999),
          ),
        ),
        body: TabBarView(
          children: const [HomeScreen(), SearchScreen(), MoreScreen()],
        ),
      ),
    );
  }
}
