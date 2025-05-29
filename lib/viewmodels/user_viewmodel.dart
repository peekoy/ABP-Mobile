import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = GetIt.instance<UserService>();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userDetails;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userDetails => _userDetails;

  UserViewModel() {
    fetchUserDetails();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setUserDetails(Map<String, dynamic> details) {
    _userDetails = details;
    notifyListeners();
  }

  Future<void> fetchUserDetails() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final details = await _userService.getUserDetails();
      print('Fetched user details: $details');
      _setUserDetails(details);
    } catch (e) {
      _setErrorMessage("Failed to fetch user details: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> uploadProfilePicture({required ImageSource source}) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        // --- CHANGE THIS LINE ---
        final responseData = await _userService
            .addProfilePicture(image); // Pass the XFile object directly
        await fetchUserDetails();
        print('Profile picture uploaded successfully: $responseData');
        _setErrorMessage(null);
      } else {
        _setErrorMessage("No image selected.");
      }
    } catch (e) {
      _setErrorMessage("Failed to upload profile picture: $e");
      print('Error uploading profile picture: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> changeDisplayName(String newDisplayName) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final success = await _userService.changeDisplayName(newDisplayName);
      if (success) {
        await fetchUserDetails();
        _setErrorMessage(null);
      } else {
        _setErrorMessage("Failed to change display name.");
      }
    } catch (e) {
      _setErrorMessage("Error changing display name: $e");
    } finally {
      _setLoading(false);
    }
  }
}
