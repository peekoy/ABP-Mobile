import 'package:flutter/material.dart';
import 'package:tubes/global_scaffold.dart';
import 'package:tubes/detail_book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
  bool _isLoading = false;
  List<Book> _books = [];
  bool _booksFound = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
            'https://j2146t42-5000.asse.devtunnels.ms/api/books/recommendation'),
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _books = data.map((book) => Book.fromJson(book)).toList();
          _booksFound = _books.isNotEmpty;
        });
      } else {
        setState(() => _booksFound = false);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching books: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleClickBook(Book book) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBookPage(id: book.id),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      selectedIndex: 2,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _booksFound
                    ? 'Recommended books for you'
                    : 'No recommended books found.',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _booksFound
                        ? ListView.builder(
                            itemCount: _books.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: BookCard(
                                book: _books[index],
                                onTap: () => _handleClickBook(_books[index]),
                              ),
                            ),
                          )
                        : const Center(
                            child: Text(
                              'No recommended books found.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Book {
  final String id,
      title,
      author,
      published,
      genre,
      format,
      isbn,
      description,
      bookImageUrl;
  final double ratingTotal;
  final int ratingCount;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.published,
    required this.genre,
    required this.format,
    required this.isbn,
    required this.description,
    required this.bookImageUrl,
    required this.ratingTotal,
    required this.ratingCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        published: json['published'],
        genre: json['genre'],
        format: json['format'],
        isbn: json['isbn'],
        description: json['description'],
        bookImageUrl: json['bookImageUrl'],
        ratingTotal: (json['ratingTotal'] ?? 0.0).toDouble(),
        ratingCount: json['ratingCount'] ?? 0,
      );
}

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                book.bookImageUrl,
                width: 140,
                height: 210,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 140,
                  height: 210,
                  color: Colors.grey,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${book.title} - ${book.author}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
