import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test2/constant.dart';
import 'package:test2/download_manager.dart';
import 'package:test2/music_page.dart';
import 'package:test2/therapy_screen.dart';

class JournalImageViewScreen extends StatefulWidget {
  const JournalImageViewScreen({super.key, required this.journalentry});
  final String journalentry;
  @override
  State<JournalImageViewScreen> createState() => _JournalImageViewScreenState();
}

class _JournalImageViewScreenState extends State<JournalImageViewScreen> {
  String imageurl = "$url/get_image";
  String appimageurl = "";
  @override
  void initState() {
    // TODO: implement initState
    getImage();
    super.initState();
  }

  getImage() async {
    try {
      final response = await http.post(
        Uri.parse(imageurl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{"info": widget.journalentry},
        ),
      );
      if (response.statusCode == 200) {
        print("reach");
        Map result = jsonDecode(response.body);
        print(result);
        String image = result['image'];
        print(image);
        setState(() {
          appimageurl = image;
        });
      }
    } catch (error) {
     await  Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Row(
          children: [
            Icon(
              Icons.dangerous,
              color: Colors.red,
            ),
            SizedBox(
              width: 5,
            ),
            Text('image failed to download'),
          ],
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DownloadManager downloadManager =
        DownloadManager(imageUrl: appimageurl, context: context);

    return Scaffold(
      body: SafeArea(
        child: appimageurl == ""
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GestureDetector(
                    onLongPress: () {
                      downloadManager.askToDownloadImage();
                    },
                    child: Container(
                      //  width: MediaQuery.of(context).size.width * 2,
                      height: MediaQuery.of(context).size.height * 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(appimageurl),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  Positioned(
                      bottom: 20.0,
                      child: Container(
                          color: Colors.transparent,
                          child: MusicPage(info: widget.journalentry)))
                ],
              ),
      ),
    );
  }
}
