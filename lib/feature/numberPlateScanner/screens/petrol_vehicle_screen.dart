import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/vehicle_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/services/vehicle_api_service.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/non_cng_alert_dashboard.dart';

/// SCREEN 2: Dedicated Petrol Vehicle Orange Alert & Information Dashboard.
class PetrolVehicleScreen extends StatelessWidget {
  const PetrolVehicleScreen({
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
      appBarTitle: 'Petrol Vehicle Alert',
      fuelBadgeFallback: 'PETROL',
      vehicleTagline: 'PETROL VEHICLE',
      alertHeadline: 'PETROL VEHICLE ALERT',
      alertDescription:
          'This is a PETROL vehicle. CNG cylinder verification is not applicable.',
      alertIcon: Icons.local_gas_station_rounded,
      headerGradient: const [
        Color(0xFFC2410C),
        Color(0xFFEA580C),
        Color(0xFFF97316),
      ],
    );
  }
}
