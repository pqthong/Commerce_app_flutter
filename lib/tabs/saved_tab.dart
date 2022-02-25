import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_commerce/services/FirebaseServices.dart';

import '../constants.dart';
import '../screens/product_page.dart';
import '../widgets/cutom_action_bar.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({Key? key}) : super(key: key);

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.usersRef
                  .doc(_firebaseServices.getUserId())
                  .collection("Saved")
                  .get(),
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
                    padding: const EdgeInsets.only(top: 100, bottom: 12),
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> map =
                      document.data() as Map<String, dynamic>;
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                      productId: document.id,
                                    )));
                          },
                          child: FutureBuilder<DocumentSnapshot>(
                            future: _firebaseServices.productRef
                                .doc(document.id)
                                .get(),
                            builder: (context, productSnap) {
                              if (productSnap.hasError) {
                                return Container(
                                  child: Center(
                                    child: Text("${productSnap.error}"),
                                  ),
                                );
                              }
                              if (productSnap.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> _productmap =
                                productSnap.data?.data()
                                as Map<String, dynamic>;
                                return Container(
                                    height: 100,
                                    width: double.infinity,
                                    padding: EdgeInsets.only(left: 24,top: 16),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: ClipRRect(
                                            child: Image.network(
                                              "${_productmap['images'][0]}",
                                              fit: BoxFit.fitHeight,height: 100,
                                              loadingBuilder: (BuildContext context, Widget child,
                                                  ImageChunkEvent? loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              color: Colors.black),
                                          width: 100,
                                        ),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(_productmap['name'],style: Constants.regularDarkText,),
                                              Text("\$${_productmap['price']}",style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context).accentColor
                                              ),),
                                              Text("Color : ${map['size']}",style:TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14
                                              ),)
                                            ],
                                          ),
                                          margin: EdgeInsets.only(left: 16),
                                        )
                                      ],
                                    ));
                              }
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ));
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

          CustomActionBar(hasBackArrow: false,title: "Saved Products",)
        ],
      ),
    );
  }
}
