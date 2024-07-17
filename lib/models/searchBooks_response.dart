import 'package:anonymy/models/books.dart';

class SearchBookResponse {
  final List<Book> searchResults;

  SearchBookResponse({required this.searchResults});

  factory SearchBookResponse.fromJson(Map<String, dynamic> json) {
    return SearchBookResponse(
      searchResults: (json['search_results'] as List)
          .map((p) => Book.fromJson(p))
          .toList(),
    );
  }
}