import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'boxplayer.dart';
import 'pipcamera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  
  final cameras = await availableCameras();
  var camera;
  bool frontCam = false;

  if(cameras.length > 1) {
    camera = cameras[1];
    frontCam = true;
  } else {
    camera = cameras.first;
  }

  runApp(YellowVBox(camera: camera, frontCam: frontCam));
}

//todo: make firebase login 
//todo: add different source for video
class YellowVBox extends StatelessWidget {

  final CameraDescription camera;
  final bool frontCam;

  const YellowVBox({
    Key key,
    @required this.camera,
    @required this.frontCam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YellowBox',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.amberAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          BoxPlayer(),
          PipCamera(camera: camera, frontCam: frontCam,)
        ],
      ),
    );
  }
}

