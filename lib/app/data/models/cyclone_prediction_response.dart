class CyclonePredictionResponse {
  final String? timestampUtc;
  final Location? location;
  final WeatherData? weatherData;
  final String? cycloneCondition;

  CyclonePredictionResponse({
    this.timestampUtc,
    this.location,
    this.weatherData,
    this.cycloneCondition,
  });

  factory CyclonePredictionResponse.fromJson(Map<String, dynamic> json) {
    return CyclonePredictionResponse(
      timestampUtc: json['timestamp_utc'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      weatherData: json['weather_data'] != null ? WeatherData.fromJson(json['weather_data']) : null,
      cycloneCondition: json['cyclone_condition'],
    );
  }
}

class Location {
  final double? latitude;
  final double? longitude;
  final String? district;

  Location({this.latitude, this.longitude, this.district});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      district: json['district'],
    );
  }
}

class WeatherData {
  final double? usaWind;
  final int? usaPres;
  final int? stormSpeed;
  final int? stormDir;
  final int? month;

  WeatherData({
    this.usaWind,
    this.usaPres,
    this.stormSpeed,
    this.stormDir,
    this.month,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      usaWind: (json['usa_wind'] as num?)?.toDouble(),
      usaPres: json['usa_pres'],
      stormSpeed: json['storm_speed'],
      stormDir: json['storm_dir'],
      month: json['month'],
    );
  }
}
