
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_commerce/screens/register_page.dart';
import 'package:the_commerce/widgets/custom_btn.dart';
import 'package:the_commerce/widgets/custom_input.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


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

  bool _loginFormLoading = false;
  String _loginEmail = ""  ;
  String _loginPassword = "";
  late FocusNode _passwordFocusNode = FocusNode();

  Future<String?> _createAccount () async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _loginEmail, password: _loginPassword);
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
      _loginFormLoading= true;
    });
    String? _createAccountFeedback = await _createAccount();
    if (_createAccountFeedback != null ){
      _alertDialogBuilder(_createAccountFeedback);
      setState(() {
        _loginFormLoading = false;
      });
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
                padding:  EdgeInsets.only(top: 24),
                child: Text("Welcome User,\nLogin to your account",textAlign: TextAlign.center,style: Constants.boldHeading,),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Email...",
                    onChanged: (value){
                      _loginEmail = value;
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
                      _loginPassword = value;
                    },
                    onSubmitted: (value){
                      _submitForm();
                    },
                    focusNode: _passwordFocusNode,
                  ),
                  CustomBtn(
                    text: "Login",
                    onPressed: () {
                      setState(() {
                        _submitForm();
                      });
                    },isLoading: _loginFormLoading,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12 ),
                child: CustomBtn(text: "Create new Account",onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => RegisterPage()
                  ));
                },outlineBtn: true,),
              )
            ],
          ),
        ),
      )
    );
  }
}
