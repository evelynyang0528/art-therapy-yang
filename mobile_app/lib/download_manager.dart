import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class DownloadManager {
  DownloadManager({required this.imageUrl, required this.context});
  final String imageUrl;
  final BuildContext context;

  Future<bool> requestPermission() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final androidVersion = androidInfo.version.sdkInt;
    bool granted;
    print("==================Requesting==================");
    if (androidVersion >= 33) {
      granted = await Permission.photos.request().isGranted;
    } else {
      granted = await Permission.storage.request().isGranted;
    }
    return granted;
  }

  downloadToDevice() async {
    try {
      print('Downloading image from $imageUrl');
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        print('Image downloaded successfully');
        final result = await ImageGallerySaverPlus.saveImage(
          Uint8List.fromList(response.bodyBytes),
          quality: 100,
          name: "daily_image_${DateTime.now().toIso8601String()}",
        );
        print('Image save result: $result');
        // if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(
              width: 5,
            ),
            Text('image downloaded'),
          ],
        )));
        // }
      } else {
        print('Failed to download image: ${response.statusCode}');
        // if (mounted) {
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
            Text('failed to download'),
          ],
        )));
        // }
      }
    } catch (e) {
      print('Error saving image: $e');
      // if (mounted) {
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
          Text('failed to download'),
        ],
      )));
      // }
    }
  }

  void askToDownloadImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Do you want to save this image?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Save to album'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  bool granted = await requestPermission();
                  if (granted) {
                    downloadToDevice();
                  } else {
                    print("=================Permission not granted");
                  }
                },
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }
}
