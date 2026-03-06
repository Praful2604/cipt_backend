import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status != null && status < 500,
    ));
    // CookieManager doesn't support web - browser handles cookies via credentials
    if (!kIsWeb) {
      _dio.interceptors.add(CookieManager(CookieJar()));
    }
  }

  Dio get dio => _dio;

  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await _dio.post('/login', data: {'username': username, 'password': password});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final res = await _dio.post('/register', data: {
      'username': username,
      'email': email,
      'password': password,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> checkSession() async {
    final res = await _dio.get('/check-session');
    return res.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    await _dio.get('/logout');
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    final res = await _dio.get('/get-user-info');
    return res.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getVideos(String domain) async {
    final res = await _dio.get('/get-videos', queryParameters: {'domain': domain});
    final data = res.data;
    if (data is List) return data;
    if (data is Map && data['videos'] != null) return data['videos'] as List;
    return [];
  }

  Future<Map<String, dynamic>> uploadAnswer({
    required String videoPath,
    required int question,
    required String domain,
    required String sessionId,
    required String username,
  }) async {
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(videoPath),
      'question': question.toString(),
      'domain': domain,
      'sessionId': sessionId,
      'username': username,
    });
    final res = await _dio.post('/upload-answer', data: formData);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateReport(String sessionId) async {
    final res = await _dio.post('/generate-report', data: {'session_id': sessionId});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> analyzePosture(String videoPath) async {
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(videoPath),
    });
    final res = await _dio.post('/analyze/posture', data: formData);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> analyzeEye(String videoPath) async {
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(videoPath),
    });
    final res = await _dio.post('/analyze/eye', data: formData);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> analyzeFer(String videoPath) async {
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(videoPath),
    });
    final res = await _dio.post('/analyze/fer', data: formData);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> analyzeSound(String audioPath) async {
    final formData = FormData.fromMap({
      'audio': await MultipartFile.fromFile(audioPath),
    });
    final res = await _dio.post('/analyze/sound', data: formData);
    return res.data as Map<String, dynamic>;
  }
}
