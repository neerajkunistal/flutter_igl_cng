import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/model/location_prediction.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GeoLocationState extends Equatable {}

class GeoLocationInit extends GeoLocationState {
  @override
  List<Object?> get props => [];
}

class FetchLocationDataState extends GeoLocationInit {
  final List<LocationPrediction> locationList;
  final String address;
  final TextEditingController searchTextFieldController;
  final dynamic location;
  final double lat;
  final double long;
  final CameraPosition cameraPosition;

  FetchLocationDataState({
    required this.locationList,
    required this.address,
    required this.searchTextFieldController,
    this.location,
    required this.lat,
    required this.long,
    required this.cameraPosition,
  });

  @override
  List<Object?> get props =>
      [locationList, address, location, long, lat, cameraPosition];
}

class GoogleMapLoadingState extends GeoLocationInit {
  @override
  List<Object?> get props => [];
}
