import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


// // maptiler
// Future<Uint8List?> fetchMapSnapshot(double latitude, double longitude, String apiKey) async {
//   final url =
//       'https://api.maptiler.com/maps/streets/static/$longitude,$latitude,14/768x1024.jpg?key=$apiKey';

//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     return response.bodyBytes;
//   } else {
//     print('Failed to load map snapshot: ${response.statusCode}');
//     return null;
//   }
// }

// thunderforest map data
Future<Uint8List> fetchTrafficMap(
    double latitude, double longitude, String apiKey) async {
  final url =
      'https://tile.thunderforest.com/static/transport/$longitude,$latitude,14/768x1024.png?apikey=$apiKey';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load traffic map');
  }
}

//google maps static api
Future<Uint8List> fetchStaticMap(double latitude, double longitude, String apiKey) async {
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=17&size=768x1024&markers=color:red|label:A|$latitude,$longitude&key=$apiKey'
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    // Handle error
    throw Exception('Failed to fetch static map');
  }
}

Future<String?> uploadImage(Uint8List imageData) async {
  final user = FirebaseAuth.instance.currentUser;
  final uid = user!.uid;
  final timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
  final filename = 'traffic_map_${timestamp}_${uid}.png';

  final storageRef = FirebaseStorage.instance.ref().child('images/$filename');

  try {
    await storageRef.putData(imageData);
    final imageUrl =
        await storageRef.getDownloadURL();
    print('Image uploaded successfully');
    return imageUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}
