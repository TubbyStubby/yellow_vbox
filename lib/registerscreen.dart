import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:yellow_vbox/routes.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _userIdController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPassController = TextEditingController();
  TextEditingController _userPassRepeatController = TextEditingController();
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
        hintText:  'someone@someplace.com',
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.black54),
        hintStyle: TextStyle(color: Colors.black38)
      ),
    );

    final userNameField = TextFormField(
      controller: _userNameController,
      keyboardType: TextInputType.name,
      enabled: isSubmitting,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText:  'John Doe',
        labelText: 'User Name',
        labelStyle: TextStyle(color: Colors.black54),
        hintStyle: TextStyle(color: Colors.black38)
      ),
    );

    final userPassField = TextFormField(
      obscureText: true,
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

    final userPassRepeatField = TextFormField(
      obscureText: true,
      controller: _userPassRepeatController,
      keyboardType: TextInputType.visiblePassword,
      enabled: isSubmitting,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText:  'Re-enter Password',
        labelText: 'Reapeat Password',
        labelStyle: TextStyle(color: Colors.black54),
        hintStyle: TextStyle(color: Colors.black38)
      ),
    );

    final fields = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        userNameField,
        userIdField,
        userPassField,
        userPassRepeatField
      ],
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.black87,
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        onPressed: () async {
          try {
            final User user = (await _auth.createUserWithEmailAndPassword(
                email: _userIdController.text,
                password: _userPassController.text,
              )
            ).user;
            if(user != null) {
              await user.updateProfile(displayName: _userNameController.text, photoURL: "");
              Navigator.of(context).pushReplacementNamed(Approutes.homePage);
            }
          } catch(e) {
            print(e);
            _userPassController.text = "";
            _userPassRepeatController.text = "";
            _userIdController.text = "";
            _userNameController.text = "";
            //todo error dialog
          }
        },
        child: Text(
          'Register',
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
        registerButton,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Already a member?',
              style: TextStyle(
                color: Colors.black87
              ),
            ),
            MaterialButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed(Approutes.authLogin),
              child: Text(
                "Login",
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
                  'Register',
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