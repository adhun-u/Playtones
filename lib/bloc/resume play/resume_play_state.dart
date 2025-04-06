part of 'resume_play_bloc.dart';

sealed class ResumePlayState extends Equatable {
  const ResumePlayState();

  @override
  List<Object> get props => [];
}

final class ResumePlayInitial extends ResumePlayState {}

final class ErrorState extends ResumePlayState {
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
  const ErrorState({required this.errorMessage});
}
