import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:blacksheep/screens/home_screen.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

/// Shows a sheep video for 6 seconds then go to HomeScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/video1.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _timer = Timer(Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.play();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blacksheep_background_full.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _controller.value.isInitialized
            ? OverflowBox(
                maxWidth: _controller.value.size.width / 1.4,
                maxHeight: _controller.value.size.height / 1.4,
                child: VideoPlayer(_controller),
              )
            : NowHeader('BlackSheep loading...'),
      ),
    );
  }
}
