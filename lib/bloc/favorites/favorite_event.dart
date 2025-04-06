part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

//Adding songs into favorite list event
final class AddSongs extends FavoriteEvent {
  final int songId;
  const AddSongs({required this.songId});
  @override
  List<Object> get props => [songId];
}

//Getting favorite songs event
final class GetSongEvent extends FavoriteEvent {}

//Remove song event
final class RemoveSongEvent extends FavoriteEvent {
  final int songId;
  const RemoveSongEvent({required this.songId});
  @override
  List<Object> get props => [songId];
}

//Play song event
final class PlaySongEvent extends FavoriteEvent {
  final int index;
  const PlaySongEvent({required this.index});
  @override
  List<Object> get props => [index];
}

//Delete All songs event
final class DeleteAllSongs extends FavoriteEvent {}
