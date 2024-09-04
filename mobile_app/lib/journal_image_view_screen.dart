import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test2/constant.dart';
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
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //
      //   centerTitle: true,
      // ),

      body: SafeArea(
        child: appimageurl == ""
            ? const Center(child: CircularProgressIndicator())
            : Stack(
              children: [
                GestureDetector(
                  onTap:(){Navigator.of(context).pop();} ,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_back),),
                ),
                InteractiveViewer(
                          boundaryMargin: EdgeInsets.all(8),
                          minScale: 0.1,
                          maxScale: 1.6,
                  child: OverflowBox(
                    maxWidth: 1024,
                    maxHeight: 1024,

                        child: Image.network(
                            fit: BoxFit.contain,
                            appimageurl),
                      ),
                    ),


              ],
            ),

      ),
    );
  }
}
