import 'package:fireflutter/Screens/createtweet_screen.dart';
import 'package:fireflutter/Screens/home_screen.dart';
import 'package:fireflutter/Screens/notifications_screen.dart';
import 'package:fireflutter/Screens/profile_screen.dart';
import 'package:fireflutter/Screens/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;

  const FeedScreen({Key key, this.currentUserId}) : super(key: key);
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedTab = 0;

 // List<Widget> _feedScreens = 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
    HomeScreen(),
    SearchScreen(
      currentUserId: widget.currentUserId,
    ),
    NotificationsScreen(),
    ProfileScreen(
      currentUserId: widget.currentUserId,
      visitedUserId: widget.currentUserId,
    ),
  ].elementAt(_selectedTab),     
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        activeColor: Color(0xff00acee),
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
