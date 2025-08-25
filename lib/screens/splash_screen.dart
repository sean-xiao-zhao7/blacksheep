import 'package:flutter/material.dart';
import 'package:sheepfold/screens/home_screen.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse('https://blacksheep01.com/assets/videos/video1.mp4'),
          )
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 6000), () {}).then((value) {
      if (mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (ctx) => HomeScreen()));
      }
    });

    _controller.play();
    return Scaffold(
      body: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : Container(),
    );
  }
}
