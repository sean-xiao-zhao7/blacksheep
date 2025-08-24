import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen(this.switchScreen, {super.key});
  final Function switchScreen;

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   setState(() {
    //     currentGroup = newGroup;
    //     currentScreen = newScreen;
    //     _loading = false;
    //   });
    // });

    final VideoPlayerController controller = VideoPlayerController.file(
      File("assets/videos/video1.mp4"),
    );
    controller.play();

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }
}
