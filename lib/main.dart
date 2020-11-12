import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'boxplayer.dart';

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

//todo: move to pip file
// todo: make it minimizable
// todo: set initial to minimized if only 1 camera
// todo: change cameras
class PipCamera extends StatefulWidget {
  final CameraDescription camera;
    final bool frontCam;

  const PipCamera({
    Key key,
    @required this.camera,
    @required this.frontCam,
  }) : super(key: key);

  @override
  _PipCameraState createState() => _PipCameraState();
}

class _PipCameraState extends State<PipCamera> {
  double _bottomPos = 10, _rightPos = 10;

  CameraController _cameraController;
  Future<void> _initCamControllerFuture;

  double _pipZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initCamControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width, screenHeight = screenSize.height;

    final rb = context.findRenderObject() as RenderBox;
    final pipHeight = rb?.size?.height ?? 0, pipWidth = rb?.size?.width ?? 0;

    var edgeDistance = 5.0;
    var hzFarLimit = screenWidth - edgeDistance - pipWidth;
    var vtFarLimit = screenHeight - edgeDistance - pipHeight;
    
    return Positioned(
      width: 200.0 * _pipZoom,
      bottom: _bottomPos,
      right: _rightPos,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _pipZoom = _pipZoom > 1.0 ? 1.0 : 1.5;
          });
        },
        onPanUpdate: (DragUpdateDetails details) {
          var dx = details.delta.dx, dy = details.delta.dy;

          setState(() {
            if(dx < 0)
              _rightPos = min(_rightPos - dx, hzFarLimit);
            else
              _rightPos = max(_rightPos - dx, edgeDistance);
            if(dy < 0)
              _bottomPos = min(_bottomPos - dy, vtFarLimit);
            else
              _bottomPos = max(_bottomPos - dy, edgeDistance);
          });          
        },
        child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: RotatedBox(
              quarterTurns: -1,
                child: FutureBuilder<void>(
                future: _initCamControllerFuture,
                builder: (ctx, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: CameraPreview(_cameraController)
                    );
                  } else {
                    return Center( child: CircularProgressIndicator(), );
                  }
                },
              ),
            ),
          )
        )
      )
    );
  }
}