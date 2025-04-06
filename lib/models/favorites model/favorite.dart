import 'package:hive_flutter/adapters.dart';
part 'favorite.g.dart';

@HiveType(typeId: 1)
class FavoriteModel {
  @HiveField(0)
  int songId;

  FavoriteModel({required this.songId});
}
