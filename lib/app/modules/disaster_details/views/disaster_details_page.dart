import 'package:flutter/material.dart';
import 'package:d_m/app/data/models/flood_prediction_response.dart';
import 'package:d_m/app/data/models/cyclone_prediction_response.dart';
import 'package:d_m/app/data/models/earthquake_prediction_response.dart';
import 'package:url_launcher/url_launcher.dart';

class DisasterDetailsPage extends StatelessWidget {
  // Constructor is now const and doesn't take direct disaster objects
  const DisasterDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final FloodPredictionResponse? floodPrediction = arguments?['floodPrediction'] as FloodPredictionResponse?;
    final CyclonePredictionResponse? cyclonePrediction = arguments?['cyclonePrediction'] as CyclonePredictionResponse?;
    final EarthquakePredictionResponse? earthquakePrediction = arguments?['earthquakePrediction'] as EarthquakePredictionResponse?;

    // UI to display disaster details will be added here
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (floodPrediction != null)
              _buildFloodInfo(context, floodPrediction!),
            if (cyclonePrediction != null)
              _buildCycloneInfo(context, cyclonePrediction!),
            if (earthquakePrediction != null)
              _buildEarthquakeInfo(context, earthquakePrediction!),
            if (floodPrediction == null && cyclonePrediction == null && earthquakePrediction == null)
              const Center(child: Text('No disaster details available.')),
          ],
        ),
      ),
    );
  }

  // Placeholder for methods to build UI for each disaster type
  // These will be similar to _buildFloodInfo, _buildCycloneInfo, _buildEarthquakeInfo
  // from ActiveDisasterCard.dart, but adapted for this page.

  Widget _buildFloodInfo(BuildContext context, FloodPredictionResponse flood) {
    String risk = flood.floodRisk ?? "N/A";
    Color riskColor = Colors.green;
    if (risk.toLowerCase() == 'high') riskColor = Colors.red;
    if (risk.toLowerCase() == 'medium') riskColor = Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.water_drop_outlined, color: Colors.blue.shade700, size: 28),
                const SizedBox(width: 10),
                Text('Flood Prediction', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text('District: ${flood.matchedDistrict ?? "N/A"}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Risk: ', style: Theme.of(context).textTheme.bodyLarge),
                Text(risk, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: riskColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycloneInfo(BuildContext context, CyclonePredictionResponse cyclone) {
    String condition = cyclone.cycloneCondition ?? "N/A";
    Color conditionColor = Colors.grey;
    if (cyclone.cycloneCondition != null) {
        conditionColor = Colors.green;
        if (condition.toLowerCase().contains('depression')) conditionColor = Colors.yellow.shade700;
        if (condition.toLowerCase().contains('storm')) conditionColor = Colors.orange;
        if (condition.toLowerCase().contains('cyclone') && !condition.toLowerCase().contains('no cyclone')) conditionColor = Colors.red;
        if (condition.toLowerCase().contains('super cyclone')) conditionColor = Colors.purple.shade700;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cyclone_outlined, color: Colors.blueGrey.shade700, size: 28),
                const SizedBox(width: 10),
                Text('Cyclone Prediction', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Condition: ${condition}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: conditionColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Location: ${cyclone.location?.district ?? "N/A"} (${cyclone.location?.latitude?.toStringAsFixed(2)}, ${cyclone.location?.longitude?.toStringAsFixed(2)})', style: Theme.of(context).textTheme.bodyLarge),
            if (cyclone.weatherData != null) ...[
              const SizedBox(height: 8),
              Text('Wind Speed: ${cyclone.weatherData?.usaWind} m/s', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text('Pressure: ${cyclone.weatherData?.usaPres} hPa', style: Theme.of(context).textTheme.bodyLarge),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildEarthquakeInfo(BuildContext context, EarthquakePredictionResponse earthquake) {
    // Note: The original card had a 'Read more' link. We might want to keep that.
    // For now, focusing on displaying the core info.
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.vibration_outlined, color: Colors.brown.shade700, size: 28),
                const SizedBox(width: 10),
                Text('Earthquake Prediction', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            if (earthquake.highRiskCities != null && earthquake.highRiskCities!.isNotEmpty) ...[
              Text('High-Risk Cities:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...earthquake.highRiskCities!.map((city) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text('- ${city.city}, ${city.state} (Magnitude: ${city.magnitude})', style: Theme.of(context).textTheme.bodyLarge),
              )).toList(),
              if (earthquake.readMoreUrl != null && earthquake.readMoreUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: InkWell(
                    child: Text(
                      'Read more about seismic activity',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                      ),
                    ),
                    onTap: () async {
                      final Uri? url = Uri.tryParse(earthquake.readMoreUrl!);
                      if (url != null) {
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          // Log or show a snackbar
                          print('Could not launch ${earthquake.readMoreUrl}');
                          if (ScaffoldMessenger.maybeOf(context) != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not open link: ${earthquake.readMoreUrl}')),
                              );
                          }
                        }
                      }
                    },
                  ),
                ),
            ] else
              Text('No specific high-risk cities identified currently.', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
