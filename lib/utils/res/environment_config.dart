import 'package:flutter/material.dart';

@immutable
class EnvironmentConfig extends InheritedWidget {
  final EnvironmentFlavours flavours;

  const EnvironmentConfig({
    super.key,
    required this.flavours,
    required super.child,
  });

  static EnvironmentConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw false;
  }

  String get generalUrlBaseOnFlavour {
    switch (flavours) {
      case EnvironmentFlavours.prodIGL:
        return "https://iglcngautomation.smartgasnet.com/";
      // return "https://iglcngautomation.smartgasnet.com/uatiglcng/";
      case EnvironmentFlavours.prodPBGPL:
        return "https://pbgpl.smartgasnet.com/";
      //  return "https://pbgpluat.smartgasnet.com/";
      case EnvironmentFlavours.prodMGL:
        return "https://mgl.smartgasnet.com/";
      case EnvironmentFlavours.prodHPCL:
        return "https://hpcl.smartgasnet.com/";
    }
  }
  Color get primaryTheme {
    switch (flavours) {
      case EnvironmentFlavours.prodPBGPL:
        return Color(0xFF72a720);
      case EnvironmentFlavours.prodMGL:
        return Color(0xFF72a720);
      case EnvironmentFlavours.prodIGL:
        return Color(0xFF72a720);
      case EnvironmentFlavours.prodHPCL:
        return Color(0xFF1A237E);
    }
  }

  Color get secondaryTheme {
    switch (flavours) {
      case EnvironmentFlavours.prodPBGPL:
        return Color(0xFF2f9e2c);
      case EnvironmentFlavours.prodMGL:
        return Color(0xFF2f9e2c);
      case EnvironmentFlavours.prodIGL:
        return Color(0xFF2f9e2c);
      case EnvironmentFlavours.prodHPCL:
        return Color(0xFFC62828);
    }
  }
}

enum EnvironmentFlavours {
  prodIGL,
  prodPBGPL,
  prodMGL,
  prodHPCL,
}

enum Client { igl, pbgpl, mahanagar, hpcl }
