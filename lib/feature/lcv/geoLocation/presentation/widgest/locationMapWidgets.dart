import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_event.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_state.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/presentation/widgest/AddressTextFieldWidgest.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/presentation/widgest/map_widget.dart';

class LocationMapWidgets extends StatefulWidget {
  const LocationMapWidgets({Key? key}) : super(key: key);

  @override
  _LocationMapWidgets createState() => _LocationMapWidgets();
}

class _LocationMapWidgets extends State<LocationMapWidgets> {
  @override
  void initState() {
    BlocProvider.of<GeoLocationBloc>(context)
        .add(MapPageLoadingEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeoLocationBloc, GeoLocationState>(
      builder: (context, state) {
        if (state is GoogleMapLoadingState) {
          return const Center(
            child: CenterLoaderWidget(),
          );
        } else if (state is FetchLocationDataState) {
          return Stack(
            children: [
              const MapWidgets(),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: AddressTextFieldWidget(
                  maxLines: 1,
                  height: MediaQuery.of(context).size.height * 0.06,
                  address: state.address,
                  callback: (value) {},
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CenterLoaderWidget(),
          );
        }
      },
    );
  }
}
