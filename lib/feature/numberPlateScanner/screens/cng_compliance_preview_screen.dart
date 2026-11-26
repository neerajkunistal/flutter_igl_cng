import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/cylinder_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/vehicle_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/services/vehicle_api_service.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/compliance_status_card.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/cylinder_certificate_card.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/vehicle_info_card.dart';
import 'package:flutter_igl_cng/utils/res/app_font.dart';
class CngCompliancePreviewScreen extends StatefulWidget {
  const CngCompliancePreviewScreen({
    super.key,
    this.apiService,
    this.initialVehicle,
    this.vehicleNumber = 'TN28AQ3165',
  });

  final VehicleApiService? apiService;
  final VehicleDetailsModel? initialVehicle;
  final String vehicleNumber;

  @override
  State<CngCompliancePreviewScreen> createState() =>
      _CngCompliancePreviewScreenState();
}

class _CngCompliancePreviewScreenState
    extends State<CngCompliancePreviewScreen> {
  late final VehicleApiService _apiService;
  late final bool _ownsApiService;

  bool _showCompliantMode = true;
  bool _isLoadingVehicle = false;
  bool _isLoadingPeso = true;
  String? _vehicleError;
  String? _pesoError;

  VehicleDetailsModel? _liveVehicle;
  List<CylinderDetailsModel> _livePesoCylinders = const [];
  String? _pesoVehicleNumber;

  @override
  void initState() {
    super.initState();
    _ownsApiService = widget.apiService == null;
    _apiService = widget.apiService ?? VehicleApiService();
    _liveVehicle = widget.initialVehicle;
    unawaited(_loadAllApis());
  }

  @override
  void dispose() {
    if (_ownsApiService) {
      _apiService.dispose();
    }
    super.dispose();
  }

  Future<void> _loadAllApis() async {
    await Future.wait([
      _loadVehicleDetails(),
      _loadPesoList(),
    ]);
  }

  Future<void> _loadVehicleDetails() async {
    setState(() {
      _isLoadingVehicle = true;
      _vehicleError = null;
    });
    try {
      final details =
          await _apiService.fetchVehicleDetails(widget.vehicleNumber);
      if (!mounted) return;
      setState(() {
        _liveVehicle = details;
        _isLoadingVehicle = false;
      });
    } on VehicleApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingVehicle = false;
        _vehicleError = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingVehicle = false;
        _vehicleError = 'Unable to load vehicle details: $e';
      });
    }
  }

  Future<void> _loadPesoList() async {
    setState(() {
      _isLoadingPeso = true;
      _pesoError = null;
    });
    try {
      final peso = await _apiService.fetchPesoDetails(widget.vehicleNumber);
      if (!mounted) return;
      setState(() {
        _livePesoCylinders = peso.cylinders;
        _pesoVehicleNumber = peso.vehicleNumber;
        _isLoadingPeso = false;
      });
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
        _pesoError = 'Unable to load PESO certificates: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompliant = _showCompliantMode;
    final vehicle = _liveVehicle;

    final Color themePrimary =
        isCompliant ? AnprUiColors.brandDarkGreen : const Color(0xFFB91C1C);
    final Color themeSecondary =
        isCompliant ? AnprUiColors.brandGreen : const Color(0xFFDC2626);
    final Color pageBg =
        isCompliant ? const Color(0xFFF3FBF4) : const Color(0xFFFEF4F4);

    final String headerPlate =
        vehicle?.displayRegistrationNumber ?? widget.vehicleNumber;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: themePrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'CNG Compliance & PESO',
          style: TextStyle(
            fontSize: AppFont.font_16,
            fontWeight: FontWeight.w700,
            fontFamily: AppFont.poppins,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Vehicle & PESO APIs',
            onPressed:
                (_isLoadingVehicle || _isLoadingPeso) ? null : _loadAllApis,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic Theme Header Banner matching Compliant / Not Compliant
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [themePrimary, themeSecondary],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themePrimary.withAlpha(60),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Mode Segmented Switcher
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(42),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ModeTabButton(
                              label: 'Compliant CNG',
                              icon: Icons.check_circle_rounded,
                              selected: isCompliant,
                              selectedColor: const Color(0xFF15803D),
                              onTap: () =>
                                  setState(() => _showCompliantMode = true),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _ModeTabButton(
                              label: 'Not Compliant CNG',
                              icon: Icons.cancel_rounded,
                              selected: !isCompliant,
                              selectedColor: const Color(0xFFDC2626),
                              onTap: () =>
                                  setState(() => _showCompliantMode = false),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Compliance Hero Card inside header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(24),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: isCompliant
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFFEE2E2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCompliant
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              color: isCompliant
                                  ? const Color(0xFF15803D)
                                  : const Color(0xFFDC2626),
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isCompliant
                                      ? 'COMPLIANT — CNG REFILLING PERMITTED'
                                      : 'NOT COMPLIANT — DISPENSING PROHIBITED',
                                  style: TextStyle(
                                    color: isCompliant
                                        ? const Color(0xFF15803D)
                                        : const Color(0xFFB91C1C),
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.3,
                                    fontFamily: AppFont.poppins,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Vehicle: $headerPlate',
                                  style: TextStyle(
                                    color: const Color(0xFF1F2937),
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVehicleDetailsSection(vehicle, isCompliant, themePrimary),
                    const SizedBox(height: 18),
                    _SectionHeading(
                      title: isCompliant
                          ? 'PESO CERTIFICATES'
                          : 'PESO CERTIFICATES (NON-COMPLIANT)',
                      color: isCompliant
                          ? AnprUiColors.brandDarkGreen
                          : const Color(0xFFB91C1C),
                      icon: isCompliant
                          ? Icons.workspace_premium_rounded
                          : Icons.warning_amber_rounded,
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isCompliant
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCompliant
                                ? const Color(0xFF86EFAC)
                                : const Color(0xFFFCA5A5),
                          ),
                        ),
                        child: Text(
                          'PESO API',
                          style: TextStyle(
                            color: isCompliant
                                ? const Color(0xFF15803D)
                                : const Color(0xFFB91C1C),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildLivePesoSection(isCompliant: isCompliant),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsSection(
    VehicleDetailsModel? vehicle,
    bool isCompliant,
    Color themePrimary,
  ) {
    if (vehicle == null && _isLoadingVehicle) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AnprUiColors.cardBorder),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: themePrimary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Loading vehicle details from API...',
                style: TextStyle(
                  color: const Color(0xFF374151),
                  fontSize: AppFont.font_13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (vehicle == null && _vehicleError != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFCA5A5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFFB91C1C)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _vehicleError!,
                style: TextStyle(
                  color: const Color(0xFF7F1D1D),
                  fontSize: AppFont.font_12,
                ),
              ),
            ),
            TextButton(
              onPressed: _loadVehicleDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (vehicle == null) return const SizedBox.shrink();

    final int liveCylCount = _livePesoCylinders.isNotEmpty
        ? _livePesoCylinders.length
        : vehicle.totalCylinderCount;
    final int displayedExpiredCount =
        isCompliant ? vehicle.expiredCylinderCount() : liveCylCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurakshaStatusOverviewCard(
          vehicle: vehicle,
          forceCngEndorsedPill: true,
          showCylinderSummaryOverride: !isCompliant && liveCylCount > 0,
          overrideCylinderCount: liveCylCount,
          overrideExpiredCylinderCount: displayedExpiredCount,
        ),
        const SizedBox(height: 16),
        VehicleOwnerRegistrationCard(
          vehicle: vehicle,
          fuelFallback: vehicle.rcFuelDesc ?? 'CNG',
          accentColor: themePrimary,
        ),
      ],
    );
  }

  Widget _buildLivePesoSection({required bool isCompliant}) {
    if (_isLoadingPeso) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AnprUiColors.cardBorder),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: isCompliant
                    ? AnprUiColors.brandGreen
                    : const Color(0xFFDC2626),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Loading live PESO certificate list...',
                style: TextStyle(
                  color: const Color(0xFF374151),
                  fontSize: AppFont.font_13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_pesoError != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFCA5A5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  color: Color(0xFFB91C1C),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Unable to fetch PESO certificates',
                    style: TextStyle(
                      color: const Color(0xFF991B1B),
                      fontSize: AppFont.font_14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _pesoError!,
              style: TextStyle(
                color: const Color(0xFF7F1D1D),
                fontSize: AppFont.font_12,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFB91C1C),
                  foregroundColor: Colors.white,
                ),
                onPressed: _loadPesoList,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ),
          ],
        ),
      );
    }

    if (_livePesoCylinders.isEmpty) {
      return const MissingCylinderInfoCard();
    }

    return Column(
      children: [
        for (int i = 0; i < _livePesoCylinders.length; i++) ...[
          CylinderCertificateCard(
            cylinder: _livePesoCylinders[i],
            index: i,
            vehicleNumber:
                _liveVehicle?.displayRegistrationNumber ?? _pesoVehicleNumber,
            overrideValidity:
                isCompliant ? null : ValidityStatus.expired,
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _ModeTabButton extends StatelessWidget {
  const _ModeTabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(24),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? selectedColor : Colors.white.withAlpha(220),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? selectedColor : Colors.white.withAlpha(235),
                  fontSize: AppFont.font_12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.color,
    required this.icon,
    this.trailing,
  });

  final String title;
  final Color color;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: AppFont.font_13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              fontFamily: AppFont.poppins,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
