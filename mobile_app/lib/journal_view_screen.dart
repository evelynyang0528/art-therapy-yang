import 'package:flutter/material.dart';
import 'package:test2/journal_image_view_screen.dart';

class JournalViewScreen extends StatefulWidget {
  const JournalViewScreen({super.key, required this.journalEntry});
  final String journalEntry;
  @override
  State<JournalViewScreen> createState() => _JournalViewScreenState();
}

class _JournalViewScreenState extends State<JournalViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Text(widget.journalEntry),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Start a therapy session and listen to a nice music base on this joural. We can handle this for you. We will generate a image and music to calm or cheer you up."),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JournalImageViewScreen(
                      journalentry: widget.journalEntry,
                    ),
                  ),
                );
              },
              child: const Text("start therapy"),
            ),
          ),
        ],
      ),
    );
  }
}
