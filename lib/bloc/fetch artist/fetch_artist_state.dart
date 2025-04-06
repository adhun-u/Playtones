part of 'fetch_artist_bloc.dart';

sealed class FetchArtistState extends Equatable {
  const FetchArtistState();

  @override
  List<Object> get props => [];
}

final class FetchArtistInitial extends FetchArtistState {
  @override
  List<Object> get props => [];
}

//Loading state
final class LoadingState extends FetchArtistState {
  @override
  List<Object> get props => [];
}

//Artist fetch state
final class ArtistFetchState extends FetchArtistState {
  List<ArtistModel> artists = [];
  ArtistFetchState({required this.artists});

  @override
  List<Object> get props => [artists];
}

//Error state
final class ErrorState extends FetchArtistState {
  String errorMessage;
  ErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//Artist based songs state
final class ArtistBasedSongState extends FetchArtistState {
  final int artistId;
  final List<SongModel> songs;
  const ArtistBasedSongState({required this.artistId, required this.songs});
  @override
  List<Object> get props => [songs];
}
