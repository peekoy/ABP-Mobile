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
    {'title': 'Rewind It Back', 'cover': 'assets/1.png', 'description': '-'},
    {
      'title': 'Reckless',
      'cover': 'assets/Reckless.png',
      'description':
          'After surviving the Purging Trials, Ordinary-born Paedyn Gray has killed the King, and kickstarted a Resistance throughout the land. Now she running from the one person she had wanted to run to.\n\nKai Azer is now Ilya Enforcer, loyal to his brother Kitt, the new King. He has vowed to find Paedyn and bring her to justice.\n\nAcross the deadly Scorches, and deep into the hostile city of Dor, Kai pursues the one person he wishes he didn have to. But in a city without Elites, the balance between the hunter and hunted shifts and the battle between duty and desire is deadly.\n\nBe swept away by this kiss-or-kill romantasy trilogy taking the world by storm.'
    },
    {
      'title': 'Life of Pi',
      'cover': 'assets/Life.png',
      'description':
          'Life of Pi is a fantasy adventure novel by Yann Martel published in 2001. The protagonist, Piscine Molitor `Pi` Patel, a Tamil boy from Pondicherry, explores issues of spirituality and practicality from an early age. He survives 227 days after a shipwreck while stranded on a lifeboat in the Pacific Ocean...'
    },
    {
      'title': 'Killing Stalking: Deluxe Edition Vol. 8',
      'cover': 'assets/Killing.png',
      'description':
          'Seungbae has hit rock bottom—but things get a lot worse when he receives a phone call informing him of Chief Kwak’s suicide. Seungbae isn’t convinced that Kwak killed himself, though. In fact, he’s pretty sure he knows who did kill Kwak. Fueled by anger and grief, Seungbae sets out to put Sangwoo behind bars once and for all.'
    },
    {
      'title':
          'Batman: Detective Comics, Vol. 4: Gotham Nocturne Intermezzo: Outlaw',
      'cover': 'assets/Batman.png',
      'description':
          'Following the events of “The Gotham War”, Batman, now under the influence of the Azmer demon is set to be publicly hanged in Gotham City to atone for his crimes. With Gotham’s citizens under the spell of Orgham, the city is thrown into chaos like it’s never seen before. Can Batman’s greatest allies and enemies rescue him from the gallows before it’s lights out on Bruce Wayne?'
    },
    {
      'title': 'Sunrise on the Reaping',
      'cover': 'assets/6.png',
      'description':
          'As the day dawns on the fiftieth annual Hunger Games, fear grips the districts of Panem. This year, in honor of the Quarter Quell, twice as many tributes will be taken from their homes.\n\nBack in District 12, Haymitch Abernathy is trying not to think too hard about his chances. All he cares about is making it through the day and being with the girl he loves.\n\nWhen Haymitch`s name is called, he can feel all his dreams break. He`s torn from his family and his love, shuttled to the Capitol with the three other District 12 a young friend who`s nearly a sister to him, a compulsive oddsmaker, and the most stuck-up girl in town.\n\nAs the Games begin, Haymitch understands he`s been set up to fail. But there`s something in him that wants to fight . . . and have that fight reverberate far beyond the deadly arena.`'
    },
  ];
  List<Map<String, String>> filteredBooks = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                    //     builder: (context) => DetailBookPage(book: filteredBooks[index]),
                    //   ),
                    // );
                  },
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300, width: 1),
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
                              child: Image.asset(
                                filteredBooks[index]['cover']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Book info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filteredBooks[index]['title'] ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 6),
                                SizedBox(
                                    height: 90,
                                    child: Scrollbar(
                                      controller: _scrollController,
                                      thumbVisibility: true,
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.only(right: 14),
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                          filteredBooks[index]['description'] ??
                                              '',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    )),
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
