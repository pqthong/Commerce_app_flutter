import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String? getUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  CollectionReference get productRef => _productRef;
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection("Product_commerce");
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  CollectionReference get usersRef => _usersRef;


}
