part of 'most_played_bloc.dart';

sealed class MostPlayedState extends Equatable {
  const MostPlayedState();

  @override
  List<Object> get props => [];
}

final class MostPlayedInitial extends MostPlayedState {}

//Loading state
final class LoadingMostPlayed extends MostPlayedState {}

//Get most played songs state
final class GetMostPlayedSongState extends MostPlayedState {
  final List<MostPlayedModel> mostPlayedSongs;
  const GetMostPlayedSongState({required this.mostPlayedSongs});
  @override
  List<Object> get props => [mostPlayedSongs];
}
