import 'dart:async';
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
    return musicUrl.isNotEmpty
        ? AudioPlayerScreen(
            audioUrl: musicUrl,
          )
        : const CircularProgressIndicator();
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
  Duration? _duration;
  Duration? _position;

  StreamSubscription? durationSubscription;
  StreamSubscription? positionSubscription;
  StreamSubscription? playerCompleteSubscription;
  StreamSubscription? playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;
  bool get _isStopped => _playerState == PlayerState.stopped;
  String get _positionText => _position.toString().split(".").first;
  String get _durationText => _duration.toString().split(".").first;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player.setSource(UrlSource(widget.audioUrl));
    _playerState = player.state;
    player.getDuration().then((durationValue) {
      setState(() {
        _duration = durationValue;
      });
    });

    player.getCurrentPosition().then((value) {
      setState(() {
        _position = value;
      });
    });

    initStreams();
  }

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

  initStreams() {
    durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    positionSubscription = player.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
    playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });
    playerStateChangeSubscription = player.onPlayerStateChanged.listen((event) {
      setState(() {
        _playerState = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _isPlaying
            ? IconButton(
                onPressed: _isPlaying ? pauseAudio : null,
                icon: const Icon(
                  Icons.pause,
                  size: 40,
                ))
            : IconButton(
                icon: const Icon(
                  Icons.play_arrow,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: _isPlaying ? null : playAudio),
        Slider(
          thumbColor: Colors.black,
          activeColor: Colors.black54,
          value: (_position != null &&
                  _duration != null &&
                  _position!.inMilliseconds > 0 &&
                  _position!.inMilliseconds < _duration!.inMilliseconds)
              ? _position!.inMilliseconds / _duration!.inMilliseconds
              : 0.0,
          onChanged: (value) {
            final duration = _duration;
            if (duration == null) return;
            final position = value * duration.inMilliseconds;
            player.seek(Duration(milliseconds: position.round()));
          },
        ),
        Text(_position != null
            ? "$_positionText / $_durationText"
            : _duration != null
                ? _durationText
                : "")
      ],
    );
  }
}
