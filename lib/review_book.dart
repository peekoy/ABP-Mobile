import 'package:flutter/material.dart';

class ReviewBook extends StatefulWidget {
  const ReviewBook({super.key});

  @override
  State<ReviewBook> createState() => _ReviewBookState();
}

class _ReviewBookState extends State<ReviewBook> {
  final TextEditingController _reviewController = TextEditingController();
  String? _userReview;
  bool _isEditing = false;

  final List<Map<String, String>> reviews = [
    {"name": "Deo", "review": "Mantap"},
    {"name": "Hito", "review": "Mantep"},
    {"name": "Faiz", "review": "Mantep"},
  ];

  void _submitReview() {
    if (_reviewController.text.isNotEmpty) {
      setState(() {
        _userReview = _reviewController.text;
        _isEditing = false;
        _reviewController.clear();
      });
    }
  }

  void _editReview() {
    setState(() {
      _isEditing = true;
      _reviewController.text = _userReview ?? '';
    });
  }

  void _deleteReview() {
    setState(() {
      _userReview = null;
      _reviewController.clear();
      _isEditing = false;
    });
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _editReview();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteReview();
              },
            ),
          ],
        );
      },
    );
  }

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
        const SizedBox(height: 10),
        _userReview == null || _isEditing
            ? Column(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _reviewController,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        decorationThickness: 0,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        hintText: 'Write your review here...',
                      ),
                      maxLines: null,
                      expands: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text("F", style: const TextStyle(color: Colors.black)),
                ),
                title: Text("Fikri",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_userReview ?? ''),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: _showOptions,
                ),
              ),
        const SizedBox(height: 20),
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
