// import 'package:flutter/material.dart';
// import 'package:tubes/global_scaffold.dart';

// class RatingBookPage extends StatefulWidget {
//   final String bookId;
//   const RatingBookPage({super.key, required this.bookId});

//   @override
//   State<RatingBookPage> createState() => _RatingBookPageState();
// }

// class _RatingBookPageState extends State<RatingBookPage> {
//   int? _selectedRating; // null = no rating

//   void _submitRating() {
//     // TODO: Integrate with backend or state management
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Submitted rating: ${_selectedRating ?? 'None'}')),
//     );
//   }

//   void _removeRating() {
//     setState(() => _selectedRating = null);
//     // TODO: Integrate with backend or state management
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Rating removed')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GlobalScaffold(
//       selectedIndex: 4, // Use 4 for rating page (not in nav bar)
//       body: SafeArea(
//         child: Center(
//           child: Card(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 8,
//             color: Theme.of(context).colorScheme.surface,
//             child: Container(
//               width: 320,
//               padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 4,
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   const Text(
//                     'Rate this book',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//                   // Star rating row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (index) {
//                       final starIndex = index + 1;
//                       return IconButton(
//                         icon: Icon(
//                           _selectedRating != null && _selectedRating! >= starIndex
//                               ? Icons.star
//                               : Icons.star_border,
//                           color: Colors.amber[700],
//                           size: 36,
//                         ),
//                         onPressed: () {
//                           setState(() => _selectedRating = starIndex);
//                         },
//                         splashRadius: 22,
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 24),
//                   // Submit button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _selectedRating != null ? _submitRating : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).colorScheme.primary,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         textStyle: const TextStyle(fontWeight: FontWeight.bold),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text('Submit'),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   // Remove rating button
//                   SizedBox(
//                     width: double.infinity,
//                     child: OutlinedButton(
//                       onPressed: _selectedRating != null ? _removeRating : null,
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.grey[700],
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         textStyle: const TextStyle(fontWeight: FontWeight.bold),
//                         side: BorderSide(color: Colors.grey[400]!),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text('Remove Rating'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class RatingBottomSheet extends StatefulWidget {
  final String bookId;
  final int initialRating;
  final Function(int) onRatingChanged;

  const RatingBottomSheet({
    Key? key,
    required this.bookId,
    this.initialRating = 0,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
    print('Rating bottom sheet opened for book ID: ${widget.bookId}');
  }

  void _handleDragDown(DragEndDetails details) {
    // If the user drags down with sufficient velocity, close the bottom sheet
    if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
      Navigator.of(context).pop();
    }
  }

  void _submitRating() {
    // Here you would typically send the rating to your backend
    print('Submitting rating $_currentRating for book ID: ${widget.bookId}');

    // Call the callback to update the parent widget
    widget.onRatingChanged(_currentRating);

    // Close the bottom sheet
    Navigator.pop(context);
  }

  void _removeRating() {
    // Here you would typically remove the rating from your backend
    print('Removing rating for book ID: ${widget.bookId}');

    // Call the callback to update the parent widget
    widget.onRatingChanged(0);

    // Close the bottom sheet
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator with drag functionality
          GestureDetector(
            onVerticalDragEnd: _handleDragDown,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          // Title
          const Text(
            'Rate this book',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),

          // Star rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentRating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.star,
                    size: 40,
                    color: _currentRating > index
                        ? Colors.amber
                        : Colors.grey[300],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 30),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submitRating,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Remove rating button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: _removeRating,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xCC0F172D)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: const Color(0xCC0F172D),
              ),
              child: const Text(
                'Remove Rating',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
