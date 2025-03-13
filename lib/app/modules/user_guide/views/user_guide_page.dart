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
            SizedBox(height: 16),

            Text(
              '🌍 Causes:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            ),
            Text(
              disasterInfo['causes'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),

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
    'causes': "Floods occur when excessive water overflows onto normally dry land. They can be triggered by both natural and human activities. Common causes include:\n\n- **Heavy Rainfall**: Prolonged or intense rain can overwhelm drainage systems and rivers, causing flooding.\n- **Cyclones and Hurricanes**: These storms bring heavy rainfall and storm surges, flooding coastal areas.\n- **Dam Failures**: Structural weaknesses or excessive water pressure can cause dams to break, releasing massive amounts of water.\n- **Deforestation**: Loss of trees reduces water absorption, increasing runoff and the risk of flash floods.\n- **Urbanization**: Concrete surfaces prevent water absorption, causing water to accumulate rapidly.\n- **Glacial Melting**: Climate change accelerates glacier melting, leading to rising water levels and floods in nearby regions.\n\nFloods can cause severe destruction, including loss of life, water contamination, building collapses, and landslides. Low-lying areas and regions near rivers are at the highest risk.",
    'do': [
      "Stay updated with weather forecasts and flood warnings.",
      "Move valuables and important documents to higher levels in your home.",
      "Store emergency supplies, including clean water, food, flashlights, and first aid kits.",
      "Know your area's evacuation routes and nearest shelters.",
      "Turn off electricity and gas to prevent fire hazards during a flood.",
      "Move to higher ground or upper floors if it is safe to do so.",
      "Avoid walking or driving through floodwaters. Even six inches of moving water can knock you down.",
      "Abandon your vehicle if water is rising quickly and seek higher ground immediately.",
      "Boil drinking water or use purification tablets to prevent disease after a flood.",
      "Watch out for weakened structures and sinkholes before entering buildings.",
      "Report fallen power lines and other hazards to authorities."
    ],
    'dont': [
      "Do not ignore flood warnings or delay evacuation orders.",
      "Do not attempt to swim in floodwaters; currents can be stronger than they appear.",
      "Do not use electrical appliances or touch outlets in a flooded area.",
      "Do not drive through water-covered roads; as little as two feet of water can carry away most vehicles.",
      "Do not return home until authorities declare it safe."
    ],
    'video': "https://www.youtube.com/watch?v=example_flood_video"
  },

};

