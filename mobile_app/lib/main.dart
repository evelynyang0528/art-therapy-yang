import 'dart:convert';
import 'package:test2/music_page.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: SplashScreen(),
    );
  }
}

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  int selectedIndex = 1;

  List<Widget> screens  = [
    AddJournalScreen(),
    // MyHomePage(),
    MusicPage(info: "I feel sad "),
    JournalListScreen(),
  ];

  void _onItemTap(
    int index,
  ) {
    if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddJournalScreen(),
          ));
    } else if (index == 1) {
      setState(() {

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MyHomePage()));
      });
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
      body: screens[selectedIndex],
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
  bool isFetchingData = true;

  String? imageUrl;
  String? dailyText;

  Future<void> fetchImage() async {
    try {
      final response = await http.get(Uri.parse('$url/get_daily_image'));

      if (response.statusCode == 200) {
        setState(() {
          Map result = jsonDecode(response.body);
          imageUrl = result["image"].toString().trim();
          dailyText = result["phrase"].toString();
          isFetchingData = false;
        });
      } else {

        print("Error *************************");
        if (context.mounted) {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load!')),
          );
        }
      }
    } catch (E) {
      print(E);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load!')),
      );
    }
  }

  void _showNotification() {
    AlertDialog(
        title: const Text('Image Load Error'),
        content: Text('Image could not be loaded. Please try again.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Art Therapy",
              style: TextStyle(fontFamily: "DancingScript", fontSize: 32)),
          centerTitle: true,
        ),
        body: !isFetchingData
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.network(
                        imageUrl ?? "",
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        dailyText ?? "",
                        style: TextStyle(
                            fontSize: 20, fontFamily: "EduVICWANTBeginner"),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ))

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
