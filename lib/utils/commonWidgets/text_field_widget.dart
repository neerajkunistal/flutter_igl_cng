import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final GestureTapCallback? onTap;
  final String labelText;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;
  final int? maxLength;
  final int? maxLine;
  final Widget? suffixIcon;
  final bool? isRequired;

  const TextFieldWidget({
    super.key,
    required this.labelText,
    this.enabled,
    this.controller,
    this.onTap,
    this.onChanged,
    this.textInputType,
    this.maxLength,
    this.suffixIcon,
    this.maxLine,
    this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextFormField(
          enabled: enabled ?? true,
          controller: controller,
          style: TextStyle(
            fontSize: AppFont.font_14,
            color: AppColor.black,
          ),
          inputFormatters: textInputType != null
              ? textInputType == TextInputType.number
                  ? [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,4}'))
                    ]
                  : null
              : null,
          keyboardType: textInputType == null
              ? TextInputType.text
              : kIsWeb
                  ? textInputType ?? TextInputType.text
                  : Platform.isIOS
                      ? textInputType == TextInputType.number
                          ? const TextInputType.numberWithOptions(
                              signed: true, decimal: true)
                          : textInputType ?? TextInputType.text
                      : textInputType ?? TextInputType.text,
          maxLength: maxLength,
          maxLines: maxLine ?? 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: 8, vertical: maxLine != null ? 8 : 0),
            suffixIcon: suffixIcon ?? const Text(""),
            label: Text.rich(TextSpan(children: [
              TextSpan(text: labelText),
              TextSpan(
                  text: isRequired != null && isRequired == true ? ' *' : "",
                  style: const TextStyle(color: Colors.red)),
            ])),
            labelStyle: TextStyle(
              fontSize: AppFont.font_14,
              color: controller == null
                  ? AppColor.themeColor
                  : controller!.text.toString().isNotEmpty
                      ? AppColor.themeColor
                      : AppColor.themeColor,
            ),
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
          ),
          onChanged: onChanged),
    );
  }
}
