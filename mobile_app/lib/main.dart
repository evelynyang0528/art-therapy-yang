import 'dart:convert';
import 'constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'journal_list_screen.dart';
import 'splashscreen.dart';
import 'journal.dart';
import 'package:camera/camera.dart';
import 'journal_entry.dart';
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
    requestStoragePermission();
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
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
      home: SplashScreen(
        cameras: _cameras,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.cameras});

  final String title;
  final List<CameraDescription> cameras;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  List<JournalEntry> journalEntry = [];

  String? imageUrl;
  String? dailyText;

  Future<void> fetchImage() async {
    try {
      final response = await http.get(Uri.parse('$url/get_daily_image'));

      if (response.statusCode == 200) {
        setState(() {
          Map result = jsonDecode(response.body);
          imageUrl = result["image"].toString().trim();
          dailyText=result["phrase"].toString();
        });
      } else {
        _showNotification();
      }
    } catch (E) {
      print(E);
      _showNotification();
    }
  }
  void _showNotification() {
    // Show notification alerting user that the image could not be loaded
    AlertDialog(
        title: const Text('Image Load Error'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Image could not be loaded. Please try again.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
        ]);
  }


  void addingEntry(BuildContext context) async {
    final newentry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => journalscreen(cameras: widget.cameras),
      ),
    );
    if (newentry != null) {
      setState(() {
        journalEntry.add(newentry);
      });
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const JournalListScreen()));
    }
  }

  int selectedIndex = 0;

  void _onItemTap(
    int index,
  ) {
    if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => journalscreen(
              cameras: widget.cameras,
            ),
          ));
      // addingentry(context);
    } else if (index == 2) {
      setState(() {
        selectedIndex = 2;
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const JournalListScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Art Therapy",
            style: TextStyle(fontFamily: "DancingScript", fontSize: 32)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: imageUrl != null
            ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 20,),
                  Text(dailyText ?? "", style: TextStyle(fontSize: 20,fontFamily:"EduVICWANTBeginner" ),),

                ],
              ),
            )
            : Container(
                color: Colors.cyan,
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        selectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
        onTap: _onItemTap,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.blueGrey,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
