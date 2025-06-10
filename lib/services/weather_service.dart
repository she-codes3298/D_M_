import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'AIzaSyDx5jUKoJPNoeKSjbLcaCqMGrpVHErGhq0';

  // First get place details from Google Places API
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json'
        '?input=$city&inputtype=textquery&fields=geometry&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get place details');
    }
  }
}
