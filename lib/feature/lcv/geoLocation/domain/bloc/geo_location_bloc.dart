import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_event.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_state.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/model/location_prediction.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/helper/geo_location_helper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoLocationBloc extends Bloc<GeoLocationEvent, GeoLocationState> {
  List<LocationPrediction> _locationPredicationList = [];

  List<LocationPrediction> get locationPredicationList =>
      _locationPredicationList;

  LocationPrediction _locationPrediction = LocationPrediction();

  LocationPrediction get locationPrediction => _locationPrediction;

  String _address = "";

  String get address => _address;

  String _keyWord = "";

  String get keyWord => _keyWord;
  dynamic location = "";

  double lat = 0.0;
  double long = 0.0;
  late GoogleMapController mapController;
  late CameraPosition cameraPosition;

  TextEditingController searchTextFieldController = TextEditingController();

  GeoLocationBloc() : super(GeoLocationInit()) {
    on<SearchKeyWordLocationDataEvent>(_searchKeyWord);
    on<SelectAddressEvent>(_selectLocationAddress);
    on<PageLoadingEvent>(_pageLoading);
    on<MapPageLoadingEvent>(_googleMapLoading);
    on<GoogleMapLocationHandler>(_googleMapCameraHanderl);
    on<ChangeGoogleMapCameraPositionEvent>(_changeGoogleMapCameraPosition);
  }

  _pageLoading(PageLoadingEvent event, emit) {
    emit(GoogleMapLoadingState());
    _keyWord = "";
    _address = "";
    _locationPredicationList = [];
    _locationPrediction = LocationPrediction();
    searchTextFieldController.text = event.address;
    location = "";
    cameraPosition = const CameraPosition(
      target: LatLng(0.0, 0.0),
      zoom: 14.0,
    );
    _eventCompleted(emit);
  }

  _searchKeyWord(SearchKeyWordLocationDataEvent event, emit) async {
    _keyWord = event.keyword.toString();
    var res = await GeoLocationHelper.fetchPlacesList(
        context: event.context, keyWord: event.keyword);
    if (res != null) {
      _locationPredicationList = fromJsonToLocPrediction(res['predictions']);
    }
    _eventCompleted(emit);
  }

  _selectLocationAddress(SelectAddressEvent event, emit) async {
    _locationPredicationList = [];
    _locationPrediction = event.locationPrediction;
    var res = await GeoLocationHelper.fetchPlaceDetails(
        context: event.context,
        placeId: event.locationPrediction.placeId.toString(),
        addrees: event.locationPrediction.description.toString());
    if (res != null) {
      searchTextFieldController.selection = TextSelection.fromPosition(
          TextPosition(offset: searchTextFieldController.text.length));
      searchTextFieldController.text =
          event.locationPrediction.description.toString();
      location = res;
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<GeoLocationState> emit) {
    emit(FetchLocationDataState(
        locationList: locationPredicationList,
        address: address,
        searchTextFieldController: searchTextFieldController,
        location: location,
        long: long,
        lat: lat,
        cameraPosition: cameraPosition));
  }

  _googleMapLoading(MapPageLoadingEvent event, emit) async {
    emit(GoogleMapLoadingState());
    Position position = await GeoLocationHelper.getGeoLocationPosition();
    try {
      if (event.lat != null && event.long != null) {
        lat = event.lat!;
        long = event.long!;
      } else {
        lat = position.latitude;
        long = position.longitude;
      }
      cameraPosition = CameraPosition(
        target: LatLng(lat, long),
        zoom: 14.0,
      );
      var res = await GeoLocationHelper.fetchLatLongLocationData(
          context: event.context, lat: lat, long: long);
      location = res;
      _address = res["address"];
      _eventCompleted(emit);
    } catch (e) {
      print(e.toString());
    }
  }

  _changeGoogleMapCameraPosition(
      ChangeGoogleMapCameraPositionEvent event, emit) {
    cameraPosition = event.cameraPosition;
    _eventCompleted(emit);
  }

  _googleMapCameraHanderl(GoogleMapLocationHandler event, emit) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
        cameraPosition.target.latitude, cameraPosition.target.longitude);
    _address = placeMarks.first.street.toString() +
        "," +
        placeMarks.first.subLocality.toString() +
        ',' +
        placeMarks.first.locality.toString();
    ;
    cameraPosition = CameraPosition(
      target: LatLng(
          cameraPosition.target.latitude, cameraPosition.target.longitude),
      zoom: 14.0,
    );
    lat = cameraPosition.target.latitude;
    long = cameraPosition.target.longitude;
    var res = await GeoLocationHelper.fetchLatLongLocationData(
        context: event.context, lat: lat, long: long);
    location = res;
    // _address = res["address"];
    _eventCompleted(emit);
  }
}
