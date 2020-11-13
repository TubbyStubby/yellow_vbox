import 'package:flutter/material.dart';

import 'package:yellow_vbox/routes.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final logo = ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.grey[800], BlendMode.modulate),
      child: FlutterLogo(
        size: 100,
      )
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.black87,
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        onPressed: () => Navigator.of(context).pushNamed(Approutes.authLogin),
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

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.grey[800],
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        onPressed: () => Navigator.of(context).pushNamed(Approutes.authRegister),
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

    final butttons = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        loginButton, 
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, mq.size.height*0.025),
          child: registerButton,
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.amber[600],
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, mq.size.height * 0.05, 0, 0),
              child: logo,
            ),
            butttons
          ],
        ),
      ),
    );
  }
}
