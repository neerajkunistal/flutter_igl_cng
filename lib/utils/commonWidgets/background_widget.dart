import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AppBackgroundWidget extends StatelessWidget {
  final Widget child;
  final bool isGradientChange;
  final bool isRemoveBackground;

  const AppBackgroundWidget({
    super.key,
    required this.child,
    this.isGradientChange = false,
    this.isRemoveBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isRemoveBackground == true
            ? null
            : LinearGradient(
          begin: isGradientChange == null
              ? Alignment.topLeft
              : Alignment.topRight,
          end: isGradientChange == null
              ? Alignment.centerRight
              : Alignment.centerLeft,
          colors:  [
            EnvironmentConfig.of(context)!.primaryTheme.withValues(alpha: 0.8),
            EnvironmentConfig.of(context)!.secondaryTheme.withValues(alpha: 0.8),
            EnvironmentConfig.of(context)!.primaryTheme,
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Stack(
        children: [
          isRemoveBackground == true
              ? const SizedBox.shrink()
              : Positioned(
            top: 20.0,
            left: MediaQuery.of(context).size.width * 0.18,
            right: 0.0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              child: Image.asset(
                AppIcon.pumpIcon,
                opacity: const AlwaysStoppedAnimation(.9),
                fit: BoxFit.fill,
              ),
            ),
          ),
          isRemoveBackground == true
              ? const SizedBox.shrink()
              : Image.asset(
            AppIcon.transperentBackground,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
          child,
        ],
      ),
    );
  }
}