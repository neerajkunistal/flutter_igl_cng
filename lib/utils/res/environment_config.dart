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
      case EnvironmentFlavours.productionIglCng:
        return "https://iglcngautomation.smartgasnet.com/";
      case EnvironmentFlavours.developmentIglCng:
        return "https://iglcngautomation.smartgasnet.com/uatiglcng/";
      case EnvironmentFlavours.prodPBGPL:
      return "https://pbgpl.smartgasnet.com/";
      case EnvironmentFlavours.devPBGPL:
        return "https://pbgpluat.smartgasnet.com/";
    }
  }
}

enum EnvironmentFlavours { productionIglCng, developmentIglCng, prodPBGPL, devPBGPL }
