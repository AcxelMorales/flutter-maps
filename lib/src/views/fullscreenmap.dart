import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class FullScreenMap extends StatefulWidget {
  const FullScreenMap();

  @override
  State createState() => FullScreenMapState();
}

class FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;
  String selectedStyle = 'mapbox://styles/acxel/ckmi6unwi1jzs17o0o0souips';

  final center = LatLng(37.810037, -122.476735);
  final streetStyle = 'mapbox://styles/acxel/ckmi6unwi1jzs17o0o0souips';
  final darkStyle = 'mapbox://styles/acxel/ckmi6sfgk4qep17oliej720lw';
  final satelliteStyle = 'mapbox://styles/acxel/ckmi6vbw6103g17ogtw07brwc';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _onStyleLoaded() {
    addImageFromAsset('assetImage', 'assets/symbols/custom-icon.png');
    addImageFromUrl('networkImage', Uri.parse('https://via.placeholder.com/50'));
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _createMap(),
      floatingActionButton: _floatingButtons(),
    );
  }

  Column _floatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: Icon(Icons.pin_drop_outlined),
          onPressed: () {
            mapController.addSymbol(SymbolOptions(
              geometry: center,
              // iconSize: 2,
              // iconImage: 'beer-15',
              iconImage: 'assetImage',
              textField: 'Ubicación',
              textOffset: Offset(0, 3),
              textSize: 13
            ));
          },
        ),
        SizedBox(height: 15.0),
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomIn());
          },
        ),
        SizedBox(height: 5.0),
        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
        ),
        SizedBox(height: 15.0),
        FloatingActionButton(
          child: Icon(Icons.add_to_home_screen_rounded),
          onPressed: () {
            if (selectedStyle == satelliteStyle) {
              selectedStyle = darkStyle;
            } else if (selectedStyle == darkStyle) {
              selectedStyle = streetStyle;
            } else {
              selectedStyle = satelliteStyle;
            }

            setState(() {});
          }
        )
      ],
    );
  }

  MapboxMap _createMap() {
    return MapboxMap(
      accessToken: 'pk.eyJ1IjoiYWN4ZWwiLCJhIjoiY2ttaHoxMHN1MGMyeDJwcW1reGM3Znh5NSJ9.v_2O-i41q8qU2BtvqmAs9Q',
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: center, zoom: 17.0),
      onStyleLoadedCallback: _onStyleLoaded,
    );
  }
}
