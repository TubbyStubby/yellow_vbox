import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellow_vbox/routes.dart';

import 'boxplayer.dart';
import 'pipcamera.dart';
import 'startscreen.dart';

//todo: ios internet perms
//todo: ios firebase
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  Firebase.initializeApp();
  
  runApp(YellowVBox());
}

//todo: make firebase login 
//todo: add different source for video
class YellowVBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YellowBox',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.amberAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: Approutes.define(),
      home: StartScreen(),
      // Stack(
      //   fit: StackFit.expand,
      //   children: <Widget>[
      //     BoxPlayer(),
      //     PipCamera()
      //   ],
      // ),
    );
  }
}

