import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tubes/services/rating_service.dart';

class RatingViewModel extends ChangeNotifier {
  final RatingService _ratingService = GetIt.instance<RatingService>();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _ratingResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get ratingResponse => _ratingResponse;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setRatingResponse(Map<String, dynamic> response) {
    _ratingResponse = response;
    notifyListeners();
  }

  /// Adds a rating for a given book.
  // Changed bookId type from int to String
  Future<void> addRating(String bookId, int rating) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      // You'll need to update your RatingService.addRating to accept String bookId
      final response = await _ratingService.addRating(bookId, rating);
      _setRatingResponse(response);
      if (response['success'] == false) {
        _setErrorMessage(response['message'] ?? 'Failed to add rating.');
      }
    } catch (e) {
      _setErrorMessage("Failed to add rating: $e");
      print('Error adding rating: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Deletes a rating for a given book.
  // Changed bookId type from int to String
  Future<void> deleteRating(String bookId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      // You'll need to update your RatingService.deleteRating to accept String bookId
      final response = await _ratingService.deleteRating(bookId);
      _setRatingResponse(response);
      if (response['success'] == false) {
        _setErrorMessage(response['message'] ?? 'Failed to delete rating.');
      }
    } catch (e) {
      _setErrorMessage("Failed to delete rating: $e");
      print('Error deleting rating: $e');
    } finally {
      _setLoading(false);
    }
  }

  void clearState() {
    _isLoading = false;
    _errorMessage = null;
    _ratingResponse = null;
    notifyListeners();
  }
}
