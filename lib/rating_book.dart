import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes/viewmodels/rating_viewmodel.dart'; // Make sure this path is correct

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
  late int _currentLocalRating;

  @override
  void initState() {
    super.initState();
    _currentLocalRating = widget.initialRating;
    print('Rating bottom sheet opened for book ID: ${widget.bookId}');
  }

  void _handleDragDown(DragEndDetails details) {
    if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RatingViewModel>(
      builder: (context, viewModel, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewModel.errorMessage != null &&
              viewModel.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(viewModel.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
            viewModel.clearState();
          } else if (viewModel.ratingResponse != null &&
              viewModel.ratingResponse!['success'] == true) {
            viewModel.clearState(); // Clear the response after showing
          }
        });

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              const Text(
                'Rate this book',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentLocalRating = index + 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.star,
                        size: 40,
                        color: _currentLocalRating > index
                            ? Colors.amber
                            : Colors.grey[300],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          await viewModel.addRating(
                              widget.bookId, _currentLocalRating);
                          if (viewModel.ratingResponse != null &&
                              viewModel.ratingResponse!['success'] == true) {
                            widget.onRatingChanged(_currentLocalRating);
                            Navigator.pop(context);
                          }
                          viewModel.clearState();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          await viewModel.deleteRating(widget.bookId);
                          if (viewModel.ratingResponse != null &&
                              viewModel.ratingResponse!['success'] == true) {
                            widget.onRatingChanged(0);
                            Navigator.pop(context);
                          }
                          viewModel.clearState();
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xCC0F172D)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: const Color(0xCC0F172D),
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
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
      },
    );
  }
}
