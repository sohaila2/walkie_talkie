import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import '../../controller/walkie_controller.dart';
part 'walkie_state.dart';

class WalkieCubit extends Cubit<WalkieState> {
  WalkieCubit() : super(WalkieInitial());

  static WalkieCubit get(context) => BlocProvider.of(context);

  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioRecorder record = AudioRecorder();
  String audioPath = '';
  bool isRecording = false;
  final Map<String, bool> _isPlayingMap = {};
  final Map<String, bool> _audioEndedMap = {};
  int? currentlyPlayingIndex;
  String currentlyPlayingFilename = '';
  bool isSomeoneRecording = false;

  Future<void> startRecording() async {
    try {
      if (await record.hasPermission()) {
        emit(RecordLoadingState());
        audioPath = await getFilePath();
        await record.start(const RecordConfig(encoder: AudioEncoder.aacLc),
            path: audioPath);
        isRecording = true;
        isSomeoneRecording = true;
        emit(StartRecordState());
      }
    } catch (error) {
      print(error);
    }
  }

  void stopRecording() async {
    if (isRecording) {
      await record.stop();
      isRecording = false;
      isSomeoneRecording = false;
      emit(StopRecordState());
    }
  }

  bool isPlayingForRecording(String fileName) {
    return _isPlayingMap[fileName] ?? false;
  }

  bool audioEndedForRecording(String fileName) {
    return _audioEndedMap[fileName] ?? false;
  }

  Future<void> playAudio(String fileName) async {
    try {
      await stopAudio();

      String audioUrl = await getAudioURL(fileName);
      await audioPlayer.play(UrlSource(audioUrl));
      _isPlayingMap[fileName] = true;
      emit(PlayAudioState());

      audioPlayer.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.completed) {
          _isPlayingMap[fileName] = false;
          _audioEndedMap[fileName] = true;
          emit(ListenToAudioState());
        }
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    _isPlayingMap.clear();
    _audioEndedMap.clear();
    emit(StopAudioState());
  }
}
