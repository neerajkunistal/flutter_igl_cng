import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/cylinder_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/compliance_status_card.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/widgets/vehicle_info_card.dart';
import 'package:flutter_igl_cng/utils/res/app_font.dart';

/// Displays an individual PESO / CNG cylinder compliance card with color-coded
/// status badge (Green = Valid, Red = Expired, Amber = Expiring Soon / Pending).
class CylinderCertificateCard extends StatelessWidget {
  const CylinderCertificateCard({
    super.key,
    required this.cylinder,
    required this.index,
    this.vehicleNumber,
    this.showViewCertificateButton = true,
    this.overrideValidity,
  });

  final CylinderDetailsModel cylinder;
  final int index;
  final String? vehicleNumber;
  final bool showViewCertificateButton;
  final ValidityStatus? overrideValidity;

  @override
  Widget build(BuildContext context) {
    final ValidityStatus validity =
        overrideValidity ?? cylinder.evaluateValidity();
    final Color statusColor = AnprUiColors.statusForeground(validity);
    final Color cardBorderColor = validity == ValidityStatus.expired
        ? const Color(0xFFFCA5A5)
        : (validity == ValidityStatus.valid
            ? const Color(0xFF86EFAC)
            : AnprUiColors.cardBorder);
    final Color cardBgColor = validity == ValidityStatus.expired
        ? const Color(0xFFFEF2F2)
        : Colors.white;
    final serialSuffix = (cylinder.cylinderNumber != null &&
            cylinder.cylinderNumber!.isNotEmpty)
        ? ': ${cylinder.cylinderNumber}'
        : '';

    final fields = <VehicleInfoField>[
      VehicleInfoField(
        label: 'Cylinder ID / Serial No.',
        value: cylinder.cylinderNumber,
      ),
      VehicleInfoField(
        label: 'Certificate No.',
        value: cylinder.certificateNumber ?? cylinder.pesoApprovalNo,
      ),
      VehicleInfoField(
        label: 'Hydro Test Date',
        value: cylinder.testDate,
      ),
      if (cylinder.manufacturingDate != null)
        VehicleInfoField(
          label: 'Cylinder Mfg. Date',
          value: cylinder.manufacturingDate,
        )
      else
        VehicleInfoField(
          label: 'Last Testing Date',
          value: cylinder.lastTestingDate,
        ),
      VehicleInfoField(
        label: 'Hydro Test Due Date',
        value: cylinder.nextTestDueDate,
      ),
      VehicleInfoField(
        label: 'Water Capacity (Litre)',
        value: cylinder.waterCapacity,
      ),
      if (cylinder.testingCompanyName != null)
        VehicleInfoField(
          label: 'Testing Company Name',
          value: cylinder.testingCompanyName,
        ),
      if (cylinder.manufacturer != null)
        VehicleInfoField(
          label: 'Cylinder Make',
          value: cylinder.manufacturer,
        ),
      VehicleInfoField(
        label: 'Certificate / Test Result',
        value: cylinder.status ?? cylinder.certificateValidity,
        status: validity,
      ),
      if (cylinder.vehicleRegistrationNumber != null)
        VehicleInfoField(
          label: 'Vehicle Reg. No. (PESO)',
          value: cylinder.vehicleRegistrationNumber,
        ),
    ];

    return Column(
      children: [
        VehicleInfoCard(
          title: 'Cylinder #${index + 1}$serialSuffix',
          icon: Icons.propane_tank_rounded,
          accentColor: statusColor,
          borderColor: cardBorderColor,
          backgroundColor: cardBgColor,
          trailing: ValidityBadge(
            status: validity,
            customLabel: validity == ValidityStatus.valid
                ? 'VALID'
                : (validity == ValidityStatus.expired ? 'EXPIRED' : null),
          ),
          fields: fields,
        ),
        if (showViewCertificateButton) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: statusColor,
                backgroundColor: cardBgColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: cardBorderColor),
                ),
              ),
              onPressed: () => PesoCertificateDetailSheet.show(
                context,
                cylinder: cylinder,
                vehicleNumber: vehicleNumber ??
                    cylinder.vehicleRegistrationNumber ??
                    'Not Available',
                validity: validity,
              ),
              icon: const Icon(Icons.description_outlined, size: 17),
              label: Text(
                'View Certificate',
                style: TextStyle(
                  fontSize: AppFont.font_12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Modal detail view matching the Suraksha Plus "PESO CERTIFICATE DETAILS"
/// Government of India card.
class PesoCertificateDetailSheet extends StatelessWidget {
  const PesoCertificateDetailSheet({
    super.key,
    required this.cylinder,
    required this.vehicleNumber,
    required this.validity,
  });

  final CylinderDetailsModel cylinder;
  final String vehicleNumber;
  final ValidityStatus validity;

  static Future<void> show(
    BuildContext context, {
    required CylinderDetailsModel cylinder,
    required String vehicleNumber,
    required ValidityStatus validity,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PesoCertificateDetailSheet(
        cylinder: cylinder,
        vehicleNumber: vehicleNumber,
        validity: validity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      maxChildSize: 0.92,
      minChildSize: 0.45,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 14, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AnprUiColors.brandDarkGreen,
                      AnprUiColors.brandGreen,
                    ],
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(110),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(35),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PESO Certificate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFont.font_16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppFont.poppins,
                                ),
                              ),
                              Text(
                                'Petroleum and Explosives Safety Organisation',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(220),
                                  fontSize: AppFont.font_11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ValidityBadge(status: validity),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    VehicleInfoCard(
                      title: 'PESO CERTIFICATE DETAILS',
                      icon: Icons.description_rounded,
                      accentColor: AnprUiColors.brandDarkGreen,
                      fields: [
                        VehicleInfoField(
                          label: 'Vehicle Number',
                          value: vehicleNumber,
                        ),
                        VehicleInfoField(
                          label: 'Cylinder ID / Serial No.',
                          value: cylinder.cylinderNumber,
                        ),
                        VehicleInfoField(
                          label: 'Certificate No.',
                          value: cylinder.certificateNumber,
                        ),
                        VehicleInfoField(
                          label: 'Cylinder Manufacturing Date',
                          value: cylinder.manufacturingDate,
                        ),
                        VehicleInfoField(
                          label: 'Hydro Test Date',
                          value: cylinder.testDate,
                        ),
                        VehicleInfoField(
                          label: 'Hydro Test Due Date',
                          value: cylinder.nextTestDueDate,
                        ),
                        VehicleInfoField(
                          label: 'Water Capacity',
                          value: cylinder.waterCapacity,
                        ),
                        VehicleInfoField(
                          label: 'Cylinder Make',
                          value: cylinder.manufacturer,
                        ),
                        VehicleInfoField(
                          label: 'Testing Company',
                          value: cylinder.testingCompanyName,
                        ),
                        VehicleInfoField(
                          label: 'Test Result',
                          value: cylinder.status,
                          status: validity,
                        ),
                        if (cylinder.cylinderAgeValidTill != null)
                          VehicleInfoField(
                            label: 'Cylinder Age Valid Till',
                            value: cylinder.cylinderAgeValidTill,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AnprUiColors.brandGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Informational card when the backend/VAHAN response does not include PESO /
/// individual cylinder certificate records.
class MissingCylinderInfoCard extends StatelessWidget {
  const MissingCylinderInfoCard({
    super.key,
    this.rcCylinderCount,
  });

  final String? rcCylinderCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AnprUiColors.subtleYellowBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AnprUiColors.subtleYellowBorder, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFB45309),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PESO / Cylinder Certificate Data Unavailable',
                  style: TextStyle(
                    color: const Color(0xFF92400E),
                    fontSize: AppFont.font_14,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFont.poppins,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'The API response did not include PESO certificate or individual '
                  'hydro-testing cylinder records${rcCylinderCount != null && rcCylinderCount!.isNotEmpty ? ' (RC cylinder count: $rcCylinderCount)' : ''}. '
                  'Physical / Suraksha Plus verification is pending.',
                  style: TextStyle(
                    color: const Color(0xFF78350F),
                    fontSize: AppFont.font_12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
