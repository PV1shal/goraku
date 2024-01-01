class EpisodeModel {
  final String id;
  final String episodeId;
  final int episodeNumber;
  final String title;
  final String image;
  final String url;

  EpisodeModel({
    required this.id,
    required this.episodeId,
    required this.episodeNumber,
    required this.title,
    required this.image,
    required this.url,
  });

  EpisodeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        episodeId = json['episodeId'],
        episodeNumber = json['episodeNumber'],
        title = json['title'],
        image = json['image'],
        url = json['url'];
}
