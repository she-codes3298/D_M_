import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'complete_profile_page.dart';

class ViewDetailsPage extends StatefulWidget {
  @override
  _ViewDetailsPageState createState() => _ViewDetailsPageState();
}

class _ViewDetailsPageState extends State<ViewDetailsPage> {
  final Color accentColor = const Color(0xFF5F6898);
  final Color background = const Color(0xFFE3F2FD);

  String? name, age, bloodGroup, emergencyContact, abhaId, allergies, medicalHistory;
  bool isProfileComplete = true; // Flag to check if all details are filled

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
      emergencyContact = prefs.getString('emergencyContact') ?? 'N/A';
      abhaId = prefs.getString('abhaId') ?? 'N/A';
      allergies = prefs.getString('allergies') ?? 'None';
      medicalHistory = prefs.getString('medicalHistory') ?? 'No medical history available';

      // Check if any field is still 'N/A'
      isProfileComplete = !(name == 'N/A' || age == 'N/A' || bloodGroup == 'N/A' ||
          emergencyContact == 'N/A' || abhaId == 'N/A');
    });
  }

  void _navigateToCompleteProfile() async {
    bool? profileUpdated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompleteProfilePage()),
    );

    if (profileUpdated == true) {
      loadProfileDetails(); // Refresh profile details after updating
    }
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
              // Section Title: Personal Information
              Text(
                "Personal Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentColor),
              ),
              SizedBox(height: 10),
              buildInfoTile("Name", name),
              buildInfoTile("Age", age),
              buildInfoTile("Blood Group", bloodGroup),
              buildInfoTile("Emergency Contact", emergencyContact),
              buildInfoTile("ABHA ID", abhaId),
              SizedBox(height: 20),

              // Section Title: Medical History
              Text(
                "Medical History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentColor),
              ),
              SizedBox(height: 10),
              buildInfoTile("Allergies", allergies),
              buildInfoTile("Medical History", medicalHistory),

              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _navigateToCompleteProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isProfileComplete ? Colors.orange : Colors.red,
                  ),
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text(isProfileComplete ? "Edit Profile" : "Complete Profile", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 10),
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
}
