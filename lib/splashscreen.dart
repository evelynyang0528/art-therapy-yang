import 'package:flutter/material.dart';
import 'package:test2/main.dart';
import 'package:camera/camera.dart';
class splashscreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const splashscreen({super.key, required this.cameras});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState(){
    super.initState();
    init();
  }
  Future<void> init() async {
    await Future.delayed(Duration(seconds: 4)).then((value){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>MyHomePage(title:"", cameras: widget.cameras,)));
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
            Container(height: 110,width: 110,color: Colors.blue,),
            SizedBox(height: 20,),
            Text("Art Therapy",style: TextStyle(fontSize: 28,fontFamily:"DancingScript" ),)
          ],
        ),
      ),
    );
  }
}
