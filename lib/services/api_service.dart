import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../models/weather_model.dart';
import '../models/user_model.dart';

class ApiService {
  // Unsplash API URL 및 키
  static const String _unsplashBaseUrl = 'https://api.unsplash.com';
  static const String _unsplashAccessKey = 'YOUR_UNSPLASH_ACCESS_KEY';

  // 뉴스 API URL 및 키 (실제 앱에서는 환경 변수로 관리하는 것을 권장)
  static const String _newsBaseUrl = 'YOUR_NEWS_API_URL';
  static const String _newsApiKey = 'YOUR_NEWS_API_KEY';

  // 날씨 API URL 및 키
  static const String _weatherBaseUrl = 'YOUR_WEATHER_API_URL';
  static const String _weatherApiKey = 'YOUR_WEATHER_API_KEY';

  // 싱글톤 패턴 구현
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // HTTP 클라이언트
  final http.Client _client = http.Client();

  // 샘플 데이터 사용 여부 (API 연동 전 개발 시 사용)
  final bool _useSampleData = true;

  // 뉴스 목록 가져오기
  Future<List<NewsArticle>> getNews() async {
    if (_useSampleData) {
      // 샘플 데이터 사용
      return NewsArticle.getSampleNews();
    }

    try {
      final response = await _client.get(
        Uri.parse('$_newsBaseUrl/articles?apiKey=$_newsApiKey'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['articles'];
        return jsonData.map((json) => NewsArticle.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  // 키워드로 뉴스 검색
  Future<List<NewsArticle>> searchNews(String keyword) async {
    if (_useSampleData) {
      // 키워드로 샘플 데이터 필터링
      final allNews = NewsArticle.getSampleNews();
      return allNews
          .where((article) =>
              article.title.toLowerCase().contains(keyword.toLowerCase()) ||
              article.content.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    try {
      final response = await _client.get(
        Uri.parse('$_newsBaseUrl/search?q=$keyword&apiKey=$_newsApiKey'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['articles'];
        return jsonData.map((json) => NewsArticle.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching news: $e');
    }
  }

  // 날씨 정보 가져오기
  Future<Weather> getWeather(String city) async {
    if (_useSampleData) {
      // 샘플 날씨 데이터 사용
      return Weather.getSampleWeather();
    }

    try {
      final response = await _client.get(
        Uri.parse('$_weatherBaseUrl/weather?q=$city&appid=$_weatherApiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Weather.fromJson(jsonData);
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  // 날씨 예보 가져오기
  Future<List<Weather>> getWeatherForecast(String city) async {
    if (_useSampleData) {
      // 샘플 날씨 예보 데이터 사용
      return Weather.getWeatherForecast();
    }

    try {
      final response = await _client.get(
        Uri.parse('$_weatherBaseUrl/forecast?q=$city&appid=$_weatherApiKey'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['list'];
        return jsonData.map((json) => Weather.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load weather forecast: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather forecast: $e');
    }
  }

  // 유저 정보 가져오기
  Future<User> getUserInfo(String userId) async {
    if (_useSampleData) {
      // 샘플 유저 데이터 사용
      return User.getSampleUser();
    }

    try {
      final response = await _client.get(
        Uri.parse('$_newsBaseUrl/users/$userId?apiKey=$_newsApiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return User.fromJson(jsonData);
      } else {
        throw Exception('Failed to load user info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user info: $e');
    }
  }

  // Unsplash에서 이미지 검색
  Future<String> getImageFromUnsplash(String query) async {
    if (_useSampleData) {
      // 샘플 이미지 URL 리턴
      return 'https://source.unsplash.com/random/800x600/?$query';
    }

    try {
      final response = await _client.get(
        Uri.parse('$_unsplashBaseUrl/photos/random?query=$query&client_id=$_unsplashAccessKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData['urls']['regular'];
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching image: $e');
    }
  }
} 