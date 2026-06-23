import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class DropDownSearchWidget extends StatelessWidget {
  final List<dynamic> items;
  final ValueChanged<dynamic>? onChanged;
  final DropdownSearchItemAsString<dynamic>? itemAsString;
  final String hint;
  final dynamic selectedItem;
  final bool? isRequired;
  final bool? enabled;

  const DropDownSearchWidget({
    super.key,
    required this.items,
    this.onChanged,
    required this.itemAsString,
    required this.hint,
    this.selectedItem,
    this.isRequired,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConfig.getDeviceType(context: context) == DeviceType.phone
          ? MediaQuery.of(context).size.height * 0.07
          : MediaQuery.of(context).size.height * 0.15,
      child: DropdownSearch<dynamic>(
        selectedItem: selectedItem,
        enabled: enabled ?? true,
        compareFn: (i, s) => i.isEqual(s),
        decoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            label: TextWidget(
              "$hint${isRequired == false ? "" : ' *'}",
              color: EnvironmentConfig.of(context)!.primaryTheme,
            ),
            hintStyle: TextStyle(
                fontSize: AppFont.font_14, color: EnvironmentConfig.of(context)!.primaryTheme),
            contentPadding: EdgeInsets.only(
                top: AppConfig.getDeviceType(context: context) ==
                        DeviceType.phone
                    ? MediaQuery.of(context).size.height * 0.018
                    : MediaQuery.of(context).size.height * 0.03,
                left: AppConfig.getDeviceType(context: context) ==
                        DeviceType.phone
                    ? MediaQuery.of(context).size.height * 0.01
                    : MediaQuery.of(context).size.height * 0.02),
            hintText: hint,
            filled: false,
          ),
        ),
        items: (filter, infiniteScrollProps) => items,
        itemAsString: itemAsString,
        onChanged: onChanged,
        popupProps: PopupProps.dialog(
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
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
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: ButtonWidget(
                          fontSize: AppFont.font_12,
                          height: AppConfig.getDeviceType(context: context) ==
                                  DeviceType.tablet
                              ? 50
                              : MediaQuery.of(context).size.height * 0.038,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: AppString.cancel,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
