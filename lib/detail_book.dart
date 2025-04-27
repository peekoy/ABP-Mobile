import 'package:flutter/material.dart';
import 'package:tubes/global_scaffold.dart';
import 'package:tubes/review_book.dart';
import 'package:tubes/rating_book.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchBook(widget.id);
  }

  Future<void> _fetchBook(String id) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
          Uri.parse('https://j2146t42-5000.asse.devtunnels.ms/api/books/$id'));
      if (!mounted) return;
      if (response.statusCode == 200) {
        setState(() => _book = Book.fromJson(json.decode(response.body)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching book: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int _userRating = 0;

  void _showRatingBottomSheet() {
    if (_book == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => RatingBottomSheet(
        bookId: _book!.id,
        initialRating: _userRating,
        onRatingChanged: (rating) {
          setState(() {
            _userRating = rating;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                    '460 pages,\nPaperback',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Genre with multiple lines
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
                                    'Fiction Fantasy\nClassic Adventure\nMagical Realism',
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
                                : 'Life of Pi is a fantasy adventure novel by Yann Martel published in 2001. The protagonist, Piscine Molitor "Pi" Patel, a Tamil boy from Pondicherry, explores issues of spirituality and practicality from an early age. He survives 227 days after a shipwreck while stranded on a boat in the Pacific Ocean with a Bengal tiger named Richard Parker.',
                            style: const TextStyle(fontSize: 14),
                          ),

                          const SizedBox(height: 16),

                          // Rating
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (index) => Icon(
                                  index < (_book!.ratingTotal)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${(_book!.ratingCount)})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          // --- Rate This Book Button ---
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _showRatingBottomSheet,
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: Colors.grey),
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text('Rate This Book'),
                            ),
                          ),

                          // Review
                          ReviewBook(),
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

class Book {
  final String id;
  final String title;
  final String author;
  final String published;
  final String genre;
  final String format;
  final String isbn;
  final String description;
  final String bookImageUrl;
  final double ratingTotal;
  final int ratingCount;

  Book({
    this.id = '',
    this.title = '',
    this.author = '',
    this.published = '',
    this.genre = '',
    this.format = '',
    this.isbn = '',
    this.description = '',
    this.bookImageUrl = '',
    this.ratingTotal = 0.0,
    this.ratingCount = 0,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        author: json['author'] ?? '',
        published: json['published'] ?? '',
        genre: json['genre'] ?? '',
        format: json['format'] ?? '',
        isbn: json['isbn'] ?? '',
        description: json['description'] ?? '',
        bookImageUrl: json['bookImageUrl'] ?? '',
        ratingTotal: (json['ratingTotal'] ?? 0.0).toDouble(),
        ratingCount: json['ratingCount'] ?? 0,
      );
}
