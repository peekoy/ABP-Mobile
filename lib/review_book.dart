import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes/viewmodels/review_viewmodel.dart';

class ReviewBook extends StatefulWidget {
  final String bookId;

  const ReviewBook({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  State<ReviewBook> createState() => _ReviewBookState();
}

class _ReviewBookState extends State<ReviewBook> {
  final TextEditingController _reviewController = TextEditingController();
  bool _isEditing = false;

  String _getAvatarInitial(String? displayName) {
    return displayName != null && displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : "U";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ReviewViewModel>(context, listen: false);
      viewModel.initializeReviewSection(widget.bookId).then((_) {
        if (viewModel.userReview != null &&
            viewModel.userReview!['review'] != null) {
          _reviewController.text = viewModel.userReview!['review'];
          _isEditing = false;
        } else {
          _reviewController.clear();
          _isEditing = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _showOptions(BuildContext context, ReviewViewModel viewModel) {
    // ... (keep existing _showOptions method)
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _isEditing = true;
                  _reviewController.text =
                      viewModel.userReview?['review'] ?? '';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () async {
                Navigator.pop(ctx);
                final reviewIdToDelete = viewModel.userReview?['id'];
                if (reviewIdToDelete != null) {
                  await viewModel.deleteReview(reviewIdToDelete, widget.bookId);
                  if (viewModel.reviewOperationResponse?['success'] == true ||
                      !viewModel.hasUserReviewed) {
                    _reviewController.clear();
                    _isEditing = true;
                  }
                }
                viewModel.clearOperationState();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewViewModel>(
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
            viewModel.clearOperationState();
          }
        });

        final bool isLoggedIn = viewModel.currentUserData != null;
        final bool hasUserReviewedThisBuild = viewModel.hasUserReviewed;

        if (hasUserReviewedThisBuild && !_isEditing) {
          if (_reviewController.text != viewModel.userReview!['review']) {
            _reviewController.text = viewModel.userReview!['review'] ?? '';
          }
        } else if (!hasUserReviewedThisBuild && _isEditing) {}

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLoggedIn ? "Your Review" : "Reviews",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (viewModel.isLoading &&
                _reviewController.text.isEmpty &&
                !hasUserReviewedThisBuild)
              const Center(child: CircularProgressIndicator())
            else if (!isLoggedIn)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Please log in to write a review or see your review.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else if (hasUserReviewedThisBuild && !_isEditing)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      viewModel.currentUserData?['profileImageUrl'] != null
                          ? NetworkImage(
                              viewModel.currentUserData?['profileImageUrl'])
                          : null,
                  child: viewModel.currentUserData?['profileImageUrl'] == null
                      ? Text(
                          _getAvatarInitial(
                              viewModel.currentUserData?['displayName']),
                          style: const TextStyle(color: Colors.black))
                      : null,
                ),
                title: Text(viewModel.currentUserData?['displayName'] ?? "You",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(viewModel.userReview!['review'] ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showOptions(context, viewModel),
                ),
              )
            else
              Column(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _reviewController,
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                        decorationThickness: 0,
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        hintText: 'Share your thoughts on the book',
                      ),
                      maxLines: null,
                      expands: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (hasUserReviewedThisBuild &&
                          _isEditing) // Show Cancel if was editing an existing review
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                              _reviewController.text =
                                  viewModel.userReview!['review'] ?? '';
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                                if (_reviewController.text.isNotEmpty) {
                                  bool success = false;
                                  if (hasUserReviewedThisBuild && _isEditing) {
                                    final reviewIdToUpdate =
                                        viewModel.userReview?['id'];
                                    if (reviewIdToUpdate != null) {
                                      await viewModel.updateReview(
                                          reviewIdToUpdate,
                                          _reviewController.text,
                                          widget.bookId);
                                      success =
                                          viewModel.reviewOperationResponse?[
                                                  'success'] ??
                                              false;
                                    }
                                  } else {
                                    await viewModel.addReview(
                                        widget.bookId, _reviewController.text);
                                    success =
                                        viewModel.reviewOperationResponse?[
                                                'success'] ??
                                            false;
                                  }

                                  if (success) {
                                    setState(() {
                                      _isEditing = false;
                                    });
                                  }
                                  viewModel.clearOperationState();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Review cannot be empty!')),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: viewModel.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.0),
                              )
                            : Text(
                                (hasUserReviewedThisBuild && _isEditing) ||
                                        (hasUserReviewedThisBuild &&
                                            !_isEditing &&
                                            _reviewController.text !=
                                                (viewModel.userReview?[
                                                        'review'] ??
                                                    ''))
                                    ? "Update Review"
                                    : "Submit Review",
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 20),
            const Text(
              "Other Reviews",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (viewModel.isLoading && viewModel.otherReviews.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (viewModel.otherReviews.isEmpty)
              const Center(child: Text('No other reviews yet.'))
            else
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: viewModel.otherReviews.length,
                  itemBuilder: (context, index) {
                    final review = viewModel.otherReviews[index];
                    String name = review["displayName"] ?? 'Unknown User';
                    String reviewText = review["review"] ?? '';
                    String profileImageUrl = review["profileImageUrl"] ?? '';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : null,
                        child: profileImageUrl.isEmpty
                            ? Text(_getAvatarInitial(name),
                                style: const TextStyle(color: Colors.black))
                            : null,
                      ),
                      title: Text(name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(reviewText),
                    );
                  },
                ),
              )
          ],
        );
      },
    );
  }
}
