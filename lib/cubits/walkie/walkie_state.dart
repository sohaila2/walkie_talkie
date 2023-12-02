part of 'walkie_cubit.dart';

@immutable
abstract class WalkieState {}

class WalkieInitial extends WalkieState {}

class RecordLoadingState extends WalkieState {}
class StartRecordState extends WalkieState {}
class StopRecordState extends WalkieState {}



class AudioLoadingState extends WalkieState {}

class GetAudioState extends WalkieState{}

class PlayAudioState extends WalkieState{}

class ListenToAudioState extends WalkieState{}

class StopAudioState extends WalkieState{}
