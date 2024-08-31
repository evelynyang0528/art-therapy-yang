import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key, required this.therapyImage});
  final String therapyImage;
  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  CameraDescription? camera;
  String emotion = "";
  bool isRecording = false;

  @override
  void initState() {
    initializeCamera();
    // TODO: implement initState
    super.initState();
  }

  initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      camera = cameras!.first;
    }
    cameraController = CameraController(camera!, ResolutionPreset.high);
    await cameraController?.initialize();
    setState(() {});
  }

  recordVideo() async {
    print("=======Recording====");
    if (cameraController != null) {
      if (!cameraController!.value.isInitialized) {
        return;
      }

      final folder = await getTemporaryDirectory();
      final filepath =
          '${folder.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await cameraController!.startVideoRecording();
      setState(() {
        isRecording = true;
      });
      await Future.delayed(const Duration(seconds: 10));
      final videofile = await cameraController!.stopVideoRecording();
      print("==================VIDEO FILE =================");
      await sendVideoToServer(videofile.path);
      setState(() {
        isRecording = false;
      });
    }
  }

  // sendVideoToServer
  sendVideoToServer(String videopath) async {
    final uri = Uri.parse("$url/analyze_emotion_video");
    final request = http.MultipartRequest("POST", uri)
      ..files.add(await http.MultipartFile.fromPath('video', videopath));
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responsebody = await response.stream.bytesToString();
        final Map<String, dynamic> jsonresponse = jsonDecode(responsebody);
        setState(() {
          emotion = jsonresponse["emotion"];
        });
      } else {
        print("failed to load ${response.statusCode}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load, please try again')),
          );
        }
      }
    } catch (error) {
      print(error);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load, please try again')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          title:  const Column(
            children: [
              Text(
                "Art Therapy",
                style: TextStyle(fontFamily: "DancingScript", fontSize: 32),

              ),
              SizedBox(height: 10,),

              Text( "Video Therapy",style: TextStyle(fontSize: 18), )
            ],
          ),
          centerTitle: true,
        ),
        body: emotion != ""
            ? Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.network(
                      widget.therapyImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align( alignment: Alignment.bottomCenter,child: Container(
                    margin: const EdgeInsets.all(60.0),
                    color: Colors.grey.shade100,
                    child: Text("your emotion: $emotion",style: TextStyle(fontSize: 24),),
                  ))
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    if (!isRecording)
                      const Text(
                        "A 10 seconds video will be recorded\n Please put your face in front of the camera.",
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(
                      height: 60,
                    ),
                    if (cameraController != null &&
                        cameraController!.value.isInitialized)
                      Center(
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: CameraPreview(cameraController!),
                        ),
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (cameraController != null) {
                          recordVideo();
                        }
                      },
                      child: isRecording
                          ? SizedBox(
                              width: 120,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Recording..."),
                                  SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator()),
                                ],
                              ),
                            )
                          : const Text("Start Therapy"),
                    ),
                    if (!isRecording)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "we will analyze your emotion using this video"),
                      ),
                    Text(emotion,
                        style: TextStyle(
                          fontSize: 24,
                        )),
                  ],
                ),
              ));
  }
}
