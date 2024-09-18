import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test2/journal_list_screen.dart';
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
  var isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  void _onChangeText(String text) {
      if (text.length > 1){
        setState(() {
          isButtonEnabled = text.isNotEmpty;
        });
      }
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

    setState(() {
      _textcontroller.text = "";
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journal saved successfully!')),
      );

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>  JournalListScreen())
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
         toolbarHeight: 80,
          title:  const Column(
            children: [
              Text(
                "Art Therapy",
                style: TextStyle(fontFamily: "DancingScript", fontSize: 32)
              ),
              SizedBox(height: 10,),
              Text("Add Entry",style: TextStyle(fontSize: 18), )
            ],
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 160),
                  const Text(
                    "Please Enter How You Feel?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _textcontroller,
                      onChanged:_onChangeText,
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed:isButtonEnabled ? saveJournal : null,
                      child: Text("Add Entry"),)
                ],
              ),
            ),
          ],
        ));
    ();
  }
}
