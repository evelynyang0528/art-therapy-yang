import 'dart:io';

import 'package:flutter/material.dart';

class Imageviewpage extends StatefulWidget {
  final String imagepath;
  const Imageviewpage({super.key, required this.imagepath});

  @override
  State<Imageviewpage> createState() => _ImageviewpageState();
}

class _ImageviewpageState extends State<Imageviewpage> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("capturedimage"),
      ),
      body: Center(
        child: Image.file(File(widget.imagepath)),
      ),
    );
  }
}
