

import 'package:flutter/material.dart';

const baseUrl = 'http://192.168.0.113:8000/api';
const pdfUrl = 'http://192.168.0.113:8000/pdfs';
const loginUrl = '$baseUrl/login';
const registerUrl = '$baseUrl/register';
const getUserUrl = '$baseUrl/user';
const getAllBooks = '$baseUrl/books';
const serverError = 'SERVER ERROR';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something Went Wrong';
const primaryColor = Color.fromRGBO(255, 114, 222, 1);

Color kPrimaryColor = Color(0xFFEC3133);
Color kStarsColor = Color(0xFFFA6400);