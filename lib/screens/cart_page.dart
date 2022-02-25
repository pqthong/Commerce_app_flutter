import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_commerce/constants.dart';
import 'package:the_commerce/screens/product_page.dart';
import 'package:the_commerce/services/FirebaseServices.dart';
import 'package:the_commerce/widgets/custom_btn.dart';
import 'package:the_commerce/widgets/cutom_action_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  Future deletedCart(String id) async {
    _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart").doc(id).delete();
  }
  SnackBar _snackBar = SnackBar(content: Text("Removed"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomActionBar(
            hasBackArrow: true,
            title: "Cart",
          ),
          FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.usersRef
                  .doc(_firebaseServices.getUserId())
                  .collection("Cart")
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
                                    padding: EdgeInsets.only(left: 24, top: 16),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: ClipRRect(
                                            child: Image.network(
                                              "${_productmap['images'][0]}",
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
                                              fit: BoxFit.fitHeight,
                                              height: 100,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                _productmap['name'],
                                                style:
                                                    Constants.regularDarkText,
                                              ),
                                              Text(
                                                "\$${_productmap['price']}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                              Text(
                                                "Color : ${map['size']}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                          margin: EdgeInsets.only(left: 16),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Container(
                                              child: Icon(
                                                  Icons.remove_circle_outline),
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(right: 32),
                                            ),
                                            onTap: () async {
                                              await deletedCart(document.id);
                                              Scaffold.of(context).showSnackBar(_snackBar);
                                              setState(() {

                                              });
                                            },
                                          ),
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
          Container(
              alignment: Alignment.bottomCenter,
              child: CustomBtn(outlineBtn: false,text: "Process To Payment",)
          )
        ],
      ),
    );
  }
}
