import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:yellow_vbox/routes.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _userIdController = TextEditingController();
  TextEditingController _userPassController = TextEditingController();
  bool isSubmitting = true;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    
    final userIdField = TextFormField(
      controller: _userIdController,
      keyboardType: TextInputType.emailAddress,
      enabled: isSubmitting,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText:  'UserName / Email',
        labelText: 'UserId',
        labelStyle: TextStyle(color: Colors.black54),
        hintStyle: TextStyle(color: Colors.black38)
      ),
    );

    final userPassField = TextFormField(
      controller: _userPassController,
      keyboardType: TextInputType.visiblePassword,
      enabled: isSubmitting,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText:  'Password',
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.black54),
        hintStyle: TextStyle(color: Colors.black38)
      ),
    );

    final fields = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        userIdField,
        userPassField,
      ],
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.black87,
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        onPressed: () async {
          try {
            final User user = (await _auth.signInWithEmailAndPassword(
                email: _userIdController.text,
                password: _userPassController.text
              )
            ).user;
            if(user != null) {
              Navigator.of(context).pushReplacementNamed(Approutes.homePage);
            }
          } catch(e) {
            print(e);
            _userPassController.text = "";
            _userIdController.text = "";
            //todo error dialog
          }
        },
        child: Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    final buttons = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 20),
        loginButton,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Not a member?',
              style: TextStyle(
                color: Colors.black87
              ),
            ),
            MaterialButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed(Approutes.authRegister),
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.black87,),
              ),
            ),
          ],
        )
      ],
    );
    
    return Scaffold(
      backgroundColor: Colors.amber[600],
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          //padding: EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.all(20),
            height: mq.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                fields,
                buttons,
              ],
            ),
          ),
        ),
      )
    );
  }
}