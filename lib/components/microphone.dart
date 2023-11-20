import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

class Microphone extends StatefulWidget {
  @override
  State<Microphone> createState() => _MicrophoneState();
}

class _MicrophoneState extends State<Microphone> {
  late bool isRecording;
  String recordingPath = '';
  final AudioRecorder record = AudioRecorder();

  @override
  void initState() {
    super.initState();
    isRecording = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (!isRecording) {
                startRecording();
              } else {
                stopRecording();
              }
            },
            child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              if (isRecording) {
                stopRecording();
              }
              sendRecording(recordingPath);
            },
            child: Text('Send Recording'),
          ),
        ],
      ),
    );
  }

  void startRecording() async {
    try {
      if (await record.hasPermission()) {
        recordingPath = await getFilePath();
        await record.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: recordingPath,
        );
        setState(() {
          isRecording = true;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void stopRecording() async {
    if (isRecording) {
   await record.stop();
      setState(() {
        isRecording = false;
      });
    }
  }

  Future<String> getFilePath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String timestamp = DateTime.now().toIso8601String();
    return appDocDirectory.path + '/recording_' + timestamp + '.m4a';
  }

  void sendRecording(String path) {
    final fileName = path.split('/').last;
    FirebaseStorage.instance.ref().child(fileName).putFile(File(path));
    FirebaseFirestore.instance.collection('walkie').add({'filename': fileName});
  }
}
