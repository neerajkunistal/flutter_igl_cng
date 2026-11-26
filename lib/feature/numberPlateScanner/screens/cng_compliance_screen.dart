import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/vehicle_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/services/vehicle_api_service.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/compliance_status_card.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/cylinder_certificate_card.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/vehicle_info_card.dart';
import 'package:flutter_igl_cng/utils/res/app_font.dart';

/// SCREEN 1: Suraksha Plus CNG Vehicle Compliance Verification Dashboard.
///
/// Automatically fetches PESO cylinder certificates from `/api/vehicle/peso`
/// when [vehicle.cylinders] is empty and [apiService] is provided.
class CngComplianceScreen extends StatefulWidget {
  const CngComplianceScreen({
    super.key,
    required this.vehicle,
    this.apiService,
  });

  final VehicleDetailsModel vehicle;
  final VehicleApiService? apiService;

  @override
  State<CngComplianceScreen> createState() => _CngComplianceScreenState();
}

class _CngComplianceScreenState extends State<CngComplianceScreen> {
  late VehicleDetailsModel _vehicle;
  bool _isLoadingPeso = false;
  String? _pesoError;

  @override
  void initState() {
    super.initState();
    _vehicle = widget.vehicle;
    if (_vehicle.cylinders.isEmpty && widget.apiService != null) {
      unawaited(_loadPesoCertificates());
    }
  }

  Future<void> _loadPesoCertificates() async {
    final service = widget.apiService;
    if (service == null || _isLoadingPeso) return;
    setState(() {
      _isLoadingPeso = true;
      _pesoError = null;
    });
    try {
      final peso =
          await service.fetchPesoDetails(_vehicle.displayRegistrationNumber);
      if (!mounted) return;
      if (peso.cylinders.isNotEmpty) {
        setState(() {
          _vehicle = _vehicle.copyWithCylinders(peso.cylinders);
          _isLoadingPeso = false;
        });
      } else {
        setState(() => _isLoadingPeso = false);
      }
    } on VehicleApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingPeso = false;
        _pesoError = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingPeso = false;
        _pesoError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = _vehicle;
    final compliance = vehicle.evaluateCngCompliance();
    final endorseStatus = vehicle.evaluateCngEndorsementStatus();
    final pucStatus = vehicle.evaluatePucStatus();
    final insStatus = vehicle.evaluateInsuranceStatus();
    final fitStatus = vehicle.evaluateFitnessStatus();
    final taxStatus = vehicle.evaluateTaxStatus();
    final pesoStatus = vehicle.evaluatePesoStatus();

    final String complianceBadgeLabel;
    final String heroHeadline;
    final Color complianceBadgeBg;
    final Color complianceBadgeFg;
    switch (compliance.level) {
      case OverallComplianceLevel.compliant:
        complianceBadgeLabel = 'COMPLIANT';
        heroHeadline = 'COMPLIANT — CNG REFILLING PERMITTED';
        complianceBadgeBg = const Color(0xFFDCFCE7);
        complianceBadgeFg = const Color(0xFF15803D);
      case OverallComplianceLevel.expiringOrPending:
        complianceBadgeLabel = 'ATTENTION';
        heroHeadline = compliance.headline;
        complianceBadgeBg = const Color(0xFFFEF3C7);
        complianceBadgeFg = const Color(0xFFB45309);
      case OverallComplianceLevel.nonCompliant:
        complianceBadgeLabel = 'NOT COMPLIANT';
        heroHeadline = 'NOT COMPLIANT — DISPENSING PROHIBITED';
        complianceBadgeBg = const Color(0xFFFEE2E2);
        complianceBadgeFg = const Color(0xFFB91C1C);
    }

    return Scaffold(
      backgroundColor: AnprUiColors.canvasBg,
      appBar: AppBar(
        backgroundColor: compliance.level == OverallComplianceLevel.nonCompliant
            ? const Color(0xFFB91C1C)
            : AnprUiColors.brandDarkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'CNG Compliance Verification',
          style: TextStyle(
            fontSize: AppFont.font_16,
            fontWeight: FontWeight.w700,
            fontFamily: AppFont.poppins,
          ),
        ),
        actions: [
          if (widget.apiService != null)
            IconButton(
              tooltip: 'Refresh PESO Certificates',
              onPressed: _isLoadingPeso ? null : _loadPesoCertificates,
              icon: const Icon(Icons.refresh_rounded),
            ),
        ],
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
                brandTitle: 'Suraksha Plus • CNG Verification',
                vehicleNumber: vehicle.displayRegistrationNumber,
                fuelBadgeText:
                    (vehicle.rcFuelDesc ?? 'CNG').trim().toUpperCase(),
                fuelBadgeColor: const Color(0xFF15803D),
                subtitleText: 'CNG Vehicle Identified',
                sourceLabel: vehicle.source,
                gradientColors:
                    compliance.level == OverallComplianceLevel.nonCompliant
                        ? const [Color(0xFFB91C1C), Color(0xFFDC2626)]
                        : [
                            AnprUiColors.brandDarkGreen,
                            AnprUiColors.brandGreen,
                          ],
                rightBadge: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: complianceBadgeBg,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    complianceBadgeLabel,
                    style: TextStyle(
                      color: complianceBadgeFg,
                      fontSize: AppFont.font_11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ComplianceStatusCard(
                      level: compliance.level,
                      headline: heroHeadline,
                      summary: compliance.summary,
                      reasons: compliance.reasons,
                    ),
                    const SizedBox(height: 16),
                    SurakshaStatusOverviewCard(vehicle: vehicle),
                    const SizedBox(height: 16),
                    VehicleOwnerRegistrationCard(
                      vehicle: vehicle,
                      fuelFallback: 'CNG',
                      accentColor: AnprUiColors.brandGreen,
                    ),
                    const SizedBox(height: 16),
                    VehicleInfoCard(
                      title: 'CNG Endorsement, PUC & Insurance',
                      icon: Icons.verified_rounded,
                      accentColor: AnprUiColors.brandGreen,
                      fields: [
                        VehicleInfoField(
                          label: 'CNG Endorsement on RC',
                          value: vehicle.cngEndorsementDisplayText,
                          status: endorseStatus,
                        ),
                        VehicleInfoField(
                          label: 'PUC Certificate Valid Upto',
                          value: vehicle.rcPuccUpto,
                          status: pucStatus,
                        ),
                        if (vehicle.rcPuccNo != null)
                          VehicleInfoField(
                            label: 'PUC Certificate No.',
                            value: vehicle.rcPuccNo,
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
                          label: 'Insurance Policy No.',
                          value: vehicle.rcInsurancePolicyNo,
                        ),
                        VehicleInfoField(
                          label: 'Fitness Valid Upto',
                          value: vehicle.rcFitUpto,
                          status: fitStatus,
                        ),
                        VehicleInfoField(
                          label: 'Tax Valid Upto',
                          value: vehicle.rcTaxUpto,
                          status: taxStatus,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (vehicle.pesoCertificateNumber != null ||
                        vehicle.pesoStatus != null ||
                        vehicle.pesoValidUpto != null) ...[
                      VehicleInfoCard(
                        title: 'PESO Certificate Details',
                        icon: Icons.workspace_premium_rounded,
                        accentColor: AnprUiColors.statusForeground(pesoStatus),
                        trailing: ValidityBadge(status: pesoStatus),
                        fields: [
                          VehicleInfoField(
                            label: 'PESO Certificate No.',
                            value: vehicle.pesoCertificateNumber,
                          ),
                          VehicleInfoField(
                            label: 'PESO Status',
                            value: vehicle.pesoStatus,
                            status: pesoStatus,
                          ),
                          VehicleInfoField(
                            label: 'PESO Certificate Validity',
                            value: vehicle.pesoValidUpto,
                          ),
                          VehicleInfoField(
                            label: 'Total Cylinders (RC)',
                            value: vehicle.rcNoCyl,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_isLoadingPeso)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AnprUiColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AnprUiColors.brandGreen,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              'Fetching PESO cylinder certificates...',
                              style: TextStyle(
                                fontSize: AppFont.font_13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF374151),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_pesoError != null && vehicle.cylinders.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFB91C1C),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _pesoError!,
                                style: TextStyle(
                                  fontSize: AppFont.font_12,
                                  color: const Color(0xFF7F1D1D),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _loadPesoCertificates,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    else if (vehicle.cylinders.isNotEmpty) ...[
                      for (int i = 0; i < vehicle.cylinders.length; i++) ...[
                        CylinderCertificateCard(
                          cylinder: vehicle.cylinders[i],
                          index: i,
                          vehicleNumber: vehicle.displayRegistrationNumber,
                        ),
                        const SizedBox(height: 14),
                      ],
                    ] else ...[
                      MissingCylinderInfoCard(
                        rcCylinderCount: vehicle.rcNoCyl,
                      ),
                      const SizedBox(height: 16),
                    ],
                    AdditionalApiFieldsCard(
                      allDataFields: vehicle.allDataFields,
                      accentColor: AnprUiColors.brandGreen,
                      excludedKeys: const {
                        'rcRegnNo',
                        'rcOwnerName',
                        'rcFuelDesc',
                        'rcVhClassDesc',
                        'rcVhType',
                        'rcRegnDt',
                        'rcRegisteredAt',
                        'rcStatus',
                        'rcMakerDesc',
                        'rcMakerModel',
                        'rcPuccUpto',
                        'rcPuccNo',
                        'rcInsuranceUpto',
                        'rcInsuranceComp',
                        'rcInsurancePolicyNo',
                        'rcFitUpto',
                        'rcTaxUpto',
                        'pesoCertificateNumber',
                        'pesoStatus',
                        'pesoValidUpto',
                        'cngEndorsementStatus',
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
