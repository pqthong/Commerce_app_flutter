import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_commerce/constants.dart';
import 'package:the_commerce/screens/cart_page.dart';
import 'package:the_commerce/services/FirebaseServices.dart';

class CustomActionBar extends StatelessWidget {
  CustomActionBar(
      {Key? key, this.title, this.hasBackArrow, this.hasTitle, this.hasBackground})
      : super(key: key);

  final String? title;
  final bool? hasBackArrow;
  final bool? hasBackground;
  final bool? hasTitle;
  final CollectionReference _usersRef = FirebaseFirestore.instance.collection("Users");
  FirebaseServices _firebaseServices = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    bool _hasBackGround = hasBackground ?? true;



    return Container(
      decoration: BoxDecoration(
          gradient: _hasBackGround ? LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0)],
              begin: const Alignment(0, 0),
              end: const Alignment(0, 1)) : null ),
      padding: const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (hasBackArrow ?? false)
            GestureDetector(
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.keyboard_backspace_sharp,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          if (hasTitle ?? true)
            Text(
              title ?? "Action bar",
              style: Constants.boldHeading,
            ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage()));
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: StreamBuilder<QuerySnapshot>(
                builder: (context, snapshot) {
                  int _totalItems = 0;

                  if ( snapshot.connectionState == ConnectionState.active){
                    List _document = snapshot.data!.docs ;
                    _totalItems = _document.length;
                  }

                  return Text(
                    "$_totalItems",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  );
                },
                stream: _usersRef.doc(_firebaseServices.getUserId()).collection("Cart").snapshots(),


              ),
            ),
          )
        ],
      ),
    );
  }
}
