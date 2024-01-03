import 'package:goraku/Models/SearchResultsModel.dart';

class SearchMetaModel {
  final int currentPage;
  final bool hasNextPage;
  final List<SearchResultsModel> results;

  SearchMetaModel(
      {required this.currentPage,
      required this.hasNextPage,
      required this.results});

  SearchMetaModel.fromJson(Map<String, dynamic> json)
      : currentPage = json['currentPage'],
        hasNextPage = json['hasNextPage'],
        results = json['results']
            .map<SearchResultsModel>(
                (result) => SearchResultsModel.fromJson(result))
            .toList();
}
