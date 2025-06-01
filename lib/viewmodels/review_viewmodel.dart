import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tubes/services/review_service.dart';
import 'package:tubes/services/auth_service.dart';
import 'package:tubes/services/user_service.dart';

class ReviewViewModel extends ChangeNotifier {
  final ReviewService _reviewService = GetIt.instance<ReviewService>();
  final AuthService _authService = GetIt.instance<AuthService>();
  final UserService _userService = GetIt.instance<UserService>();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _reviewOperationResponse;
  List<Map<String, dynamic>> _allReviewsForBook = [];
  Map<String, dynamic>? _currentUserData; // Still keep for userReview getter
  List<Map<String, dynamic>> _allUsersData = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get reviewOperationResponse => _reviewOperationResponse;
  List<Map<String, dynamic>> get allReviewsForBook => _allReviewsForBook;
  Map<String, dynamic>? get currentUserData => _currentUserData;

  Map<String, dynamic>? get userReview {
    if (_currentUserData == null || _currentUserData!['id'] == null) {
      return null;
    }
    final userId = _currentUserData!['id'];
    return _allReviewsForBook
        .firstWhereOrNull((review) => review['userId'] == userId);
  }

  bool get hasUserReviewed {
    return userReview != null;
  }

  List<Map<String, dynamic>> get otherReviews {
    final List<Map<String, dynamic>> resultReviews = _allReviewsForBook
        .map((review) => _mapReviewToDisplay(review))
        .toList();

    return resultReviews;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setReviewOperationResponse(Map<String, dynamic> response) {
    _reviewOperationResponse = response;
    notifyListeners();
  }

  void _setAllReviewsForBook(List<Map<String, dynamic>> reviews) {
    _allReviewsForBook = reviews;
    notifyListeners();
  }

  void _setCurrentUserData(Map<String, dynamic>? userData) {
    _currentUserData = userData;
  }

  void _setAllUsersData(List<Map<String, dynamic>> users) {
    _allUsersData = users;
  }

  // _mapReviewToDisplay can stay the same as it's already generic
  Map<String, dynamic> _mapReviewToDisplay(Map<String, dynamic> review) {
    final userId = review['userId'];
    final user =
        _allUsersData.firstWhereOrNull((userData) => userData['id'] == userId);

    return {
      ...review,
      'displayName': user?['displayName'] ?? 'Unknown User',
      'profileImageUrl': user?['profileImageUrl'] ?? '',
    };
  }

  Future<void> initializeReviewSection(String bookId) async {
    if (_isLoading) return;

    _setLoading(true);
    _setErrorMessage(null);
    _reviewOperationResponse = null;

    try {
      _currentUserData = await _authService.getUserData();
      _setCurrentUserData(_currentUserData);

      _allUsersData = await _userService.getAllUsers();
      _setAllUsersData(_allUsersData);

      final List<Map<String, dynamic>> reviewsList =
          await _reviewService.getReviewsForBook(bookId);

      _setAllReviewsForBook(reviewsList);
    } catch (e) {
      _setErrorMessage("Failed to initialize review data: $e");
      print('Error initializing review data: $e');
      _setAllReviewsForBook([]);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addReview(String bookId, String reviewText) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final response = await _reviewService.addReview(bookId, reviewText);
      _setReviewOperationResponse(response);
      if (response['success'] == false) {
        _setErrorMessage(response['message'] ?? 'Failed to add review.');
      } else {
        await initializeReviewSection(bookId);
      }
    } catch (e) {
      _setErrorMessage("Failed to add review: $e");
      print('Error adding review: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteReview(String reviewId, String bookId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final response = await _reviewService.deleteReview(bookId);
      _setReviewOperationResponse(response);
      if (response['success'] == false) {
        _setErrorMessage(response['message'] ?? 'Failed to delete review.');
      } else {
        await initializeReviewSection(bookId);
      }
    } catch (e) {
      _setErrorMessage("Failed to delete review: $e");
      print('Error deleting review: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateReview(
      String reviewId, String reviewText, String bookId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final response = await _reviewService.updateReview(bookId, reviewText);
      _setReviewOperationResponse(response);
      if (response['success'] == false) {
        _setErrorMessage(response['message'] ?? 'Failed to update review.');
      } else {
        await initializeReviewSection(bookId);
      }
    } catch (e) {
      _setErrorMessage("Failed to update review: $e");
      print('Error updating review: $e');
    } finally {
      _setLoading(false);
    }
  }

  void clearOperationState() {
    _isLoading = false;
    _errorMessage = null;
    _reviewOperationResponse = null;
    notifyListeners();
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
