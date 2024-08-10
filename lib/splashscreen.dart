import 'package:flutter/material.dart';
import 'package:test2/main.dart';
import 'package:camera/camera.dart';

class SplashScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SplashScreen({super.key, required this.cameras});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 4)).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(
                title: "",
                cameras: widget.cameras,
              ),),);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 110,
              width: 110,
              color: Colors.blue,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Art Therapy",
              style: TextStyle(fontSize: 28, fontFamily: "DancingScript"),
            )
          ],
        ),
      ),
    );
  }
}
