class EarthquakePredictionResponse {
  final List<HighRiskCity>? highRiskCities;
  final String? readMoreUrl;

  EarthquakePredictionResponse({
    this.highRiskCities,
    this.readMoreUrl,
  });

  factory EarthquakePredictionResponse.fromJson(Map<String, dynamic> json) {
    var citiesList = json['high_risk_cities'] as List?;
    List<HighRiskCity>? highRiskCitiesList;
    if (citiesList != null) {
      highRiskCitiesList = citiesList.map((i) => HighRiskCity.fromJson(i)).toList();
    }

    return EarthquakePredictionResponse(
      highRiskCities: highRiskCitiesList,
      readMoreUrl: json['read_more_url'],
    );
  }
}

class HighRiskCity {
  final String? city;
  final String? state;
  final double? magnitude;

  HighRiskCity({this.city, this.state, this.magnitude});

  factory HighRiskCity.fromJson(Map<String, dynamic> json) {
    return HighRiskCity(
      city: json['city'],
      state: json['state'],
      magnitude: (json['magnitude'] as num?)?.toDouble(),
    );
  }
}
