part of 'fetch_audio_bloc.dart';

@immutable
sealed class FetchAudioEvent {
  const FetchAudioEvent();
}

//Fetching songs event
final class FetchSongsEvent extends FetchAudioEvent {}

//loaded songs in audioplayer
final class LoadSongs extends FetchSongsEvent {}

//play song event
final class PlaysongEvent extends FetchSongsEvent {
  int index;
  bool isFromPlaylist = false;
  int? songId;
  PlaysongEvent({
    required this.index,
    this.isFromPlaylist = false,
    this.songId,
  });
}
