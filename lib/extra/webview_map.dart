// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Future<Uint8List> getScreenshotFromHtml(BuildContext context, double lat, double lng) async {
//   Completer<Uint8List> screenshotCompleter = Completer();
//   InAppWebViewController? webViewController;

//   String htmlContent = '''
//   <!DOCTYPE html>
//   <html>
//   <head>
//     <title>Google Maps with Traffic Layer</title>
//     <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD0LayCont6VX0Ztytf2oUbMOkcimwOINM&callback=initMap" async defer></script>
//     <style>
//       #map {
//         height: 100%;
//         width: 100%;
//       }
//     </style>
//   </head>
//   <body>
//     <div id="map"></div>
//     <script>
//       function initMap() {
//         const lat = $lat;
//         const lng = $lng;
//         const map = new google.maps.Map(document.getElementById('map'), {
//           center: { lat: lat, lng: lng },
//           zoom: 17,
//         });
//         const trafficLayer = new google.maps.TrafficLayer();
//         trafficLayer.setMap(map);
//         new google.maps.Marker({
//           position: { lat: lat, lng: lng },
//           map: map,
//           title: 'Marker',
//         });
//       }
//     </script>
//     <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js"></script>
//   </body>
//   </html>
//   ''';

//   final webView = InAppWebView(
//     initialData: InAppWebViewInitialData(
//       data: htmlContent,
//     ),
//     onWebViewCreated: (controller) {
//       webViewController = controller;
//     },
//     onLoadStop: (controller, url) async {
//       // Once the page is fully loaded, take a screenshot
//       await Future.delayed(const Duration(seconds: 4));
//       final screenshot = await webViewController?.takeScreenshot();
//       if (screenshot != null) {
//         screenshotCompleter.complete(screenshot);
//       } else {
//         screenshotCompleter.completeError('Failed to capture screenshot');
//       }
//     },
//   );

//   final overlayEntry = OverlayEntry(
//     builder: (context) => Offstage(child: webView),
//   );

//   // Insert the WebView into the Overlay
//   Overlay.of(context).insert(overlayEntry);

//   // Wait for the screenshot to be captured
//   final screenshot = await screenshotCompleter.future;

//   // Remove the WebView from the Overlay
//   overlayEntry.remove();

//   return screenshot;
// }
