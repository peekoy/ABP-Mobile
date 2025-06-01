import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:tubes/services/auth_service.dart';
import 'package:tubes/services/book_service.dart';
import 'package:tubes/services/rating_service.dart';
import 'package:tubes/services/review_service.dart';
import 'package:tubes/services/token_service.dart';
import 'package:tubes/services/user_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Dio>(() {
    final dio =
        Dio(BaseOptions(baseUrl: "https://j2146t42-5000.asse.devtunnels.ms"));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await locator<TokenService>().getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
    return dio;
  });

  locator.registerLazySingleton<AuthService>(() => AuthService(locator<Dio>()));
  locator.registerLazySingleton<TokenService>(() => TokenService());
  locator.registerLazySingleton<FlutterSecureStorage>(
      () => FlutterSecureStorage());
  locator.registerLazySingleton<UserService>(() => UserService(locator<Dio>()));
  locator.registerLazySingleton<RatingService>(
      () => RatingService(locator<Dio>()));
  locator.registerLazySingleton<ReviewService>(
      () => ReviewService(locator<Dio>()));
  locator.registerLazySingleton<BookService>(() => BookService(locator<Dio>()));
}
