import 'package:dio/dio.dart';
import 'package:tubes/models/book_model.dart';

class BookService {
  final Dio _dio;

  BookService(this._dio);

  // Helper function to safely parse a list of dynamic to a list of Books
  List<Book> _parseBookList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => Book.fromJson(json))
          .toList();
    }
    if (data is Map<String, dynamic>) {
      // If API returns a single map but we expect a list (e.g., for home book)
      return [Book.fromJson(data)];
    }
    return [];
  }

  // Helper function to safely parse a single book map to a Book object
  Book _parseBook(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Book.fromJson(data);
    }
    // If the API returns a list with one item for details, take the first
    if (data is List && data.isNotEmpty) {
      return Book.fromJson(data[0] as Map<String, dynamic>);
    }
    throw const FormatException(
        'Expected a Map or non-empty List for Book details.');
  }

  Future<List<Book>> getAllBooks() async {
    try {
      final response = await _dio.get('/api/books');
      return _parseBookList(response.data);
    } catch (e) {
      print('Error fetching all books: $e');
      return [];
    }
  }

  Future<Book> getBookDetails(String bookId) async {
    try {
      final response = await _dio.get('/api/books/$bookId');
      return _parseBook(response.data);
    } catch (e) {
      print('Error fetching book details: $e');
      // Return a dummy book or throw an error based on your error handling strategy
      // For now, return a basic book with the given ID
      return Book(id: bookId, title: 'Error Loading Book');
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await _dio.get('/api/books/search?q=$query');
      return _parseBookList(response.data);
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }

  Future<List<Book>> getRecommendedBooks() async {
    try {
      final response = await _dio.get('/api/books/recommendation');
      return _parseBookList(response.data);
    } catch (e) {
      print('Error fetching recommended books: $e');
      return [];
    }
  }

  Future<List<Book>> getUpcomingBooks() async {
    try {
      final response = await _dio.get('/api/books/upcoming');
      return _parseBookList(response.data);
    } catch (e) {
      print('Error fetching upcoming books: $e');
      return [];
    }
  }

  Future<List<Book>> getHomeBooks() async {
    try {
      final response = await _dio.get('/api/books/home');
      return _parseBookList(response.data);
    } catch (e) {
      print('Error fetching home books: $e');
      return [];
    }
  }
}
