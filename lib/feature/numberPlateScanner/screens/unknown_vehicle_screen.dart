import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/vehicle_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/compliance_status_card.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/vehicle_info_card.dart';
import 'package:flutter_igl_cng/utils/res/app_font.dart';

/// CASE D: Fallback Vehicle Information Screen when `rcFuelDesc` is null,
/// empty, or contains a fuel type other than CNG, PETROL, or DIESEL.
class UnknownVehicleScreen extends StatelessWidget {
  const UnknownVehicleScreen({
    super.key,
    required this.vehicle,
  });

  final VehicleDetailsModel vehicle;

  @override
  Widget build(BuildContext context) {
    final rawFuel = (vehicle.rcFuelDesc ?? '').trim();
    final bool isMissingFuel = rawFuel.isEmpty;
    final rcStatus = vehicle.evaluateRcStatus();
    final pucStatus = vehicle.evaluatePucStatus();
    final insStatus = vehicle.evaluateInsuranceStatus();

    final makerModel = [
      vehicle.rcMakerDesc,
      vehicle.rcMakerModel,
    ].where((e) => e != null && e.isNotEmpty).join(' • ');

    return Scaffold(
      backgroundColor: AnprUiColors.canvasBg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B5563),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Vehicle Information',
          style: TextStyle(
            fontSize: AppFont.font_16,
            fontWeight: FontWeight.w700,
            fontFamily: AppFont.poppins,
          ),
        ),
      ),
      bottomNavigationBar: VehicleScannerActionBar(
        primaryColor: AnprUiColors.brandGreen,
        onScanAgain: () => Navigator.of(context).pop(true),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VehicleDashboardHeader(
                brandTitle: 'IGL Suraksha Plus • Vehicle Check',
                vehicleNumber: vehicle.displayRegistrationNumber,
                fuelBadgeText: isMissingFuel ? 'UNSPECIFIED' : rawFuel,
                fuelBadgeColor: const Color(0xFFB45309),
                subtitleText: 'Unclassified Fuel Category',
                sourceLabel: vehicle.source,
                gradientColors: const [
                  Color(0xFF374151),
                  Color(0xFF4B5563),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SurakshaStatusOverviewCard(
                      vehicle: vehicle,
                      isAlertTheme: true,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AnprUiColors.subtleYellowBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AnprUiColors.subtleYellowBorder,
                          width: 1.3,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.help_outline_rounded,
                            color: Color(0xFFB45309),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isMissingFuel
                                  ? 'Fuel type (rcFuelDesc) was not provided by the API and could not be classified into CNG, PETROL, or DIESEL.'
                                  : 'Fuel type "$rawFuel" could not be classified into CNG, PETROL, or DIESEL.',
                              style: TextStyle(
                                color: const Color(0xFF78350F),
                                fontSize: AppFont.font_13,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    VehicleInfoCard(
                      title: 'Vehicle Registration Details',
                      icon: Icons.directions_car_rounded,
                      accentColor: const Color(0xFF4B5563),
                      fields: [
                        VehicleInfoField(
                          label: 'Registration Number',
                          value: vehicle.displayRegistrationNumber,
                        ),
                        VehicleInfoField(
                          label: 'Original Fuel Type (rcFuelDesc)',
                          value: isMissingFuel ? null : rawFuel,
                        ),
                        VehicleInfoField(
                          label: 'Owner Name',
                          value: vehicle.rcOwnerName,
                        ),
                        VehicleInfoField(
                          label: 'Vehicle Type / Class',
                          value: vehicle.rcVhClassDesc ?? vehicle.rcVhType,
                        ),
                        VehicleInfoField(
                          label: 'Manufacturer & Model',
                          value: makerModel.isNotEmpty ? makerModel : null,
                        ),
                        VehicleInfoField(
                          label: 'Registration Date',
                          value: vehicle.rcRegnDt,
                        ),
                        VehicleInfoField(
                          label: 'Vehicle Age',
                          value: vehicle.computeVehicleAge(),
                        ),
                        VehicleInfoField(
                          label: 'Registered RTO',
                          value: vehicle.rcRegisteredAt,
                        ),
                        VehicleInfoField(
                          label: 'RC Status',
                          value: vehicle.rcStatus,
                          status: rcStatus,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    VehicleInfoCard(
                      title: 'PUC & Insurance Status',
                      icon: Icons.policy_rounded,
                      accentColor: AnprUiColors.brandGreen,
                      fields: [
                        VehicleInfoField(
                          label: 'PUC Valid Upto',
                          value: vehicle.rcPuccUpto,
                          status: pucStatus,
                        ),
                        VehicleInfoField(
                          label: 'Insurance Valid Upto',
                          value: vehicle.rcInsuranceUpto,
                          status: insStatus,
                        ),
                        VehicleInfoField(
                          label: 'Insurance Company',
                          value: vehicle.rcInsuranceComp,
                        ),
                        VehicleInfoField(
                          label: 'Fitness Valid Upto',
                          value: vehicle.rcFitUpto,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AdditionalApiFieldsCard(
                      allDataFields: vehicle.allDataFields,
                      accentColor: const Color(0xFF4B5563),
                      excludedKeys: const {
                        'rcRegnNo',
                        'rcFuelDesc',
                        'rcOwnerName',
                        'rcVhClassDesc',
                        'rcVhType',
                        'rcMakerDesc',
                        'rcMakerModel',
                        'rcRegnDt',
                        'rcRegisteredAt',
                        'rcStatus',
                        'rcPuccUpto',
                        'rcInsuranceUpto',
                        'rcInsuranceComp',
                        'rcFitUpto',
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
