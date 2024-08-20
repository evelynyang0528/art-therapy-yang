import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key});

  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  CameraDescription? camera;

  @override
  void initState() {
    initializecamera();
    recordvideo();
    // TODO: implement initState
    super.initState();
  }

  initializecamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      camera = cameras!.first;
    }
    cameraController = CameraController(camera!, ResolutionPreset.high);
    await cameraController?.initialize();
    setState(() {});
  }

  recordvideo() async {
    print("=======Recording====");
    if (!cameraController!.value.isInitialized) {
      return;
    }

    final folder = await getTemporaryDirectory();
    final filepath =
        '${folder.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
    await cameraController!.startVideoRecording();
    await Future.delayed(Duration(seconds: 10));
    final videofile = await cameraController!.stopVideoRecording();
    print(videofile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("video therapy"),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              color: Colors.grey.shade300,
              width: 300,
              height: 300,
            ),
          ),
          if (cameraController != null && cameraController!.value.isInitialized)
            Center(
                child: SizedBox(
                    width: 300,
                    height: 300,
                    child: CameraPreview(cameraController!))),
        ],
      ),
    );
  }
}
