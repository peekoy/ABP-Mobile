import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tubes/detail_book.dart';
import 'package:tubes/global_scaffold.dart';

class ListBooksPage extends StatefulWidget {
  const ListBooksPage({Key? key}) : super(key: key);

  @override
  State<ListBooksPage> createState() => _ListBooksPageState();
}

class _ListBooksPageState extends State<ListBooksPage> {
  final List<Map<String, String>> books = [
    {'title': 'Rewind It Back', 'cover': 'assets/1.png', 'description': 'aaa'},
    {'title': 'Reckless', 'cover': 'assets/Reckless.png', 'description': 'bbb'},
    {'title': 'Life of Pi', 'cover': 'assets/Life.png', 'description': 'ccc'},
    {
      'title': 'Killing Stalking: Deluxe Edition Vol. 8',
      'cover': 'assets/Killing.png',
      'description': 'ddd'
    },
    {
      'title':
          'Batman: Detective Comics, Vol. 4: Gotham Nocturne Intermezzo: Outlaw',
      'cover': 'assets/Batman.png',
      'description': 'eee'
    },
    {
      'title': 'Sunrise on the Reaping',
      'cover': 'assets/6.png',
      'description': 'fff'
    },
  ];
  List<Map<String, String>> filteredBooks = [];

  @override
  void initState() {
    super.initState();
    filteredBooks = List.from(books);
  }

  void filterBooks(String letter) {
    setState(() {
      if (letter == 'All') {
        filteredBooks = List.from(books);
      } else {
        filteredBooks =
            books.where((book) => book['title']!.startsWith(letter)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      selectedIndex: 1,
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
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
                          onSelected: (bool value) {
                            filterBooks(letter);
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print('Clicked book: ${filteredBooks[index]['title']}');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         DetailBookPage(book: filteredBooks[index]),
                    //   ),
                    // );
                  },
                  child: Card(
                    color: Colors.white, // Background putih
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Radius sudut card
                      side: BorderSide(
                          color: Colors.grey, width: 1), // Border abu-abu
                    ),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      // Tinggi card
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            width: 100,
                            height: 140,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(8)), // Terapkan radius
                              child: Image.asset(
                                filteredBooks[index]['cover']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(
                              width: 16), // Jarak antara gambar dan teks
                          SizedBox(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  filteredBooks[index]['title']!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  filteredBooks[index]['description']!,
                                  style: TextStyle(fontSize: 16),
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
            ),
          ),
        ],
      ),
    );
  }
}
