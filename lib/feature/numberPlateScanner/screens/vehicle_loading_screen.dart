import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/vehicle_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/screens/cng_compliance_screen.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/screens/diesel_vehicle_screen.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/screens/petrol_vehicle_screen.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/screens/unknown_vehicle_screen.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/services/vehicle_api_service.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/compliance_status_card.dart';
import 'package:flutter_igl_cng/utils/res/app_font.dart';

/// Professional loading & error-recovery screen shown immediately after
/// number plate confirmation while calling `/api/vehicle/details`.
///
/// Upon a valid response, inspects `rcFuelDesc` and automatically replaces
/// itself with the matching fuel classification screen.
class VehicleLoadingScreen extends StatefulWidget {
  const VehicleLoadingScreen({
    super.key,
    required this.vehicleNumber,
    required this.apiService,
  });

  final String vehicleNumber;
  final VehicleApiService apiService;

  @override
  State<VehicleLoadingScreen> createState() => _VehicleLoadingScreenState();
}

class _VehicleLoadingScreenState extends State<VehicleLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnim;

  bool _isLoading = true;
  bool _isFetching = false;
  VehicleApiException? _error;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 0.94, end: 1.07).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    unawaited(_fetchAndRoute());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _fetchAndRoute() async {
    if (_isFetching) return;
    _isFetching = true;
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final VehicleDetailsModel details =
          await widget.apiService.fetchVehicleDetails(widget.vehicleNumber);

      if (!mounted) return;
      final Widget targetScreen = _buildDestinationScreen(details);
      await Navigator.of(context).pushReplacement(
        PageRouteBuilder<bool>(
          transitionDuration: const Duration(milliseconds: 260),
          pageBuilder: (_, __, ___) => targetScreen,
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    } on VehicleApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = VehicleApiException(
          type: VehicleApiErrorType.unexpectedError,
          message: 'Unexpected error while verifying vehicle: $e',
        );
      });
    } finally {
      _isFetching = false;
    }
  }

  Widget _buildDestinationScreen(VehicleDetailsModel details) {
    switch (details.fuelCategory) {
      case VehicleFuelCategory.cng:
        return CngComplianceScreen(
          vehicle: details,
          apiService: widget.apiService,
        );
      case VehicleFuelCategory.petrol:
        return PetrolVehicleScreen(
          vehicle: details,
          apiService: widget.apiService,
        );
      case VehicleFuelCategory.diesel:
        return DieselVehicleScreen(
          vehicle: details,
          apiService: widget.apiService,
        );
      case VehicleFuelCategory.unknown:
        return UnknownVehicleScreen(vehicle: details);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AnprUiColors.canvasBg,
      appBar: AppBar(
        backgroundColor: AnprUiColors.brandDarkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isLoading ? 'Verifying Vehicle' : 'Verification Issue',
          style: TextStyle(
            fontSize: AppFont.font_16,
            fontWeight: FontWeight.w700,
            fontFamily: AppFont.poppins,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _isLoading ? _buildLoadingBody() : _buildErrorBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBody() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AnprUiColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AnprUiColors.brandGreen.withAlpha(24),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AnprUiColors.brandDarkGreen,
                    AnprUiColors.brandGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AnprUiColors.brandGreen.withAlpha(70),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_car_filled_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AnprUiColors.subtleYellowBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AnprUiColors.subtleYellowBorder),
            ),
            child: Text(
              widget.vehicleNumber,
              style: TextStyle(
                color: const Color(0xFF111827),
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontFamily: AppFont.poppins,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Fetching Vehicle Information...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF111827),
              fontSize: AppFont.font_18,
              fontWeight: FontWeight.w700,
              fontFamily: AppFont.poppins,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Verifying vehicle details...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 6,
              backgroundColor: const Color(0xFFE5EFE2),
              color: AnprUiColors.brandGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBody() {
    final err = _error!;
    final String title;
    final IconData icon;
    switch (err.type) {
      case VehicleApiErrorType.noInternet:
        title = 'No Internet Connection';
        icon = Icons.wifi_off_rounded;
      case VehicleApiErrorType.timeout:
        title = 'Request Timed Out';
        icon = Icons.hourglass_disabled_rounded;
      case VehicleApiErrorType.vehicleNotFound:
        title = 'Vehicle Not Found';
        icon = Icons.search_off_rounded;
      case VehicleApiErrorType.unauthorized:
        title = 'Authentication Error';
        icon = Icons.lock_outline_rounded;
      case VehicleApiErrorType.badRequest:
        title = 'Invalid Registration Number';
        icon = Icons.error_outline_rounded;
      case VehicleApiErrorType.serverError:
        title = 'Server Error';
        icon = Icons.cloud_off_rounded;
      case VehicleApiErrorType.emptyResponse:
      case VehicleApiErrorType.invalidJson:
      case VehicleApiErrorType.missingFuelDesc:
      case VehicleApiErrorType.unexpectedError:
        title = 'Unable to Read Vehicle Details';
        icon = Icons.warning_amber_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFCA5A5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB91C1C).withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFB91C1C), size: 38),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.vehicleNumber,
              style: TextStyle(
                color: const Color(0xFF111827),
                fontSize: AppFont.font_16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF111827),
              fontSize: AppFont.font_18,
              fontWeight: FontWeight.w700,
              fontFamily: AppFont.poppins,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            err.message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF4B5563),
              fontSize: AppFont.font_13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AnprUiColors.brandDarkGreen,
                    side: BorderSide(color: AnprUiColors.brandGreen),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text('Scan Again'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AnprUiColors.brandGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _fetchAndRoute,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
