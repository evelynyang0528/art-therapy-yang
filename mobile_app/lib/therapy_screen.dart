// late List<CameraDescription> _cameras;
//_cameras = await availableCameras();
// void requestStoragePermission() async {
//   if (!kIsWeb) {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }
//     var cameraStatus = await Permission.camera.status;
//     if (!cameraStatus.isGranted) {
//       await Permission.camera.request();
//     }
//   }
// }


import 'package:flutter/cupertino.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key});

  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

