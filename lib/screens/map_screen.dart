
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';


class MapScreen extends StatefulWidget{
  const MapScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }

}

class _MapScreenState extends State<MapScreen> {

  GoogleMapController ?_googleMapController;
  Position ? _currentPosition;
  Marker ? _currentLocationMarker;
  bool _isEnable = false;
  Polyline? _polyline;
  List<LatLng> _polylineCoordinates =[];

  void initState() {
    super.initState();
    _requestLocationPermission();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Map'),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 1
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController = controller;
            _locationUpdates();
          },
          markers: _currentLocationMarker != null
              ? {_currentLocationMarker!}
              : {},
          polylines: _polyline!=null ? {_polyline!} : {},
        )
    );

  }

  void dispose(){
    super.dispose();
    _googleMapController?.dispose();
  }


  Future<void> _requestLocationPermission() async {
    //check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _isEnable = await Geolocator.isLocationServiceEnabled();
      if (_isEnable) {
        if (mounted) {
          setState(() {
            _animateToUserLocation();
          });
        }
      } else {
        Geolocator.openLocationSettings();
      }}
    else {
      if (permission == LocationPermission.deniedForever) {
        Geolocator.openAppSettings();
        return;
      }
      LocationPermission requestPermission = await Geolocator
          .requestPermission();
      if (requestPermission == LocationPermission.always ||
          requestPermission == LocationPermission.whileInUse) {
        _requestLocationPermission();
      }
    }
  }

  Future<void> _animateToUserLocation() async {
    if (_isEnable) {
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
            accuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 10)
        ),
      );

      _googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 17
            ),
          )
      );
      _updateMarker(_currentPosition!);
    }
  }

  void _updateMarker(Position markerPosition) {
    if (mounted) {
      setState(() {
        //add new position to the polyline co-ordinates
        _polylineCoordinates.add(LatLng(markerPosition.latitude, markerPosition.longitude));

        //update the polyline with new co-ordinates
        _polyline = Polyline(
            polylineId: PolylineId('tracking_polyline'),
            width: 5,
            color: Color(0xFFffa366),
            points: _polylineCoordinates
        );
        //update the marker position
        _currentLocationMarker = Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(markerPosition.latitude, markerPosition.longitude),
          infoWindow: InfoWindow(title: 'My Current Location',
              snippet: 'Lat: ${markerPosition.latitude}, Lon: ${markerPosition
                  .longitude}'),
        );

      });
    }
  }

  void _locationUpdates() {

    //to continuos listen for location updates use getPositionStream
   Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
          distanceFilter: 10
      ),
    ).listen((Position position){
        _currentPosition=position;
        _animateToUserLocation();
        _updateMarker(position);
    });

  }

}

