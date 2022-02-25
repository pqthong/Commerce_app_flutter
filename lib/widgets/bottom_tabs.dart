import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({Key? key, this.selectedTab, this.tabPressed}) : super(key: key);
  final int? selectedTab;
  final Function(int)? tabPressed;
  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int  _selectedTab = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0 ;

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 30
              )
            ]
        ),
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomTabButton(
              iconData: Icons.home, selected: _selectedTab == 0,
              onPressed: (){
                setState(() {
                  widget.tabPressed!(0);
                });
              },),
            BottomTabButton(
                iconData: Icons.search, selected: _selectedTab == 1,
                onPressed: (){
                  setState(() {
                    widget.tabPressed!(1);
                  });
                }),

            BottomTabButton(
                iconData: Icons.save_alt, selected: _selectedTab == 2,
                onPressed: (){
                  setState(() {
                    widget.tabPressed!(2);
                  });
                }),

            BottomTabButton(
                iconData: Icons.logout, selected: _selectedTab == 3,
                onPressed: (){
                  FirebaseAuth.instance.signOut();

                }),

          ],
        )
    );
  }
}

class BottomTabButton extends StatelessWidget {
  const BottomTabButton(
      {Key? key, this.iconData, this.selected, this.onPressed})
      : super(key: key);
  final IconData? iconData;
  final bool? selected;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16
          ),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: _selected ? Theme
                          .of(context)
                          .accentColor : Colors.transparent,
                      width: 2
                  )
              )
          ),
          child: Icon(
            iconData ?? Icons.home, size: 26, color: _selected ? Theme
              .of(context)
              .accentColor : Colors.black,
          )
      ),
    );
  }
}

