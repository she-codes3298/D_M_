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
  final Color backgroundColor = const Color(0xFFE3F2FD);

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
      userName = prefs.getString('name') ?? 'Pratiksha'; // Default name
      isProfileComplete = prefs.getString('abhaId') != null;

      if (isProfileComplete) {
        qrData = '''
        Name: ${prefs.getString('name')}
        Age: ${prefs.getString('age')}
        Blood Group: ${prefs.getString('bloodGroup')}
        Emergency Contact: ${prefs.getString('emergencyContact')}
        ABHA ID: ${prefs.getString('abhaId')}
        Allergies: ${prefs.getString('allergies')}
        Medical History: ${prefs.getString('medicalHistory')}
        Existing Medications: ${prefs.getString('existingMedications')}
        Disabilities: ${prefs.getString('disabilities')}
        Vaccination Status: ${prefs.getString('vaccinationStatus')}
        Organ Donor: ${prefs.getString('organDonor')}
        ''';
      }
    });
  }

  void _shareQRCode() {
    if (isProfileComplete && qrData != null) {
      Share.share(qrData!, subject: "My Medical QR Code");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Complete your profile to share QR Code")),
      );
    }
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
    if (isProfileComplete) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDetailsPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Complete your profile to view details")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
              CircleAvatar(
                radius: 50,
                backgroundColor: accentColor,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                userName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: accentColor),
              ),
              SizedBox(height: 20),

              // QR Code Section
              Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      isProfileComplete
                          ? QrImageView(data: qrData!, size: 150)
                          : Text("Complete your profile to generate QR Code"),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _navigateToCompleteProfile,
                        style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                        child: Text(
                          isProfileComplete ? 'Edit Profile' : 'Complete Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _navigateToMedicalDetails,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    icon: Icon(Icons.info, color: Colors.white),
                    label: Text("View Medical Details", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _shareQRCode,
                    style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                    icon: Icon(Icons.share, color: Colors.white),
                    label: Text("Share QR Code", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
