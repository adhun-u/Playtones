part of 'most_played_bloc.dart';

sealed class MostPlayedEvent extends Equatable {
  const MostPlayedEvent();

  @override
  List<Object> get props => [];
}

//Add Data event
final class AddMostPlayedSongEvent extends MostPlayedEvent {
  final int songId;
  final String title;
  final String artist;
  const AddMostPlayedSongEvent({
    required this.songId,
    required this.title,
    required this.artist,
  });
}

//Getting most played song
final class GetMostPlayedSongEvent extends MostPlayedEvent {}

//Deleting all Event
final class DeleteAllMostSongs extends MostPlayedEvent {}
