import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:playtones/models/most%20played/most_played_model.dart';
import 'package:playtones/services/database/most_played_list.dart';
part 'most_played_event.dart';
part 'most_played_state.dart';

class MostPlayedBloc extends Bloc<MostPlayedEvent, MostPlayedState> {
  MostPlayedBloc() : super(MostPlayedInitial()) {
    on<AddMostPlayedSongEvent>(addData);
    on<GetMostPlayedSongEvent>(getSong);
    on<DeleteAllMostSongs>(deleteAll);
  }
  //Adding Data to database
  Future<void> addData(
    AddMostPlayedSongEvent event,
    Emitter<MostPlayedState> emit,
  ) async {
    List<MostPlayedModel> models = [];
    Iterable<MostPlayedModel> songDetails = await MostPlayedListDB().getSong();
    for (var songDetail in songDetails) {
      models.add(songDetail);
    }
    //Checking if the song is in database to increase count
    bool exist = models.any((songDetail) => songDetail.songId == event.songId);
    if (exist) {
      //Getting the specific model to increase count
      MostPlayedModel mostPlayedModel = models.firstWhere(
        (songDetail) => songDetail.songId == event.songId,
      );
      final model = MostPlayedModel(
        songId: event.songId,
        count: mostPlayedModel.count + 1,
        title: event.title,
        artist: event.artist,
      );
      await MostPlayedListDB().addSongs(model, event.songId);
    } else {
      final model = MostPlayedModel(
        songId: event.songId,
        count: 1,
        title: event.title,
        artist: event.artist,
      );
      await MostPlayedListDB().addSongs(model, event.songId);
    }
  }

  //Getting the model to show song details
  Future<void> getSong(
    GetMostPlayedSongEvent event,
    Emitter<MostPlayedState> emit,
  ) async {
    emit(LoadingMostPlayed());
    List<MostPlayedModel> models = [];
    //Getting the details from database
    Iterable<MostPlayedModel> songDetails = await MostPlayedListDB().getSong();
    for (var songDetail in songDetails) {
      models.add(songDetail);
    }
    //Sorting to get the song which is played most
    models.sort(
      (fistModel, secondModel) => secondModel.count.compareTo(fistModel.count),
    );
    emit(GetMostPlayedSongState(mostPlayedSongs: models));
  }

  //Deleting all songs
  Future<void> deleteAll(
    DeleteAllMostSongs event,
    Emitter<MostPlayedState> emit,
  ) async {
    await MostPlayedListDB().deleteAll();
    emit(GetMostPlayedSongState(mostPlayedSongs: []));
  }
}
