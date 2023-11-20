import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/microphone.dart';
import '../components/recordings_stream.dart';

class RecordingsView extends StatefulWidget {
  static const String id = "recordings_view";

  const RecordingsView({super.key});
  @override
  _RecordingsViewState createState() => _RecordingsViewState();
}

class _RecordingsViewState extends State<RecordingsView> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentlyPlayingFilename = '';

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        stopPlaying();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Recorder'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          ElevatedButton(
            child: Text('Sign out'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RecordingsStream(
              audioPlayer: audioPlayer,
              isPlaying: isPlaying,
              currentlyPlayingFilename: currentlyPlayingFilename,
              onPlayStop: () {
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
            ),
          ),
          Microphone(),
        ],
      ),
    );
  }

  void stopPlaying() {
    setState(() {
      isPlaying = false;
      currentlyPlayingFilename = '';
    });
  }
}
