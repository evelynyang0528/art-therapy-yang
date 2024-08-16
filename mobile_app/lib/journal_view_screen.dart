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
      appBar: AppBar(title: Text(""),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            height:MediaQuery.of(context).size.height/2,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color:Colors.grey.shade200),
            child: Text(widget.journalEntry),),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>JournalImageViewScreen(journalentry:widget.journalEntry)));

          }, child: Text("generate image"),),
        ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(onPressed: (){}, child: Text("generate music"),),
          )
        ],
      ),
    );
  }
}
