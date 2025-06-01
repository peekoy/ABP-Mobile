import 'package:flutter/foundation.dart';
import 'package:tubes/services/book_service.dart';
import 'package:tubes/models/book_model.dart';

class BookViewModel extends ChangeNotifier {
  final BookService _bookService;

  BookViewModel({required BookService bookService})
      : _bookService = bookService;

  // --- State Variables ---
  bool _isLoadingAllBooks = false;
  List<Book> _allBooks = []; // Changed type to List<Book>
  String _allBooksErrorMessage = '';

  bool _isLoadingBookDetails = false;
  Book?
      _bookDetails; // Changed type to Book?, nullable as it might not be loaded
  String _bookDetailsErrorMessage = '';

  bool _isLoadingSearchResults = false;
  List<Book> _searchResults = []; // Changed type to List<Book>
  String _searchResultsErrorMessage = '';

  bool _isLoadingRecommendedBooks = false;
  List<Book> _recommendedBooks = []; // Changed type to List<Book>
  String _recommendedBooksErrorMessage = '';

  bool _isLoadingUpcomingBooks = false;
  List<Book> _upcomingBooks = []; // Changed type to List<Book>
  String _upcomingBooksErrorMessage = '';

  bool _isLoadingHomeBooks = false;
  Book? _homeBook; // Changed type to Book?, nullable
  String _homeBooksErrorMessage = '';

  // --- Getters to access state from UI ---
  bool get isLoadingAllBooks => _isLoadingAllBooks;
  List<Book> get allBooks => _allBooks;
  String get allBooksErrorMessage => _allBooksErrorMessage;

  bool get isLoadingBookDetails => _isLoadingBookDetails;
  Book? get bookDetails => _bookDetails; // Getter returns Book?
  String get bookDetailsErrorMessage => _bookDetailsErrorMessage;

  bool get isLoadingSearchResults => _isLoadingSearchResults;
  List<Book> get searchResults => _searchResults;
  String get searchResultsErrorMessage => _searchResultsErrorMessage;

  bool get isLoadingRecommendedBooks => _isLoadingRecommendedBooks;
  List<Book> get recommendedBooks => _recommendedBooks;
  String get recommendedBooksErrorMessage => _recommendedBooksErrorMessage;

  bool get isLoadingUpcomingBooks => _isLoadingUpcomingBooks;
  List<Book> get upcomingBooks => _upcomingBooks;
  String get upcomingBooksErrorMessage => _upcomingBooksErrorMessage;

  bool get isLoadingHomeBooks => _isLoadingHomeBooks;
  Book? get homeBook => _homeBook; // Getter returns Book?
  String get homeBooksErrorMessage => _homeBooksErrorMessage;

  // --- Methods to interact with the service and update state ---

  Future<void> fetchAllBooks() async {
    _isLoadingAllBooks = true;
    _allBooksErrorMessage = '';
    notifyListeners();

    try {
      _allBooks = await _bookService.getAllBooks();
      _allBooksErrorMessage = _allBooks.isEmpty ? 'No books found.' : '';
    } catch (e) {
      _allBooks = [];
      _allBooksErrorMessage = 'Failed to load all books: ${e.toString()}';
      print('Error in BookViewModel.fetchAllBooks: $e');
    } finally {
      _isLoadingAllBooks = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookDetails(String bookId) async {
    _isLoadingBookDetails = true;
    _bookDetailsErrorMessage = '';
    _bookDetails = null; // Set to null before fetching
    notifyListeners();

    try {
      _bookDetails = await _bookService.getBookDetails(bookId);
      // Check if the fetched book has a valid ID, or adjust based on your service's error return
      if (_bookDetails?.id == bookId) {
        _bookDetailsErrorMessage = ''; // No error
      } else {
        _bookDetailsErrorMessage = 'Book details not found for ID: $bookId';
        _bookDetails = null; // Ensure it's null if not found
      }
    } catch (e) {
      _bookDetails = null;
      _bookDetailsErrorMessage = 'Failed to load book details: ${e.toString()}';
      print('Error in BookViewModel.fetchBookDetails: $e');
    } finally {
      _isLoadingBookDetails = false;
      notifyListeners();
    }
  }

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _searchResultsErrorMessage = 'Please enter a search query.';
      notifyListeners();
      return;
    }

    _isLoadingSearchResults = true;
    _searchResultsErrorMessage = '';
    notifyListeners();

    try {
      _searchResults = await _bookService.searchBooks(query);
      _searchResultsErrorMessage =
          _searchResults.isEmpty ? 'No books found for "$query".' : '';
    } catch (e) {
      _searchResults = [];
      _searchResultsErrorMessage = 'Failed to search books: ${e.toString()}';
      print('Error in BookViewModel.performSearch: $e');
    } finally {
      _isLoadingSearchResults = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecommendedBooks() async {
    _isLoadingRecommendedBooks = true;
    _recommendedBooksErrorMessage = '';
    notifyListeners();

    try {
      _recommendedBooks = await _bookService.getRecommendedBooks();
      _recommendedBooksErrorMessage =
          _recommendedBooks.isEmpty ? 'No recommended books found.' : '';
    } catch (e) {
      _recommendedBooks = [];
      _recommendedBooksErrorMessage =
          'Failed to load recommended books: ${e.toString()}';
      print('Error in BookViewModel.fetchRecommendedBooks: $e');
    } finally {
      _isLoadingRecommendedBooks = false;
      notifyListeners();
    }
  }

  Future<void> fetchUpcomingBooks() async {
    _isLoadingUpcomingBooks = true;
    _upcomingBooksErrorMessage = '';
    notifyListeners();

    try {
      _upcomingBooks = await _bookService.getUpcomingBooks();
      _upcomingBooksErrorMessage =
          _upcomingBooks.isEmpty ? 'No upcoming books found.' : '';
    } catch (e) {
      _upcomingBooks = [];
      _upcomingBooksErrorMessage =
          'Failed to load upcoming books: ${e.toString()}';
      print('Error in BookViewModel.fetchUpcomingBooks: $e');
    } finally {
      _isLoadingUpcomingBooks = false;
      notifyListeners();
    }
  }

  Future<void> fetchHomeBook() async {
    _isLoadingHomeBooks = true;
    _homeBooksErrorMessage = '';
    _homeBook = null; // Set to null before fetching
    notifyListeners();

    try {
      final List<Book> books = await _bookService.getHomeBooks();
      if (books.isNotEmpty) {
        _homeBook = books.first;
        _homeBooksErrorMessage = '';
      } else {
        _homeBook = null;
        _homeBooksErrorMessage = 'No feature review book found.';
      }
    } catch (e) {
      _homeBook = null;
      _homeBooksErrorMessage =
          'Failed to load feature review book: ${e.toString()}';
      print('Error in BookViewModel.fetchHomeBook: $e');
    } finally {
      _isLoadingHomeBooks = false;
      notifyListeners();
    }
  }

  void clearSearchResults() {
    _searchResults = [];
    _searchResultsErrorMessage = '';
    notifyListeners();
  }
}
