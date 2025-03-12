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
  final Color communityBackground = const Color(0xFFE3F2FD);

  String userName = "Pratiksha"; // Default name
  String? qrData;
  bool isProfileComplete = false;

  // Dummy QR Data for Initial Display
  final String dummyQRData = """
Personal Information:
Name - Pratiksha
Age - 21
Blood Group - O+
ABHA ID - 5278496372920016

Emergency Contact:
Name - Kumari Nisha
Relation - Sibling
Phone Number - 9863301615

Medical Details:
Medical History - Asthma, Hypertension
Allergies - Dust, Peanuts, Soy
Medications - Painkillers, Antibiotics, Aspirin
Disabilities - Vision Impairment
""";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Pratiksha';
      isProfileComplete = prefs.getString('abhaId')?.isNotEmpty ?? false;

      if (isProfileComplete) {
        qrData = prefs.getString('qrData') ?? dummyQRData; // Load actual QR data
      } else {
        qrData = dummyQRData; // Show predefined dummy QR data
      }
    });
  }

  void _shareQRCode() {
    if (qrData != null && qrData!.isNotEmpty) {
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
      loadProfile();
    }
  }

  void _navigateToMedicalDetails() {
    if (isProfileComplete) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ViewDetailsPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Complete your profile to view details")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: communityBackground,
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
              // Profile Picture and Name
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: accentColor,
                    child: Icon(Icons.person, size: 50, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: accentColor),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // QR Code Section
              Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                    ],
                  ),
                  child: Column(
                    children: [
                      QrImageView(data: qrData!, size: 150),
                      SizedBox(height: 10),

                      // Complete or Edit Profile Button
                      ElevatedButton(
                        onPressed: _navigateToCompleteProfile,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                            isProfileComplete ? Colors.orange : accentColor),
                        child: Text(isProfileComplete ? 'Edit Profile' : 'Complete Profile',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // View Details & Share QR Code Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _navigateToMedicalDetails,
                    style:
                    ElevatedButton.styleFrom(backgroundColor: accentColor),
                    icon: Icon(Icons.info, color: Colors.white),
                    label: Text("View Medical Details",
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _shareQRCode,
                    style:
                    ElevatedButton.styleFrom(backgroundColor: accentColor),
                    icon: Icon(Icons.share, color: Colors.white),
                    label: Text("Share QR Code",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Additional Buttons (Community, e-Sahyog, Settings, Help)
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.groups, color: Colors.black),
                    title: Text('Community'),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onTap: () {
                      Navigator.pushNamed(context, '/community_history');
                    }, // Add Community Page Navigation
                  ),
                  SizedBox(height: 10),
                  // AI Chatbot Button (Replacing E-Sahyog)
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/ai_chatbot'); // Navigate to chatbot page
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/chatbot.png',
                          width: 28, // Set the width
                          height: 28, // Set the height
                        ),
                        SizedBox(width: 10), // Space between image and text
                        Text(
                          'E-Sahyog',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.black),
                    title: Text('Settings'),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onTap: () {}, // Settings Page
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.help_outline, color: Colors.black),
                    title: Text('Help & Support'),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onTap: () {}, // Help Page
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
