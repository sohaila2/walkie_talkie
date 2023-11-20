import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walkie_talkie/components/recordings_row.dart';

class RecordingsStream extends StatelessWidget {
  final AudioPlayer audioPlayer;
  late final bool isPlaying;
  final String currentlyPlayingFilename;
  final Function onPlayStop;

  RecordingsStream({
    super.key,
    required this.audioPlayer,
    required this.isPlaying,
    required this.currentlyPlayingFilename,
    required this.onPlayStop,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('walkie')
          .orderBy(
            'filename',
            descending: true,
          )
          .snapshots(),
      builder: (context, querySnapshot) {
        if (querySnapshot.hasData) {
          List<RecordingRow> rows = [];
          for (var document in querySnapshot.data!.docs) {
            rows.add(
              RecordingRow(
                filename: (document.data() as dynamic)['filename'],
                currentlyPlayingFilename: currentlyPlayingFilename,
                onTap: (String filename) {
                  onPlayStop();
                  isPlaying ? stopPlaying(filename) : startPlaying(filename);
                },
              ),
            );
          }
          return Expanded(
            child: ListView(
              reverse: true,
              children: rows,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void startPlaying(String filename) async {
    final url =
        await FirebaseStorage.instance.ref().child(filename).getDownloadURL();
    try {
      await audioPlayer.play(UrlSource(url));
      isPlaying = true;
    } catch (e) {
      print('Error playing file: $e');
    }
  }

  void stopPlaying(String filename) async {
    await audioPlayer.stop();
    if (currentlyPlayingFilename != null) {
      await Future.delayed(Duration(milliseconds: 100));
      startPlaying(filename);
    }
  }
}
