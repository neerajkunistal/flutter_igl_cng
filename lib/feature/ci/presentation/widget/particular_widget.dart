import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class ParticularWidget extends StatelessWidget {
  final CngModel cngData;

  const ParticularWidget({super.key,
    required this.cngData
  });

  @override
  Widget build(BuildContext context) {

    LoginDataModel userData =  UserInfo.instanceInit()!.userData!;

    return cngData.particularList != null
        && cngData.particularList!.isNotEmpty ?
    DottedBorder(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: cngData.particularList!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              ParticularModel  particularData =  cngData.particularList![index];
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        "Particulars : ",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: TextWidget(
                            particularData.name.toString(),
                            textAlign: TextAlign.end,
                            fontWeight: FontWeight.w500,
                            fontSize: AppFont.font_13,
                          )),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        "Measure ${particularData.measurementName}: ",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),
                      Expanded(
                          child: TextWidget(
                            "${particularData.measurementValue} ${particularData.measurementUnit}",
                            textAlign: TextAlign.end,
                            fontWeight: FontWeight.w500,
                            fontSize: AppFont.font_13,
                          )),
                    ],
                  ),
                   particularData.status.toString() == "1"
                       && userData.roleType == RoleType.ci
                      ? _radioButton(index: index,
                      particularData: particularData, context: context)
                      :    particularData.status.toString() != "1" ?Row(
                    children: [
                      TextWidget(
                        "Status : ",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                      ),

                      Expanded(
                          child: TextWidget(
                            particularData.status.toString() == "2" ? "Accept" : "Revised",
                            textAlign: TextAlign.end,
                            fontWeight: FontWeight.w500,
                            fontSize: AppFont.font_13,
                            color: particularData.status.toString() == "2"
                                ? AppColor.green : AppColor.red,
                          )) ,
                    ],
                  ): const SizedBox.shrink(),
                  
                  index != cngData.particularList!.length -1 ?
                  Divider(color: AppColor.lightGrey,)
                      : const SizedBox.shrink(),
                ],
              );
            }),
      ),
    ) : const SizedBox.shrink();
  }

  Widget _radioButton({required int index,
    required BuildContext context,
    required ParticularModel particularData})
  {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.all(0.0),
              title: const TextWidget('Accept'),
              value: '2',
              groupValue: particularData.currentStatus,
              onChanged: (value) {
                BlocProvider.of<ViewCiComplaintBloc>(context)
                    .add(ViewCiComplaintSelectParticularStatusEvent(status: value.toString(), index: index));
              },
            ),
          ),
          Expanded(
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.all(0.0),
              title:const TextWidget('Revised'),
              value: '0',
              groupValue: particularData.currentStatus,
              onChanged: (value) {
                BlocProvider.of<ViewCiComplaintBloc>(context)
                    .add(ViewCiComplaintSelectParticularStatusEvent(status: value.toString(), index: index));
              },
            ),
          ),
        ],
      ),
    );
  }
}
