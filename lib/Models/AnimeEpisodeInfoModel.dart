import 'package:goraku/Models/EpisodeModel.dart';

class AnimeEpisodeInfoModel {
  late final String id;
  late final String title;
  late final String url;
  late final List<String> genres;
  late final int totalEpisodes;
  late final String image;
  late final String releaseDate;
  late final String description;
  late final String subOrDub;
  late final String type;
  late final String status;
  late final String otherName;
  late final List<EpisodeModel> episodes;

  AnimeEpisodeInfoModel({
    required this.id,
    required this.title,
    required this.url,
    required this.genres,
    required this.totalEpisodes,
    required this.image,
    required this.releaseDate,
    required this.description,
    required this.subOrDub,
    required this.type,
    required this.status,
    required this.otherName,
    required List<dynamic> episodes,
  }) : episodes = _transformEpisodeList(id, title, image, url, episodes);

  static List<EpisodeModel> _transformEpisodeList(
    String id,
    String title,
    String image,
    String url,
    List<dynamic> episodes,
  ) {
    return episodes.map<EpisodeModel>((episode) {
      return EpisodeModel(
        id: id,
        episodeId: episode['id'],
        episodeNumber: episode['number'],
        title: title,
        image: image,
        url: url,
      );
    }).toList();
  }

  AnimeEpisodeInfoModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          url: json['url'],
          genres: json['genres'].cast<String>(),
          totalEpisodes: json['totalEpisodes'],
          image: json['image'],
          releaseDate: json['releaseDate'],
          description: json['description'],
          subOrDub: json['subOrDub'],
          type: json['type'],
          status: json['status'],
          otherName: json['otherName'],
          episodes: json['episodes'],
        );
}
