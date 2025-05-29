import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tubes/global_scaffold.dart';
import 'package:tubes/home.dart';
import 'package:tubes/provider/auth_provider.dart';
import 'package:tubes/viewmodels/user_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserViewModel>(context, listen: false).fetchUserDetails();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceSelection(UserViewModel viewModel) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      await viewModel.uploadProfilePicture(
                          source: ImageSource.camera);
                      if (viewModel.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(viewModel.errorMessage!)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Profile picture updated successfully!')),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);

                      await viewModel.uploadProfilePicture(
                          source: ImageSource.gallery);
                      if (viewModel.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(viewModel.errorMessage!)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Profile picture updated successfully!')),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.photo_library,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showProfilePictureDialog(UserViewModel viewModel) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Profile Picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A picture helps people recognize you and lets you know when you\'re signed in to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Visible to anyone.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _showImageSourceSelection(viewModel);
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDDDDD),
                      shape: BoxShape.circle,
                      image: viewModel.userDetails?['profileImageUrl'] != null
                          ? DecorationImage(
                              image: NetworkImage(
                                  viewModel.userDetails!['profileImageUrl']),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: viewModel.userDetails?['profileImageUrl'] == null
                        ? const Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Close the current dialog
                    await _showImageSourceSelection(viewModel);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 40),
                  ),
                  child: const Text('Change Picture'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      selectedIndex: 3,
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (userViewModel.userDetails != null &&
                userViewModel.userDetails!['displayName'] != null &&
                _nameController.text !=
                    userViewModel.userDetails!['displayName']) {
              _nameController.text = userViewModel.userDetails!['displayName'];
            }
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                // Use Column to place the logout button below the profile box
                children: [
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        userViewModel.isLoading &&
                                userViewModel.userDetails == null
                            ? const CircularProgressIndicator()
                            : InkWell(
                                onTap: () =>
                                    _showProfilePictureDialog(userViewModel),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDDDDDD),
                                    shape: BoxShape.circle,
                                    image: userViewModel.userDetails?[
                                                'profileImageUrl'] !=
                                            null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                userViewModel.userDetails![
                                                    'profileImageUrl']),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: userViewModel.userDetails?[
                                              'profileImageUrl'] ==
                                          null
                                      ? const Icon(Icons.person,
                                          size: 60, color: Colors.grey)
                                      : null,
                                ),
                              ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: userViewModel.isLoading &&
                                  userViewModel.userDetails == null
                              ? null
                              : () => _showProfilePictureDialog(userViewModel),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: userViewModel.isLoading &&
                                  userViewModel.userDetails == null
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                )
                              : const Text(
                                  'Change Profile Picture',
                                  style: TextStyle(color: Colors.black),
                                ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Display Name',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          enabled: !userViewModel.isLoading,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: userViewModel.isLoading
                              ? null
                              : () async {
                                  await userViewModel
                                      .changeDisplayName(_nameController.text);
                                  if (userViewModel.errorMessage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Display name updated successfully!')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              userViewModel.errorMessage!)),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A0A1E),
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: userViewModel.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Update Display Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        if (userViewModel.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              userViewModel.errorMessage!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height:
                          20), // Spacing between the box and the logout button
                  SizedBox(
                    width: 300, // Match the width of the profile box
                    child: OutlinedButton(
                      onPressed: () async {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .logout();
                        // Navigate to login page and remove all previous routes
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            Colors.red, // Making the logout button red
                        side: const BorderSide(color: Colors.red),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('Logout'),
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
}
