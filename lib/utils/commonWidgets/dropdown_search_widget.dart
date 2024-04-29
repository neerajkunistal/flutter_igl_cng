import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonClass/app_config.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class DropDownSearchWidget extends StatelessWidget {

  final List<dynamic> items;
  final ValueChanged<dynamic>? onChanged;
  final  DropdownSearchItemAsString<dynamic>? itemAsString;
  final String hint;
  final dynamic selectedItem;
  final DropdownSearchOnFind<String>? asyncItems;
  const DropDownSearchWidget({super.key,
    required this.items,
    this.onChanged,
    required this.itemAsString,
    required this.hint,
    this.selectedItem,
    this.asyncItems,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConfig.getDeviceType(context: context) == DeviceType.phone
          ? MediaQuery.of(context).size.height * 0.07
          : MediaQuery.of(context).size.height * 0.15,
      child: DropdownSearch<dynamic>(
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            hintStyle: TextStyle(fontSize: AppFont.font_14, color: AppColor.themeColor),
            contentPadding: EdgeInsets.only(
              top: AppConfig.getDeviceType(context: context) == DeviceType.phone
                  ? MediaQuery.of(context).size.height * 0.018
                  : MediaQuery.of(context).size.height * 0.03,

              left: AppConfig.getDeviceType(context: context) == DeviceType.phone
                  ? MediaQuery.of(context).size.height * 0.01
                  : MediaQuery.of(context).size.height * 0.02
            ),
            hintText: hint,
            filled: false,
          ),
        ),
        items: items,
        itemAsString: itemAsString,
        onChanged: onChanged,
        selectedItem: selectedItem,
        popupProps:  PopupProps.dialog(
            searchFieldProps: TextFieldProps(
              decoration:  InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
            showSearchBox: true,
            containerBuilder: (context, popupWidget) {
              return Column(
                children: [
                  Expanded(child: popupWidget),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: ButtonWidget(
                          onPressed: () {
                            Navigator.pop(context);
                          }, text: AppString.cancel,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample2(BuildContext context, dynamic item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.pipeNumber.toString()),
      ),
    );
  }
}
