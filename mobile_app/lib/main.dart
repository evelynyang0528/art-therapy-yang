import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:test2/chat_screen.dart';
import 'package:test2/custom_widget.dart';
import 'package:test2/download_manager.dart';
import 'package:test2/login_screen.dart';
import 'package:test2/music_page.dart';
import 'package:test2/sign_up_screen.dart';

import 'Therapy_screen.dart';
import 'constant.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'journal_list_screen.dart';
import 'splashscreen.dart';
import 'journal.dart';
import 'journal_entry.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  int selectedIndex = 0;

  List<Widget> screens = [
    MyHomePage(),
    JournalListScreen(),
    AddJournalScreen(),
    TherapyScreen(
      therapyImage: "appimageurl",
    ),
    // const ChatScreen()
    // LoginScreen()
    SignUpScreen(),
  ];


  void _onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        selectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: "Journals",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_front_outlined),
            label: "Therapy",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chat",
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTap,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.blueGrey,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

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

  String imageUrl = "";
  String? dailyText;

  Future<void> fetchImage() async {
    try {
      final response = await http.get(Uri.parse('$url/get_daily_image'));

      if (response.statusCode == 200) {
        setState(() {
          Map result = jsonDecode(response.body);
          imageUrl = result["image"].toString().trim();
          dailyText = result["phrase"].toString();
        });
      } else {
        print("Error *************************");
        _showNotification();
      }
    } catch (E) {
      print(E);
      _showNotification();
    }
  }

  void _showNotification() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Image Load Error'),
              content:
                  const Text('Image could not be loaded. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      fetchImage();
                    },
                    child: const Text("Retry"))
              ]);
        });
  }

  checkPermission() {
    Permission.photos.status;
  }

  @override
  Widget build(BuildContext context) {
    DownloadManager downloadManager =
    DownloadManager(imageUrl: imageUrl, context: context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Art Therapy",
            style: TextStyle(fontFamily: "DancingScript", fontSize: 32),
          ),
          centerTitle: true,
        ),
        body: imageUrl.isNotEmpty
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          downloadManager.askToDownloadImage();
                        },
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        dailyText ?? "",
                        style: const TextStyle(
                            fontSize: 20, fontFamily: "EduVICWANTBeginner"),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ))

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
