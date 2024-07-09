


import 'dart:convert';

import 'package:anonymy/constant/constant.dart';
import 'package:anonymy/models/api_response.dart';
import 'package:anonymy/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> login(String email, String password) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
      Uri.parse(loginUrl),
      body: {'email' : email, 'password' : password}
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;

      case 422:
        final Map<String, dynamic> errors = jsonDecode(response.body);
        if (errors.containsKey('WrongCredentials')) {
          apiResponse.error = errors['WrongCredentials'];
        } else {
          apiResponse.error = 'Unknown error occurred';
        }
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = somethingWentWrong;
    }
  }
  catch(e){
  apiResponse.error = serverError;
  }
    return apiResponse;
}

Future<ApiResponse> register(String name, String email, String password) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse(registerUrl),
        body: {'name': name, 'email' : email, 'password' : password}
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;

      case 422:
        final errors = jsonDecode(response.body)['errors'];
        final firstErrorKey = errors.keys.first;
        apiResponse.error = errors[firstErrorKey][0];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = somethingWentWrong;
    }
  }
  catch(e){
    apiResponse.error = serverError;
  }
    return apiResponse;
}



Future<ApiResponse> getUser() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.get(
        Uri.parse(getUserUrl),
        headers: {
          'Authorization' : 'Bearer $token'
        },
    );


    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;

      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.key.elementAt(0)][0];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = somethingWentWrong;
    }
  }
  catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}


Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}


Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('user_id') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}
