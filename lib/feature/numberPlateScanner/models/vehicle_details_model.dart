import 'package:flutter_igl_cng/feature/numberPlateScanner/models/cylinder_details_model.dart';

/// Fuel-type route classification driven by `rcFuelDesc`.
enum VehicleFuelCategory {
  cng,
  petrol,
  diesel,
  unknown,
}

/// Overall compliance tier for CNG compliance screen & status cards.
enum OverallComplianceLevel {
  compliant,
  expiringOrPending,
  nonCompliant,
}

/// Complete, null-safe representation of `/api/vehicle/details` responses.
///
/// Maps all standard VAHAN RC fields (`rc*`), PESO/CNG certificate fields,
/// nested cylinder arrays, and preserves every additional field from `data`
/// inside [allDataFields] so no API field is silently dropped.
class VehicleDetailsModel {
  const VehicleDetailsModel({
    required this.status,
    required this.source,
    required this.queriedVehicleNumber,
    this.statusMessage,
    this.rcRegnNo,
    this.rcOwnerName,
    this.rcOwnerFatherName,
    this.rcFuelDesc,
    this.rcVhClassDesc,
    this.rcVhType,
    this.rcRegnDt,
    this.rcRegnUpto,
    this.rcPurchaseDt,
    this.rcManuMonthYr,
    this.vehicleAge,
    this.rcMakerDesc,
    this.rcMakerModel,
    this.rcBodyTypeDesc,
    this.rcColor,
    this.rcChasiNo,
    this.rcEngNo,
    this.rcStatus,
    this.rcStatusAsOn,
    this.rcBlacklistStatus,
    this.rcNocDetails,
    this.rcRegisteredAt,
    this.rcPresentAddress,
    this.rcPermanentAddress,
    this.rcFinancer,
    this.rcInsuranceComp,
    this.rcInsurancePolicyNo,
    this.rcInsuranceUpto,
    this.rcPuccNo,
    this.rcPuccUpto,
    this.rcTaxUpto,
    this.rcFitUpto,
    this.rcUnldWt,
    this.rcGvw,
    this.rcSeatCap,
    this.rcNoCyl,
    this.rcWheelbase,
    this.rcCubicCap,
    this.rcNormsDesc,
    this.rcSaleAmt,
    this.cngEndorsementStatus,
    this.pesoCertificateNumber,
    this.pesoStatus,
    this.pesoValidUpto,
    this.explicitComplianceStatus,
    this.explicitComplianceMessage,
    this.isExplicitCompliant,
    this.cylinders = const <CylinderDetailsModel>[],
    this.allDataFields = const <String, dynamic>{},
    this.rawResponse = const <String, dynamic>{},
  });

  final bool status;
  final String? source;
  final String queriedVehicleNumber;
  final String? statusMessage;

  // Registration & Ownership
  final String? rcRegnNo;
  final String? rcOwnerName;
  final String? rcOwnerFatherName;
  final String? rcFuelDesc;
  final String? rcVhClassDesc;
  final String? rcVhType;
  final String? rcRegnDt;
  final String? rcRegnUpto;
  final String? rcPurchaseDt;
  final String? rcManuMonthYr;
  final String? vehicleAge;

  // Vehicle Make & Technical Specs
  final String? rcMakerDesc;
  final String? rcMakerModel;
  final String? rcBodyTypeDesc;
  final String? rcColor;
  final String? rcChasiNo;
  final String? rcEngNo;
  final String? rcStatus;
  final String? rcStatusAsOn;
  final String? rcBlacklistStatus;
  final String? rcNocDetails;
  final String? rcRegisteredAt;
  final String? rcPresentAddress;
  final String? rcPermanentAddress;
  final String? rcFinancer;

  // Insurance, PUC, Tax, Fitness
  final String? rcInsuranceComp;
  final String? rcInsurancePolicyNo;
  final String? rcInsuranceUpto;
  final String? rcPuccNo;
  final String? rcPuccUpto;
  final String? rcTaxUpto;
  final String? rcFitUpto;

  // Dimensions & Capacities
  final String? rcUnldWt;
  final String? rcGvw;
  final String? rcSeatCap;
  final String? rcNoCyl;
  final String? rcWheelbase;
  final String? rcCubicCap;
  final String? rcNormsDesc;
  final String? rcSaleAmt;

  // CNG & PESO Compliance Fields (when provided by API)
  final String? cngEndorsementStatus;
  final String? pesoCertificateNumber;
  final String? pesoStatus;
  final String? pesoValidUpto;
  final String? explicitComplianceStatus;
  final String? explicitComplianceMessage;
  final bool? isExplicitCompliant;
  final List<CylinderDetailsModel> cylinders;

  /// Full unparsed maps so every additional API field can be displayed.
  final Map<String, dynamic> allDataFields;
  final Map<String, dynamic> rawResponse;

  VehicleDetailsModel copyWithCylinders(
    List<CylinderDetailsModel> updatedCylinders, {
    String? pesoCertNo,
    String? pesoStat,
    String? pesoExpiry,
  }) {
    return VehicleDetailsModel(
      status: status,
      source: source,
      queriedVehicleNumber: queriedVehicleNumber,
      statusMessage: statusMessage,
      rcRegnNo: rcRegnNo,
      rcOwnerName: rcOwnerName,
      rcOwnerFatherName: rcOwnerFatherName,
      rcFuelDesc: rcFuelDesc,
      rcVhClassDesc: rcVhClassDesc,
      rcVhType: rcVhType,
      rcRegnDt: rcRegnDt,
      rcRegnUpto: rcRegnUpto,
      rcPurchaseDt: rcPurchaseDt,
      rcManuMonthYr: rcManuMonthYr,
      vehicleAge: vehicleAge,
      rcMakerDesc: rcMakerDesc,
      rcMakerModel: rcMakerModel,
      rcBodyTypeDesc: rcBodyTypeDesc,
      rcColor: rcColor,
      rcChasiNo: rcChasiNo,
      rcEngNo: rcEngNo,
      rcStatus: rcStatus,
      rcStatusAsOn: rcStatusAsOn,
      rcBlacklistStatus: rcBlacklistStatus,
      rcNocDetails: rcNocDetails,
      rcRegisteredAt: rcRegisteredAt,
      rcPresentAddress: rcPresentAddress,
      rcPermanentAddress: rcPermanentAddress,
      rcFinancer: rcFinancer,
      rcInsuranceComp: rcInsuranceComp,
      rcInsurancePolicyNo: rcInsurancePolicyNo,
      rcInsuranceUpto: rcInsuranceUpto,
      rcPuccNo: rcPuccNo,
      rcPuccUpto: rcPuccUpto,
      rcTaxUpto: rcTaxUpto,
      rcFitUpto: rcFitUpto,
      rcUnldWt: rcUnldWt,
      rcGvw: rcGvw,
      rcSeatCap: rcSeatCap,
      rcNoCyl: rcNoCyl,
      rcWheelbase: rcWheelbase,
      rcCubicCap: rcCubicCap,
      rcNormsDesc: rcNormsDesc,
      rcSaleAmt: rcSaleAmt,
      cngEndorsementStatus: cngEndorsementStatus,
      pesoCertificateNumber: pesoCertNo ?? pesoCertificateNumber,
      pesoStatus: pesoStat ?? pesoStatus,
      pesoValidUpto: pesoExpiry ?? pesoValidUpto,
      explicitComplianceStatus: explicitComplianceStatus,
      explicitComplianceMessage: explicitComplianceMessage,
      isExplicitCompliant: isExplicitCompliant,
      cylinders: updatedCylinders,
      allDataFields: allDataFields,
      rawResponse: rawResponse,
    );
  }

  String get displayRegistrationNumber =>
      (rcRegnNo != null && rcRegnNo!.isNotEmpty)
          ? rcRegnNo!
          : queriedVehicleNumber;

  /// Fuel-type routing classification based strictly on `rcFuelDesc`,
  /// case-insensitive and whitespace-trimmed.
  VehicleFuelCategory get fuelCategory {
    final normalized = (rcFuelDesc ?? '').trim().toUpperCase();
    if (normalized.isEmpty) return VehicleFuelCategory.unknown;
    if (normalized == 'CNG' || normalized.contains('CNG')) {
      return VehicleFuelCategory.cng;
    }
    if (normalized == 'PETROL' ||
        normalized.startsWith('PETROL') ||
        normalized == 'GASOLINE') {
      return VehicleFuelCategory.petrol;
    }
    if (normalized == 'DIESEL' || normalized.startsWith('DIESEL')) {
      return VehicleFuelCategory.diesel;
    }
    return VehicleFuelCategory.unknown;
  }

  bool get isVehicleNotFoundMessage {
    final msg = (statusMessage ?? '').trim().toLowerCase();
    return msg.contains('not found') ||
        msg.contains('no record') ||
        msg.contains('invalid vehicle');
  }

  /// Computes readable vehicle age from [vehicleAge], [rcRegnDt], or [rcManuMonthYr].
  String? computeVehicleAge({DateTime? referenceDate}) {
    if (vehicleAge != null && vehicleAge!.isNotEmpty) {
      return vehicleAge;
    }
    final now = referenceDate ?? DateTime.now();
    DateTime? baseDate = parseFlexibleDate(rcRegnDt) ?? parseFlexibleDate(rcPurchaseDt);
    if (baseDate == null && rcManuMonthYr != null) {
      final m = RegExp(r'^(\d{1,2})[-/](\d{4})$').firstMatch(rcManuMonthYr!.trim());
      if (m != null) {
        final month = int.tryParse(m.group(1)!);
        final year = int.tryParse(m.group(2)!);
        if (month != null && year != null && month >= 1 && month <= 12) {
          baseDate = DateTime(year, month, 1);
        }
      }
    }
    if (baseDate == null) return null;

    int years = now.year - baseDate.year;
    int months = now.month - baseDate.month;
    if (now.day < baseDate.day) months -= 1;
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    if (years < 0) return null;
    if (years == 0) return '$months ${months == 1 ? 'month' : 'months'}';
    if (months == 0) return '$years ${years == 1 ? 'year' : 'years'}';
    return '$years yrs $months mos';
  }

  /// Suraksha-style age summary matching "Less than 3 Years" for newer vehicles.
  String? surakshaVehicleAgeLabel({DateTime? referenceDate}) {
    if (vehicleAge != null && vehicleAge!.isNotEmpty) {
      return vehicleAge;
    }
    final now = referenceDate ?? DateTime.now();
    DateTime? baseDate =
        parseFlexibleDate(rcRegnDt) ?? parseFlexibleDate(rcPurchaseDt);
    if (baseDate == null && rcManuMonthYr != null) {
      final m = RegExp(r'^(\d{1,2})[-/](\d{4})$').firstMatch(rcManuMonthYr!.trim());
      if (m != null) {
        final month = int.tryParse(m.group(1)!);
        final year = int.tryParse(m.group(2)!);
        if (month != null && year != null && month >= 1 && month <= 12) {
          baseDate = DateTime(year, month, 1);
        }
      }
    }
    if (baseDate == null) return null;

    int years = now.year - baseDate.year;
    int months = now.month - baseDate.month;
    if (now.day < baseDate.day) months -= 1;
    if (months < 0) {
      years -= 1;
    }
    if (years < 0) return null;
    if (years < 3) return 'Less than 3 Years';
    return computeVehicleAge(referenceDate: referenceDate);
  }

  /// Strict date-passed check for `rcPuccUpto`: red if passed, green if valid.
  ValidityStatus evaluatePucStatus({DateTime? referenceDate}) =>
      evaluateDateAndFlagValidity(
        dateRaw: rcPuccUpto,
        referenceDate: referenceDate,
        expiringSoonDays: -1,
      );

  /// Strict date-passed check for `rcInsuranceUpto`: red if passed, green if valid.
  ValidityStatus evaluateInsuranceStatus({DateTime? referenceDate}) =>
      evaluateDateAndFlagValidity(
        dateRaw: rcInsuranceUpto,
        referenceDate: referenceDate,
        expiringSoonDays: -1,
      );

  int get totalCylinderCount {
    if (cylinders.isNotEmpty) return cylinders.length;
    return int.tryParse((rcNoCyl ?? '').trim()) ?? 0;
  }

  int expiredCylinderCount({DateTime? referenceDate}) {
    int count = 0;
    for (final cyl in cylinders) {
      if (cyl.evaluateValidity(referenceDate: referenceDate) ==
          ValidityStatus.expired) {
        count++;
      }
    }
    return count;
  }

  ValidityStatus evaluateFitnessStatus({DateTime? referenceDate}) =>
      evaluateDateAndFlagValidity(
        dateRaw: rcFitUpto,
        referenceDate: referenceDate,
      );

  ValidityStatus evaluateTaxStatus({DateTime? referenceDate}) =>
      evaluateDateAndFlagValidity(
        dateRaw: rcTaxUpto,
        referenceDate: referenceDate,
      );

  ValidityStatus evaluateRcStatus() {
    final st = (rcStatus ?? '').trim().toUpperCase();
    if (st.isEmpty) return ValidityStatus.pendingOrUnavailable;
    if (st.contains('SUSPEND') ||
        st.contains('CANCEL') ||
        st.contains('EXPIRED') ||
        st.contains('INACTIVE') ||
        st.contains('BLACKLIST')) {
      return ValidityStatus.expired;
    }
    if (st.contains('ACTIVE') || st.contains('VALID')) {
      return ValidityStatus.valid;
    }
    return ValidityStatus.pendingOrUnavailable;
  }

  ValidityStatus evaluateCngEndorsementStatus() {
    final explicit = (cngEndorsementStatus ?? '').trim();
    if (explicit.isNotEmpty) {
      return evaluateDateAndFlagValidity(explicitStatus: explicit);
    }
    if (fuelCategory == VehicleFuelCategory.cng) {
      return ValidityStatus.valid;
    }
    return ValidityStatus.pendingOrUnavailable;
  }

  String get cngEndorsementDisplayText {
    if (cngEndorsementStatus != null && cngEndorsementStatus!.isNotEmpty) {
      return cngEndorsementStatus!;
    }
    if (fuelCategory == VehicleFuelCategory.cng) {
      return 'Endorsed on RC (${rcFuelDesc?.trim() ?? 'CNG'})';
    }
    return 'Not Available';
  }

  ValidityStatus evaluatePesoStatus({DateTime? referenceDate}) {
    if (pesoStatus == null &&
        pesoValidUpto == null &&
        pesoCertificateNumber == null) {
      return ValidityStatus.pendingOrUnavailable;
    }
    return evaluateDateAndFlagValidity(
      dateRaw: pesoValidUpto,
      explicitStatus: pesoStatus,
      referenceDate: referenceDate,
    );
  }

  /// Evaluates overall CNG compliance strictly from API values & dates.
  ///
  /// Never assumes a CNG vehicle is compliant solely from `rcFuelDesc == "CNG"`.
  ({OverallComplianceLevel level, String headline, String summary, List<String> reasons})
      evaluateCngCompliance({DateTime? referenceDate}) {
    final reasons = <String>[];
    bool hasFailure = false;
    bool hasPendingOrExpiring = false;

    // 1. Explicit compliance flag from API (highest priority).
    if (isExplicitCompliant == false) {
      hasFailure = true;
      reasons.add(
        explicitComplianceMessage ??
            'Backend compliance flag marks this vehicle as NOT COMPLIANT.',
      );
    }
    if (explicitComplianceStatus != null) {
      final s = explicitComplianceStatus!.trim().toUpperCase();
      if (s.contains('NOT COMPLIANT') ||
          s.contains('NON-COMPLIANT') ||
          s.contains('NON COMPLIANT') ||
          s.contains('INVALID') ||
          s.contains('EXPIRED') ||
          s.contains('FAIL')) {
        hasFailure = true;
        reasons.add('API Compliance Status: $explicitComplianceStatus');
      } else if (s.contains('PENDING') || s.contains('EXPIRING')) {
        hasPendingOrExpiring = true;
        reasons.add('API Compliance Status: $explicitComplianceStatus');
      }
    }

    // 2. RC status & Blacklist
    final rcState = evaluateRcStatus();
    if (rcState == ValidityStatus.expired) {
      hasFailure = true;
      reasons.add('RC Status is ${rcStatus ?? 'Inactive/Invalid'}.');
    }
    final bl = (rcBlacklistStatus ?? '').trim().toUpperCase();
    if (bl.isNotEmpty && bl != 'NO' && bl != 'NONE' && bl != 'CLEAR') {
      hasFailure = true;
      reasons.add('Blacklist status flagged: $rcBlacklistStatus');
    }

    // 3. CNG endorsement on RC
    final endorseState = evaluateCngEndorsementStatus();
    if (endorseState == ValidityStatus.expired) {
      hasFailure = true;
      reasons.add('CNG endorsement on RC is invalid or expired.');
    } else if (endorseState == ValidityStatus.pendingOrUnavailable) {
      hasPendingOrExpiring = true;
      reasons.add('CNG RC endorsement could not be verified.');
    }

    // 4. PUC certificate
    final pucState = evaluatePucStatus(referenceDate: referenceDate);
    if (pucState == ValidityStatus.expired) {
      hasFailure = true;
      reasons.add('PUC certificate expired (${rcPuccUpto ?? 'N/A'}).');
    } else if (pucState == ValidityStatus.expiringSoon) {
      hasPendingOrExpiring = true;
      reasons.add('PUC certificate expires soon ($rcPuccUpto).');
    } else if (pucState == ValidityStatus.pendingOrUnavailable) {
      hasPendingOrExpiring = true;
      reasons.add('PUC validity date not available.');
    }

    // 5. Insurance
    final insState = evaluateInsuranceStatus(referenceDate: referenceDate);
    if (insState == ValidityStatus.expired) {
      hasFailure = true;
      reasons.add('Insurance expired (${rcInsuranceUpto ?? 'N/A'}).');
    } else if (insState == ValidityStatus.expiringSoon) {
      hasPendingOrExpiring = true;
      reasons.add('Insurance expires soon ($rcInsuranceUpto).');
    } else if (insState == ValidityStatus.pendingOrUnavailable) {
      hasPendingOrExpiring = true;
      reasons.add('Insurance validity date not available.');
    }

    // 6. Fitness (only fail if present and expired)
    final fitState = evaluateFitnessStatus(referenceDate: referenceDate);
    if (fitState == ValidityStatus.expired) {
      hasFailure = true;
      reasons.add('Fitness certificate expired ($rcFitUpto).');
    } else if (fitState == ValidityStatus.expiringSoon) {
      hasPendingOrExpiring = true;
      reasons.add('Fitness certificate expires soon ($rcFitUpto).');
    }

    // 7. PESO certificate & Cylinders
    final pesoState = evaluatePesoStatus(referenceDate: referenceDate);
    if (pesoState == ValidityStatus.expired) {
      hasFailure = true;
      reasons.add(
        'PESO certificate is expired or invalid (${pesoValidUpto ?? pesoStatus}).',
      );
    } else if (pesoState == ValidityStatus.expiringSoon) {
      hasPendingOrExpiring = true;
      reasons.add('PESO certificate is expiring soon ($pesoValidUpto).');
    }

    if (cylinders.isEmpty) {
      if (isExplicitCompliant != true && pesoState != ValidityStatus.valid) {
        hasPendingOrExpiring = true;
        reasons.add(
          'Cylinder hydro-testing / PESO certificate records were not returned by the API.',
        );
      }
    } else {
      for (int i = 0; i < cylinders.length; i++) {
        final cyl = cylinders[i];
        final cylState = cyl.evaluateValidity(referenceDate: referenceDate);
        final cylLabel = cyl.cylinderNumber ?? '#${i + 1}';
        if (cylState == ValidityStatus.expired) {
          hasFailure = true;
          reasons.add(
            'Cylinder $cylLabel test/certificate is expired or invalid.',
          );
        } else if (cylState == ValidityStatus.expiringSoon) {
          hasPendingOrExpiring = true;
          reasons.add(
            'Cylinder $cylLabel certificate is expiring soon.',
          );
        } else if (cylState == ValidityStatus.pendingOrUnavailable) {
          hasPendingOrExpiring = true;
          reasons.add(
            'Cylinder $cylLabel validity/retest date is not available.',
          );
        }
      }
    }

    if (hasFailure) {
      return (
        level: OverallComplianceLevel.nonCompliant,
        headline: 'NOT COMPLIANT',
        summary: reasons.first,
        reasons: reasons,
      );
    }

    if (hasPendingOrExpiring) {
      return (
        level: OverallComplianceLevel.expiringOrPending,
        headline: 'VERIFICATION PENDING / ATTENTION',
        summary: reasons.first,
        reasons: reasons,
      );
    }

    return (
      level: OverallComplianceLevel.compliant,
      headline: 'CNG COMPLIANT',
      summary: explicitComplianceMessage ??
          'RC endorsement, PUCC, insurance, PESO, and cylinder checks are valid.',
      reasons: reasons,
    );
  }

  static String? _str(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      if (map.containsKey(key) && map[key] != null) {
        final s = map[key].toString().trim();
        if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
      }
      final lower = key.toLowerCase();
      for (final entry in map.entries) {
        if (entry.key.toLowerCase() == lower && entry.value != null) {
          final s = entry.value.toString().trim();
          if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
        }
      }
    }
    return null;
  }

  static bool? _boolOrNull(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final v = map[key];
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final s = v.trim().toLowerCase();
        if (s == 'true' || s == '1' || s == 'yes') return true;
        if (s == 'false' || s == '0' || s == 'no') return false;
      }
    }
    return null;
  }

  static List<CylinderDetailsModel> _parseCylinders(
    Map<String, dynamic> root,
    Map<String, dynamic> data,
  ) {
    final result = <CylinderDetailsModel>[];
    const listKeys = [
      'cylinders',
      'cylinderDetails',
      'cylinder_details',
      'cngCylinders',
      'cng_cylinders',
      'pesoCylinders',
      'peso_cylinders',
      'pesoDetails',
      'peso_details',
    ];

    void extractFromSource(Map<String, dynamic> source) {
      for (final key in listKeys) {
        final val = source[key];
        if (val is List) {
          for (final item in val) {
            if (item is Map<String, dynamic>) {
              final cyl = CylinderDetailsModel.fromJson(item);
              if (cyl.hasAnyData) result.add(cyl);
            } else if (item is Map) {
              final cyl = CylinderDetailsModel.fromJson(
                Map<String, dynamic>.from(item),
              );
              if (cyl.hasAnyData) result.add(cyl);
            }
          }
        } else if (val is Map) {
          final cyl = CylinderDetailsModel.fromJson(
            Map<String, dynamic>.from(val),
          );
          if (cyl.hasAnyData) result.add(cyl);
        }
      }
    }

    extractFromSource(data);
    if (result.isEmpty) {
      extractFromSource(root);
    }
    if (result.isEmpty) {
      // Check if cylinder fields are flat inside `data` (never treat top-level
      // API `status` boolean on `root` as a cylinder status).
      final flatDataCyl = CylinderDetailsModel.fromJson(data);
      if (flatDataCyl.hasAnyData) {
        result.add(flatDataCyl);
      }
    }
    return result;
  }

  factory VehicleDetailsModel.fromJson(
    Map<String, dynamic> json, {
    required String queriedVehicleNumber,
  }) {
    final dynamic rawData = json['data'];
    final Map<String, dynamic> data = rawData is Map<String, dynamic>
        ? rawData
        : (rawData is Map
            ? Map<String, dynamic>.from(rawData)
            : <String, dynamic>{});

    // Nested CNG / PESO object if provided inside `data`.
    final Map<String, dynamic> cngNested = data['cngDetails'] is Map
        ? Map<String, dynamic>.from(data['cngDetails'] as Map)
        : (data['cng_details'] is Map
            ? Map<String, dynamic>.from(data['cng_details'] as Map)
            : <String, dynamic>{});

    final merged = <String, dynamic>{
      ...json,
      ...cngNested,
      ...data,
    };

    final bool apiStatus = json['status'] == true ||
        json['status']?.toString().toLowerCase() == 'true' ||
        json['status'] == 200;

    return VehicleDetailsModel(
      status: apiStatus,
      source: _str(json, ['source']),
      queriedVehicleNumber:
          _str(json, ['vehicle_number', 'vehicleNumber']) ?? queriedVehicleNumber,
      statusMessage: _str(merged, [
        'statusMessage',
        'status_message',
        'message',
      ]),
      rcRegnNo: _str(merged, ['rcRegnNo', 'rc_regn_no', 'regnNo']),
      rcOwnerName: _str(merged, [
        'rcOwnerName',
        'rc_owner_name',
        'ownerName',
        'owner_name',
        'rcRegisteredOwner',
      ]),
      rcOwnerFatherName: _str(merged, [
        'rcOwnerFName',
        'rcFatherName',
        'fatherName',
        'rc_f_name',
      ]),
      rcFuelDesc: _str(merged, ['rcFuelDesc', 'rc_fuel_desc', 'fuelType', 'fuel_desc']),
      rcVhClassDesc: _str(merged, ['rcVhClassDesc', 'vehicleClass', 'vhClass']),
      rcVhType: _str(merged, ['rcVhType', 'vehicleType', 'vhType']),
      rcRegnDt: _str(merged, ['rcRegnDt', 'registrationDate', 'regnDate']),
      rcRegnUpto: _str(merged, ['rcRegnUpto', 'rcValidUpto', 'regnUpto']),
      rcPurchaseDt: _str(merged, ['rcPurchaseDt', 'purchaseDate']),
      rcManuMonthYr: _str(merged, ['rcManuMonthYr', 'manuMonthYr']),
      vehicleAge: _str(merged, ['vehicleAge', 'vehicle_age', 'rcVehicleAge']),
      rcMakerDesc: _str(merged, ['rcMakerDesc', 'maker', 'manufacturer']),
      rcMakerModel: _str(merged, ['rcMakerModel', 'makerModel', 'model']),
      rcBodyTypeDesc: _str(merged, ['rcBodyTypeDesc', 'bodyType']),
      rcColor: _str(merged, ['rcColor', 'color']),
      rcChasiNo: _str(merged, ['rcChasiNo', 'rcChassisNo', 'chassisNo', 'chassisNumber']),
      rcEngNo: _str(merged, ['rcEngNo', 'rcEngineNo', 'engineNo', 'engineNumber']),
      rcStatus: _str(merged, ['rcStatus', 'rc_status']),
      rcStatusAsOn: _str(merged, ['rcStatusAsOn']),
      rcBlacklistStatus: _str(merged, ['rcBlacklistStatus', 'blacklistStatus']),
      rcNocDetails: _str(merged, ['rcNocDetails', 'nocDetails']),
      rcRegisteredAt: _str(merged, ['rcRegisteredAt', 'rto', 'registeredAt']),
      rcPresentAddress: _str(merged, ['rcPresentAddress', 'presentAddress']),
      rcPermanentAddress: _str(merged, ['rcPermanentAddress', 'permanentAddress']),
      rcFinancer: _str(merged, ['rcFinancer', 'financer']),
      rcInsuranceComp: _str(merged, ['rcInsuranceComp', 'insuranceCompany']),
      rcInsurancePolicyNo: _str(merged, ['rcInsurancePolicyNo', 'insurancePolicyNo']),
      rcInsuranceUpto: _str(merged, ['rcInsuranceUpto', 'insuranceUpto', 'insuranceValidUpto']),
      rcPuccNo: _str(merged, ['rcPuccNo', 'pucNo', 'puccNo']),
      rcPuccUpto: _str(merged, ['rcPuccUpto', 'pucUpto', 'puccUpto', 'pucValidUpto']),
      rcTaxUpto: _str(merged, ['rcTaxUpto', 'taxUpto']),
      rcFitUpto: _str(merged, ['rcFitUpto', 'fitUpto', 'fitnessUpto']),
      rcUnldWt: _str(merged, ['rcUnldWt', 'unladenWeight']),
      rcGvw: _str(merged, ['rcGvw', 'grossVehicleWeight']),
      rcSeatCap: _str(merged, ['rcSeatCap', 'seatingCapacity']),
      rcNoCyl: _str(merged, ['rcNoCyl', 'noOfCylinders']),
      rcWheelbase: _str(merged, ['rcWheelbase', 'wheelbase']),
      rcCubicCap: _str(merged, ['rcCubicCap', 'cubicCapacity']),
      rcNormsDesc: _str(merged, ['rcNormsDesc', 'emissionNorms']),
      rcSaleAmt: _str(merged, ['rcSaleAmt', 'saleAmount']),
      cngEndorsementStatus: _str(merged, [
        'cngEndorsementStatus',
        'cng_endorsement_status',
        'rcCngEndorsement',
        'cngOnRc',
        'cngEndorsement',
      ]),
      pesoCertificateNumber: _str(merged, [
        'pesoCertificateNumber',
        'peso_certificate_number',
        'pesoCertificateNo',
        'pesoCertNo',
        'pesoNumber',
        'pesoNo',
      ]),
      pesoStatus: _str(merged, [
        'pesoStatus',
        'peso_status',
        'pesoCertificateStatus',
      ]),
      pesoValidUpto: _str(merged, [
        'pesoValidUpto',
        'peso_valid_upto',
        'pesoValidity',
        'pesoExpiryDate',
      ]),
      explicitComplianceStatus: _str(merged, [
        'complianceStatus',
        'compliance_status',
        'cngComplianceStatus',
        'overallComplianceStatus',
        'overallStatus',
      ]),
      explicitComplianceMessage: _str(merged, [
        'complianceMessage',
        'compliance_message',
        'cngComplianceMessage',
      ]),
      isExplicitCompliant: _boolOrNull(merged, [
        'isCompliant',
        'is_compliant',
        'compliant',
      ]),
      cylinders: _parseCylinders(json, data),
      allDataFields: Map<String, dynamic>.unmodifiable(data),
      rawResponse: Map<String, dynamic>.unmodifiable(json),
    );
  }
}
