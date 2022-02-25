import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_commerce/constants.dart';
import 'package:the_commerce/screens/product_page.dart';
import 'package:the_commerce/services/FirebaseServices.dart';
import 'package:the_commerce/widgets/cutom_action_bar.dart';
import 'package:the_commerce/widgets/product_card.dart';

class HomeTab extends StatelessWidget {
  HomeTab({Key? key}) : super(key: key);
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productRef.get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error} "),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    padding: EdgeInsets.only(top: 100, bottom: 12),
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> map =
                          document.data() as Map<String, dynamic>;
                      return ProductCard(
                        title: map['name'],
                        imageUrl: map['images'][0],
                        price: map['price'].toString(),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductPage(productId: document.id,) ));
                        },
                      );
                    }).toList(),
                  );
                }

                return Scaffold(
                  body: Center(
                      child: CircularProgressIndicator(
                    color: Theme.of(context).accentColor,
                  )),
                );
              }),
          CustomActionBar(
            hasBackArrow: false,
            title: "Home",
          )
        ],
      ),
    );
  }
}
