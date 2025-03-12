import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewDetailsPage extends StatefulWidget {
  @override
  _ViewDetailsPageState createState() => _ViewDetailsPageState();
}

class _ViewDetailsPageState extends State<ViewDetailsPage> {
  final Color accentColor = const Color(0xFF5F6898);
  final Color background = const Color(0xFFE3F2FD);

  String? name, age, bloodGroup, emergencyName, emergencyContact, emergencyRelation, abhaId;
  List<String> medicalHistory = [], allergies = [], medications = [], disabilities = [];

  @override
  void initState() {
    super.initState();
    loadProfileDetails();
  }

  Future<void> loadProfileDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'N/A';
      age = prefs.getString('age') ?? 'N/A';
      bloodGroup = prefs.getString('bloodGroup') ?? 'N/A';
      emergencyName = prefs.getString('emergencyName') ?? 'N/A';
      emergencyContact = prefs.getString('emergencyContact') ?? 'N/A';
      emergencyRelation = prefs.getString('emergencyRelation') ?? 'N/A';
      abhaId = prefs.getString('abhaId') ?? 'N/A';

      medicalHistory = prefs.getStringList('medicalHistory') ?? [];
      allergies = prefs.getStringList('allergies') ?? [];
      medications = prefs.getStringList('medications') ?? [];
      disabilities = prefs.getStringList('disabilities') ?? [];
    });
  }

  String formatList(List<String> list) {
    return list.isNotEmpty ? list.join(", ") : "None";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("Medical Details", style: TextStyle(color: Colors.white)),
        backgroundColor: accentColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Personal Information", style: sectionTitleStyle()),
              SizedBox(height: 10),
              buildInfoTile("Name", name),
              buildInfoTile("Age", age),
              buildInfoTile("Blood Group", bloodGroup),
              buildInfoTile("ABHA ID", abhaId),

              SizedBox(height: 20),
              Text("Emergency Contact", style: sectionTitleStyle()),
              SizedBox(height: 10),
              buildInfoTile("Name", emergencyName),
              buildInfoTile("Relation", emergencyRelation),
              buildInfoTile("Phone Number", emergencyContact),

              SizedBox(height: 20),
              Text("Medical Details", style: sectionTitleStyle()),
              SizedBox(height: 10),
              buildInfoTile("Medical History", formatList(medicalHistory)),
              buildInfoTile("Allergies", formatList(allergies)),
              buildInfoTile("Medications", formatList(medications)),
              buildInfoTile("Disabilities", formatList(disabilities)),

              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  label: Text("Back to Profile", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoTile(String title, String? value) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: accentColor)),
        subtitle: Text(value ?? "N/A", style: TextStyle(fontSize: 16)),
      ),
    );
  }

  TextStyle sectionTitleStyle() => TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentColor);
}
