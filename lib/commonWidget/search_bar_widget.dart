import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final ValueChanged<String>? onChanged;
  const SearchBarWidget({super.key, this.onPressed, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _searchWidget(context: context);
  }

  Widget _searchWidget({required BuildContext context}) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.08,
        ),
        Expanded(child: _searchController(context: context)),
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.calendar_month_outlined,
              color: AppColor.white,
            ))
      ],
    );
  }

  Widget _searchController({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(
          color: const Color(0xff020202),
          fontSize: AppFont.font_12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xfff1f1f1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          hintText: "Search...",
          hintStyle: TextStyle(
              color: const Color(0xffb2b2b2),
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              decorationThickness: 6),
          prefixIcon: const Icon(
            Icons.search,
          ),
          prefixIconColor: AppColor.themeColor,
        ),
      ),
    );
  }
}
