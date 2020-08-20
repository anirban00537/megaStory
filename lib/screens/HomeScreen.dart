import 'package:megaStory/screens/PostStory.dart';
import 'package:megaStory/screens/pages/FeedPage.dart';
import 'package:megaStory/screens/pages/ProfilePage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  var pages = [
    FeedPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/dopeMeal.png',
          height: 30,
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.camera,
                color: Color(0xff5f27cd),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostStoryScreen(),
                    // fullscreenDialog: true,
                  ),
                );
              })
        ],
      ),
      body: Center(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff5f27cd),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              size: 30,
            ),
            title: Text('Story\'s'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 30,
            ),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (i) {
          setState(() {
            _selectedIndex = i;
          });
        },
      ),
    );
  }
}
