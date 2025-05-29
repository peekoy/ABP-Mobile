import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart'; // <<< MAKE SURE THIS IS IMPORTED for XFile

class UserService {
  final Dio _dio;

  UserService(this._dio);

  // User Details on Login Success
  Future<Map<String, dynamic>> getUserDetails() async {
    try {
      final response = await _dio.get('/api/users');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching user details: $e');
      return {};
    }
  }

  // Change displayName
  Future<bool> changeDisplayName(String newDisplayName) async {
    try {
      final response = await _dio
          .put('/api/users/profile', data: {'displayName': newDisplayName});
      return response.statusCode == 200;
    } catch (e) {
      print('Error changing display name: $e');
      return false;
    }
  }

  // Add Profile Picture
  Future<Map<String, dynamic>> addProfilePicture(XFile imageFile) async {
    try { 
      String? mimeType = _getMimeType(imageFile.name);
      List<int> imageBytes = await imageFile.readAsBytes();

      FormData formData = FormData.fromMap({
        "cover": MultipartFile.fromBytes(
          imageBytes,
          filename: imageFile.name,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      });

      final response = await _dio.post(
        "/api/users/profile", 
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            // Authorization header is already handled by your Dio interceptor
          },
        ),
      );

      // >>>>> FIX FOR THE TYPE ERROR IS HERE <<<<<
      if (response.data is String) {
        // If the backend returns just the URL string, wrap it in a map
        // so that the method consistently returns Map<String, dynamic>
        return {'profilePicUrl': response.data};
      } else if (response.data is Map<String, dynamic>) {
        // If the backend returns a proper JSON object (Map<String, dynamic>), use it directly.
        // This is good if your backend might return other details like { "message": "Success", "url": "..." }
        return response.data;
      } else {
        // Fallback for unexpected response types
        throw Exception(
            'Unexpected response format from server for profile picture upload.');
      }
      // >>>>> END FIX <<<<<
    } on DioException catch (error) {
      print('Error adding profile picture: $error');
      throw Exception(error.response?.data?['message'] ??
          error.message ??
          "An error occurred");
    } catch (e) {
      print('Unexpected error adding profile picture: $e');
      throw Exception("An unexpected error occurred: $e");
    }
  }

  String? _getMimeType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      default:
        return null; // Or 'application/octet-stream' for generic binary
    }
  }
}
