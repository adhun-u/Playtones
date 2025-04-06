part of 'fetch_album_bloc.dart';

@immutable
sealed class FetchAlbumEvent {
  const FetchAlbumEvent();
}

//Fetching all albums event

final class AlbumFetch extends FetchAlbumEvent {}

//Fetching songs from album event (when clicking an album)
final class AlbumBasedEvent extends FetchAlbumEvent {
  final int albumId;
  const AlbumBasedEvent({required this.albumId});
}

//play song event
final class PlaySong extends FetchAlbumEvent {
  final int index;

  const PlaySong({required this.index});
}
