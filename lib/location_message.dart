import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMessage extends StatelessWidget {
  final String base64String;

  LocationMessage({required this.base64String});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _decodeBase64(base64String),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error decoding message');
        }

        final locationData = snapshot.data as Map<String, dynamic>;
        final currentLocation = locationData['currentLocation'];
        final destination = locationData['destination'];
        final estimatedArrival = locationData['estimatedArrival'];

        // Create markers for the current location and destination
        final currentLatLng = LatLng(currentLocation['latitude'], currentLocation['longitude']);
        final destinationLatLng = LatLng(destination['latitude'], destination['longitude']);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLatLng,
                  zoom: 12,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('current_location'),
                    position: currentLatLng,
                    infoWindow: InfoWindow(title: 'Your Location'),
                  ),
                  Marker(
                    markerId: MarkerId('destination'),
                    position: destinationLatLng,
                    infoWindow: InfoWindow(title: 'Destination'),
                  ),
                },
                polylines: {
                  Polyline(
                    polylineId: PolylineId('route'),
                    points: [currentLatLng, destinationLatLng],
                    color: Colors.blue,
                    width: 5,
                  ),
                },
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Estimated Arrival: $estimatedArrival',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  // Decode the Base64 string to get location data
  Future<Map<String, dynamic>> _decodeBase64(String base64String) async {
    List<int> bytes = base64Decode(base64String);
    String jsonString = utf8.decode(bytes);
    return json.decode(jsonString);
  }
}