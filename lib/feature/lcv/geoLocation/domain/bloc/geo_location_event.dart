import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/model/location_prediction.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GeoLocationEvent extends Equatable {}

class PageLoadingEvent extends GeoLocationEvent {
  final String address;

  PageLoadingEvent({required this.address});

  @override
  List<Object?> get props => [address];
}

class SearchKeyWordLocationDataEvent extends GeoLocationEvent {
  final BuildContext context;
  final String keyword;

  SearchKeyWordLocationDataEvent(
      {required this.context, required this.keyword});

  @override
  List<Object?> get props => [context, keyword];
}

class SelectAddressEvent extends GeoLocationEvent {
  final LocationPrediction locationPrediction;
  final BuildContext context;

  SelectAddressEvent({required this.locationPrediction, required this.context});

  @override
  List<Object?> get props => [locationPrediction, context];
}

class MapPageLoadingEvent extends GeoLocationEvent {
  final BuildContext context;
  final double? lat;
  final double? long;

  MapPageLoadingEvent({required this.context, this.long, this.lat});

  @override
  List<Object?> get props => [context, long, lat];
}

class ChangeGoogleMapCameraPositionEvent extends GeoLocationEvent {
  final BuildContext context;
  final CameraPosition cameraPosition;

  ChangeGoogleMapCameraPositionEvent(
      {required this.context, required this.cameraPosition});

  @override
  List<Object?> get props => [context, cameraPosition];
}

class GoogleMapLocationHandler extends GeoLocationEvent {
  final BuildContext context;

  GoogleMapLocationHandler({required this.context});

  @override
  List<Object?> get props => [context];
}
