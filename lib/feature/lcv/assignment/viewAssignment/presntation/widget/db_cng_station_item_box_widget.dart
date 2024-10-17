import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/db_cng_station_model.dart';

class DbCngStationItemBoxWidget extends StatelessWidget {
  final List<DbCngStationModel> dbCngStationList;
  const DbCngStationItemBoxWidget({super.key,
   required this.dbCngStationList,
  });

  @override
  Widget build(BuildContext context) {
    return dbCngStationList.isNotEmpty ?
    ListView.builder(
        itemCount: dbCngStationList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          DbCngStationModel dbCngStationData =  dbCngStationList[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _rowWidget(label: AppString.arrivalTime, value: dbCngStationData.arrivalTime.toString()),
            _verticalSpace(context: context),
            _rowWidget(label: AppString.lcvPointTime, value: dbCngStationData.lcvPointTime.toString()),
            _verticalSpace(context: context),
            _rowWidget(label: AppString.flowMeterReadingOpen, value: dbCngStationData.flowMeterReadingOpening.toString()),
            _verticalSpace(context: context),
            _rowWidget(label: AppString.inPressure, value: dbCngStationData.inPressure.toString()),
            _verticalSpace(context: context),
            _rowWidget(label: AppString.flowMeterReadingClosed, value: dbCngStationData.flowMeterReadingClosing.toString()),
            _verticalSpace(context: context),
            _rowWidget(label: AppString.outPressure, value: dbCngStationData.outPressure.toString()),
            _verticalSpace(context: context),
            _rowWidget(label: AppString.fillEndTime, value: dbCngStationData.fillEndTime.toString()),
            _verticalSpace(context: context),
            dbCngStationData.dbCngAttachments!.isNotEmpty ?
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.15,
              child: ListView.builder(
                  itemCount: dbCngStationData.dbCngAttachments!.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return  _images(pictureUrl: dbCngStationData.dbCngAttachments![index].toString(),
                        context: context);
                  }),
            ) : const SizedBox.shrink()
          ],
        );
    }) : const SizedBox.shrink();
  }

  Widget _rowWidget({required String label,required String value}) {
    return Row(
      children: [
        TextWidget("$label : ",
            color: AppColor.black,
            fontSize: AppFont.font_13,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(value,
              color: AppColor.black,
              textAlign: TextAlign.start,
              fontSize: AppFont.font_13,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _images({required String pictureUrl, required BuildContext context}) {
    return pictureUrl.isNotEmpty
        ? SizedBox.fromSize(
      size: Size.fromRadius(MediaQuery.of(context).size.width * 0.08),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 0.6,
                child: Image.network(
                  pictureUrl,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes !=
                            null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, exception, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ));
        },
        child: CircleAvatar(
          backgroundColor: AppColor.white,
          radius: MediaQuery.of(context).size.width * 0.15,
          child: Image.network(
            pictureUrl,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, exception, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    )
        : const SizedBox.shrink();
  }

  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.02,
    );
  }

}
