import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/vehicle_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/screens/cng_compliance_preview_screen.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/services/vehicle_api_service.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/compliance_status_card.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/vehicle_info_card.dart';
import 'package:flutter_igl_cng/utils/res/app_font.dart';

/// Shared professional orange-alert dashboard scaffold for non-CNG fuel types
/// (Petrol and Diesel), matching the Suraksha Plus visual hierarchy.
class NonCngAlertDashboard extends StatelessWidget {
  const NonCngAlertDashboard({
    super.key,
    required this.vehicle,
    required this.appBarTitle,
    required this.fuelBadgeFallback,
    required this.vehicleTagline,
    required this.alertHeadline,
    required this.alertDescription,
    required this.alertIcon,
    required this.headerGradient,
    this.apiService,
  });

  final VehicleDetailsModel vehicle;
  final String appBarTitle;
  final String fuelBadgeFallback;
  final String vehicleTagline;
  final String alertHeadline;
  final String alertDescription;
  final IconData alertIcon;
  final List<Color> headerGradient;
  final VehicleApiService? apiService;

  static const Color _orangePrimary = Color(0xFFEA580C);
  static const Color _orangeDeep = Color(0xFFC2410C);
  static const Color _orangeBg = Color(0xFFFFF7ED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _orangeBg,
      appBar: AppBar(
        backgroundColor: headerGradient.first,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          appBarTitle,
          style: TextStyle(
            fontSize: AppFont.font_16,
            fontWeight: FontWeight.w700,
            fontFamily: AppFont.poppins,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withAlpha(36),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.white.withAlpha(115)),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CngCompliancePreviewScreen(
                      apiService: apiService,
                      initialVehicle: vehicle,
                      vehicleNumber: vehicle.displayRegistrationNumber,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.verified_user_rounded, size: 16),
              label: Text(
                'CNG / PESO',
                style: TextStyle(
                  fontSize: AppFont.font_12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: VehicleScannerActionBar(
        primaryColor: _orangePrimary,
        onScanAgain: () => Navigator.of(context).pop(true),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFEDD5),
              Color(0xFFFFF7ED),
              Color(0xFFFFFBF5),
            ],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VehicleDashboardHeader(
                  brandTitle: null,
                  vehicleNumber: vehicle.displayRegistrationNumber,
                  fuelBadgeText:
                      (vehicle.rcFuelDesc ?? fuelBadgeFallback)
                          .trim()
                          .toUpperCase(),
                  fuelBadgeColor: _orangeDeep,
                  subtitleText: vehicleTagline,
                  gradientColors: headerGradient,
                  rightBadge: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(38),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withAlpha(110)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'NON-CNG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFont.font_11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Prominent Orange Alert Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFEA580C),
                              Color(0xFFF97316),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: _orangePrimary.withAlpha(65),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(42),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withAlpha(90),
                                ),
                              ),
                              child: Icon(
                                alertIcon,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alertHeadline,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.4,
                                      fontFamily: AppFont.poppins,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    alertDescription,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Reference Image 3-Column Status Card
                      SurakshaStatusOverviewCard(
                        vehicle: vehicle,
                        isAlertTheme: true,
                      ),
                      const SizedBox(height: 16),
                      VehicleOwnerRegistrationCard(
                        vehicle: vehicle,
                        fuelFallback: fuelBadgeFallback,
                        accentColor: _orangeDeep,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
