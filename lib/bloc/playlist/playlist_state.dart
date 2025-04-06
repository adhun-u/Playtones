part of 'playlist_bloc.dart';

sealed class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object> get props => [];
}

final class PlaylistInitial extends PlaylistState {}

//Playlist state
final class AllPlaylistState extends PlaylistState {
  final List<PlaylistDataModel> playlists;
  final List<int> counts;
  final List<int> lastSongIds;
  const AllPlaylistState({
    required this.playlists,
    required this.counts,
    required this.lastSongIds,
  });
  @override
  List<Object> get props => [playlists];
}

//Fetching songs based on playlist state
final class AllSongsFromPlaylist extends PlaylistState {
  final List<SongsDataModel> songs;
  const AllSongsFromPlaylist({required this.songs});
  @override
  List<Object> get props => [songs];
}

final class ErrorState extends PlaylistState {
  final String message;
  const ErrorState({required this.message});
}
