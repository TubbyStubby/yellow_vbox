import 'package:flutter/material.dart';
import 'package:yellow_vbox/boxplayer.dart';
import 'package:yellow_vbox/pipcamera.dart';

//todo add different video sources option
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        BoxPlayer(),
        PipCamera(),
      ],
    );
  }
}