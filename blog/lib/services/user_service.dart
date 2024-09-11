import 'dart:convert';
import 'dart:io';
import 'package:blog/models/api_response.dart';
import 'package:blog/models/user.dart';
import 'package:blog/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(AppConstants.loginUrl),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)[0]][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = AppConstants.somethingwentWrong;
        break;
    }
  } catch (e) {
    print("Login Error: $e");
    apiResponse.error = AppConstants.serverError;
  }

  return apiResponse;
}

Future<ApiResponse> register(String name, String email, String password,
    String passwordConfirmation) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(AppConstants.registerUrl),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    print("Register Response: ${response.body}");

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)[0]][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = AppConstants.somethingwentWrong;
        break;
    }
  } catch (e) {
    print("Register Error: $e");
    apiResponse.error = AppConstants.serverError;
  }

  return apiResponse;
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(AppConstants.userUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      apiResponse.data = User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      apiResponse.error = AppConstants.unauthorized;
    } else {
      apiResponse.error = AppConstants.somethingwentWrong;
    }
  } catch (e) {
    print("GetUserDetail Error: $e");
    apiResponse.error = AppConstants.serverError;
  }
  return apiResponse;
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

Future<int> getUserid() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}

Future<ApiResponse> updateUser(String name, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse(AppConstants.userUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image == null
            ? {
                'name': name,
              }
            : {'name': name, 'image': image});
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = AppConstants.somethingwentWrong;
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
