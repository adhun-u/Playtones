part of 'resume_play_bloc.dart';

sealed class ResumePlayEvent extends Equatable {
  const ResumePlayEvent();

  @override
  List<Object> get props => [];
}

final class PlayWhereStoppedEvent extends ResumePlayEvent {}
