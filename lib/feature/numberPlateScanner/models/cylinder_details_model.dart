/// Certificate and hydro-test validity states derived from API dates/flags.
enum ValidityStatus {
  valid,
  expiringSoon,
  expired,
  pendingOrUnavailable,
}

extension ValidityStatusX on ValidityStatus {
  String get label {
    switch (this) {
      case ValidityStatus.valid:
        return 'Valid';
      case ValidityStatus.expiringSoon:
        return 'Expiring Soon';
      case ValidityStatus.expired:
        return 'Expired';
      case ValidityStatus.pendingOrUnavailable:
        return 'Not Available';
    }
  }
}

/// Parses common Indian VAHAN / ISO date formats cleanly without throwing.
DateTime? parseFlexibleDate(String? raw) {
  if (raw == null) return null;
  final s = raw.trim();
  if (s.isEmpty || s.toLowerCase() == 'null' || s.toLowerCase() == 'na') {
    return null;
  }

  // ISO-8601 (e.g. 2027-05-02 or 2027-05-02T00:00:00Z)
  final iso = DateTime.tryParse(s);
  if (iso != null) return DateTime(iso.year, iso.month, iso.day);

  const months = <String, int>{
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'sept': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12,
  };

  // dd-MMM-yyyy or dd/MMM/yyyy or dd MMM yyyy (e.g. 02-May-2027)
  final textMonthMatch = RegExp(
    r'^(\d{1,2})[-/\s]([A-Za-z]{3,4})[-/\s](\d{4})$',
  ).firstMatch(s);
  if (textMonthMatch != null) {
    final day = int.tryParse(textMonthMatch.group(1)!);
    final mKey = textMonthMatch.group(2)!.toLowerCase();
    final month = months[mKey];
    final year = int.tryParse(textMonthMatch.group(3)!);
    if (day != null && month != null && year != null) {
      return DateTime(year, month, day);
    }
  }

  // dd-MM-yyyy or dd/MM/yyyy
  final dmyMatch = RegExp(r'^(\d{1,2})[-/](\d{1,2})[-/](\d{4})$').firstMatch(s);
  if (dmyMatch != null) {
    final day = int.tryParse(dmyMatch.group(1)!);
    final month = int.tryParse(dmyMatch.group(2)!);
    final year = int.tryParse(dmyMatch.group(3)!);
    if (day != null &&
        month != null &&
        year != null &&
        month >= 1 &&
        month <= 12 &&
        day >= 1 &&
        day <= 31) {
      return DateTime(year, month, day);
    }
  }

  return null;
}

/// Evaluates whether a date/status string represents Valid, Expiring Soon,
/// Expired, or Not Available relative to [referenceDate].
ValidityStatus evaluateDateAndFlagValidity({
  String? dateRaw,
  String? explicitStatus,
  DateTime? referenceDate,
  int expiringSoonDays = 30,
}) {
  final statusNorm = (explicitStatus ?? '').trim().toUpperCase();
  if (statusNorm.isNotEmpty) {
    if (statusNorm.contains('EXPIRED') ||
        statusNorm.contains('INVALID') ||
        statusNorm.contains('FAIL') ||
        statusNorm.contains('REJECT') ||
        statusNorm.contains('NOT VALID') ||
        statusNorm == 'NO' ||
        statusNorm == 'FALSE') {
      return ValidityStatus.expired;
    }
    if (statusNorm.contains('EXPIRING')) {
      return ValidityStatus.expiringSoon;
    }
    if (statusNorm.contains('PENDING') || statusNorm.contains('VERIFY')) {
      return ValidityStatus.pendingOrUnavailable;
    }
  }

  final parsedDate = parseFlexibleDate(dateRaw);
  if (parsedDate != null) {
    final now = referenceDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diffDays = parsedDate.difference(today).inDays;
    if (diffDays < 0) return ValidityStatus.expired;
    if (expiringSoonDays >= 0 && diffDays <= expiringSoonDays) {
      return ValidityStatus.expiringSoon;
    }
    return ValidityStatus.valid;
  }

  if (statusNorm.isNotEmpty &&
      (statusNorm == 'PASS' ||
          statusNorm.contains('PASSED') ||
          statusNorm.contains('VALID') ||
          statusNorm.contains('ACTIVE') ||
          statusNorm.contains('COMPLIANT') ||
          statusNorm == 'OK' ||
          statusNorm == 'YES' ||
          statusNorm == 'TRUE')) {
    return ValidityStatus.valid;
  }

  return ValidityStatus.pendingOrUnavailable;
}

/// Represents a single PESO / CNG cylinder compliance record.
class CylinderDetailsModel {
  const CylinderDetailsModel({
    this.cylinderNumber,
    this.certificateNumber,
    this.testDate,
    this.lastTestingDate,
    this.nextTestDueDate,
    this.waterCapacity,
    this.certificateValidity,
    this.status,
    this.manufacturer,
    this.pesoApprovalNo,
    this.manufacturingDate,
    this.testingCompanyName,
    this.cylinderAgeValidTill,
    this.numberOfCylinders,
    this.vehicleRegistrationNumber,
    this.errorMsg,
    this.rawFields = const <String, dynamic>{},
  });

  final String? cylinderNumber;
  final String? certificateNumber;
  final String? testDate;
  final String? lastTestingDate;
  final String? nextTestDueDate;
  final String? waterCapacity;
  final String? certificateValidity;
  final String? status;
  final String? manufacturer;
  final String? pesoApprovalNo;
  final String? manufacturingDate;
  final String? testingCompanyName;
  final String? cylinderAgeValidTill;
  final String? numberOfCylinders;
  final String? vehicleRegistrationNumber;
  final String? errorMsg;
  final Map<String, dynamic> rawFields;

  static String? _pickString(Map<String, dynamic> json, List<String> keys) {
    for (final k in keys) {
      if (json.containsKey(k)) {
        final v = json[k];
        if (v != null) {
          final s = v.toString().trim();
          if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
        }
      }
      // Case-insensitive lookup fallback
      final lowerK = k.toLowerCase();
      for (final entry in json.entries) {
        if (entry.key.toLowerCase() == lowerK && entry.value != null) {
          final s = entry.value.toString().trim();
          if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
        }
      }
    }
    return null;
  }

  factory CylinderDetailsModel.fromJson(Map<String, dynamic> json) {
    final capRaw = _pickString(json, [
      'waterCapacity',
      'water_capacity',
      'Cylinder capacity in water litre',
      'capacity',
      'cylinderCapacity',
      'waterCap',
    ]);
    final String? formattedCap = capRaw == null
        ? null
        : (RegExp(r'^\d+(\.\d+)?$').hasMatch(capRaw) ? '$capRaw L' : capRaw);

    final mfgDate = _pickString(json, [
      'Cylinder Manufacturing Date',
      'manufacturingDate',
      'manufacturing_date',
      'mfgDate',
    ]);
    final hydroDate = _pickString(json, [
      'Hydro Test Date',
      'testDate',
      'test_date',
      'cylinderTestDate',
      'cylinder_test_date',
      'hydroTestDate',
      'installDate',
    ]);
    final hydroDue = _pickString(json, [
      'Hydro Test Due Date',
      'nextTestDueDate',
      'next_test_due_date',
      'nextDueDate',
      'next_due_date',
      'retestDueDate',
      'dueDate',
    ]);
    final ageTill = _pickString(json, [
      'Cylinder Age valid till Date',
      'cylinderAgeValidTill',
    ]);
    final rawValidity = _pickString(json, [
      'certificateValidity',
      'certificate_validity',
      'validUpto',
      'valid_upto',
      'validity',
      'expiryDate',
      'expiry_date',
      'pesoValidUpto',
    ]);
    final effectiveValidity = rawValidity ??
        ((ageTill != null && !ageTill.toLowerCase().contains('not available'))
            ? ageTill
            : hydroDue);

    return CylinderDetailsModel(
      cylinderNumber: _pickString(json, [
        'Cylinder ID/ Serial Number',
        'cylinderNumber',
        'cylinder_number',
        'cylinderNo',
        'cylinder_no',
        'cylNo',
        'serialNumber',
        'serial_no',
        'rcCylinderNo',
      ]),
      certificateNumber: _pickString(json, [
        'Certificate No',
        'certificateNumber',
        'certificate_number',
        'certificateNo',
        'certificate_no',
        'pesoCertificateNumber',
        'pesoCertificateNo',
        'peso_certificate_no',
        'pesoCertNo',
        'certNo',
      ]),
      testDate: hydroDate,
      lastTestingDate: _pickString(json, [
        'lastTestingDate',
        'last_testing_date',
        'lastTestDate',
        'last_test_date',
        'testedOn',
      ]) ??
          mfgDate,
      nextTestDueDate: hydroDue,
      waterCapacity: formattedCap,
      certificateValidity: effectiveValidity,
      status: _pickString(json, [
        'Test Result',
        'testResult',
        'status',
        'certificateStatus',
        'certificate_status',
        'validityStatus',
        'cylinderStatus',
        'complianceStatus',
      ]),
      manufacturer: _pickString(json, [
        'Cylinder Make',
        'manufacturer',
        'maker',
        'make',
        'kitMake',
      ]),
      pesoApprovalNo: _pickString(json, [
        'pesoApprovalNo',
        'peso_approval_no',
        'pesoNumber',
        'peso_number',
        'pesoNo',
      ]),
      manufacturingDate: mfgDate,
      testingCompanyName: _pickString(json, [
        'Testing Company Name',
        'testingCompanyName',
        'testingCompany',
        'testingAgency',
      ]),
      cylinderAgeValidTill: ageTill,
      numberOfCylinders: _pickString(json, [
        'Number of cylinders',
        'numberOfCylinders',
      ]),
      vehicleRegistrationNumber: _pickString(json, [
        'Vehicle Registration Number',
        'vehicleRegistrationNumber',
      ]),
      errorMsg: _pickString(json, ['ErrorMsg', 'errorMsg']),
      rawFields: Map<String, dynamic>.unmodifiable(json),
    );
  }

  /// True if at least one cylinder/PESO certificate attribute was returned.
  bool get hasAnyData =>
      cylinderNumber != null ||
      certificateNumber != null ||
      testDate != null ||
      lastTestingDate != null ||
      nextTestDueDate != null ||
      waterCapacity != null ||
      certificateValidity != null ||
      pesoApprovalNo != null;

  /// Evaluates individual cylinder validity based on explicit status,
  /// [certificateValidity], and [nextTestDueDate].
  ValidityStatus evaluateValidity({DateTime? referenceDate}) {
    final nextDueStatus = evaluateDateAndFlagValidity(
      dateRaw: nextTestDueDate,
      explicitStatus: status,
      referenceDate: referenceDate,
    );
    final certStatus = evaluateDateAndFlagValidity(
      dateRaw: certificateValidity,
      explicitStatus: status,
      referenceDate: referenceDate,
    );

    if (nextDueStatus == ValidityStatus.expired ||
        certStatus == ValidityStatus.expired) {
      return ValidityStatus.expired;
    }
    if (nextDueStatus == ValidityStatus.expiringSoon ||
        certStatus == ValidityStatus.expiringSoon) {
      return ValidityStatus.expiringSoon;
    }
    if (nextDueStatus == ValidityStatus.valid ||
        certStatus == ValidityStatus.valid) {
      return ValidityStatus.valid;
    }
    return ValidityStatus.pendingOrUnavailable;
  }
}
