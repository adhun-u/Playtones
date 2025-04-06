part of 'recently_played_bloc.dart';

sealed class RecentlyPlayedState extends Equatable {
  const RecentlyPlayedState();

  @override
  List<Object> get props => [];
}

final class RecentlyPlayedInitial extends RecentlyPlayedState {}

//Gretting all recent songs state
final class GetRecentSongs extends RecentlyPlayedState {
  final List<RecentlyPlayedListModel> songs;
  const GetRecentSongs({required this.songs});
  @override
  List<Object> get props => [songs];
}

//Loading state
final class LoadingRecentState extends RecentlyPlayedState {}
