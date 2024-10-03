import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/data_table_widget.dart';
import 'package:flutter_igl_cng/utils/res/app_color.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {});
        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() { });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 0, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457
      print("Speed Accuracy ${position.speedAccuracy}");
      long = position.longitude.toString();
      lat = position.latitude.toString();
      _add();

      setState(() {
        //refresh UI on update
      });
    });
  }
  final double _headerHeight = 180;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
       backgroundColor: const Color(0xFF292C29),
        body:  SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true, Icons.person),
              ),
              SafeArea(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: const EdgeInsets.fromLTRB(
                        20, 10, 20, 10), // This will be the login form
                    child:  Column(
                      children: [
                        Text(
                          'Welcome GoPlanners!',
                          style: TextStyle(
                              fontSize: 60,
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          decoration:BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            )
                          ]),
                          child: TextField(
                            decoration: textInputDecoration(
                                'User Name', 'Enter your user name'),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
    );
  }

  InputDecoration textInputDecoration([String lableText="", String hintText = ""]){
    return InputDecoration(
      labelText: lableText,
      hintText: hintText,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  void _add() {
    var markerIdVal = DateTime.now().timeZoneOffset.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(lat),
        double.parse(long),
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  Widget _marker() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: LatLng(-33.852, 151.211),
        zoom: 11.0,
      ),
      markers: Set<Marker>.of(markers.values), // YOUR MARKS IN MAP
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    const marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(9.669111, 80.014007),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[const MarkerId('place_name')] = marker;
    });
  }
}



class HeaderWidget extends StatefulWidget {
  final double _height;
  final bool _showIcon;
  final IconData _icon;

  const HeaderWidget(this._height, this._showIcon, this._icon, {Key? key}) : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState(_height, _showIcon, _icon);
}

class _HeaderWidgetState extends State<HeaderWidget> {
  double _height;
  bool _showIcon;
  IconData _icon;

  _HeaderWidgetState(this._height, this._showIcon, this._icon);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Stack(
      children: [
        ClipPath(
          clipper: ShapeClipper(
              [
                Offset(width / 5, _height),
                Offset(width / 10 * 5, _height - 60),
                Offset(width / 5 * 4, _height + 20),
                Offset(width, _height - 18)
              ]
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFFEC6E76).withOpacity(0.4),
                    Color(0xFFEA545C).withOpacity(0.7),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
          ),
        ),
        ClipPath(
          clipper: ShapeClipper(
              [
                Offset(width / 3, _height + 20),
                Offset(width / 10 * 8, _height - 60),
                Offset(width / 5 * 4, _height - 60),
                Offset(width, _height - 20)
              ]
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFFEC6E76).withOpacity(0.4),
                    Color(0xFFEA545C).withOpacity(0.7),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
          ),
        ),
        ClipPath(
          clipper: ShapeClipper(
              [
                Offset(width / 5, _height),
                Offset(width / 2, _height - 40),
                Offset(width / 5 * 4, _height - 80),
                Offset(width, _height - 20)
              ]
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFFEC6E76),
                    Color(0xFFEA545C),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
          ),
        ),
        Visibility(
          visible: _showIcon,
          child: SizedBox(
            height: _height - 80,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.only(
                  left: 5.0,
                  top: 20.0,
                  right: 5.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  border: Border.all(width: 5, color: Colors.white),
                ),
                child: Icon(
                  _icon,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];
  ShapeClipper(this._offsets);
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height-20);

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(_offsets[0].dx, _offsets[0].dy, _offsets[1].dx,_offsets[1].dy);
    path.quadraticBezierTo(_offsets[2].dx, _offsets[2].dy, _offsets[3].dx,_offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();


    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}