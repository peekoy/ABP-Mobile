// detail_book.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes/global_scaffold.dart';
import 'package:tubes/login_page.dart';
import 'package:tubes/provider/auth_provider.dart';
import 'package:tubes/review_book.dart';
import 'package:tubes/rating_book.dart';
import 'package:tubes/models/book_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailBookPage extends StatefulWidget {
  final String id;

  const DetailBookPage({super.key, required this.id});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  bool _isLoading = true;
  Book? _book;
  int _userRating = 0;

  @override
  void initState() {
    super.initState();
    _fetchBook(widget.id);
  }

  Future<void> _fetchBook(String id, {bool showLoading = true}) async {
    if (showLoading) {
      setState(() => _isLoading = true);
    }
    try {
      final response = await http.get(
          Uri.parse('https://j2146t42-5000.asse.devtunnels.ms/api/books/$id'));
      if (!mounted) return;
      if (response.statusCode == 200) {
        setState(() {
          _book = Book.fromJson(json.decode(response.body));
        });
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to load book data.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching book: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showRatingBottomSheet() {
    if (_book == null) return;

    final int initialRatingForSheet = _userRating;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => RatingBottomSheet(
        bookId: _book!.id,
        initialRating: initialRatingForSheet,
        onRatingChanged: (rating) {
          _fetchBook(widget.id, showLoading: false);
        },
      ),
    ).whenComplete(() {
      _fetchBook(widget.id, showLoading: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return GlobalScaffold(
      selectedIndex: 4,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _book == null
                ? const Center(child: Text('Book not found'))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _book!.bookImageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      _book!.bookImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Center(
                                              child:
                                                  Text('Image not available')),
                                    ),
                                  )
                                : const Center(child: Text('No image')),
                          ),
                          const SizedBox(height: 16),

                          // Book details
                          _buildDetailRow('Judul', _book!.title),
                          _buildDetailRow('Penulis', _book!.author),

                          // Publication date
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Publication',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _book!.published,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Format with pages
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Format',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _book!.format.isNotEmpty
                                        ? _book!.format
                                        : 'N/A',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Genre',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _book!.genre.isNotEmpty
                                        ? _book!.genre
                                        : 'N/A',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _buildDetailRow('ISBN', _book!.isbn),

                          const SizedBox(height: 16),

                          // Book description
                          Text(
                            _book!.description.isNotEmpty
                                ? _book!.description
                                : 'No description available.', // Use default if empty
                            style: const TextStyle(fontSize: 14),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              ...List.generate(5, (index) {
                                double rating = _book!.ratingTotal;
                                if (index < rating.floor()) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 24,
                                  );
                                } else if (index == rating.floor() &&
                                    rating % 1 != 0) {
                                  if (rating - index >= 0.75) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 24,
                                    );
                                  } else if (rating - index >= 0.25) {
                                    return const Icon(
                                      Icons.star_half,
                                      color: Colors.amber,
                                      size: 24,
                                    );
                                  } else {
                                    return const Icon(
                                      Icons.star_border,
                                      color: Colors.amber,
                                      size: 24,
                                    );
                                  }
                                } else {
                                  return const Icon(
                                    Icons.star_border,
                                    color: Colors.amber,
                                    size: 24,
                                  );
                                }
                              }),
                              const SizedBox(width: 8),
                              Text(
                                '${_book!.ratingTotal.toStringAsFixed(1)} (${_book!.ratingCount})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // --- Rate This Book Button ---
                          authProvider.isAuthenticated
                              ? SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: _showRatingBottomSheet,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      side:
                                          const BorderSide(color: Colors.black),
                                      textStyle: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: const Text(
                                      'Rate This Book',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              :
                              // Push into login page
                              SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      side:
                                          const BorderSide(color: Colors.black),
                                      textStyle: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: const Text(
                                      'Login to Rate',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),

                          // Review
                          ReviewBook(
                            bookId: _book!.id,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
