import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class BoxPlayer extends StatefulWidget {
  final Function onTapCallback;

  BoxPlayer({
    Key key,
    this.onTapCallback,
  }) : super(key: key);

  @override
  _BoxPlayerState createState() => _BoxPlayerState();
}

class _BoxPlayerState extends State<BoxPlayer> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  bool _greyOverlayVisibility = false;
  bool _volumeSliderVisibility = false;
  double _currentVolume = 0;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      _currentVolume = _controller.value.volume;
      _controller.setLooping(true);
      _controller.play();
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Butterfly Video'),
      // ),

      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //rehide status bar using Future.delayed
          GestureDetector(
            onVerticalDragStart: (DragStartDetails details) {
              setState(() {
                _volumeSliderVisibility = true;
              });
            },
            onVerticalDragUpdate: (DragUpdateDetails details) {
              var dy = -details.delta.dy * 0.5;
              setState(() {
                if(dy < 0)
                  _currentVolume = max(_currentVolume + dy, 0);
                else
                  _currentVolume = min(_currentVolume + dy, 100);
              });
              _controller.setVolume(_currentVolume/100);
            },
            onVerticalDragEnd: (_) {
              setState(() {
                _volumeSliderVisibility = false;
              });
            },
            onTap: () {
              if(widget.onTapCallback != null)
                widget.onTapCallback();
              setState(() {
                if(_controller.value.isPlaying) {
                  _controller.pause();
                  _greyOverlayVisibility = true;
                } else {
                  _controller.play();
                }
              });
            },
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center( 
                    child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller)
                      ),
                  );
                } 
                else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Visibility(
            //todo animated opacity
            child: Opacity(
              opacity: 0.8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if(widget.onTapCallback != null)
                      widget.onTapCallback();
                    _greyOverlayVisibility = false;
                    _controller.play();
                  });
                },
                child: Container(
                  color: Colors.black,
                  child: Center( child: Icon(Icons.play_arrow, size: 100, color: Colors.amberAccent,)),
                ),
              )
            ),
            visible: _greyOverlayVisibility,
          ),
          Visibility(
            visible: _greyOverlayVisibility || _volumeSliderVisibility,
            child: Positioned(
              bottom: 10,
              // width: 50,
              child:  Column(
                children: <Widget>[
                  //todo: add a position scroll?
                  Icon( _currentVolume == 0 ? Icons.volume_mute
                      : _currentVolume < 45 ? Icons.volume_down
                      : Icons.volume_up
                      , color: Colors.amberAccent,
                    ),
                  //todo wrap in fractionallysizedbox
                  RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      inactiveColor: Colors.black,
                      value: _currentVolume, 
                      min: 0,
                      max: 100,
                      divisions: 50,
                      // label: _currentVolume.round().toString(),
                      onChanged: (double volume) {
                        setState(() {            
                          _controller.setVolume(volume/100);
                          _currentVolume = volume;
                        });
                      },
                    ),
                  ),
                ]
              )
            )
          ),
        ],
      )
    );
  }
}