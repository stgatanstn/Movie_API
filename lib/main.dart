import 'package:flutter/material.dart';
import 'package:movie_app/views/dashboard.dart';
import 'package:movie_app/views/login_view.dart';
import 'package:movie_app/views/movie_view.dart';
import 'package:movie_app/views/pesan_view.dart';
import 'package:movie_app/views/register_user_view.dart';
import 'package:movie_app/views/register_category_view.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/login': (context) => LoginView(),
      '/dashboard': (context) => DashboardView(),
      '/registeruser': (context) => RegisterUserView(),
      '/registercategory': (context) => RegisterCategoryView(),
      '/movie': (context) => MovieView(),
      '/pesan': (context) => PesanView(),
    },
  ));
}
