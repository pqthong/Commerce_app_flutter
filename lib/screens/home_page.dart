import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_commerce/constants.dart';
import 'package:the_commerce/services/FirebaseServices.dart';
import 'package:the_commerce/tabs/home_tab.dart';
import 'package:the_commerce/tabs/saved_tab.dart';
import 'package:the_commerce/tabs/search_tab.dart';
import 'package:the_commerce/widgets/bottom_tabs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _tabsPageController = PageController();
  int _selectedTab = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Expanded(
            child: PageView(
              controller: _tabsPageController,
              onPageChanged: (num) {
                setState(() {
                  _selectedTab = num;
                });
              },
              children: [HomeTab(), SearchTab(), SavedTab()],
            ),
          ),
        ),
        Container(
            child: BottomTabs(
          selectedTab: _selectedTab,
          tabPressed: (num) {
            setState(() {
              _selectedTab = num;
              _tabsPageController.animateToPage(_selectedTab,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn);
            });
          },
        ))
      ],
    ));
  }
}
