import 'package:flutter/material.dart';
import 'package:tubes/global_scaffold.dart';

class RatingBookPage extends StatefulWidget {
  final String bookId;
  const RatingBookPage({super.key, required this.bookId});

  @override
  State<RatingBookPage> createState() => _RatingBookPageState();
}

class _RatingBookPageState extends State<RatingBookPage> {
  int? _selectedRating; // null = no rating

  void _submitRating() {
    // TODO: Integrate with backend or state management
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Submitted rating: ${_selectedRating ?? 'None'}')),
    );
  }

  void _removeRating() {
    setState(() => _selectedRating = null);
    // TODO: Integrate with backend or state management
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rating removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      selectedIndex: 4, // Use 4 for rating page (not in nav bar)
      body: SafeArea(
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            color: Theme.of(context).colorScheme.surface,
            child: Container(
              width: 320,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Text(
                    'Rate this book',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Star rating row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return IconButton(
                        icon: Icon(
                          _selectedRating != null && _selectedRating! >= starIndex
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber[700],
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() => _selectedRating = starIndex);
                        },
                        splashRadius: 22,
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedRating != null ? _submitRating : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Remove rating button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _selectedRating != null ? _removeRating : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        side: BorderSide(color: Colors.grey[400]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Remove Rating'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 