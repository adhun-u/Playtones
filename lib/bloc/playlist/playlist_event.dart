part of 'playlist_bloc.dart';

sealed class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object> get props => [];
}

//Creating playlist event
final class CreatePlaylistEvent extends PlaylistEvent {
  final String name;
  const CreatePlaylistEvent({required this.name});
}

//Fetching playlist event
final class FetchPlaylistEvent extends PlaylistEvent {
  @override
  List<Object> get props => [];
}

//Adding songs to playlist event
final class AddSongsToPlaylistEvent extends PlaylistEvent {
  final SongModel song;
  final String playlistId;
  const AddSongsToPlaylistEvent({required this.playlistId, required this.song});
}

//Getting songs from database event
final class GetSongsFromPlaylistEvent extends PlaylistEvent {
  final String playlistId;
  const GetSongsFromPlaylistEvent({required this.playlistId});
}

//Play event
final class PlaySongEvent extends PlaylistEvent {
  final int index;
  const PlaySongEvent({required this.index});
}

//Delete Playlist
final class DeletePlaylistEvent extends PlaylistEvent {
  final String playlistId;
  const DeletePlaylistEvent({required this.playlistId});
}

//Delete a song from playlist
final class DeleteSongFromPlaylistEvent extends PlaylistEvent {
  final String songId;
  const DeleteSongFromPlaylistEvent({required this.songId});
}

//Renaming playlist event
final class RenamePlaylistEvent extends PlaylistEvent {
  final String id;
  final String newName;
  @override
  List<Object> get props => [];
  const RenamePlaylistEvent({required this.id, required this.newName});
}
