import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/cylinder_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/vehicle_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/compliance_status_card.dart';
import 'package:flutter_igl_cng/utils/res/app_font.dart';

class VehicleInfoField {
  const VehicleInfoField({
    required this.label,
    required this.value,
    this.status,
    this.statusLabel,
  });

  final String label;
  final String? value;
  final ValidityStatus? status;
  final String? statusLabel;
}

/// Reusable rounded Material 3 card for grouped vehicle RC & status fields.
class VehicleInfoCard extends StatelessWidget {
  const VehicleInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.fields,
    this.accentColor,
    this.trailing,
    this.borderColor,
    this.backgroundColor,
  });

  final String title;
  final IconData icon;
  final List<VehicleInfoField> fields;
  final Color? accentColor;
  final Widget? trailing;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AnprUiColors.brandGreen;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor ?? AnprUiColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(11),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withAlpha(24),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accent, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF111827),
                      fontSize: AppFont.font_15,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFont.poppins,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFEEF2EE)),
            const SizedBox(height: 6),
            for (int i = 0; i < fields.length; i++) ...[
              _VehicleFieldRow(field: fields[i]),
              if (i < fields.length - 1)
                const Divider(height: 1, color: Color(0xFFF3F6F3)),
            ],
          ],
        ),
      ),
    );
  }
}

class _VehicleFieldRow extends StatelessWidget {
  const _VehicleFieldRow({required this.field});

  final VehicleInfoField field;

  @override
  Widget build(BuildContext context) {
    final raw = field.value?.trim() ?? '';
    final bool isMissing = raw.isEmpty || raw.toLowerCase() == 'null';
    final String displayValue = isMissing ? 'Not Available' : raw;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              field.label,
              style: TextStyle(
                color: const Color(0xFF4B5563),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  displayValue,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: isMissing
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF111827),
                    fontSize: 14.5,
                    fontWeight: isMissing ? FontWeight.w500 : FontWeight.w700,
                    fontStyle: isMissing ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
                if (field.status != null) ...[
                  const SizedBox(height: 4),
                  ValidityBadge(
                    status: field.status!,
                    customLabel: field.statusLabel,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders all extra API fields returned in `data` so no backend attribute is
/// ever discarded.
class AdditionalApiFieldsCard extends StatelessWidget {
  const AdditionalApiFieldsCard({
    super.key,
    required this.allDataFields,
    this.excludedKeys = const <String>{},
    this.accentColor,
  });

  final Map<String, dynamic> allDataFields;
  final Set<String> excludedKeys;
  final Color? accentColor;

  static String _humanizeKey(String rawKey) {
    var k = rawKey;
    if (k.startsWith('rc') && k.length > 2) {
      k = k.substring(2);
    }
    k = k.replaceAll('_', ' ');
    k = k.replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (m) => '${m.group(1)} ${m.group(2)}',
    );
    return k
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  static String? _formatValue(dynamic v) {
    if (v == null) return 'Not Available';
    if (v is List) {
      if (v.isEmpty) return 'None';
      if (v.every((e) => e is! Map && e is! List)) {
        return v.join(', ');
      }
      return '${v.length} record(s)';
    }
    if (v is Map) {
      if (v.isEmpty) return 'Not Available';
      return v.entries
          .map((e) => '${_humanizeKey(e.key.toString())}: ${e.value ?? 'N/A'}')
          .join('\n');
    }
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return 'Not Available';
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final normalizedExcluded =
        excludedKeys.map((k) => k.toLowerCase()).toSet();

    final extraFields = <VehicleInfoField>[];
    for (final entry in allDataFields.entries) {
      if (normalizedExcluded.contains(entry.key.toLowerCase())) continue;
      // Skip nested cylinder lists already shown in cylinder section.
      if (entry.value is List &&
          entry.key.toLowerCase().contains('cylinder')) {
        continue;
      }
      extraFields.add(
        VehicleInfoField(
          label: _humanizeKey(entry.key),
          value: _formatValue(entry.value),
        ),
      );
    }

    if (extraFields.isEmpty) return const SizedBox.shrink();

    return VehicleInfoCard(
      title: 'Complete API & Registry Fields',
      icon: Icons.list_alt_rounded,
      accentColor: accentColor,
      fields: extraFields,
    );
  }
}

/// Shared "Vehicle Owner & Registration" card used identically across
/// Vehicle Alert and CNG Compliance screens.
class VehicleOwnerRegistrationCard extends StatelessWidget {
  const VehicleOwnerRegistrationCard({
    super.key,
    required this.vehicle,
    required this.fuelFallback,
    required this.accentColor,
  });

  final VehicleDetailsModel vehicle;
  final String fuelFallback;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final rcStatus = vehicle.evaluateRcStatus();

    return VehicleInfoCard(
      title: 'Vehicle Owner & Registration',
      icon: Icons.badge_rounded,
      accentColor: accentColor,
      fields: [
        VehicleInfoField(
          label: 'Vehicle Number',
          value: vehicle.displayRegistrationNumber,
        ),
        // VehicleInfoField(
        //   label: 'Owner Name',
        //   value: vehicle.rcOwnerName,
        // ),
        VehicleInfoField(
          label: 'Fuel Type (rcFuelDesc)',
          value: vehicle.rcFuelDesc ?? fuelFallback,
        ),
        VehicleInfoField(
          label: 'Vehicle Type / Class',
          value: vehicle.rcVhClassDesc != null && vehicle.rcVhType != null
              ? '${vehicle.rcVhClassDesc} (${vehicle.rcVhType})'
              : vehicle.rcVhClassDesc ?? vehicle.rcVhType,
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
    );
  }
}

/// Persistent bottom CTA bar for all vehicle classification screens.
class VehicleScannerActionBar extends StatelessWidget {
  const VehicleScannerActionBar({
    super.key,
    required this.onScanAgain,
    this.primaryColor,
  });

  final VoidCallback onScanAgain;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? AnprUiColors.brandGreen;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AnprUiColors.cardBorder)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(14),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onScanAgain,
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(
                  'Scan Next Vehicle',
                  style: TextStyle(
                    fontSize: AppFont.font_14,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFont.poppins,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
