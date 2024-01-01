import 'package:goraku/Models/EpisodeModel.dart';

class RecentEpisodesModel {
  final String currentPage;
  final bool hasNextPage;
  final List<EpisodeModel> episodes;

  RecentEpisodesModel({
    required this.currentPage,
    required this.hasNextPage,
    required this.episodes
  });

  RecentEpisodesModel.fromJson(Map<String, dynamic> json)
    : currentPage = json['currentPage'],
      hasNextPage = json['hasNextPage'],
      episodes = List<EpisodeModel>.from(json['results'].map((episode) => EpisodeModel.fromJson(episode)));
}
