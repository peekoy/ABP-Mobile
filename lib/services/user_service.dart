import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

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

  // Get All Users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await _dio.get('/api/users/all');
      if (response.data is List) {
        return (response.data as List<dynamic>)
            .whereType<Map<String, dynamic>>()
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        print('User API returned a single map, wrapping in a list.');
        return [response.data as Map<String, dynamic>];
      } else {
        print(
            'Error: User API returned unexpected data type: ${response.data.runtimeType}');
        return [];
      }
    } catch (e) {
      print('Error fetching all users: $e');
      return [];
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
          },
        ),
      );

      if (response.data is String) {
        return {'profilePicUrl': response.data};
      } else if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        throw Exception(
            'Unexpected response format from server for profile picture upload.');
      }
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
        return null;
    }
  }
}
