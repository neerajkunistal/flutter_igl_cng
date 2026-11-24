import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_event.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidgets extends StatefulWidget {
  const MapWidgets({Key? key}) : super(key: key);

  @override
  _MapWidgetsState createState() => _MapWidgetsState();
}

class _MapWidgetsState extends State<MapWidgets> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // BlocProvider.of<GeoLocationBloc>(context).add(MapPageLoadingEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeoLocationBloc, GeoLocationState>(
      builder: (context, state) {
        if (state is GoogleMapLoadingState) {
          return const Center(child: CenterLoaderWidget());
        } else if (state is FetchLocationDataState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: state.cameraPosition != null
                ? Stack(
                    children: [
                      GoogleMap(
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: state.cameraPosition,
                        onMapCreated: (controller) {},
                        onCameraMove: (CameraPosition cameraPosition) {
                          cameraPosition = cameraPosition;
                          BlocProvider.of<GeoLocationBloc>(context).add(
                              ChangeGoogleMapCameraPositionEvent(
                                  context: context,
                                  cameraPosition: cameraPosition));
                        },
                        onCameraIdle: () async {
                          BlocProvider.of<GeoLocationBloc>(context)
                              .add(GoogleMapLocationHandler(context: context));
                        },
                      ),
                      Center(
                        child: Image.asset(AppIcon.truckMarker,
                            color: AppColor.black,
                            height: MediaQuery.of(context).size.width * 0.03),
                      )
                    ],
                  )
                : Center(child: CenterLoaderWidget()),
          );
        } else {
          return Center(child: CenterLoaderWidget());
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        BlocProvider.of<GeoLocationBloc>(context)
            .add(MapPageLoadingEvent(context: context));
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }
}
