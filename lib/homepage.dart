import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:yellow_vbox/boxplayer.dart';
import 'package:yellow_vbox/pipcamera.dart';
import 'package:yellow_vbox/routes.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

//todo add different video sources option
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showSignout = false;
  String userName;

  @override
  void initState() {
    super.initState();
    userName = _auth.currentUser.displayName;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signoutButton = Material(
      color: Colors.amber,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      child: MaterialButton(
        //padding: EdgeInsets.all(1),
        onPressed: () async {
          User user = _auth.currentUser;
          if(user != null)
            await _auth.signOut();
          Navigator.of(context).pushReplacementNamed(Approutes.authLogin);
        },
        child: Text(
          'Sign Out',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15, color: Colors.black),
        ),
      ),
    );

    final userGreeting = Text(
      'Hello, $userName',
      style: TextStyle(color: Colors.amber, fontSize: 15,),
    );

    //todo add signed in info
    return Stack(
      fit: StackFit.expand,
      children: [
        BoxPlayer(
          onTapCallback: () {
            setState(() {
              showSignout = !showSignout;
            });
          },
        ),
        Positioned(
          top: 10,
          width: MediaQuery.of(context).size.width,
          child: Visibility(
            visible: showSignout,            
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  userGreeting,
                  signoutButton,
                ],
              ),
            ),
          )
        ),
        PipCamera(),
      ],
    );
  }
}
