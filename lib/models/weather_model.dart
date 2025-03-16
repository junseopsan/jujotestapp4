class Weather {
  final String city;
  final double temperature;
  final String condition;
  final String icon;
  final double humidity;
  final double windSpeed;
  final String windDirection;
  final DateTime updateTime;
  
  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.updateTime,
  });
  
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['city'] ?? '',
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      condition: json['condition'] ?? '',
      icon: json['icon'] ?? '',
      humidity: (json['humidity'] ?? 0.0).toDouble(),
      windSpeed: (json['windSpeed'] ?? 0.0).toDouble(),
      windDirection: json['windDirection'] ?? '',
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'])
          : DateTime.now(),
    );
  }
  
  // 샘플 날씨 데이터 - API 연동 전 테스트용
  static Weather getSampleWeather() {
    return Weather(
      city: '서울',
      temperature: 22.5,
      condition: '맑음',
      icon: 'clear_day',
      humidity: 60.0,
      windSpeed: 3.5,
      windDirection: '동남풍',
      updateTime: DateTime.now(),
    );
  }
  
  // 날씨 예보 데이터
  static List<Weather> getWeatherForecast() {
    return [
      Weather(
        city: '서울',
        temperature: 22.5,
        condition: '맑음',
        icon: 'clear_day',
        humidity: 60.0,
        windSpeed: 3.5,
        windDirection: '동남풍',
        updateTime: DateTime.now(),
      ),
      Weather(
        city: '서울',
        temperature: 20.0,
        condition: '흐림',
        icon: 'cloudy',
        humidity: 65.0,
        windSpeed: 4.0,
        windDirection: '남풍',
        updateTime: DateTime.now().add(const Duration(days: 1)),
      ),
      Weather(
        city: '서울',
        temperature: 18.5,
        condition: '비',
        icon: 'rainy',
        humidity: 80.0,
        windSpeed: 5.0,
        windDirection: '남서풍',
        updateTime: DateTime.now().add(const Duration(days: 2)),
      ),
      Weather(
        city: '서울',
        temperature: 17.0,
        condition: '소나기',
        icon: 'rain_shower',
        humidity: 75.0,
        windSpeed: 4.5,
        windDirection: '서풍',
        updateTime: DateTime.now().add(const Duration(days: 3)),
      ),
      Weather(
        city: '서울',
        temperature: 19.5,
        condition: '구름 조금',
        icon: 'partly_cloudy',
        humidity: 60.0,
        windSpeed: 3.0,
        windDirection: '북서풍',
        updateTime: DateTime.now().add(const Duration(days: 4)),
      ),
    ];
  }
} 