import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class CivilianRefugeeMap extends StatefulWidget {
  @override
  _CivilianRefugeeMapState createState() => _CivilianRefugeeMapState();
}

class _CivilianRefugeeMapState extends State<CivilianRefugeeMap> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> refugeeCamps = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _listenToCamps();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void _listenToCamps() {
    FirebaseFirestore.instance
        .collection('civilian_data')
        .doc('refugee_camps')
        .snapshots()
        .listen((snapshot) {
      var data = snapshot.data();
      if (data != null && data.containsKey('camps')) {
        List<Map<String, dynamic>> camps = (data['camps'] as List)
            .map((camp) => {
          'name': camp['name'] ?? 'Unknown',
          'location': LatLng(
              (camp['location'] as GeoPoint).latitude,
              (camp['location'] as GeoPoint).longitude),
          'address': camp['address'] ?? 'No Address Available',
          'capacity': camp['capacity'] ?? 0,
          'current_occupancy': camp['current_occupancy'] ?? 0,
          'resources': camp['resources'] ?? 'None',
          'contact': camp['contact'] ?? 'No Contact Available',
        })
            .toList();
        setState(() {
          refugeeCamps = camps;
          _updateMarkers();
        });
      }
    });
  }

  void _updateMarkers() {
    _markers.clear();
    for (var camp in refugeeCamps) {
      _markers.add(Marker(
        markerId: MarkerId(camp['name']),
        position: camp['location'],
        infoWindow: InfoWindow(
          title: camp['name'],
          snippet:
          "Capacity: ${camp['capacity']}, Occupied: ${camp['current_occupancy']}",
          onTap: () => _showCampDetails(camp),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
  }

  void _showCampDetails(Map<String, dynamic> camp) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(camp['name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("📍 Address: ${camp['address']}"),
              Text("🏠 Capacity: ${camp['capacity']} | 🏡 Occupied: ${camp['current_occupancy']}"),
              Text("🛠 Resources: ${camp['resources']}"),
              Text("📞 Contact: ${camp['contact']}"),
              SizedBox(height: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.directions),
                label: Text("Navigate Here"),
                onPressed: () {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(camp['location'], 15),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Refugee Camps Near You")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation ?? LatLng(28.7041, 77.1025),
              zoom: 5,
            ),
            markers: _markers,
            onMapCreated: (controller) => _mapController = controller,
          ),
          Positioned(
            top: 10,
            left: 10,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.my_location, color: Colors.white),
              onPressed: () {
                if (_currentLocation != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(_currentLocation!, 14),
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 220,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
              ),
              child: ListView.separated(
                itemCount: refugeeCamps.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  final camp = refugeeCamps[index];
                  return ListTile(
                    title: Text(camp['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("📍 ${camp['address']}"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showCampDetails(camp),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
