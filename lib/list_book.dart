import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes/detail_book.dart';
import 'package:tubes/global_scaffold.dart';
import 'package:tubes/viewmodels/book_viewmodel.dart';
import 'package:tubes/models/book_model.dart';

class ListBooksPage extends StatefulWidget {
  const ListBooksPage({Key? key}) : super(key: key);

  @override
  State<ListBooksPage> createState() => _ListBooksPageState();
}

class _ListBooksPageState extends State<ListBooksPage> {
  // Removed the hardcoded list of books as we'll fetch from the ViewModel

  final ScrollController _scrollController = ScrollController();
  String _selectedLetter = 'All'; // Track the currently selected filter letter

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch all books when the page initializes
      Provider.of<BookViewModel>(context, listen: false).fetchAllBooks();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _filterBooks(String letter, List<Book> allBooks) {
    setState(() {
      _selectedLetter = letter;
      // The actual filtering will happen in the Consumer widget based on _selectedLetter
    });
  }

  void _handleClickBook(Book book) {
    if (book.id.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBookPage(id: book.id),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book ID not available.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      selectedIndex: 1,
      body: Column(
        children: [
          // --- Filter Chips Section ---
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // Changed to horizontal for better UX
              child: Row(
                spacing: 6.0,
                children: [
                  'All',
                  'A',
                  'B',
                  'C',
                  'D',
                  'E',
                  'F',
                  'G',
                  'H',
                  'I',
                  'J',
                  'K',
                  'L',
                  'M',
                  'N',
                  'O',
                  'P',
                  'Q',
                  'R',
                  'S',
                  'T',
                  'U',
                  'V',
                  'W',
                  'X',
                  'Y',
                  'Z'
                ]
                    .map((letter) => FilterChip(
                          label: Text(letter),
                          selected: _selectedLetter == letter,
                          onSelected: (bool value) {
                            if (value) {
                              _filterBooks(
                                  letter,
                                  Provider.of<BookViewModel>(context,
                                          listen: false)
                                      .allBooks);
                            }
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
          // --- Book List Section ---
          Expanded(
            child: Consumer<BookViewModel>(
              builder: (context, bookViewModel, child) {
                if (bookViewModel.isLoadingAllBooks) {
                  return const Center(child: CircularProgressIndicator());
                } else if (bookViewModel.allBooksErrorMessage.isNotEmpty) {
                  return Center(
                      child:
                          Text('Error: ${bookViewModel.allBooksErrorMessage}'));
                } else if (bookViewModel.allBooks.isEmpty) {
                  return const Center(child: Text('No books available.'));
                } else {
                  // Filter the books based on the selected letter
                  final List<Book> displayedBooks = _selectedLetter == 'All'
                      ? bookViewModel.allBooks
                      : bookViewModel.allBooks
                          .where(
                              (book) => book.title.startsWith(_selectedLetter))
                          .toList();

                  if (displayedBooks.isEmpty) {
                    return Center(
                        child: Text(
                            'No books starting with "$_selectedLetter" found.'));
                  }

                  return ListView.builder(
                    itemCount: displayedBooks.length,
                    itemBuilder: (context, index) {
                      final book = displayedBooks[index];
                      return GestureDetector(
                        onTap: () => _handleClickBook(book),
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Cover image
                                Container(
                                  width: 80,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      book.bookImageUrl.isNotEmpty
                                          ? book.bookImageUrl
                                          : 'assets/placeholder.png', // Use placeholder if URL is empty
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
                                const SizedBox(width: 12),
                                // Book info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        height: 90,
                                        child: Scrollbar(
                                          controller: _scrollController,
                                          thumbVisibility: true,
                                          child: SingleChildScrollView(
                                            padding: const EdgeInsets.only(
                                                right: 14),
                                            scrollDirection: Axis.vertical,
                                            child: Text(
                                              book.description.isNotEmpty
                                                  ? book.description
                                                  : 'No description available.',
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
