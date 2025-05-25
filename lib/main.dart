import 'package:tubes/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes/home.dart';
import 'package:tubes/viewmodels/login_viewmodel.dart';
import 'package:tubes/provider/auth_provider.dart';
import 'package:tubes/services/auth_service.dart';

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
