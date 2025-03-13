import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:d_m/app/common/widgets/common_scaffold.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Virtual Training Guide',
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: disasterCategories.length,
          itemBuilder: (context, index) {
            String category = disasterCategories.keys.elementAt(index);
            IconData icon = disasterCategories[category]!;

            return Card(
              color: Colors.blue[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Icon(icon, size: 30, color: Color(0xFF5F6898)),
                title: Text(
                  category,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5F6898),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisasterDetailPage(category: category),
                    ),
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF5F6898)),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DisasterDetailPage extends StatelessWidget {
  final String category;
  const DisasterDetailPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final disasterInfo = disasterDetails[category] ?? {'do': [], 'dont': [], 'video': ''};

    return CommonScaffold(
      title: category,
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Image Illustration
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/${category.toLowerCase().replaceAll(" ", "_")}.png', // Add images in assets
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            // To-Do List
            Text(
              '✅ To-Do List:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green[800]),
            ),
            ...disasterInfo['do']!.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text(item, style: TextStyle(fontSize: 16))),
                ],
              ),
            )),
            SizedBox(height: 12),

            // Don'ts List
            Text(
              "❌ Don'ts:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red[800]),
            ),
            ...disasterInfo['dont']!.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.cancel, color: Colors.red[700], size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text(item, style: TextStyle(fontSize: 16))),
                ],
              ),
            )),
            SizedBox(height: 12),

            // Learn More Video
            if (disasterInfo['video']!.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () async {
                  final Uri url = Uri.parse(disasterInfo['video']!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                icon: Icon(Icons.video_library),
                label: Text('Watch Training Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Disaster Categories
Map<String, IconData> disasterCategories = {
  'Earthquake': Icons.house,
  'Flood': Icons.water,
  'Cyclone': Icons.air,
  'Fire Safety': Icons.local_fire_department,
  'Tsunami': Icons.waves,
  'Landslide': Icons.terrain,
  'Pandemic': Icons.health_and_safety,
  'Industrial Accidents': Icons.factory,
  'Nuclear Disasters': Icons.radioactive_sharp,
};

// Disaster-Specific Do’s, Don'ts, and Video Links
Map<String, Map<String, dynamic>> disasterDetails = {
  'Earthquake': {
    'do': [
      'Drop, Cover, and Hold under a sturdy table.',
      'Stay indoors until the shaking stops.',
      'Turn off gas, electricity if safe to do so.',
      'Keep emergency supplies ready.',
    ],
    'dont': [
      'Do not use elevators during tremors.',
      'Do not stand near windows or mirrors.',
      'Do not run outside immediately.',
    ],
    'video': 'https://www.youtube.com/watch?v=GSDmqLQmMN0',
  },
  'Flood': {
    'do': [
      'Move to higher ground immediately.',
      'Turn off electrical appliances.',
      'Store drinking water in clean containers.',
      'Follow evacuation instructions from authorities.',
    ],
    'dont': [
      'Do not drive or walk through floodwaters.',
      'Do not touch electrical equipment if wet.',
      'Do not ignore weather alerts.',
    ],
    'video': 'https://www.youtube.com/watch?v=8y_U0DFiB0I',
  },
  'Cyclone': {
    'do': [
      'Secure loose objects outside your home.',
      'Stay indoors and away from windows.',
      'Stockpile emergency supplies.',
      'Charge your phone and power banks.',
    ],
    'dont': [
      'Do not go near coastal areas.',
      'Do not use candles if power goes out (fire risk).',
      'Do not spread rumors about cyclone paths.',
    ],
    'video': 'https://www.youtube.com/watch?v=RKTgNNB4kB0',
  },
  'Fire Safety': {
    'do': [
      'Stop, Drop, and Roll if clothing catches fire.',
      'Use a fire extinguisher for small fires.',
      'Evacuate immediately in case of large fires.',
      'Test smoke alarms regularly.',
    ],
    'dont': [
      'Do not use water on electrical fires.',
      'Do not open doors if you feel heat behind them.',
      'Do not re-enter a burning building.',
    ],
    'video': 'https://www.youtube.com/watch?v=dcQ_kJB2mO8',
  },
};

