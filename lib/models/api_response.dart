import 'package:anonymy/models/books.dart';

class ApiResponse{
  Object? data;
  String? error;
}


class BookResponse {
  List<Book> books;
  List<Book>? booksUnder100Pages;
  List<Book>? bookRate5;

  BookResponse({
    required this.books,
    this.booksUnder100Pages,
    this.bookRate5
  });

}