import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/app_bar_widget.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/home_drawer_widget.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/bloc/request_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/request/presentation/widget/request_item_box_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestWidget extends StatefulWidget {
  const RequestWidget({super.key});

  @override
  State<RequestWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    BlocProvider.of<RequestBloc>(context)
        .add(RequestPageEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawerWidget(),
      key: _scaffoldKey,
      backgroundColor: AppColor.white,
      body: BlocBuilder<RequestBloc, RequestState>(
        builder: (context, state) {
          if (state is FetchRequestDataState) {
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

  Widget _itemBuilder({required FetchRequestDataState dataState}) {
    return Stack(
      children: [
        _googleMap(dataState: dataState),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.03,
          child: AppBarWidget(
            titleName: AppString.appName,
            scaffoldKey: _scaffoldKey,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _listBuilder(dataState: dataState),
        )
      ],
    );
  }

  Widget _googleMap({required FetchRequestDataState dataState}) {
    return dataState.isLoader == false
        ? GoogleMap(
            myLocationEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(dataState.currentLat, dataState.currentLong),
              zoom: 14.4746,
            ),
            compassEnabled: false,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            // mapType: MapType.normal,
            zoomControlsEnabled: true,
            markers: dataState.currentLocationMarker,
            polylines: dataState.polylines,
            onMapCreated: (GoogleMapController controller) async {},
          )
        : const CenterLoaderWidget();
  }

  Widget _listBuilder({required FetchRequestDataState dataState}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: ListView.builder(
          itemCount: dataState.assignmentList.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return RequestItemBoxWidget(
              index: index,
              assignmentData: dataState.assignmentList[index],
              assignmentList: dataState.assignmentList,
            );
          }),
    );
  }
}
