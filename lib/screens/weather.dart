import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final ApiService _apiService = ApiService();
  Weather? _currentWeather;
  List<Weather> _forecast = [];
  bool _isLoading = true;
  String _city = '서울'; // 기본 도시 설정

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentWeather = await _apiService.getWeather(_city);
      final forecast = await _apiService.getWeatherForecast(_city);
      
      setState(() {
        _currentWeather = currentWeather;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('날씨 정보를 불러오는 중 오류가 발생했습니다.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _changeCity(String city) {
    setState(() {
      _city = city;
    });
    _loadWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('날씨 - $_city'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeCity,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: '서울',
                  child: Text('서울'),
                ),
                const PopupMenuItem(
                  value: '부산',
                  child: Text('부산'),
                ),
                const PopupMenuItem(
                  value: '인천',
                  child: Text('인천'),
                ),
                const PopupMenuItem(
                  value: '대구',
                  child: Text('대구'),
                ),
                const PopupMenuItem(
                  value: '광주',
                  child: Text('광주'),
                ),
              ];
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentWeather == null
              ? _buildErrorState()
              : RefreshIndicator(
                  onRefresh: _loadWeatherData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCurrentWeather(),
                        const SizedBox(height: 24),
                        const Text(
                          '5일 예보',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildForecast(),
                        const SizedBox(height: 16),
                        _buildWeatherInfo(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildCurrentWeather() {
    if (_currentWeather == null) return const SizedBox.shrink();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_currentWeather!.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _currentWeather!.condition,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _getWeatherIcon(_currentWeather!.icon),
                  size: 80,
                  color: _getWeatherColor(_currentWeather!.icon),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(
                  icon: Icons.water_drop,
                  label: '습도',
                  value: '${_currentWeather!.humidity.toStringAsFixed(0)}%',
                ),
                _buildWeatherDetail(
                  icon: Icons.air,
                  label: '풍속',
                  value: '${_currentWeather!.windSpeed.toStringAsFixed(1)} m/s',
                ),
                _buildWeatherDetail(
                  icon: Icons.navigation,
                  label: '풍향',
                  value: _currentWeather!.windDirection,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildForecast() {
    if (_forecast.isEmpty) return const SizedBox.shrink();
    
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _forecast.length,
        itemBuilder: (context, index) {
          final forecast = _forecast[index];
          return Card(
            margin: const EdgeInsets.only(right: 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatForecastDate(forecast.updateTime),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    _getWeatherIcon(forecast.icon),
                    size: 32,
                    color: _getWeatherColor(forecast.icon),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${forecast.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    forecast.condition,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '날씨 정보',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '현재 제공되는 날씨 정보는 샘플 데이터입니다. 실제 날씨 정보는 기상청이나 기타 날씨 서비스 API를 통해 제공받을 수 있습니다.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '날씨 정보 갱신 주기: 1시간',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              '마지막 업데이트: ${_formatDate(_currentWeather?.updateTime ?? DateTime.now())}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            '날씨 정보를 불러올 수 없습니다.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadWeatherData,
            child: const Text('새로고침'),
          ),
        ],
      ),
    );
  }

  // 날씨 아이콘 가져오기
  IconData _getWeatherIcon(String icon) {
    switch (icon) {
      case 'clear_day':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.water_drop;
      case 'rain_shower':
        return Icons.grain;
      case 'partly_cloudy':
        return Icons.wb_cloudy;
      default:
        return Icons.wb_sunny;
    }
  }

  // 날씨 아이콘 색상 가져오기
  Color _getWeatherColor(String icon) {
    switch (icon) {
      case 'clear_day':
        return Colors.orange;
      case 'cloudy':
        return Colors.grey;
      case 'rainy':
        return Colors.blue;
      case 'rain_shower':
        return Colors.lightBlue;
      case 'partly_cloudy':
        return Colors.amber;
      default:
        return Colors.orange;
    }
  }

  // 날짜 포맷
  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // 예보 날짜 포맷 (요일 표시)
  String _formatForecastDate(DateTime date) {
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.month}/${date.day} ($weekday)';
  }
} 