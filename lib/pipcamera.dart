// todo: change cameras
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PipCamera extends StatefulWidget {
  @override
  _PipCameraState createState() => _PipCameraState();
}

class _PipCameraState extends State<PipCamera> {
  double _bottomPos = 10, _rightPos = 10;

  bool showCam = false, isCamReady = false;
  CameraController _cameraController;
  Future<void> _initCamControllerFuture;

  double _pipZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _getCam();
    // _cameraController = CameraController(
    //   widget.camera,
    //   ResolutionPreset.medium,
    // );

    // _initCamControllerFuture = _cameraController.initialize();
  }

  Future<void> _getCam() async {
    final cameras = await availableCameras();
    var cam;
    if(cameras.length > 1) {
      showCam = true;
      cam = cameras[1];
    } else {
      cam = cameras.first;
    }

    _cameraController = CameraController(cam, ResolutionPreset.medium);

    _initCamControllerFuture = _cameraController.initialize();

    if(!mounted) {
      return;
    }
    setState(() {
      isCamReady = true;
    });
  }

  void didChangeAppLifeCycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed && _cameraController != null) {
      _initCamControllerFuture = _cameraController.initialize();
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width, screenHeight = screenSize.height;

    final rb = context.findRenderObject() as RenderBox;
    final pipHeight = (rb?.size)?.height ?? 0, pipWidth = (rb?.size)?.width ?? 0;

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
            _pipZoom = showCam ? 0.25 : 1.0;
          });
          setState(() {
            showCam = !showCam;
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
          color: showCam ? Colors.black: Colors.amberAccent,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: RotatedBox(
              quarterTurns: -1,
              child: Visibility(
                visible: showCam,
                maintainAnimation: true,
                maintainSize: true,
                maintainState: true,
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
            ),
          )
        )
      )
    );
  }
}