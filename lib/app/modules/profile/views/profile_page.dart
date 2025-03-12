import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'complete_profile_page.dart';
import 'view_details_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color accentColor = const Color(0xFF5F6898);
  final Color background = const Color(0xFFE3F2FD);

  String userName = "Pratiksha"; // Default name
  String? qrData;
  bool isProfileComplete = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Pratiksha';
      isProfileComplete = prefs.getString('abhaId') != null &&
          prefs.getString('age') != null &&
          prefs.getString('bloodGroup') != null &&
          prefs.getString('emergencyContact') != null;

      if (isProfileComplete) {
        qrData = '''
        Name: ${prefs.getString('name')}
        Age: ${prefs.getString('age')}
        Blood Group: ${prefs.getString('bloodGroup')}
        Emergency Contact: ${prefs.getString('emergencyContact')}
        ABHA ID: ${prefs.getString('abhaId')}
        ''';
      }
    });
  }

  void _navigateToCompleteProfile() async {
    bool? profileUpdated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompleteProfilePage()),
    );

    if (profileUpdated == true) {
      loadProfile(); // Refresh profile and QR code
    }
  }

  void _navigateToMedicalDetails() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDetailsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(radius: 50, backgroundColor: accentColor, child: Icon(Icons.person, size: 50, color: Colors.white)),
              SizedBox(height: 10),
              Text(userName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: accentColor)),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _navigateToCompleteProfile,
                style: ElevatedButton.styleFrom(backgroundColor: isProfileComplete ? Colors.orange : Colors.red),
                child: Text(isProfileComplete ? "Edit Profile" : "Complete Profile", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _navigateToMedicalDetails, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: Text("View Medical Details", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}
