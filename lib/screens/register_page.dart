
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future<void> _alertDialogBuilder( String error ) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("close dialog"))
            ],
          );
        });
  }

  bool _registerFormLoading = false;
  String _registerEmail = ""  ;
  String _registerPassword = "";
  late FocusNode _passwordFocusNode = FocusNode();

  Future<String?> _createAccount () async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _registerEmail, password: _registerPassword);
      return null;
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return'The account already exists for that email.';
      }
      return e.message ;
    } catch (e) {
      return e.toString() ;
    }

  }

  void _submitForm() async {
    setState(() {
      _registerFormLoading= true;
    });
    String? _createAccountFeedback = await _createAccount();
    if (_createAccountFeedback != null ){
      _alertDialogBuilder(_createAccountFeedback);
      setState(() {
        _registerFormLoading = false;
      });
    }else{
      Navigator.pop(context);
    }
  }



  @override
  void initState() {
    _passwordFocusNode =  FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                "Create A new Account",
                textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Column(
              children: [
                CustomInput(
                  hintText: "Email...",
                  onChanged: (value){
                    _registerEmail = value;
                  },
                  onSubmitted: (value){
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  isPasswordField: true,
                  hintText: "Password...",
                  onChanged: (value){
                    _registerPassword = value;
                  },
                  onSubmitted: (value){
                    _submitForm();
                },
                  focusNode: _passwordFocusNode,
                ),
                CustomBtn(
                  text: "Create New Acoount",
                  onPressed: () {
                    setState(() {
                      _submitForm();
                    });
                  },isLoading: _registerFormLoading,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CustomBtn(
                text: "Back To Login",
                onPressed: () {
                  Navigator.pop(context);
                },
                outlineBtn: true,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
