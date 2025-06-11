import 'package:d_m/services/location_service.dart';
import 'package:d_m/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:d_m/app/common/widgets/common_scaffold.dart';
import 'package:d_m/app/common/widgets/language_selection_dialog.dart';
import 'package:d_m/app/common/widgets/translatable_text.dart';
import 'dart:math';
import 'package:d_m/app/modules/user_marketplace.dart';
import 'package:d_m/app/common/widgets/active_disaster_card.dart';

class CivilianDashboardView extends StatefulWidget {
  const CivilianDashboardView({super.key});

  @override
  State<CivilianDashboardView> createState() => _CivilianDashboardViewState();
}

class _CivilianDashboardViewState extends State<CivilianDashboardView> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String? _errorMessage;
  final WeatherService _weatherService = WeatherService();
  String _weatherIconCode = '01d';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  String _getCityName() {
    if (_errorMessage != null) {
      return 'Weather Unavailable';
    }
    return LocationService.currentCity ?? 'Current Location';
  }

  String _getWeatherInfo() {
    if (_errorMessage != null || _weatherData == null) {
      final dummyOptions = [
        {'text': '27.3°C | Sunny', 'icon': '01d'},
        {'text': '24.8°C | Cloudy', 'icon': '03d'},
        {'text': '29.1°C | Normal', 'icon': '02d'},
      ];
      final selected = dummyOptions[Random().nextInt(dummyOptions.length)];
      _weatherIconCode = selected['icon']!;
      return selected['text']!;
    }

    final temp =
        ((_weatherData?['main']?['temp'] as num?)?.toDouble()?.toStringAsFixed(
          1,
        ) ??
            '27.5') +
            '°C';

    final desc = _weatherData?['weather']?[0]?['description'];
    final descFormatted =
    desc != null
        ? desc
        .toLowerCase()
        .split(' ')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ')
        : 'Normal';

    _weatherIconCode = _weatherData?['weather']?[0]?['icon'] ?? '01d';

    return '$temp | $descFormatted';
  }

  IconData _getWeatherIcon() {
    if (_errorMessage != null) {
      return Icons.cloud_off;
    }

    if (_weatherData == null) {
      return Icons.cloud_outlined;
    }

    final weatherMain =
    _weatherData?['weather']?[0]?['main']?.toString().toLowerCase();

    switch (weatherMain) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
        return Icons.blur_on;
      default:
        return Icons.cloud;
    }
  }

  Color _getWeatherColor() {
    if (_errorMessage != null) {
      return Colors.red;
    }

    final weatherMain =
    _weatherData?['weather']?[0]?['main']?.toString().toLowerCase();

    switch (weatherMain) {
      case 'clear':
        return Colors.orange;
      case 'rain':
      case 'drizzle':
        return Colors.blue;
      case 'thunderstorm':
        return Colors.purple;
      case 'snow':
        return Colors.lightBlue;
      case 'clouds':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String? city = LocationService.currentCity;

    if (city == null || city.isEmpty) {
      setState(() {
        _errorMessage = 'City not found.';
        _isLoading = false;
      });
      return;
    }

    try {
      _weatherData = await _weatherService.fetchWeather(city);
    } catch (e) {
      _errorMessage = 'Could not fetch weather.';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color(0xFF5F6898);
    final Color communityBackground = const Color(0xFFE3F2FD);
    final Color disasterBackground = const Color(0xFFE3F2FD); // Same color as community

    return CommonScaffold(
      title: 'Dashboard',
      currentIndex: 0,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // WEATHER CARD - Moved to top for better visibility
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://openweathermap.org/img/wn/$_weatherIconCode@2x.png',
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.wb_sunny,
                              size: 48,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getCityName(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getWeatherInfo(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ACTIVE DISASTER SECTION - Larger and scrollable
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    height: 280, // Increased height for more content
                    decoration: BoxDecoration(
                      color: disasterBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red[600],
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Active Disasters',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            child: const ActiveDisasterCard(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // COMMUNITY SECTION - Compact layout
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 320, // Reduced height for more compact layout
                    decoration: BoxDecoration(
                      color: communityBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Community Header
                        Row(
                          children: [
                            const Icon(
                              Icons.people_outline,
                              color: Colors.blue,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Community Updates',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Scrollable Community Content
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Community Post Header
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                        "assets/images/default_user.png",
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TranslatableText(
                                            'NDRF - Disaster Response',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '2 hours ago',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert, size: 20),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Post Content
                                const TranslatableText(
                                  'A 6.2 magnitude earthquake struck Manipur today, causing tremors across the region. Our teams are assessing damage, and emergency relief camps have been set up in Imphal and nearby areas. Citizens are advised to stay alert and follow safety protocols.',
                                  style: TextStyle(fontSize: 13, height: 1.4),
                                ),

                                const SizedBox(height: 12),

                                // Earthquake Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    "assets/images/dummy_img.jpg",
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Reaction Bar
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildReactionIcon(
                                      icon: Icons.thumb_up_alt_outlined,
                                      label: 'Like',
                                      count: '24',
                                    ),
                                    _buildReactionIcon(
                                      icon: Icons.mode_comment_outlined,
                                      label: 'Comment',
                                      count: '8',
                                    ),
                                    _buildReactionIcon(
                                      icon: Icons.share_outlined,
                                      label: 'Share',
                                      count: '12',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // View Community Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/community_history',
                                arguments: {
                                  'author': 'Disaster Response team',
                                  'content':
                                  'A 6.2 magnitude earthquake struck Manipur today. Relief camps are being set up. Stay alert and follow safety protocols.',
                                },
                              );
                            },
                            icon: const Icon(Icons.group, size: 18),
                            label: const TranslatableText('View Full Community'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Add some bottom padding to avoid floating button overlap
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Floating Ecommerce button
          Positioned(
            bottom: 165,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF5F6898),
              heroTag: "marketplace",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserMarketplacePage(),
                ),
              ),
              child: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ),

          // Floating AI Chatbot Button
          Positioned(
            bottom: 101,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: accentColor,
              heroTag: "chatbot",
              onPressed: () {
                Navigator.pushNamed(context, '/ai_chatbot');
              },
              child: Image.asset(
                'assets/images/chatbot1.png',
                width: 28,
                height: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for reaction icons with counts
  Widget _buildReactionIcon({
    required IconData icon,
    required String label,
    String? count
  }) {
    return InkWell(
      onTap: () {
        // Handle reaction tap
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (count != null) ...[
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
                TranslatableText(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}