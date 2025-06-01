import 'package:dio/dio.dart';

class ReviewService {
  final Dio _dio;

  ReviewService(this._dio);

  // Add a new review
  Future<Map<String, dynamic>> addReview(String bookId, String review) async {
    try {
      final response = await _dio.post('/api/books/$bookId/review', data: {
        'review': review,
      });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Error adding review: $e');
      return {};
    }
  }

  // Delete a review
  Future<Map<String, dynamic>> deleteReview(String bookId) async {
    try {
      final response = await _dio.delete('/api/books/$bookId/review');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Error deleting review: $e');
      return {};
    }
  }

  // Update a review
  Future<Map<String, dynamic>> updateReview(
      String bookId, String review) async {
    try {
      final response = await _dio.put('/api/books/$bookId/review', data: {
        'review': review,
      });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Error updating review: $e');
      return {};
    }
  }

  // Get a specific review
  Future<List<Map<String, dynamic>>> getReviewsForBook(String bookId) async {
    try {
      final response = await _dio.get('/api/books/$bookId/review');
      if (response.data is List) {
        return (response.data as List<dynamic>)
            .whereType<Map<String, dynamic>>()
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        print('Review API returned a single map, wrapping in a list.');
        return [response.data as Map<String, dynamic>];
      } else {
        print(
            'Error: Review API returned unexpected data type: ${response.data.runtimeType}');
        return [];
      }
    } catch (e) {
      print('Error getting review for book $bookId: $e');
      return [];
    }
  }
}
