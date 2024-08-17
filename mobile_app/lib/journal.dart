import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'image_view_page.dart';
import 'package:path/path.dart' show join;
import 'journal_entry.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({
    super.key,
  });

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final TextEditingController _textcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // save the journal to the user device.
  saveJournal() async {
    String text = _textcontroller.text;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String timeStamp = DateTime.now().toIso8601String();
    await sharedPreferences.setString(timeStamp, text);

    // Get a list of all journals
    List<String>? timeStamps = sharedPreferences.getStringList("j_timestamps");
    timeStamps ??= [];
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
          backgroundColor: Colors.white,
          title: Text("add entry"),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 160),
                  const Text(
                    "Please Enter How You Feel?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _textcontroller,
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Please Add Photos Here",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        saveJournal();
                      },
                      child: Text("Add Entry"))
                ],
              ),
            ),
          ],
        ));
    ();
  }
}
