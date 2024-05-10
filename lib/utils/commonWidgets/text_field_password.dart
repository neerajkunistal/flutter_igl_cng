import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class TextFieldPasswordWidget extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;
  final bool? obscureText;
  final bool? isPasswordIcon;
  final TextInputType? inputType;
  final int? maxLength;
  final VoidCallback? passwordOnPressed;
  final GestureTapCallback? onTap;
  final bool? enabled;
  final bool? isRequired;

  const TextFieldPasswordWidget(
      {super.key,
      required this.labelText,
      this.hintText,
      this.textEditingController,
      this.obscureText,
      this.onChanged,
      this.inputType,
      this.isPasswordIcon,
      this.maxLength,
      this.passwordOnPressed,
      this.onTap,
      this.enabled,
      this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: TextFormField(
          onTap: onTap,
          enabled: enabled ?? true,
          maxLength: maxLength,
          onChanged: onChanged,
          keyboardType: inputType ?? TextInputType.text,
          controller: textEditingController,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
              // labelText: labelText,
              label: Text.rich(TextSpan(children: [
                TextSpan(text: labelText),
                TextSpan(
                    text: isRequired != null && isRequired == true ? ' *' : "",
                    style: const TextStyle(color: Colors.red)),
              ])),
              labelStyle: TextStyle(
                  fontSize: AppFont.font_14, color: AppColor.themeColor),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 1,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              contentPadding: const EdgeInsets.all(15),
              suffixIcon: isPasswordIcon != null
                  ? IconButton(
                      onPressed: passwordOnPressed,
                      icon: Icon(
                        obscureText == true
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColor.grey,
                      ),
                    )
                  : null),
        ));
  }
}
