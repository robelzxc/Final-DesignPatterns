import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:ipt_capstone/Pages/noteform.dart';
import 'package:ipt_capstone/Pages/notepage.dart';
import 'profilepage.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  var userData;

  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            NotePage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(icon: Icon(Icons.home), title: Text('NotePage')),
            BottomNavyBarItem(icon: Icon(Icons.account_circle_rounded), title: Text('Profile'))
          ],
          onItemSelected: (index) {
            setState(() {
              _pageController.jumpToPage(index);
            });
          }),
    );
  }
}
