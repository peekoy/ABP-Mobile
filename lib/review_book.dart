import 'package:flutter/material.dart';

class ReviewBook extends StatefulWidget {
  const ReviewBook({super.key});

  @override
  State<ReviewBook> createState() => _ReviewBookState();
}

class _ReviewBookState extends State<ReviewBook> {
  final TextEditingController _reviewController = TextEditingController();
  final List<Map<String, String>> reviews = [
    {"name": "Deo", "review": "Mantap"},
    {"name": "Hito", "review": "Mantep"},
    {"name": "Faiz", "review": "Mantep"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Write a Review",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        // const SizedBox(height: 10),
        // Container(
        //   height: 200,
        //   decoration: BoxDecoration(
        //     border: Border.all(color: Colors.black),
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: TextField(
        //     decoration: InputDecoration(
        //       contentPadding: EdgeInsets.all(10),
        //       border: InputBorder.none,
        //     ),
        //   ),
        // ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Text("F", style: const TextStyle(color: Colors.black)),
          ),
          title: Text("Fikri",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Hallo"),
          trailing: Icon(Icons.more_vert),
        ),
        // const SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end, // Memindahkan ke kanan
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         if (_reviewController.text.isNotEmpty) {
        //           setState(() {
        //             reviews.add({
        //               "name": "User",
        //               "review": _reviewController.text,
        //             });
        //             _reviewController.clear();
        //           });
        //         }
        //       },
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.black,
        //         shape: RoundedRectangleBorder(
        //           borderRadius:
        //               BorderRadius.circular(2), // Hilangkan rounded border
        //         ),
        //       ),
        //       child: const Text(
        //         "Submit Review",
        //         style: TextStyle(color: Colors.white),
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 10),
        Text(
          "Reviews",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              String name = reviews[index]["name"]!;
              String review = reviews[index]["review"]!;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(name[0],
                      style: const TextStyle(color: Colors.black)),
                ),
                title: Text(name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(review),
              );
            },
          ),
        )
      ],
    );
  }
}
