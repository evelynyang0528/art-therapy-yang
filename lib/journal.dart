import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test2/ImageViewPage.dart';

class journalscreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const journalscreen({super.key, required this.cameras});

  @override
  State<journalscreen> createState() => _journalscreenState();
}

class _journalscreenState extends State<journalscreen> {
  late CameraController controller;
  late XFile? imagefile;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void takepicture() async {
    try {
      final XFile picture = await controller.takePicture();
      setState(() {
        imagefile = picture;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Imageviewpage(imagepath: imagefile!.path)));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("add entry"),
        ),
        body: Stack(
          children: [
            CameraPreview(controller),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                ),
                Text(
                  "please enter how you feel",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("please add photos here"),
                ElevatedButton(onPressed: takepicture, child: Text("login"))
              ],
            ),
          ],
        ));
    ();
  }
}
