import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/cylinder_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/vehicle_details_model.dart';
import 'package:flutter_igl_cng/utils/res/app_color.dart';
import 'package:flutter_igl_cng/utils/res/app_font.dart';

/// Shared brand palette combining IGL CNG green, clean white, and subtle yellow.
class AnprUiColors {
  static Color get brandGreen => AppColor.themeColor;
  static Color get brandDarkGreen => const Color(0xFF14532D);
  static Color get brandMidGreen => AppColor.themeLightColor;
  static Color get accentYellow => AppColor.themeSecondary;
  static Color get subtleYellowBg => const Color(0xFFFEF9E7);
  static Color get subtleYellowBorder => const Color(0xFFF6D56B);
  static Color get canvasBg => const Color(0xFFF5F8F4);
  static Color get cardBorder => const Color(0xFFE3ECE1);

  static Color statusForeground(ValidityStatus status) {
    switch (status) {
      case ValidityStatus.valid:
        return const Color(0xFF15803D);
      case ValidityStatus.expiringSoon:
      case ValidityStatus.pendingOrUnavailable:
        return const Color(0xFFB45309);
      case ValidityStatus.expired:
        return const Color(0xFFB91C1C);
    }
  }

  static Color statusBackground(ValidityStatus status) {
    switch (status) {
      case ValidityStatus.valid:
        return const Color(0xFFDCFCE7);
      case ValidityStatus.expiringSoon:
      case ValidityStatus.pendingOrUnavailable:
        return const Color(0xFFFEF3C7);
      case ValidityStatus.expired:
        return const Color(0xFFFEE2E2);
    }
  }
}

/// Compact color-coded badge for Valid / Expired / Expiring Soon / N/A.
class ValidityBadge extends StatelessWidget {
  const ValidityBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  final ValidityStatus status;
  final String? customLabel;

  @override
  Widget build(BuildContext context) {
    final fg = AnprUiColors.statusForeground(status);
    final bg = AnprUiColors.statusBackground(status);
    final IconData icon;
    switch (status) {
      case ValidityStatus.valid:
        icon = Icons.check_circle_rounded;
      case ValidityStatus.expiringSoon:
        icon = Icons.schedule_rounded;
      case ValidityStatus.pendingOrUnavailable:
        icon = Icons.help_outline_rounded;
      case ValidityStatus.expired:
        icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withAlpha(55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            customLabel ?? status.label,
            style: TextStyle(
              color: fg,
              fontSize: AppFont.font_11,
              fontWeight: FontWeight.w700,
              fontFamily: AppFont.poppins,
            ),
          ),
        ],
      ),
    );
  }
}

/// Top dashboard hero header showing Suraksha Plus / IGL branding, Indian
/// number plate badge, fuel badge, and status pill.
class VehicleDashboardHeader extends StatelessWidget {
  const VehicleDashboardHeader({
    super.key,
    required this.vehicleNumber,
    required this.fuelBadgeText,
    required this.fuelBadgeColor,
    required this.subtitleText,
    required this.gradientColors,
    this.brandTitle = 'IGL Suraksha Plus',
    this.rightBadge,
    this.sourceLabel,
  });

  final String vehicleNumber;
  final String fuelBadgeText;
  final Color fuelBadgeColor;
  final String subtitleText;
  final List<Color> gradientColors;
  final String? brandTitle;
  final Widget? rightBadge;
  final String? sourceLabel;

  @override
  Widget build(BuildContext context) {
    final bool hasBrand = brandTitle != null && brandTitle!.trim().isNotEmpty;
    final bool hasSource = sourceLabel != null && sourceLabel!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withAlpha(65),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasBrand || hasSource) ...[
            Row(
              children: [
                if (hasBrand)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(32),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withAlpha(55)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          color: AnprUiColors.accentYellow,
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          brandTitle!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFont.font_12,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFont.poppins,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                if (hasSource)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(45),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Source: $sourceLabel',
                      style: TextStyle(
                        color: Colors.white.withAlpha(235),
                        fontSize: AppFont.font_10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          // Indian Number Plate Display Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD5E3D2), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(24),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D4ED8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_car_rounded,
                          color: Colors.white, size: 14),
                      SizedBox(height: 2),
                      Text(
                        'IND',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REGISTRATION NUMBER',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: AppFont.font_10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.9,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SelectableText(
                        vehicleNumber,
                        style: TextStyle(
                          color: const Color(0xFF111827),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.8,
                          fontFamily: AppFont.poppins,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: fuelBadgeColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: fuelBadgeColor.withAlpha(90)),
                  ),
                  child: Text(
                    fuelBadgeText,
                    style: TextStyle(
                      color: fuelBadgeColor,
                      fontSize: AppFont.font_12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  subtitleText,
                  style: TextStyle(
                    color: Colors.white.withAlpha(240),
                    fontSize: AppFont.font_13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (rightBadge != null) ...[
                const SizedBox(width: 8),
                rightBadge!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Large Compliance Hero Card for CNG Compliance Screen.
class ComplianceStatusCard extends StatelessWidget {
  const ComplianceStatusCard({
    super.key,
    required this.level,
    required this.headline,
    required this.summary,
    this.reasons = const <String>[],
  });

  final OverallComplianceLevel level;
  final String headline;
  final String summary;
  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    final Color primary;
    final Color bgColor;
    final Color borderColor;
    final IconData icon;

    switch (level) {
      case OverallComplianceLevel.compliant:
        primary = const Color(0xFF15803D);
        bgColor = const Color(0xFFECFDF3);
        borderColor = const Color(0xFF86EFAC);
        icon = Icons.check_circle_rounded;
      case OverallComplianceLevel.expiringOrPending:
        primary = const Color(0xFFB45309);
        bgColor = AnprUiColors.subtleYellowBg;
        borderColor = AnprUiColors.subtleYellowBorder;
        icon = Icons.warning_amber_rounded;
      case OverallComplianceLevel.nonCompliant:
        primary = const Color(0xFFB91C1C);
        bgColor = const Color(0xFFFEF2F2);
        borderColor = const Color(0xFFFCA5A5);
        icon = Icons.gpp_bad_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primary.withAlpha(22),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primary.withAlpha(28),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primary, size: 38),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headline,
                      style: TextStyle(
                        color: primary,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                        fontFamily: AppFont.poppins,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary,
                      style: TextStyle(
                        color: const Color(0xFF1F2937),
                        fontSize: 14,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (reasons.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(color: borderColor, height: 1),
            const SizedBox(height: 10),
            ...reasons.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Icon(Icons.circle, size: 6, color: primary),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r,
                        style: TextStyle(
                          color: const Color(0xFF374151),
                          fontSize: AppFont.font_12,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Suraksha Plus 3-column verification status card inspired by the reference
/// dashboard: displays `CNG ON RC`, `PUCC`, and `INSURANCE` pills (Green check
/// vs Red close / Warning triangle), optional `Vehicle Age` banner, and
/// `# CYLINDER` / `# EXPIRED` strip for CNG vehicles.
class SurakshaStatusOverviewCard extends StatelessWidget {
  const SurakshaStatusOverviewCard({
    super.key,
    required this.vehicle,
    this.isAlertTheme = false,
    this.forceCngEndorsedPill = false,
    this.showCylinderSummaryOverride,
    this.overrideCylinderCount,
    this.overrideExpiredCylinderCount,
  });

  final VehicleDetailsModel vehicle;
  final bool isAlertTheme;
  final bool forceCngEndorsedPill;
  final bool? showCylinderSummaryOverride;
  final int? overrideCylinderCount;
  final int? overrideExpiredCylinderCount;

  @override
  Widget build(BuildContext context) {
    final endorseStatus = vehicle.evaluateCngEndorsementStatus();
    final pucStatus = vehicle.evaluatePucStatus();
    final insStatus = vehicle.evaluateInsuranceStatus();
    final fuelCat = vehicle.fuelCategory;
    final ageLabel = vehicle.surakshaVehicleAgeLabel();

    final int cylCount = overrideCylinderCount ?? vehicle.totalCylinderCount;
    final int expiredCyls =
        overrideExpiredCylinderCount ?? vehicle.expiredCylinderCount();
    final bool showCylinderRow = showCylinderSummaryOverride ??
        (fuelCat == VehicleFuelCategory.cng &&
            (cylCount > 0 || vehicle.cylinders.isNotEmpty));

    final Color borderColor;
    final Color cardBg;
    if (isAlertTheme) {
      borderColor = const Color(0xFFFB923C);
      cardBg = const Color(0xFFFFFBF2);
    } else if (expiredCyls > 0) {
      borderColor = const Color(0xFFFCA5A5);
      cardBg = Colors.white;
    } else {
      borderColor = AnprUiColors.cardBorder;
      cardBg = Colors.white;
    }

    // Column 1: CNG ON RC
    final _PillSpec rcPill;
    if (forceCngEndorsedPill || fuelCat == VehicleFuelCategory.cng) {
      rcPill = (!forceCngEndorsedPill && endorseStatus == ValidityStatus.expired)
          ? const _PillSpec(
              header: 'CNG ON RC',
              label: 'NOT\nENDORSED',
              fgColor: Color(0xFFB91C1C),
              borderColor: Color(0xFFDC2626),
              bgColor: Color(0xFFFEF2F2),
              icon: Icons.close_rounded,
              circleIconBg: Color(0xFFDC2626),
            )
          : const _PillSpec(
              header: 'CNG ON RC',
              label: 'CNG\nENDORSED',
              fgColor: Color(0xFF14532D),
              borderColor: Color(0xFF16A34A),
              bgColor: Colors.white,
              icon: Icons.check_rounded,
              circleIconBg: Color(0xFF15803D),
            );
    } else if (fuelCat == VehicleFuelCategory.petrol) {
      rcPill = const _PillSpec(
        header: 'CNG ON RC',
        label: 'PETROL ONLY',
        fgColor: Color(0xFFDC2626),
        borderColor: Color(0xFFEA580C),
        bgColor: Color(0xFFFFF7ED),
        icon: Icons.warning_rounded,
        isTriangleWarning: true,
      );
    } else if (fuelCat == VehicleFuelCategory.diesel) {
      rcPill = const _PillSpec(
        header: 'CNG ON RC',
        label: 'DIESEL ONLY',
        fgColor: Color(0xFFDC2626),
        borderColor: Color(0xFFEA580C),
        bgColor: Color(0xFFFFF7ED),
        icon: Icons.warning_rounded,
        isTriangleWarning: true,
      );
    } else {
      final raw = (vehicle.rcFuelDesc ?? '').trim().toUpperCase();
      rcPill = _PillSpec(
        header: 'CNG ON RC',
        label: raw.isEmpty ? 'UNKNOWN' : raw,
        fgColor: const Color(0xFFB45309),
        borderColor: const Color(0xFFF59E0B),
        bgColor: const Color(0xFFFEF3C7),
        icon: Icons.warning_rounded,
        isTriangleWarning: true,
      );
    }

    // Column 2: PUCC (`rcPuccUpto`)
    final _PillSpec pucPill = _buildDatePill(
      header: 'PUCC',
      validLabel: 'PUCC\nVALID',
      expiredLabel: 'PUCC\nEXPIRED',
      missingLabel: 'PUCC\nN/A',
      dateValue: vehicle.rcPuccUpto,
      status: pucStatus,
    );

    // Column 3: INSURANCE (`rcInsuranceUpto`)
    final _PillSpec insPill = _buildDatePill(
      header: 'INSURANCE',
      validLabel: 'INSURED',
      expiredLabel: 'EXPIRED',
      missingLabel: 'N/A',
      dateValue: vehicle.rcInsuranceUpto,
      status: insStatus,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: (isAlertTheme ? const Color(0xFFEA580C) : Colors.black)
                .withAlpha(18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (ageLabel != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF08A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEAB308), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEAB308).withAlpha(35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    color: Color(0xFF78350F),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Vehicle Age: $ageLabel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF111827),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                        fontFamily: AppFont.poppins,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _SurakshaPillColumn(spec: rcPill)),
              const SizedBox(width: 10),
              Expanded(child: _SurakshaPillColumn(spec: pucPill)),
              const SizedBox(width: 10),
              Expanded(child: _SurakshaPillColumn(spec: insPill)),
            ],
          ),
          if (showCylinderRow) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _SurakshaPillColumn(spec: rcPill)),
                const SizedBox(width: 10),
                Expanded(
                  child: _CylinderCountPillColumn(
                    header: '# CYLINDER',
                    count: cylCount,
                    subtitle: 'TOTAL',
                    icon: Icons.propane_tank_rounded,
                    bgColor: const Color(0xFFFEF08A),
                    borderColor: const Color(0xFFEAB308),
                    textColor: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _CylinderCountPillColumn(
                    header: '# EXPIRED',
                    count: expiredCyls,
                    subtitle: expiredCyls > 0 ? 'EXPIRED' : 'VALID',
                    icon: expiredCyls > 0
                        ? Icons.cancel_rounded
                        : Icons.check_circle_rounded,
                    bgColor: expiredCyls > 0
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF15803D),
                    borderColor: expiredCyls > 0
                        ? const Color(0xFF991B1B)
                        : const Color(0xFF14532D),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  _PillSpec _buildDatePill({
    required String header,
    required String validLabel,
    required String expiredLabel,
    required String missingLabel,
    required String? dateValue,
    required ValidityStatus status,
  }) {
    final cleanDate = (dateValue ?? '').trim();
    final subDate =
        cleanDate.isEmpty || cleanDate.toLowerCase() == 'null' ? null : cleanDate;

    switch (status) {
      case ValidityStatus.valid:
        return _PillSpec(
          header: header,
          label: validLabel,
          subDate: subDate,
          fgColor: const Color(0xFF14532D),
          borderColor: const Color(0xFF16A34A),
          bgColor: Colors.white,
          icon: Icons.check_rounded,
          circleIconBg: const Color(0xFF15803D),
        );
      case ValidityStatus.expired:
        return _PillSpec(
          header: header,
          label: expiredLabel,
          subDate: subDate,
          fgColor: const Color(0xFFB91C1C),
          borderColor: const Color(0xFFDC2626),
          bgColor: const Color(0xFFFEF2F2),
          icon: Icons.close_rounded,
          circleIconBg: const Color(0xFFDC2626),
        );
      case ValidityStatus.expiringSoon:
      case ValidityStatus.pendingOrUnavailable:
        return _PillSpec(
          header: header,
          label: missingLabel,
          subDate: subDate,
          fgColor: const Color(0xFF92400E),
          borderColor: const Color(0xFFF59E0B),
          bgColor: const Color(0xFFFFFBEB),
          icon: Icons.help_outline_rounded,
          circleIconBg: const Color(0xFFD97706),
        );
    }
  }
}

class _PillSpec {
  const _PillSpec({
    required this.header,
    required this.label,
    required this.fgColor,
    required this.borderColor,
    required this.bgColor,
    required this.icon,
    this.circleIconBg,
    this.isTriangleWarning = false,
    this.subDate,
  });

  final String header;
  final String label;
  final Color fgColor;
  final Color borderColor;
  final Color bgColor;
  final IconData icon;
  final Color? circleIconBg;
  final bool isTriangleWarning;
  final String? subDate;
}

class _SurakshaPillColumn extends StatelessWidget {
  const _SurakshaPillColumn({required this.spec});

  final _PillSpec spec;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          spec.header,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF111827),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
            fontFamily: AppFont.poppins,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 108),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            color: spec.bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: spec.borderColor, width: 2.2),
            boxShadow: [
              BoxShadow(
                color: spec.borderColor.withAlpha(32),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (spec.isTriangleWarning)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: spec.fgColor.withAlpha(24),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(spec.icon, color: spec.fgColor, size: 28),
                )
              else
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: spec.circleIconBg ?? spec.fgColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (spec.circleIconBg ?? spec.fgColor).withAlpha(65),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(spec.icon, color: Colors.white, size: 24),
                ),
              const SizedBox(height: 8),
              Text(
                spec.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: spec.fgColor,
                  fontSize: 13.5,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                  fontFamily: AppFont.poppins,
                ),
              ),
              if (spec.subDate != null) ...[
                const SizedBox(height: 4),
                Text(
                  spec.subDate!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF374151),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CylinderCountPillColumn extends StatelessWidget {
  const _CylinderCountPillColumn({
    required this.header,
    required this.count,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
  });

  final String header;
  final int count;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          header,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF111827),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
            fontFamily: AppFont.poppins,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 112),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 2.2),
            boxShadow: [
              BoxShadow(
                color: borderColor.withAlpha(42),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 22),
              const SizedBox(height: 2),
              Text(
                '$count',
                style: TextStyle(
                  color: textColor,
                  fontSize: 30,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  fontFamily: AppFont.poppins,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: textColor.withAlpha(220),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
