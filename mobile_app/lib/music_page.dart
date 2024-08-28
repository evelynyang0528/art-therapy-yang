import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'constant.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key, required this.info});
  final String info;
  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  String musicUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMusic();
  }

  Future<void> getMusic() async {
    try {
      final response = await http.post(
        Uri.parse('$url/generate_audio'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "journal": widget.info,
        }),
      );

      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        String tempUrl = result["music_url"];
        setState(() {
          musicUrl = tempUrl;
        });
      } else {
        print("error------------");
      }
    } catch (error) {
      print("error------------");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: musicUrl.isNotEmpty
          ? AudioPlayerScreen(
              audioUrl: musicUrl,
            )
          : const CircularProgressIndicator(),
    ));
  }
}

// Create a new screen let the screen accept audio url
// Write a function to play audio
// Add a button to the screen and when the Button is pressed call the function play audio

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key, required this.audioUrl});
  final String audioUrl;
  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final player = AudioPlayer();
  PlayerState? _playerState;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;
  bool get _isStopped => _playerState == PlayerState.stopped;

  playAudio() async {
    // if(_playerState==PlayerState.completed || _playerState == PlayerState.stopped) {
    //   player.setSource((UrlSource(widget.audioUrl)));
    // }
    await player.play(UrlSource(widget.audioUrl));
    setState(() {
      _playerState = PlayerState.playing;
    });
  }

  pauseAudio() async {
    await player.pause();
    setState(() {
      _playerState = PlayerState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _isPlaying
            ? IconButton(onPressed: () {}, icon: Icon(Icons.pause))
            : IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: _isPlaying ? null : playAudio),

        IconButton(
          icon: Icon(Icons.stop),
          onPressed: () {
            playAudio();
          },
        ),
      ],
    );
  }
}
