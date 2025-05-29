import 'package:get_it/get_it.dart';
import 'package:tubes/dio/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes/home.dart';
import 'package:tubes/viewmodels/login_viewmodel.dart';
import 'package:tubes/provider/auth_provider.dart';
import 'package:tubes/services/auth_service.dart';
import 'package:tubes/viewmodels/user_viewmodel.dart';

void main() {
  setupLocator();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => locator<AuthService>(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            Provider.of<AuthService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<UserViewModel>()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
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
