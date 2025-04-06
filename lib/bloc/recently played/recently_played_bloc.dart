import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playtones/models/recent%20model/recently_played_list.dart';
import 'package:playtones/services/database/recently_played_list.dart';
part 'recently_played_event.dart';
part 'recently_played_state.dart';

class RecentlyPlayedBloc
    extends Bloc<RecentlyPlayedEvent, RecentlyPlayedState> {
  final audioQuery = OnAudioQuery();
  RecentlyPlayedBloc() : super(RecentlyPlayedInitial()) {
    on<AddData>(addData);
    on<GetSongsEvent>(getSongs);
    on<DeleteAllRecent>(deleteAllSongs);
  }
  //Adding song id to database
  void addData(AddData event, Emitter<RecentlyPlayedState> emit) async {
    await RecentlyPlayedDB().addSong(
      event.songId,
      event.time,
      event.title,
      event.artist,
    );
  }

  //Getting all songs according to song id
  void getSongs(GetSongsEvent event, Emitter<RecentlyPlayedState> emit) async {
    List<RecentlyPlayedListModel> models = [];
    emit(LoadingRecentState());
    //Fetching all ids from database
    Iterable<RecentlyPlayedListModel> songDetails =
        await RecentlyPlayedDB().getSongDetails();

    //Adding songdetails to model
    for (var recentSong in songDetails) {
      models.add(recentSong);
    }
    //sorting descending order of gettin lates played song
    models.sort((firstModel, secondModel) {
      return secondModel.time!.compareTo(firstModel.time!);
    });
    emit(GetRecentSongs(songs: models));
  }

  //Delete all songs
  Future<void> deleteAllSongs(
    DeleteAllRecent event,
    Emitter<RecentlyPlayedState> emit,
  ) async {
    await RecentlyPlayedDB().deleteAll();
    emit(GetRecentSongs(songs: []));
  }
}
