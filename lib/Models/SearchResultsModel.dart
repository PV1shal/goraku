class SearchResultsModel {
  late String id;
  late String title;
  late String url;
  late String image;
  late String releaseDate;
  late String subOrDub;

  SearchResultsModel({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
    required this.releaseDate,
    required this.subOrDub,
  });

  SearchResultsModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        url = json['url'],
        image = json['image'],
        releaseDate = json['releaseDate'],
        subOrDub = json['subOrDub'];
}
