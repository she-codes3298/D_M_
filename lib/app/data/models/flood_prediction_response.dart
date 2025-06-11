class FloodPredictionResponse {
  final String? originalDistrict;
  final String? matchedDistrict;
  final String? floodRisk;

  FloodPredictionResponse({
    this.originalDistrict,
    this.matchedDistrict,
    this.floodRisk,
  });

  factory FloodPredictionResponse.fromJson(Map<String, dynamic> json) {
    return FloodPredictionResponse(
      originalDistrict: json['original_district'],
      matchedDistrict: json['matched_district'],
      floodRisk: json['flood_risk'],
    );
  }
}
