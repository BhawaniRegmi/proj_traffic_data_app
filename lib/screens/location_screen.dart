import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traffic_data_app/extra/map_snapshot.dart';

const String kGoogleApiKey = 'AIzaSyD0LayCont6VX0Ztytf2oUbMOkcimwOINM';
const String kThunderApiKey = '606e7734e68e4830a0f159d2d161039d';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final service = FlutterBackgroundService();
  Timer? _timer;
  bool _isLogging = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Location location = Location();
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _loadIsLogging();
  }

  void _loadIsLogging() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLogging = (prefs.getBool('isL_isLogging') ?? false);
    });
  }

  void _toggleIsLogging(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLogging = value;
      prefs.setBool('isLogging', _isLogging);
    });
  }

  void _startLogging() {
    if (_isLogging) return;

    setState(() {
      _isLogging = true;
    });

    service.startService();

    // Start periodic logging every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
    // _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isLogging) {
        timer.cancel();
        return;
      }
      _logData(); // Call _logData periodically
    });

    // Stop logging automatically at 7:30 pm
    final now = DateTime.now();
    final stopTime = DateTime(now.year, now.month, now.day, 19, 30);

    if (now.isBefore(stopTime)) {
      final durationUntilStop = stopTime.difference(now);
      Timer(durationUntilStop, _stopLogging);
    } else {
      // This means the time is already past 7:30
      _stopLogging();
    }
  }

  void _stopLogging() {
    if (!_isLogging) return;

    setState(() {
      _isLogging = false;
      _timer!.cancel();
    });

    service.invoke("stopService");
  }

  Future<void> _logData() async {
    // Location
    try {
      _locationData = await location.getLocation();
      print('got location');
    } on Exception catch (_) {
      print('Oh no something went wrong with location');
      return;
    }

    // get map snapshot
    Uint8List? imageData;
    try {
      final lat = _locationData!.latitude;
      final lng = _locationData!.longitude;

      if (lat != null && lng != null) {
        // imageData = await fetchTrafficMap(lat, lng, kThunderApiKey);
        // imageData = await getScreenshotFromHtml(context, lat, lng);
        imageData = await fetchStaticMap(lat,lng,kGoogleApiKey);
        print('Map snapshot retrieved.');
      } else {
        print('Latitude or longitude is null.');
        return;
      }
    } catch (e) {
      print('Error fetching map snapshot: $e');
      return;
    }

    // upload image
    String? imageUrl;

    try {
      imageUrl = await uploadImage(imageData);
      print('Image uploaded, URL: $imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
      return;
    }

    // Send to Firebase
    try {
      final data = {
        'timestamp': FieldValue.serverTimestamp(),
        'location':
            'Latitude: ${_locationData?.latitude ?? 'error'}, Longitude: ${_locationData?.longitude ?? 'error'}',
        'image_url': imageUrl,
      };

      var uid = FirebaseAuth.instance.currentUser!.uid;

      await _firestore
          .collection('location_data')
          .doc(uid)
          .collection('entries')
          .add(data);
      print('Data logged');
    } catch (e) {
      print('Oh no something went wrong with uploading');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        color: Colors.blue[300],
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _isLogging ? Colors.green : Colors.red.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: () async {
                _startLogging();
                _isLogging = await service.isRunning();
                _toggleIsLogging(_isLogging);
              },
              child: const Text('Start Logging'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                _stopLogging();
                _isLogging = await service.isRunning();
                _toggleIsLogging(_isLogging);
              },
              child: const Text('Stop Logging'),
            ),
          ],
        ),
      ),
    );
  }
}
