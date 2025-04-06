part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

//Initial state
final class FavoriteInitial extends FavoriteState {}

//Success state
final class SuccessState extends FavoriteState {
  final String message;
  const SuccessState({required this.message});
}

//Getting favorite songs state
final class GetSongsState extends FavoriteState {
  final List<SongModel> songs;
  const GetSongsState({required this.songs});

  @override
  List<Object> get props => [songs];
}

final class ErrorState extends FavoriteState {
  final String errorMessage;
  const ErrorState({required this.errorMessage});
}
