import 'package:flutter/material.dart';
import 'package:yellow_vbox/routes.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _userIdController;
  TextEditingController _userPassController;
  TextEditingController _userPassRepeatController;
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

    final userPassRepeatField = TextFormField(
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
        onPressed: () => {}, //todo register auth
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
              onPressed: () => Navigator.of(context).pushNamed(Approutes.authLogin),
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