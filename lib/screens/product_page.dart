import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_commerce/constants.dart';
import 'package:the_commerce/services/FirebaseServices.dart';
import 'package:the_commerce/widgets/cutom_action_bar.dart';
import 'package:the_commerce/widgets/image_swipe.dart';
import 'package:the_commerce/widgets/product_size.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, this.productId}) : super(key: key);
  final String? productId;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final FirebaseServices _firebaseServices = FirebaseServices();

  String _selectedSize = "0";

  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"size": _selectedSize});
  }
  Future _addToSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set({"size": _selectedSize});
  }

  final SnackBar _snackBar = SnackBar(content: Text("Product added to cart"));
  final SnackBar _snackBar2 = SnackBar(content: Text("Product saved"));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: _firebaseServices.productRef.doc(widget.productId).get(),
            builder: (context, snapshot) {
              print( snapshot.toString());
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error} "),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> documentData =
                    snapshot.data?.data() as Map<String, dynamic>;
                List imageList = documentData['images'];
                List productSize = documentData['size'];
                return ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: imageList,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Text(
                        documentData['name'],
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Text(
                        "\$${documentData['price'].toString()}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Text(
                        "${documentData['desc']}",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Text(
                        "Select size",
                        style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSize: productSize,onSelected: (sizeSelected){
                        _selectedSize = sizeSelected ;
                    },
                    ),
                    Container(
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Container(
                              child: const Icon(
                                Icons.save_alt,
                                size: 24,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              width: 60,
                              height: 60,
                              margin: const EdgeInsets.only(left: 24),
                            ),
                            onTap: () async {
                              await _addToSaved();
                              Scaffold.of(context).showSnackBar(_snackBar2);
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                child: const Text(
                                  "Add To Cart",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                height: 64,
                                alignment: Alignment.center,
                              ),
                              onTap: () async {
                                await _addToCart();
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                            ),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 48),
                    )
                  ],
                );
              }

              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
