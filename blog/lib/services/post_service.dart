import 'dart:convert';

import 'package:blog/models/api_response.dart';
import 'package:blog/models/post.dart';
import 'package:blog/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:blog/utils/app_constants.dart';

Future<ApiResponse> getPosts() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(AppConstants.postsUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['posts'] as List<dynamic>)
            .map((p) => Post.fromJson(p))
            .toList();
        break;
      case 401:
        apiResponse.error = AppConstants.unauthorized;
        break;
      default:
        apiResponse.error = AppConstants.somethingwentWrong;
        print("Error Response Body: ${response.body}");
        break;
    }
  } catch (e) {
    print("Error: $e");
    apiResponse.error = AppConstants.serverError;
  }

  return apiResponse;
}

Future<ApiResponse> createPosts(String body, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(AppConstants.postsUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: image != null ? {'body': body, 'image': image} : {'body': body},
    );
    print("Create Post Response: ${response.body}");

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = AppConstants.unauthorized;
        break;
      default:
        apiResponse.error = AppConstants.somethingwentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = AppConstants.serverError;
  }
  return apiResponse;
}

Future<ApiResponse> editPost(int postId, String body) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse('${AppConstants.postsUrl}/$postId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {'body': body},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body))['message'];
        break;
      case 403:
        apiResponse.error = (jsonDecode(response.body))['message'];
        break;
      case 401:
        apiResponse.error = AppConstants.unauthorized;
        break;
      default:
        apiResponse.error = AppConstants.somethingwentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = AppConstants.serverError;
  }
  return apiResponse;
}

Future<ApiResponse> deletePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('${AppConstants.postsUrl}/$postId'),
      headers: {
        'Accept': 'application/json', // Fix typo in 'Authorization'
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body))['message'];
        break;
      case 403:
        apiResponse.error = (jsonDecode(response.body))['message'];
        break;
      case 401:
        apiResponse.error = AppConstants.unauthorized;
        break;
      default:
        apiResponse.error = AppConstants.somethingwentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = AppConstants.serverError;
  }
  return apiResponse;
}

Future<ApiResponse> likeUnlikePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse('${AppConstants.postsUrl}/$postId/likes'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = AppConstants.unauthorized;
        break;
      default:
        if (response.body != null && response.body.isNotEmpty) {
          // Utilisez le message d'erreur de la réponse s'il est disponible
          apiResponse.error = jsonDecode(response.body)['message'] ??
              AppConstants.somethingwentWrong;
        } else {
          // Sinon, utilisez une valeur par défaut
          apiResponse.error = AppConstants.somethingwentWrong;
        }
        break;
    }
  } catch (e) {
    apiResponse.error = AppConstants.serverError;
  }
  return apiResponse;
}
