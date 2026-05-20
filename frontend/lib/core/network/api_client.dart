import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  // Change to your machine IP if testing on a physical device
  static const String baseUrl = 'http://localhost:3000';

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
