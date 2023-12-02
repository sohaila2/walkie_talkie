import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walkie_talkie/constants.dart';
import 'package:walkie_talkie/cubits/walkie/walkie_cubit.dart';

import '../controller/walkie_controller.dart';
import '../helper/show_snack_bar.dart';

class WalkieScreen extends StatelessWidget {
  static String id = 'WalkieScreen';

  @override
  Widget build(BuildContext context) {
    WalkieCubit walkie = WalkieCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColourPrimary,
        title: Text(kAppTitle, style: kTextStyleAppTitle),
      ),
      body: BlocConsumer<WalkieCubit, WalkieState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('walkie1').orderBy(
                    'filename',
                    descending: true,
                  )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var recordings = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: recordings.length,
                      itemBuilder: (context, index) {
                        var recordingData =
                            recordings[index].data() as Map<String, dynamic>;
                        var fileName = recordingData['filename'];
                        bool isPlaying = walkie.isPlayingForRecording(fileName);
                        bool audioEnded =
                            walkie.audioEndedForRecording(fileName);
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: state is AudioLoadingState
                                    ? const CircularProgressIndicator()
                                    : Icon(audioEnded
                                        ? Icons.play_arrow
                                        : (isPlaying
                                            ? Icons.stop
                                            : Icons.play_arrow),color: kColourPrimary,),
                                onPressed: () async {
                                  if (isPlaying) {
                                    walkie.stopAudio();
                                  } else {
                                    await walkie.playAudio(fileName);
                                    audioEnded = false;
                                  }
                                },
                              ),
                              SizedBox(width: 16.0),
                              Text(
                                timeago.format(DateTime.parse(
                                    fileName.split('_').last.substring(0, 19))),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style:  ElevatedButton.styleFrom(
                      primary: kColourPrimary
          ),
                    onPressed: () {
                      if (!walkie.isRecording) {
                        if (!walkie.isSomeoneRecording) {
                          walkie.startRecording();
                        } else {
                          showSnackBar(context, 'Someone is currently recording');
                        }
                      } else {
                        walkie.stopRecording();
                      }
                    },
                    child: Text(walkie.isRecording
                        ? 'Stop Recording'
                        : 'Start Recording'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style:  ElevatedButton.styleFrom(
                        primary: kColourPrimary
                    ),
                    onPressed: () async {
                      if (walkie.isRecording) {
                        walkie.stopRecording();
                      }
                      uploadAudioToFirebase(walkie.audioPath);
                    },
                    child: Text('Send Recording'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
