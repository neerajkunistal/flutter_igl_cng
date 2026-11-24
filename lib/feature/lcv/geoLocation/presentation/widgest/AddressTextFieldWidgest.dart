import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_event.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_state.dart';

class AddressTextFieldWidget extends StatefulWidget {
  final void Function(dynamic) callback;
  final String address;
  final double? height;
  final int? maxLines;

  const AddressTextFieldWidget(
      {required this.callback,
      required this.address,
      this.height,
      this.maxLines});

  @override
  _AddressTextFieldWidget createState() => _AddressTextFieldWidget();
}

class _AddressTextFieldWidget extends State<AddressTextFieldWidget> {
  @override
  void initState() {
    BlocProvider.of<GeoLocationBloc>(context)
        .add(PageLoadingEvent(address: widget.address));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeoLocationBloc, GeoLocationState>(
      builder: (context, state) {
        if (state is FetchLocationDataState) {
          return Column(
            children: [
              _searchKeyTextFieldWidget(dataState: state),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              _addressList(dataState: state),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _searchKeyTextFieldWidget(
      {required FetchLocationDataState dataState}) {
    widget.callback.call(dataState.location);
    return TextFieldWidget(
      maxLine: widget.maxLines ?? 3,
      controller: dataState.searchTextFieldController,
      labelText: "Address",
      onChanged: (value) {
        BlocProvider.of<GeoLocationBloc>(context).add(
            SearchKeyWordLocationDataEvent(
                keyword: value.toString(), context: context));
      },
    );
  }

  Widget _addressList({required FetchLocationDataState dataState}) {
    return dataState.locationList.isNotEmpty
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            child: Card(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: ListView.builder(
                  itemCount: dataState.locationList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        BlocProvider.of<GeoLocationBloc>(context).add(
                            SelectAddressEvent(
                                locationPrediction:
                                    dataState.locationList[index],
                                context: context));
                      },
                      child: Container(
                        color: AppColor.white,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.01),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.01),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_gas_station,
                                  color: AppColor.black,
                                ),
                                // Image.asset(AppIcon.truckMarker, color: AppColor.black, height: MediaQuery.of(context).size.width * 0.03),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03),
                                Flexible(
                                  child: TextWidget(
                                    dataState.locationList[index].description
                                        .toString(),
                                    textAlign: TextAlign.start,
                                    fontSize: AppFont.font_15,
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        : const SizedBox.shrink();
  }
}
