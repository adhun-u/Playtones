part of 'fetch_artist_bloc.dart';

sealed class FetchArtistEvent extends Equatable {
  const FetchArtistEvent();

  @override
  List<Object> get props => [];
}

//Fetchinga artist event
final class ArtistFetchEvent extends FetchArtistEvent {}

//Fetching songs based on an artist event
final class ArtistBasedSongsEvent extends FetchArtistEvent {
  final int artistId;
  const ArtistBasedSongsEvent({required this.artistId});
}

//To play song
final class PlaysongEvent extends FetchArtistEvent {
  final int index;
  const PlaysongEvent({required this.index});
}
