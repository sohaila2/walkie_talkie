import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void uploadAudioToFirebase(String audioPath) {
  try {
    final fileName = audioPath.split('/').last; //
    Reference audioRef = FirebaseStorage.instance.ref().child(fileName);
    audioRef.putFile(File(audioPath));
    FirebaseFirestore.instance
        .collection('walkie1')
        .add({'filename': fileName});
  } catch (e) {
    print("Error uploading audio: $e");
  }
}

Future<String> getFilePath() async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  String timestamp = DateTime.now().toIso8601String();
  return appDocDirectory.path + '/recording_' + timestamp + '.m4a';
}

Future<String> getAudioURL(String audioFileName) async {
  Reference audioRef = FirebaseStorage.instance.ref().child(audioFileName);
  return await audioRef.getDownloadURL();
}
