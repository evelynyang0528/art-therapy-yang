import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test2/journal_view_screen.dart';
import 'package:test2/therapy_screen.dart';
import 'detailed_info.dart';
import 'journal_entry.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  Map<String, String> journals = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<Map<String, String>> getJournals() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? timeStamps = sharedPreferences.getStringList("j_timestamps");
    timeStamps ??= [];

    for (String timeStamp in timeStamps) {
      String? journalEntry = sharedPreferences.getString(timeStamp);
      if (journalEntry != null) {
        journals[timeStamp] = journalEntry;
      }
    }

    return journals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("past entries"),
      ),
      body: FutureBuilder(
        future: getJournals(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No journals found.'));
          }

          journals = snapshot.data!;
          return ListView.builder(
              itemCount: journals.length,
              itemBuilder: (context, index) {
                DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
                String timeStamp = journals.keys.elementAt(index);
                String newdate=formatter.format(DateTime.parse(timeStamp));
                String journalEntry = journals[timeStamp]!;
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>JournalViewScreen(journalEntry: journalEntry)));
                  },
                  child: ListTile(
                    title: Text(newdate),
                    trailing:Icon(Icons.arrow_forward_ios,size: 15,) ,



                  ),
                );
              });
        },
      ),
    );
  }
}
