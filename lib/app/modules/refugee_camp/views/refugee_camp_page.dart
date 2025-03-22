import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RefugeeCampMap extends StatefulWidget {
  @override
  _RefugeeCampMapState createState() => _RefugeeCampMapState();
}

class _RefugeeCampMapState extends State<RefugeeCampMap> {
  GoogleMapController? _mapController;
  Location _location = Location();
  LatLng? _currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
    _fetchCamps();
  }

  void _fetchUserLocation() async {
    var locationData = await _location.getLocation();
    setState(() {
      _currentPosition = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      _markers.add(
        Marker(
          markerId: MarkerId('userLocation'),
          position: _currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      );
    });
  }

  void _fetchCamps() async {
    FirebaseFirestore.instance.collection('refugee_camps').get().then((
      snapshot,
    ) {
      setState(() {
        for (var camp in snapshot.docs) {
          var data = camp.data() as Map<String, dynamic>;
          LatLng campPosition = LatLng(data['latitude'], data['longitude']);
          _markers.add(
            Marker(
              markerId: MarkerId(camp.id),
              position: campPosition,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
              infoWindow: InfoWindow(
                title: data['name'],
                snippet: 'Tap for details',
              ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Refugee Camps")),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(20.5937, 78.9629),
          zoom: 5,
        ),
        markers: _markers,
        myLocationEnabled: true,
      ),
    );
  }
}
