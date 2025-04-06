part of 'fetch_album_bloc.dart';

sealed class FetchAlbumState extends Equatable {
  const FetchAlbumState();

  @override
  List<Object> get props => [];
}

//album initial state

final class FetchAlbumInitial extends FetchAlbumState {}

//album loaded state
final class AlbumsLoaded extends FetchAlbumState {
  final List<AlbumModel> albums;

  const AlbumsLoaded({required this.albums});

  @override
  List<Object> get props => [albums];
}

//Loading state

final class LoadingState extends FetchAlbumState {}

//Error state
final class ErrorState extends FetchAlbumState {
  final String error;
  const ErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

//chacking songs of album state
final class AlbumBasedSongsState extends FetchAlbumState {
  final List<SongModel> songs;
  final int albumId;
  const AlbumBasedSongsState({required this.songs, required this.albumId});
  @override
  List<Object> get props {
    return [songs, albumId];
  }
}

//Fetching songs from album state
final class FetchSongDetailsFromFetchAudioBloc extends FetchAlbumState {
  final List<SongModel> songs;
  const FetchSongDetailsFromFetchAudioBloc({required this.songs});
  @override
  List<Object> get props => [songs];
}
