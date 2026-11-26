import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/vehicle_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/services/vehicle_api_service.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/non_cng_alert_dashboard.dart';

/// SCREEN 3: Dedicated Diesel Vehicle Orange Alert & Information Dashboard.
class DieselVehicleScreen extends StatelessWidget {
  const DieselVehicleScreen({
    super.key,
    required this.vehicle,
    this.apiService,
  });

  final VehicleDetailsModel vehicle;
  final VehicleApiService? apiService;

  @override
  Widget build(BuildContext context) {
    return NonCngAlertDashboard(
      vehicle: vehicle,
      apiService: apiService,
      appBarTitle: 'Diesel Vehicle Alert',
      fuelBadgeFallback: 'DIESEL',
      vehicleTagline: 'DIESEL VEHICLE',
      alertHeadline: 'DIESEL VEHICLE ALERT',
      alertDescription:
          'This is a DIESEL vehicle. CNG cylinder verification is not applicable.',
      alertIcon: Icons.local_shipping_rounded,
      headerGradient: const [
        Color(0xFF9A3412),
        Color(0xFFEA580C),
        Color(0xFFF59E0B),
      ],
    );
  }
}
