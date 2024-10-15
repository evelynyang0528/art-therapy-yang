import 'dart:io';

import 'package:flutter/material.dart';
import 'journal_entry.dart';

class detailedinfo extends StatefulWidget {
  final JournalEntry journalentry;

  const detailedinfo({super.key, required this.journalentry});

  @override
  State<detailedinfo> createState() => _detailedinfoState();
}

class _detailedinfoState extends State<detailedinfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${widget.journalentry.months} ${widget.journalentry.days}"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.file(
                File(widget.journalentry.filepath),
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              Flexible(
                child: Text(widget.journalentry.AIentry),
              ),
              Flexible(
                child: Text(widget.journalentry.entry),
              )
            ],
          ),
        ),
      ),
    );
  }
}
