part of 'fetch_audio_bloc.dart';

@immutable
sealed class FetchAudioState extends Equatable {}

//Initial state
final class FetchAudioInitial extends FetchAudioState {
  List<SongModel> songs = [];

  @override
  List<Object?> get props => [songs];
}

//Loading state
final class FetchAudioLoadingState extends FetchAudioState {
  @override
  List<Object?> get props => [];
}

//Songs loaded Songs
final class FetchAudioLoadedState extends FetchAudioState {
  List<SongModel> songs = [];

  FetchAudioLoadedState({required this.songs});

  @override
  List<Object?> get props => [songs];
}

//Error State
final class FetchErrorState extends FetchAudioState {
  String errorMessage;
  FetchErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
