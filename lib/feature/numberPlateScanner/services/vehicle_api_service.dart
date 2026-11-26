import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/cylinder_details_model.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/models/vehicle_details_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:http/http.dart' as http;

enum VehicleApiErrorType {
  noInternet,
  timeout,
  vehicleNotFound,
  badRequest,
  unauthorized,
  serverError,
  emptyResponse,
  invalidJson,
  missingFuelDesc,
  unexpectedError,
}

class VehicleApiException implements Exception {
  const VehicleApiException({
    required this.type,
    required this.message,
    this.statusCode,
  });

  final VehicleApiErrorType type;
  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'VehicleApiException(type=$type, statusCode=$statusCode, message=$message)';
}

/// Parsed response wrapper for `POST /api/vehicle/peso`.
class PesoDetailsResponse {
  const PesoDetailsResponse({
    required this.status,
    required this.source,
    required this.vehicleNumber,
    required this.cylinders,
    this.rawResponse = const <String, dynamic>{},
  });

  final bool status;
  final String? source;
  final String vehicleNumber;
  final List<CylinderDetailsModel> cylinders;
  final Map<String, dynamic> rawResponse;

  factory PesoDetailsResponse.fromJson(
    Map<String, dynamic> json, {
    required String queriedVehicleNumber,
  }) {
    final dynamic rawData = json['data'];
    final cylinders = <CylinderDetailsModel>[];
    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map<String, dynamic>) {
          final cyl = CylinderDetailsModel.fromJson(item);
          if (cyl.hasAnyData) cylinders.add(cyl);
        } else if (item is Map) {
          final cyl = CylinderDetailsModel.fromJson(
            Map<String, dynamic>.from(item),
          );
          if (cyl.hasAnyData) cylinders.add(cyl);
        }
      }
    } else if (rawData is Map) {
      final cyl = CylinderDetailsModel.fromJson(
        Map<String, dynamic>.from(rawData),
      );
      if (cyl.hasAnyData) cylinders.add(cyl);
    }

    final bool apiStatus = json['status'] == true ||
        json['status']?.toString().toLowerCase() == 'true' ||
        json['status'] == 200;

    return PesoDetailsResponse(
      status: apiStatus,
      source: json['source']?.toString().trim(),
      vehicleNumber: json['vehicle_number']?.toString().trim() ??
          queriedVehicleNumber,
      cylinders: List<CylinderDetailsModel>.unmodifiable(cylinders),
      rawResponse: Map<String, dynamic>.unmodifiable(json),
    );
  }
}

/// Service for querying IGL CNG UAT Vehicle Details and PESO POST APIs.
class VehicleApiService {
  VehicleApiService({
    http.Client? client,
    String? endpointUrl,
    String? pesoEndpointUrl,
    String? apiKey,
    Duration timeout = const Duration(seconds: 15),
    int maxRetries = 1,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null,
        _endpointUrl = endpointUrl ?? defaultEndpointUrl,
        _pesoEndpointUrl = pesoEndpointUrl ?? defaultPesoEndpointUrl,
        _apiKey = apiKey ?? defaultApiKey,
        _timeout = timeout,
        _maxRetries = maxRetries;

  static const String defaultEndpointUrl =
      'https://iglcngautomation.smartgasnet.com/uatiglcng/api/vehicle/details';

  static const String defaultPesoEndpointUrl =
      'https://iglcngautomation.smartgasnet.com/uatiglcng/api/vehicle/peso';

  static const String defaultApiKey =
      '58eb6e8363662c47f36b0f9854acc3f0f27e743af7d9680e32e35fa363c99e07';

  final http.Client _client;
  final bool _ownsClient;
  final String _endpointUrl;
  final String _pesoEndpointUrl;
  final String _apiKey;
  final Duration _timeout;
  final int _maxRetries;

  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }

  static String normalizeVehicleNumber(String raw) =>
      raw.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

  /// Calls `POST /api/vehicle/details` with `{"vehicle_number": "<REG_NO>"}`.
  Future<VehicleDetailsModel> fetchVehicleDetails(String rawVehicleNumber) async {
    final vehicleNumber = normalizeVehicleNumber(rawVehicleNumber);
    if (vehicleNumber.isEmpty) {
      throw const VehicleApiException(
        type: VehicleApiErrorType.badRequest,
        message: 'Scanned vehicle registration number is empty.',
        statusCode: 400,
      );
    }

    return _withRetry(() async {
      final result = await _postJsonMap(
        Uri.parse(_endpointUrl),
        <String, dynamic>{
          'vehicle_number': 'TN28AQ3165',
          // 'vehicle_number': vehicleNumber,
        },
        vehicleNumber: vehicleNumber,
      );

      final model = VehicleDetailsModel.fromJson(
        result.map,
        queriedVehicleNumber: vehicleNumber,
      );

      if (model.isVehicleNotFoundMessage ||
          (!model.status && model.allDataFields.isEmpty)) {
        throw VehicleApiException(
          type: VehicleApiErrorType.vehicleNotFound,
          statusCode: result.statusCode,
          message: model.statusMessage ??
              _extractErrorMessage(result.map) ??
              'Vehicle details not found for $vehicleNumber.',
        );
      }

      if (!model.status) {
        throw VehicleApiException(
          type: VehicleApiErrorType.serverError,
          statusCode: result.statusCode,
          message: _extractErrorMessage(result.map) ??
              'Vehicle lookup returned unsuccessful status.',
        );
      }

      if (model.allDataFields.isEmpty) {
        throw VehicleApiException(
          type: VehicleApiErrorType.emptyResponse,
          statusCode: result.statusCode,
          message: 'Vehicle details payload is empty for $vehicleNumber.',
        );
      }

      return model;
    });
  }

  /// Calls `POST /api/vehicle/peso` to retrieve PESO cylinder certificates.
  Future<PesoDetailsResponse> fetchPesoDetails(String rawVehicleNumber) async {
    final vehicleNumber = normalizeVehicleNumber(rawVehicleNumber);
    if (vehicleNumber.isEmpty) {
      throw const VehicleApiException(
        type: VehicleApiErrorType.badRequest,
        message: 'Vehicle registration number is required for PESO lookup.',
        statusCode: 400,
      );
    }

    return _withRetry(() async {
      final result = await _postJsonMap(
        Uri.parse(_pesoEndpointUrl),
        <String, dynamic>{
          'vehicle_number': 'UP16FN4897',
          // 'vehicle_number': vehicleNumber,
        },
        vehicleNumber: vehicleNumber,
      );

      final parsed = PesoDetailsResponse.fromJson(
        result.map,
        queriedVehicleNumber: vehicleNumber,
      );

      if (!parsed.status) {
        throw VehicleApiException(
          type: VehicleApiErrorType.serverError,
          statusCode: result.statusCode,
          message: _extractErrorMessage(result.map) ??
              'PESO certificate lookup returned unsuccessful status.',
        );
      }

      return parsed;
    });
  }

  Future<T> _withRetry<T>(Future<T> Function() action) async {
    int attempt = 0;
    while (true) {
      try {
        return await action();
      } on VehicleApiException catch (e) {
        final bool retryable = attempt < _maxRetries &&
            (e.type == VehicleApiErrorType.timeout ||
                e.type == VehicleApiErrorType.serverError);
        if (!retryable) rethrow;
        attempt++;
        await Future<void>.delayed(Duration(milliseconds: 350 * attempt));
      }
    }
  }

  Future<({int statusCode, Map<String, dynamic> map})> _postJsonMap(
    Uri uri,
    Map<String, dynamic> bodyMap, {
    required String vehicleNumber,
  }) async {
    final headers = _buildHeaders();
    final body = jsonEncode(bodyMap);

    debugPrint('VehicleApiService: POST $uri body=$body');

    http.Response response;
    try {
      response = await _client
          .post(uri, headers: headers, body: body)
          .timeout(_timeout);
    } on SocketException catch (e) {
      debugPrint('VehicleApiService: SocketException $e');
      throw const VehicleApiException(
        type: VehicleApiErrorType.noInternet,
        message:
            'No internet connection or unable to reach the verification server.',
      );
    } on TimeoutException catch (e) {
      debugPrint('VehicleApiService: TimeoutException $e');
      throw const VehicleApiException(
        type: VehicleApiErrorType.timeout,
        message: 'Verification request timed out. Please try again.',
      );
    } on http.ClientException catch (e) {
      debugPrint('VehicleApiService: ClientException $e');
      throw VehicleApiException(
        type: VehicleApiErrorType.noInternet,
        message: 'Network error while contacting server: ${e.message}',
      );
    } catch (e) {
      debugPrint('VehicleApiService: Unexpected error $e');
      throw VehicleApiException(
        type: VehicleApiErrorType.unexpectedError,
        message: 'Unable to fetch vehicle details ($e).',
      );
    }

    final rawBody = response.body.trim();
    if (rawBody.isEmpty) {
      throw VehicleApiException(
        type: VehicleApiErrorType.emptyResponse,
        statusCode: response.statusCode,
        message: 'Server returned an empty response (HTTP ${response.statusCode}).',
      );
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(rawBody);
    } catch (_) {
      throw VehicleApiException(
        type: VehicleApiErrorType.invalidJson,
        statusCode: response.statusCode,
        message: 'Server returned an invalid JSON response.',
      );
    }

    if (decoded is! Map) {
      throw VehicleApiException(
        type: VehicleApiErrorType.invalidJson,
        statusCode: response.statusCode,
        message: 'Unexpected response format from verification API.',
      );
    }

    final Map<String, dynamic> map = Map<String, dynamic>.from(decoded);
    final int code = response.statusCode;

    if (code == 401 || code == 403) {
      throw VehicleApiException(
        type: VehicleApiErrorType.unauthorized,
        statusCode: code,
        message: _extractErrorMessage(map) ??
            'Authentication failed (HTTP $code). Please verify API key or login session.',
      );
    }

    if (code == 404) {
      throw VehicleApiException(
        type: VehicleApiErrorType.vehicleNotFound,
        statusCode: code,
        message: _extractErrorMessage(map) ??
            'No record found for $vehicleNumber.',
      );
    }

    if (code == 400 || (code >= 400 && code < 500)) {
      throw VehicleApiException(
        type: VehicleApiErrorType.badRequest,
        statusCode: code,
        message: _extractErrorMessage(map) ??
            'Invalid request (HTTP $code) for $vehicleNumber.',
      );
    }

    if (code >= 500) {
      throw VehicleApiException(
        type: VehicleApiErrorType.serverError,
        statusCode: code,
        message: _extractErrorMessage(map) ??
            'Verification server error (HTTP $code). Please retry.',
      );
    }

    return (statusCode: code, map: map);
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': _apiKey,
    };

    try {
      final userData = UserInfo.instanceInit()?.userData;
      final token = userData?.token?.trim() ?? '';
      if (token.isNotEmpty && token.toLowerCase() != 'null') {
        headers['Authorization'] = token;
      }
      final email = userData?.email?.trim() ?? '';
      if (email.isNotEmpty && email.toLowerCase() != 'null') {
        headers['Email'] = email;
      }
      final password = userData?.password?.trim() ?? '';
      if (password.isNotEmpty && password.toLowerCase() != 'null') {
        headers['Password'] = password;
      }
    } catch (_) {
      // Allow standalone/test execution where UserInfo may not be initialized.
    }

    return headers;
  }

  String? _extractErrorMessage(Map<String, dynamic> map) {
    final messages = map['messages'];
    if (messages is Map && messages.isNotEmpty) {
      final joined = messages.values
          .where((v) => v != null && v.toString().trim().isNotEmpty)
          .map((v) => v.toString().trim())
          .join('\n');
      if (joined.isNotEmpty) return joined;
    } else if (messages is String && messages.trim().isNotEmpty) {
      return messages.trim();
    }

    final data = map['data'];
    if (data is Map && data['statusMessage'] != null) {
      final s = data['statusMessage'].toString().trim();
      if (s.isNotEmpty) return s;
    }

    for (final k in ['message', 'error', 'statusMessage']) {
      final v = map[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }
}
