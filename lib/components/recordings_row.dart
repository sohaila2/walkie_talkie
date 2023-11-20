import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class RecordingRow extends StatelessWidget {
  final String filename;
  final String currentlyPlayingFilename;
  final Function onTap;

  RecordingRow({
    required this.filename,
    required this.currentlyPlayingFilename,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Icon(
              currentlyPlayingFilename == filename
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              size: 36.0,
              color: currentlyPlayingFilename == filename
                  ? Colors.white
                  : Colors.blue,
            ),
            SizedBox(width: 16.0),
            Text(
              timeago.format(
                  DateTime.parse(filename.split('_').last.substring(0, 19))),
              style: currentlyPlayingFilename == filename
                  ? const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              )
                  : const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        onTap(filename);
      },
    );
  }
}