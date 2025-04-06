part of 'recently_played_bloc.dart';

sealed class RecentlyPlayedEvent extends Equatable {
  const RecentlyPlayedEvent();

  @override
  List<Object> get props => [];
}

//Adding data to database event
final class AddData extends RecentlyPlayedEvent {
  final int songId;
  final DateTime time;
  final String title;
  final String artist;
  const AddData({
    required this.songId,
    required this.time,
    required this.title,
    required this.artist,
  });
  @override
  List<Object> get props => [songId, time, title, artist];
}

//Getting songs event
final class GetSongsEvent extends RecentlyPlayedEvent {}

//Play song event
final class Playsong extends RecentlyPlayedEvent {
  final int index;

  const Playsong({required this.index});
  @override
  List<Object> get props => [index];
}

//Delete all songs
final class DeleteAllRecent extends RecentlyPlayedEvent {}
