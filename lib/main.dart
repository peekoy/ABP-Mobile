import 'package:tubes/dio/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes/home.dart';
import 'package:tubes/services/book_service.dart'; // Make sure this import is correct
import 'package:tubes/viewmodels/book_viewmodel.dart'; // Make sure this import is correct
import 'package:tubes/viewmodels/login_viewmodel.dart';
import 'package:tubes/provider/auth_provider.dart';
import 'package:tubes/services/auth_service.dart';
import 'package:tubes/viewmodels/rating_viewmodel.dart';
import 'package:tubes/viewmodels/review_viewmodel.dart';
import 'package:tubes/viewmodels/user_viewmodel.dart';

void main() {
  setupLocator(); // Your GetIt setup

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => locator<AuthService>(),
        ),
        Provider<BookService>(
          create: (_) => locator<BookService>(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            Provider.of<AuthService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<BookViewModel>(
          create: (context) => BookViewModel(
            bookService: Provider.of<BookService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => RatingViewModel()),
        ChangeNotifierProvider(create: (_) => ReviewViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
