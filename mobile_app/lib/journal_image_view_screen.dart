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
  String appimageurl ="";
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text(
          "Therapy",
          style: const TextStyle(fontFamily: "DancingScript", fontSize: 32),
        ),
        centerTitle: true,
      ),

      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: appimageurl == ""
            ? const Center(child: CircularProgressIndicator())
            : Image.network(
                appimageurl,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
