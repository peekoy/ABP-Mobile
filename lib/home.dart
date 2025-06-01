import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes/detail_book.dart';
import 'package:tubes/global_scaffold.dart';
import 'package:tubes/viewmodels/book_viewmodel.dart';
import 'package:tubes/models/book_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  // Your navigation function
  void _handleClickBook(Book book) {
    if (book.id.isNotEmpty) {
      // Ensure book has an ID to navigate
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBookPage(id: book.id),
        ),
      );
    } else {
      // Optionally show a snackbar or alert if ID is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book ID not available.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookViewModel = Provider.of<BookViewModel>(context, listen: false);
      bookViewModel.fetchHomeBook();
      bookViewModel.fetchRecommendedBooks();
      bookViewModel.fetchUpcomingBooks();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      selectedIndex: 0,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Feature Review",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // --- Feature Review Section ---
            Consumer<BookViewModel>(
              builder: (context, bookViewModel, child) {
                if (bookViewModel.isLoadingHomeBooks) {
                  return Center(child: CircularProgressIndicator());
                } else if (bookViewModel.homeBooksErrorMessage.isNotEmpty) {
                  return Center(
                      child: Text(
                          'Error: ${bookViewModel.homeBooksErrorMessage}'));
                } else if (bookViewModel.homeBook == null ||
                    bookViewModel.homeBook!.id.isEmpty) {
                  // Check for null and empty ID
                  return Center(child: Text('No feature book available.'));
                } else {
                  final book = bookViewModel
                      .homeBook!; // Use ! as we've checked for null
                  return GestureDetector(
                    onTap: () =>
                        _handleClickBook(book), // Add onTap for navigation
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 120, // Increased width for larger image
                            height: 180, // Increased height for larger image
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: Image.network(
                                book.bookImageUrl ??
                                    'assets/placeholder.png', // Use book.bookImageUrl
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/placeholder.png',
                                      fit: BoxFit.cover);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title, // Use book.title
                                    style: const TextStyle(
                                      fontSize: 18, // Slightly larger title
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2, // Allow title to wrap
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "by ${book.author ?? 'N/A'}", // Use book.author
                                    style: const TextStyle(
                                      fontSize: 15, // Slightly larger author
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        "${book.ratingTotal} Rating", // Use book.averageRating, book.ratingCount
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 60,
                                    ),
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Scrollbar(
                                      controller: _scrollController,
                                      thumbVisibility: true,
                                      child: SingleChildScrollView(
                                        padding:
                                            const EdgeInsets.only(right: 14),
                                        controller: _scrollController,
                                        child: Text(
                                          book.description ??
                                              'No description available.', // Use book.description
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
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
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Recommended Books",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // --- Recommended Books Section ---
            Consumer<BookViewModel>(
              builder: (context, bookViewModel, child) {
                if (bookViewModel.isLoadingRecommendedBooks) {
                  return Center(child: CircularProgressIndicator());
                } else if (bookViewModel
                    .recommendedBooksErrorMessage.isNotEmpty) {
                  return Center(
                      child: Text(
                          'Error: ${bookViewModel.recommendedBooksErrorMessage}'));
                } else if (bookViewModel.recommendedBooks.isEmpty) {
                  return Center(child: Text('No recommended books available.'));
                } else {
                  return SizedBox(
                    height: 250, // Increased height for larger images
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bookViewModel.recommendedBooks.length,
                      itemBuilder: (context, index) {
                        final book = bookViewModel.recommendedBooks[index];
                        return GestureDetector(
                          onTap: () => _handleClickBook(
                              book), // Add onTap for navigation
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      150, // Increased width for larger images
                                  height:
                                      200, // Increased height for larger images
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      book.bookImageUrl ??
                                          'assets/placeholder.png',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/placeholder.png',
                                            fit: BoxFit.cover);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 150, // Match image width
                                  child: Text(
                                    book.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13, // Slightly larger font
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 150, // Match image width
                                  child: Text(
                                    book.author ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 12, // Slightly larger font
                                      color: Colors.grey.shade700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Upcoming Books",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // --- Upcoming Books Section ---
            Consumer<BookViewModel>(
              builder: (context, bookViewModel, child) {
                if (bookViewModel.isLoadingUpcomingBooks) {
                  return Center(child: CircularProgressIndicator());
                } else if (bookViewModel.upcomingBooksErrorMessage.isNotEmpty) {
                  return Center(
                      child: Text(
                          'Error: ${bookViewModel.upcomingBooksErrorMessage}'));
                } else if (bookViewModel.upcomingBooks.isEmpty) {
                  return Center(child: Text('No upcoming books available.'));
                } else {
                  return SizedBox(
                    height: 250, // Increased height for larger images
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bookViewModel.upcomingBooks.length,
                      itemBuilder: (context, index) {
                        final book = bookViewModel.upcomingBooks[index];
                        return GestureDetector(
                          onTap: () => _handleClickBook(
                              book), // Add onTap for navigation
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width:
                                          150, // Increased width for larger images
                                      height:
                                          200, // Increased height for larger images
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          book.bookImageUrl ??
                                              'assets/placeholder.png',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                                'assets/placeholder.png',
                                                fit: BoxFit.cover);
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          book.published != null
                                              ? "Release: ${book.published!}"
                                              : "Coming Soon", // Use book.published
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 150, // Match image width
                                  child: Text(
                                    book.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 150, // Match image width
                                  child: Text(
                                    book.author ??
                                        'N/A', // Assuming upcoming books also have an author
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
