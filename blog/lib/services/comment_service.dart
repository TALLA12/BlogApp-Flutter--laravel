import 'dart:convert';

import 'package:blog/models/api_response.dart';
import 'package:blog/models/comment.dart';
import 'package:blog/services/user_service.dart';
import 'package:blog/utils/app_constants.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getComments(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .get(Uri.parse('${AppConstants.postsUrl}/$postId/comments'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['comments']
            .map((p) => Comment.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

Future<ApiResponse> createComment(int postId, String? comment) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .post(Uri.parse('${AppConstants.postsUrl}/$postId/comments'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'comment': comment
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

Future<ApiResponse> deleteComment(int commentId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .delete(Uri.parse('${AppConstants.commentsURL}/$commentId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print(response.body);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

Future<ApiResponse> editComment(int commentId, String comment) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .put(Uri.parse('${AppConstants.commentsURL}/$commentId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'comment': comment
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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
