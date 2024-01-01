class SourceModel {
  final String url;
  final bool isM3U8;
  final String quality;

  SourceModel({
    required this.url,
    required this.isM3U8,
    required this.quality,
  });

  SourceModel.fromJson(Map<String, dynamic> json)
    : url = json['url'],
      isM3U8 = json['isM3U8'],
      quality = json['quality'];
}
