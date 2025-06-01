import 'package:dio/dio.dart';

class RatingService {
  final Dio _dio;

  RatingService(this._dio);

  Map<String, dynamic> _handleApiResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    } else if (data is String) {
      if (data.isNotEmpty) {
        return {'success': true, 'message': data};
      } else {
        return {
          'success': true,
          'message': 'Operation successful, no specific message from API.'
        };
      }
    } else if (data == null) {
      return {
        'success': true,
        'message': 'Operation successful, no content from API.'
      };
    } else {
      return {'success': false, 'message': 'Unexpected API response format.'};
    }
  }

  Future<Map<String, dynamic>> addRating(String bookId, int rating) async {
    try {
      final response = await _dio.post(
        '/api/books/$bookId/rating',
        data: {'rating': rating},
      );
      return _handleApiResponse(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        return _handleApiResponse(e.response!.data);
      }
      return {
        'success': false,
        'message': e.message ?? 'Network error or unknown issue.'
      };
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred: $e'};
    }
  }

  /// Deletes a rating for a book.
  Future<Map<String, dynamic>> deleteRating(String bookId) async {
    try {
      final response = await _dio.delete('/api/books/$bookId/rating');
      return _handleApiResponse(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        return _handleApiResponse(e.response!.data);
      }
      return {
        'success': false,
        'message': e.message ?? 'Network error or unknown issue.'
      };
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred: $e'};
    }
  }
}
