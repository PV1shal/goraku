import 'package:goraku/Models/SourceModel.dart';

class WatchEpisodeModel {
  final List<SourceModel> sources;
  WatchEpisodeModel({required this.sources});

  WatchEpisodeModel.fromJson(Map<String, dynamic> json)
      : sources = List<SourceModel>.from(
            json['sources'].map((source) => SourceModel.fromJson(source)));
}
