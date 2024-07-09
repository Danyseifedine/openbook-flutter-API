import 'dart:convert';

import 'package:anonymy/constant/constant.dart';
import 'package:anonymy/models/api_response.dart'; // Assuming you have ApiResponse defined
import 'package:anonymy/models/books.dart';
import 'package:anonymy/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getBooks() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(getAllBooks),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    switch (response.statusCode) {
      case 200:
        var jsonData = jsonDecode(response.body);

        // Retrieve books and books_under_100_pages from JSON
        List<Book> books = (jsonData['books'] as List)
            .map((p) => Book.fromJson(p))
            .toList();


        List<Book> booksUnder100Pages = (jsonData['books_under_100_pages'] as List)
              .map((p) => Book.fromJson(p))
              .toList();

        List<Book> booksRate5 = (jsonData['books_rate_5'] as List)
            .map((p) => Book.fromJson(p))
            .toList();

        BookResponse bookResponse = BookResponse(
          books: books,
          booksUnder100Pages: booksUnder100Pages,
          bookRate5: booksRate5
        );

        // Assign BookResponse to apiResponse.data
        apiResponse.data = bookResponse;
        break;

      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors;
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}
