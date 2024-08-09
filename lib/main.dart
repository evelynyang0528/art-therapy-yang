import 'dart:convert';
import 'constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test2/journallistscreen.dart';
import 'package:test2/splashscreen.dart';
import 'journal.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'journalentry.dart';
import 'package:http/http.dart' as http;
late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requeststoragepermission();
  }

  void requeststoragepermission() async {
    if (!kIsWeb) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      var camerastatus = await Permission.camera.status;
      if (!camerastatus.isGranted) {
        await Permission.camera.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(


        useMaterial3: true,
      ),
      home: splashscreen(
        cameras: _cameras,
      ),
    );
  }
}
// This widget is the root of your application.

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.cameras});


  final String title;
  final List<CameraDescription> cameras;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<JournalEntry> journalEntry = [];


  String? imageUrl;
  @override
  void initstate(){
    super.initState();
    // fetchimage();
  }
  Future<void> fetchimage()async{
    try {
      final response = await http.get(Uri.parse('$url/get_daily_image'));
      if(response.statusCode==200){
        setState(() {
          Map result=jsonDecode(response.body);
          imageUrl=result["image"].toString().trim();
        });
      }
    }catch(E){print(E);}
  }
  void addingentry(BuildContext context)async{
    final newentry = await Navigator.push(context,MaterialPageRoute(builder: (context)=>journalscreen(cameras: widget.cameras),),);
    if(newentry !=null ){
      setState(() {
        journalEntry.add(newentry);
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => JournalListScreen()));
    }
  }
  int selectedIndex = 0;

  void _onitemtap(int index,) {
    if (index == 0) {

      Navigator.push(
        context, MaterialPageRoute(builder: (context) => journalscreen(cameras: widget.cameras,),));
      // addingentry(context);
    }
     else if (index == 2) {
      setState(() {
        selectedIndex = 2;
        Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (context) => JournalListScreen()));
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.white,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Art Therapy",
            style: TextStyle(fontFamily: "DancingScript", fontSize: 32)),
        centerTitle: true,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SizedBox.expand(
          child: imageUrl != null ? Image.network(imageUrl!,fit: BoxFit.cover,):Container(
            color: Colors.cyan,
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const journalscreen()));
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
        selectedLabelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: "journals",
          )
        ],
        currentIndex: selectedIndex,
        onTap: _onitemtap,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.blueGrey,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
