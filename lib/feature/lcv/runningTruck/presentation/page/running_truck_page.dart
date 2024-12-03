import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/domain/bloc/running_truck_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/presentation/widget/running_truck_item_box_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunningTruckPage extends StatefulWidget {
  const RunningTruckPage({super.key});

  @override
  State<RunningTruckPage> createState() => _RunningTruckPageState();
}

class _RunningTruckPageState extends State<RunningTruckPage> {
  GoogleMapController? mapController;

  @override
  void initState() {
    BlocProvider.of<RunningTruckBloc>(context)
        .add(RunningTruckPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: BlocBuilder<RunningTruckBloc, RunningTruckState>(
        builder: (context, state) {
          if (state is FetchRunningTruckDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return _centerLoader();
          }
        },
      ),
    );
  }

  Widget _centerLoader() {
    return const Center(child: CenterLoaderWidget());
  }

  Widget _itemBuilder({required FetchRunningTruckDataState dataState}) {
    return Stack(
      children: [
        _googleMap(dataState: dataState),
        Align(
          alignment: Alignment.bottomCenter,
          child: _listBuilder(dataState: dataState),
        ),
        _searchTextField(),
      ],
    );
  }

  Widget _searchTextField()  {
    return  Padding(
      padding:  const EdgeInsets.all(10),
      child: TextFieldWidget(
        filled: true,
        labelText: AppString.searchVehicleNo,
        onChanged: (value) {
          BlocProvider.of<RunningTruckBloc>(context)
          .add(RunningTruckSearchEvent(keyword: value.toString(), context: context));
        },
      ),
    );
  }

  Widget _googleMap({required FetchRunningTruckDataState dataState}) {
    if(mapController != null){
      mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
           CameraPosition(
            bearing: 270.0,
            target: LatLng(dataState.latLng.latitude, dataState.latLng.longitude),
            tilt: 30.0,
             zoom: 14.4746,
          ),
        ),
      );
    }
    return dataState.isLoader == false
        ? GoogleMap(
            myLocationEnabled: false,
            initialCameraPosition: CameraPosition(
              bearing: 270.0,
              target: LatLng(dataState.latLng.latitude, dataState.latLng.longitude),
              tilt: 30.0,
              zoom: 14.4746,
            ),
            compassEnabled: false,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            markers: dataState.markerRunningTruckPoints,
            onMapCreated: _onMapCreated,
          )
        : const CenterLoaderWidget();
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget _listBuilder({required FetchRunningTruckDataState dataState}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: ListView.builder(
          itemCount: dataState.assignmentList.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return RunningTruckItemBoxWidget(
                index: index, assignmentData: dataState.assignmentList[index]);
          }),
    );
  }
}
