import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_commerce/constants.dart';
import 'package:the_commerce/services/FirebaseServices.dart';
import 'package:the_commerce/widgets/custom_input.dart';

import '../screens/product_page.dart';
import '../widgets/product_card.dart';

class SearchTab extends StatefulWidget {
  SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        if (_searchString.isEmpty)
          Container(
              margin: const EdgeInsets.only(top: 45),
              child: const Center(
                  child: Text(
                "Seach Results",
                style: Constants.regularDarkText,
              )))
        else
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: FutureBuilder<QuerySnapshot>(
                future: _firebaseServices.productRef.orderBy("name").startAt(
                    [_searchString]).endAt(["$_searchString\uf8ff"]).get(),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                          productId: document.id,
                                        )));
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
          ),
        Container(
          padding: EdgeInsets.only(top: 45),
          child: CustomInput(
            hintText: "Seach here....",
            onSubmitted: (value) {
              setState(() {
                _searchString = value;
              });
            },
          ),
        ),
      ],
    ));
  }
}
