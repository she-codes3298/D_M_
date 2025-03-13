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
  'Earthquake': Icons.house, // Represents home safety
  'Flood': Icons.water, // Represents water-related disasters
  'Cyclone': Icons.air, // Represents stormy winds
  'Fire Safety': Icons.local_fire_department, // Represents fire hazards
  'Tsunami': Icons.waves, // Represents massive ocean waves
  'Landslide': Icons.terrain, // Represents ground movement
  'Pandemic': Icons.health_and_safety, // Represents health-related disasters
  'Industrial Accidents': Icons.factory, // Represents factory and chemical hazards
  'Nuclear Disasters': Icons.volcano, // Represents radioactive hazards
  'Drought': Icons.cloud_off, // Represents water scarcity
  'Terrorist Attacks': Icons.dangerous, // Represents threats to security
  'Chemical Spills': Icons.science, // Represents hazardous chemical leaks
  'Volcanic Eruption': Icons.whatshot, // Represents volcanic activity
  'Heatwave': Icons.thermostat, // Represents extreme heat conditions
  'Cold Wave': Icons.ac_unit, // Represents extreme cold conditions
  'Lightning Strikes': Icons.flash_on, // Represents thunderstorms
  'Oil Spills': Icons.local_gas_station, // Represents environmental pollution
  'Mine Collapses': Icons.construction, // Represents underground hazards
  'Building Collapse': Icons.apartment, // Represents structural failures
  'Tornado': Icons.wind_power, // Represents rotating windstorms
  'Stampede': Icons.people, // Represents crowd-related hazards
  'Train Accidents': Icons.train, // Represents rail transport hazards
  'Airplane Crash': Icons.flight, // Represents aviation disasters
  'Bridge Collapse': Icons.horizontal_rule_rounded, // Represents infrastructure failure
  'Forest Fire': Icons.forest, // Represents wildfires
  'Dam Failure': Icons.flood_sharp, // Represents water infrastructure failure
  'Avalanche': Icons.snowing, // Represents falling snow disasters
  'Electrocution': Icons.electric_bolt, // Represents electrical hazards
};


// Disaster-Specific Do’s, Don'ts, and Video Links
Map<String, Map<String, dynamic>> disasterDetails = {
  'Earthquake': {
    'causes': "Earthquakes occur due to sudden movements in the Earth's crust, mainly caused by tectonic plate shifts along fault lines. These movements generate seismic waves, leading to ground shaking. The most common causes of earthquakes include:\n\n- **Tectonic Activity**: The Earth's crust is divided into plates that constantly move. When stress builds up at the plate boundaries, it is released as an earthquake.\n- **Volcanic Eruptions**: Underground magma movement can trigger earthquakes near active volcanoes.\n- **Human Activities**: Mining, fracking, dam construction, and underground nuclear tests can induce seismic activity.\n- **Subduction Zones**: When one tectonic plate slides beneath another, intense pressure builds up, eventually causing massive quakes, often leading to tsunamis.",
    'do': [
      "Secure heavy furniture and appliances to prevent them from toppling.",
      "Identify safe spots in your home, such as under sturdy tables or against interior walls.",
      "Keep an emergency kit with food, water, flashlight, and first-aid supplies.",
      "Drop, Cover, and Hold under sturdy furniture during an earthquake.",
      "Move away from windows, mirrors, and heavy objects.",
      "If outside, move to an open area away from buildings and trees.",
      "If in a vehicle, pull over safely and remain inside until the shaking stops.",
      "Check yourself and others for injuries after the shaking stops.",
      "Turn off gas and electricity if there are signs of leaks or sparks.",
      "Listen to emergency broadcasts and follow official evacuation instructions."
    ],
    'dont': [
      "Do not use elevators during or after an earthquake.",
      "Do not rush outside if you’re in a high-rise building; use stairs after the shaking stops.",
      "Do not light matches or candles immediately after a quake, as gas leaks may cause explosions.",
      "Do not stand under doorways, as they are no longer the safest places in modern buildings.",
      "Do not spread unverified information or rumors that could cause panic."
    ],
    'video': "https://www.youtube.com/watch?v=G2Trp3XBT9E"
  },

  'Flood': {
    'icon': Icons.water,
    'backgroundColor': Colors.blue[100],
    'generalInfo': "Floods result from excessive rainfall, dam failures, or storm surges. They lead to property damage, loss of life, and waterborne diseases. Early warning systems and proper drainage can help mitigate their effects.",
    'dos': [
      "Move to higher ground immediately.",
      "Turn off electricity and gas to prevent hazards.",
      "Keep emergency supplies, including drinking water and dry food.",
      "Avoid walking or driving through floodwaters.",
      "Stay tuned to weather reports for updates."
    ],
    'donts': [
      "Do not attempt to swim through floodwaters.",
      "Do not ignore evacuation orders from authorities.",
      "Do not touch electrical appliances if wet.",
      "Do not drink floodwater—it may be contaminated."
    ],
    'videoLink': "https://www.youtube.com/watch?v=78p_w_7GOWg"
  },

  'Cyclone': {
    'icon': Icons.air,
    'backgroundColor': Colors.cyan[100],
    'generalInfo': "Cyclones are intense circular storms that form over warm ocean waters. They bring heavy rainfall, strong winds, and storm surges, causing widespread devastation. Preparedness and timely warnings save lives.",
    'dos': [
      "Secure doors, windows, and loose objects outside.",
      "Stock up on food, water, and first aid supplies.",
      "Stay indoors during the storm and away from windows.",
      "Charge mobile phones and keep emergency contacts handy.",
      "Follow evacuation orders if issued by local authorities."
    ],
    'donts': [
      "Do not ignore cyclone warnings.",
      "Do not venture outside until an official all-clear is given.",
      "Do not use mobile phones unnecessarily to keep networks free.",
      "Do not attempt to drive during heavy winds."
    ],
    'videoLink': "https://www.youtube.com/watch?v=9MrflsDV0cA"
  },

  'Fire Safety': {
    'icon': Icons.local_fire_department,
    'backgroundColor': Colors.red[100],
    'generalInfo': "Fires can start due to electrical faults, gas leaks, or unattended flames. They spread rapidly, causing severe injuries and property damage. Fire safety training and precautions are essential for prevention.",
    'dos': [
      "Install smoke detectors and fire extinguishers at home.",
      "Have an emergency evacuation plan for all family members.",
      "Turn off electrical appliances when not in use.",
      "Use a fire blanket or extinguisher to control small fires.",
      "Crawl low under smoke to avoid inhaling toxic fumes."
    ],
    'donts': [
      "Do not leave cooking unattended.",
      "Do not overload electrical circuits.",
      "Do not block emergency exits or fire escape routes.",
      "Do not use water to extinguish oil or electrical fires."
    ],
    'videoLink': "https://www.youtube.com/watch?v=RQUiVT4XJUM"
  },
};

