import 'package:flutter/material.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test2/detailedinfo.dart';
import 'journalentry.dart';
class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {

  Map<String,String> journals = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

 Future<Map<String,String>> getjournals()async{
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   List<String>?  timeStamps= sharedPreferences.getStringList("j_timestamps");
   timeStamps??=[];

   for(String timeStamp in timeStamps)
     {String? journalEntry = 
         sharedPreferences.getString(timeStamp);
       if (journalEntry!=null){
         journals[timeStamp]= journalEntry;
       }
     }

   return journals;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("past entries"),
      ),
      body: FutureBuilder(
        future:getjournals(),
        builder: (BuildContext context, AsyncSnapshot<Map<String,String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No journals found.'));
          }

          journals = snapshot.data!;
          return ListView.builder(
            itemCount:journals.length ,
          itemBuilder: (context,index){
              String timeStamp = journals.keys.elementAt(index);
              String journalEntry = journals[timeStamp]!;
            return ListTile(
              title: Text(journalEntry),
            );
          });
      },

      ),
    );
  }
}