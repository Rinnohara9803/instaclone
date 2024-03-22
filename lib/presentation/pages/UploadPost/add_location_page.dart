import 'package:geocoding/geocoding.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instaclone/utilities/snackbars.dart';

import '../../../services/shared_service.dart';

class SetLocationPage extends StatefulWidget {
  static String routeName = '/set-ocation-page';
  final Function(String location) setPostLocation;
  const SetLocationPage({Key? key, required this.setPostLocation})
      : super(key: key);

  @override
  State<SetLocationPage> createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  double? _latitude;
  double? _longitude;
  late GoogleMapController _googleMapController;

  late LatLng currentLatLng;

  final List<Marker> _markers = [];
  Marker? _locationMarker;

  Marker getCurrentMarker(double lat, double long) {
    return Marker(
      markerId: const MarkerId('Post Location'),
      infoWindow: const InfoWindow(
        title: 'Post Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
      position: LatLng(
        lat,
        long,
      ),
    );
  }

  Marker getMarker(
    BuildContext context,
    double latitude,
    double longitude,
    String rentId,
  ) {
    return Marker(
      onTap: () {},
      markerId: const MarkerId('Post Location'),
      infoWindow: const InfoWindow(
        title: 'Your Post Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
      position: LatLng(
        latitude,
        longitude,
      ),
    );
  }

  final _cameraPosition = CameraPosition(
    target: LatLng(
      SharedService.currentLocation.latitude,
      SharedService.currentLocation.longitude,
    ),
    zoom: 12.5,
    tilt: 0,
  );

  @override
  void initState() {
    _latitude = SharedService.currentLocation.latitude;
    _longitude = SharedService.currentLocation.longitude;
    print(_latitude);
    print(_longitude);
    _locationMarker = Marker(
      onTap: () {},
      markerId: const MarkerId('Current Location'),
      infoWindow: const InfoWindow(
        title: 'Current Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
      position: LatLng(
        SharedService.currentLocation.latitude,
        SharedService.currentLocation.longitude,
      ),
    );
    _markers.add(_locationMarker!);

    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                markers: _markers.map((marker) {
                  return marker;
                }).toSet(),
                onTap: (latLng) {
                  setState(() {
                    if (_markers.length > 1) {
                      _markers.removeLast();
                      _latitude = latLng.latitude;
                      _longitude = latLng.longitude;
                      _markers.add(
                        getCurrentMarker(
                          latLng.latitude,
                          latLng.longitude,
                        ),
                      );
                    } else {
                      _latitude = latLng.latitude;
                      _longitude = latLng.longitude;
                      _markers.add(
                        getCurrentMarker(
                          latLng.latitude,
                          latLng.longitude,
                        ),
                      );
                    }
                  });
                },
                initialCameraPosition: _cameraPosition,
                onMapCreated: (controller) => _googleMapController = controller,
              ),
              Positioned(
                bottom: 20,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBoxConstants.sizedboxw10,
                      Expanded(
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          child: InkWell(
                            onTap: () async {
                              print(_latitude);
                              print(_longitude);
                              try {
                                // Perform reverse geocoding
                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(
                                        _latitude!, _longitude!);

                                // Extract location details from the first placemark
                                Placemark placemark = placemarks[0];

                                // Construct the location string
                                String location =
                                    '${placemark.locality} , ${placemark.subAdministrativeArea} , ${placemark.administrativeArea} , ${placemark.country} ';

                                print(location);
                                widget.setPostLocation(location);
                                Navigator.pop(context);
                              } catch (e) {
                                SnackBars.showErrorSnackBar(
                                    context, ('Something went wrong.'));
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
