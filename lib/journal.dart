import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test2/ImageViewPage.dart';
import 'package:path/path.dart' show join;
import 'package:test2/journalentry.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
class journalscreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const journalscreen({super.key, required this.cameras});

  @override
  State<journalscreen> createState() => _journalscreenState();
}

class _journalscreenState extends State<journalscreen> {
  final TextEditingController _textcontroller = TextEditingController();
  late CameraController controller;
  late XFile? imagefile;
  bool cameravisible = false;
  bool nobackbutton = true;
  bool camorvid = true;
  bool isrecording = false;
  late Future<void> futurecontroller;
  String emotion = '';
  String aientry = '';


  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    // futurecontroller = controller.initialize();
    // controller.initialize().then((_) {
    //   if (!mounted) {
    //     return;
    //   }
    //   setState(() {});
    // }).catchError((Object e) {
    //   if (e is CameraException) {
    //     switch (e.code) {
    //       case 'CameraAccessDenied':
    //         // Handle access errors here.
    //         break;
    //       default:
    //         // Handle other errors here.
    //         break;
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Future<void> AIresponse(String entry)async{
  final response = await http.get(Uri.parse('$url/ai_response'));
  if (response.statusCode==200){
    Map result = jsonDecode(response.body);
    aientry = result["phrase"].toString().trim();
  }
  }
  Future<void> sendvideo(String filepath)async{
    final uri = Uri.parse('$url/analyze_emotion');
    final request = http.MultipartRequest('POST',uri)
    ..files.add(await http.MultipartFile.fromPath('video', filepath));
    try {
      final response = await request.send();
      if (response.statusCode==200){
        final responsebody = await response.stream.bytesToString();
        final Map<String,dynamic> jsonresponse = jsonDecode(responsebody);
        setState(() {
          emotion = jsonresponse['emotion'];
        });
      }
    } catch(E){print(E);}
  }
  Future<void> startrecording() async {
    try {
      await futurecontroller;
      await controller.startVideoRecording();
      setState(() {
        isrecording = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> stoprecording() async {
    try {
      final XFile videofile = await controller.stopVideoRecording();
      print(videofile.path);
      setState(() {
        isrecording = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void takepicture() async {
    if (cameravisible) {
      try {
        final XFile picture = await controller.takePicture();
        setState(() {
          imagefile = picture;
          cameravisible = false;
          nobackbutton = true;
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Imageviewpage(imagepath: imagefile!.path)));
      } catch (e) {
        print(e);
      }
    } else {
      setState(() {
        cameravisible = true;
        nobackbutton = false;
      });
    }
  }

  // save the journal to the user device.
  saveJournal() async {
    String text = _textcontroller.text;
    SharedPreferences  sharedPreferences = await SharedPreferences.getInstance();
    String timeStamp = DateTime.now().toIso8601String();
    await sharedPreferences.setString(timeStamp, text);


      // Get a list of all journals
    List<String>?  timeStamps= sharedPreferences.getStringList("j_timestamps");
    timeStamps??=[];
    timeStamps.add(timeStamp);
    await sharedPreferences.setStringList("j_timestamps", timeStamps);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journal saved successfully!')),
      );
    }


    // add this journal we have create to the list.
      print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: nobackbutton,
          backgroundColor: Colors.white,
          title: Text("add entry"),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 160),
                  Text(
                    "Please Enter How You Feel?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: _textcontroller,
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Please Add Photos Here",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        iconSize: 60,
                        onPressed: takepicture,
                        icon: Icon(Icons.photo_camera_front),
                      )),
                  ElevatedButton(onPressed: (){
                    // DateTime time = DateTime.now();
                    // String months = DateFormat('MMMM').format(time);
                    // String days =  DateFormat('dd').format(time);
                    // sendvideo(imagefile!.path);
                    // AIresponse(_textcontroller.text);
                    // final newentry = JournalEntry(filepath: imagefile!.path, months:months , days: days, entry: _textcontroller.text, AIentry: "AIentry", emotion: emotion);
                    // Navigator.pop(context,newentry);
                    saveJournal();
              
                  }, child: Text("Add Entry"))
                ],
              ),
            ),
            cameravisible
                ? Stack(
                    children: [
                      Container(
                        child: CameraPreview(controller),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 60,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          color: Colors.white,
                          //alignment: Alignment.center,
                          child: Align(
                            child: Container(
                              height: 50,
                              width: 50,
                              padding: camorvid
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.all(10),
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (camorvid) {
                                    takepicture();
                                  } else {
                                    setState(() {
                                      isrecording ? stoprecording():startrecording();
                                    });
                                  }
                                },
                                child: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isrecording ? Colors.red : Colors.black,
                                  shape: camorvid
                                      ? CircleBorder(
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                        )
                                      : RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 6),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                nobackbutton = true;
                                cameravisible = false;
                              });
                            },
                            icon: Icon(Icons.arrow_back_ios_new),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, 0.87),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    camorvid = true;
                                  });
                                },
                                child: Text(
                                  "Photos",
                                  style: TextStyle(color: Colors.black),
                                )),
                            SizedBox(
                              width: 25,
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    camorvid = false;
                                  });
                                },
                                child: Text(
                                  "Videos",
                                  style: TextStyle(color: Colors.black),
                                )),
                          ],
                        ),
                      )
                    ],
                  )
                : SizedBox(),
          ],
        ));
    ();
  }
}
