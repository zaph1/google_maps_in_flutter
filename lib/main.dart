import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};
  late BitmapDescriptor buildingIcon;

  @override
  void initState() {
    super.initState();
    loadCustomMarkerIcon();
  }

  // Load the custom marker icon
  void loadCustomMarkerIcon() async {
    buildingIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)), // Size of the icon
      'assets/icon.png', // Path to your custom icon
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final upmFaculties = await locations.getCustomLocations();
    setState(() {
      _markers.clear();
      for (final faculty in upmFaculties.offices) {
        final marker = Marker(
          markerId: MarkerId(faculty.name),
          position: LatLng(faculty.lat, faculty.lng),
          icon: buildingIcon, // Use the custom icon
          infoWindow: InfoWindow(
            title: faculty.name,
            snippet: faculty.address,
          ),
        );
        _markers[faculty.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('UPM Faculty Locations'),
          elevation: 2,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(3.0045, 101.7072), // Centered on UPM
            zoom: 15,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}