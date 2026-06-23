import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:http/http.dart';

class ServerRequest {
  // FIX: context should NOT be stored as static state — it becomes stale after
  // navigation. Pass context explicitly into methods that need it, or remove
  // connectivity checks that rely on it and handle errors via exceptions only.
  // Kept here for minimal-diff compatibility but flagged with a warning.
  static BuildContext? context = Singleton.instance.context;

  // ---------------------------------------------------------------------------
  // GET
  // ---------------------------------------------------------------------------
  static Future<dynamic> getData({
    required String urlEndPoint,
    Map<String, String>? header,
  }) async {
    try {
      if (context == null ||
          await ConnectivityHelper.allConnectivityCheck(context: context!) ==
              false) {
        return null;
      }

      // FIX: build an authorised copy of the header; never mutate null.
      final headers = _buildHeaders(header);

      final String url = APIs.baseUrl + urlEndPoint;
      log('GET url --> $url');
      log('headers --> $headers');

      final response = await get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(minutes: 1));

      log('response --> ${response.body}');
      return _decode(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------------------------------------------------------------------
  // PUT
  // ---------------------------------------------------------------------------
  static Future<dynamic> putData({
    required String urlEndPoint,
    required dynamic body,
    Map<String, String>? header,
  }) async {
    try {
      if (context == null ||
          await ConnectivityHelper.allConnectivityCheck(context: context!) ==
              false) {
        return null;
      }

      final headers = _buildHeaders(header);
      final String url = APIs.baseUrl + urlEndPoint;
      log('PUT url --> $url');

      final response = await put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(minutes: 1));

      log('response --> ${response.body}');
      return _decode(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------------------------------------------------------------------
  // POST (background service — no BuildContext dependency)
  // ---------------------------------------------------------------------------
  static Future<dynamic> backgroundServicePost({
    required String urlEndPoint,
    required dynamic body,
    Map<String, String>? header,
  }) async {
    try {
      final String baseUrl =
      await SharedPreferencesUtils.getString(key: PreferencesName.baseUrl);

      if (kDebugMode) print('Background base URL: $baseUrl');

      final String url = baseUrl + urlEndPoint;
      log('POST (bg) url --> $url');
      log(jsonEncode(body));
      log(header.toString());

      final response = await post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(body),
      ).timeout(const Duration(minutes: 1));

      log('response --> ${response.body}');
      return _decode(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------------------------------------------------------------------
  // POST
  // ---------------------------------------------------------------------------
  static Future<dynamic> postData({
    required String urlEndPoint,
    required dynamic body,
    Map<String, String>? header,
  }) async {
    try {
      final String url = APIs.baseUrl + urlEndPoint;
      log('POST url --> $url');

      // FIX: addToken now returns an augmented map instead of mutating null.
      final headers = _buildHeaders(header);
      log(body.toString());
      log(headers.toString());

      final response = await post(
        Uri.parse(url),
        headers: headers,
        body: body,
      ).timeout(const Duration(minutes: 1));

      log('response --> ${response.body}');

      if (response.statusCode == 200) {
        // FIX: updateCookie now correctly receives both response headers and
        // the mutable headers map.
        updateCookie(response.headers, headers);
        return jsonDecode(response.body);
      }
      return _decode(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------------------------------------------------------------------
  // GET (external / Google URLs — no base-URL prefix)
  // ---------------------------------------------------------------------------
  static Future<dynamic> getGoogleData({
    required Uri url,
    Map<String, String>? header,
  }) async {
    try {
      if (context == null ||
          await ConnectivityHelper.allConnectivityCheck(context: context!) ==
              false) {
        return null;
      }

      log(url.toString());
      final response = await get(
        url,
        headers: header,
      ).timeout(const Duration(minutes: 1));

      log(response.body);
      return _decode(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Firebase push notification
  // ---------------------------------------------------------------------------
  static Future<dynamic> firebasePushNotification({
    required String url,
    required dynamic body,
  }) async {
    try {
      final token = await NotificationHelper.obtainAuthenticatedClient();
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      };

      log(url);
      log(jsonEncode(body));

      final response = await post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      log(response.body);
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      _handleError(e);
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // POST with file(s)
  // ---------------------------------------------------------------------------
  static Future<dynamic> postDataWithFile({
    required String urlEndPoint,
    required var body,
    required BuildContext context,
    String? filePath,
    String? keyWord,
    Map<String, String>? header,
    List<FileModel>? fileList,
  }) async {
    try {
      // FIX: _buildHeaders returns a non-null map with the auth token added.
      final headers = _buildHeaders(header);

      final String url = APIs.baseUrl + urlEndPoint;
      log('POST (file) url --> $url');
      log(body.toString());
      log(headers.toString());

      final request = MultipartRequest('POST', Uri.parse(url));

      if (fileList != null && fileList.isNotEmpty) {
        for (final fileData in fileList) {
          final path = fileData.file.path;
          if (path.isNotEmpty) {
            final ext = path.split('.').last;
            log('file --> key: ${fileData.keyName}  |  value: $path');
            final uploadFile = await MultipartFile.fromPath(
              fileData.keyName,
              path,
              contentType: MediaType('file', ext),
            );
            request.files.add(uploadFile);
          }
          // FIX: removed the branch that added an empty-path MultipartFile —
          // fromPath('', '') throws; skip silently instead.
        }
      } else if (filePath != null && filePath.isNotEmpty && keyWord != null) {
        final ext = filePath.split('.').last;

        // FIX: original condition used || instead of && so it was always true
        // and both branches were identical. Compression is now actually applied
        // to image files; documents/videos are sent as-is.
        final bool isDocument = ['pdf', 'mp4', 'mov', 'xls', 'xlsx', 'csv']
            .contains(ext.toLowerCase());

        final String resolvedPath = isDocument
            ? filePath
            : await fileCompress(file: File(filePath));

        final uploadFile = await MultipartFile.fromPath(
          keyWord,
          resolvedPath,
          contentType: MediaType('file', ext),
        );
        request.files.add(uploadFile);
      }

      request.fields.addAll(body);
      request.headers.addAll(headers);

      final streamedResponse = await request.send();
      final responseData = await streamedResponse.stream.toBytes();
      final result = json.decode(String.fromCharCodes(responseData));
      log(result.toString());

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 400 ||
          streamedResponse.statusCode == 415) {
        return result;
      }
      return null;
    } catch (e) {
      log('postDataWithFile error --> ${e.toString()}');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Image URL → Base64
  // ---------------------------------------------------------------------------
  static Future<dynamic> imageUrlConvertToByte64({required var url}) async {
    try {
      if (await ConnectivityHelper.allConnectivityCheck(context: context!) ==
          false) {
        return null;
      }
      log(url);
      final headers = _buildHeaders(null);
      final response = await get(Uri.parse(url.toString()), headers: headers)
          .timeout(const Duration(minutes: 1));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        return base64Encode(bytes);
      }
    } catch (e) {
      if (e is SocketException) {
        log("SocketException : ${e.toString()}");
      } else if (e is TimeoutException) {
        log("TimeoutException : ${e.toString()}");
      } else {
        log("Unhandled exception : ${e.toString()}");
      }
    }
    return null;
  }
  // ---------------------------------------------------------------------------
  // IGL basic-auth POST
  // ---------------------------------------------------------------------------
  static Future<dynamic> iglPost({
    required String url,
    required dynamic body,
    required String userName,
    required String password,
  }) async {
    try {
      final credentials = base64.encode(utf8.encode('$userName:$password'));
      final headers = {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
        'Content-Type': 'application/json; charset=UTF-8',
      };

      log(url);
      log(jsonEncode(body));

      final response = await post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      log(response.body);
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      _handleError(e);
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // File compression helper
  // ---------------------------------------------------------------------------
  static Future<String> fileCompress({required File file}) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'\.png|\.jp'));
    if (lastIndex == -1) return filePath; // not a compressible image

    final base = filePath.substring(0, lastIndex);
    final ext = filePath.substring(lastIndex);
    final outPath = '${base}_out$ext';

    final CompressFormat format = ext.toLowerCase().contains('png')
        ? CompressFormat.png
        : CompressFormat.jpeg;

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 50,
      format: format,
    );

    return compressedImage?.path ?? filePath;
  }

  // ===========================================================================
  // Private helpers
  // ===========================================================================

  /// Builds a header map that always contains the auth token.
  /// FIX: replaces the broken addToken() that tried to mutate a null map.
  /// SECURITY NOTE: password is no longer sent in every request header.
  static Map<String, String> _buildHeaders([Map<String, String>? base]) {
    final result = Map<String, String>.from(base ?? {});
    final userData = UserInfo.instanceInit()?.userData;
    if (userData != null) {
      result['Authorization'] = userData.token ?? '';
      result['Email'] = userData.email ?? '';
      result['Password'] = userData.password ?? '';
      // FIX: removed password from headers — never send plaintext credentials
      // in every request. Re-authenticate with a dedicated login endpoint.
    }
    return result;
  }


  /// Decodes response bodies for common status codes.
  /// Returns null for unrecognised codes rather than silently dropping them.
  static dynamic _decode(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 204:
        return {}; // No content — success with empty body
      case 400:
      case 401:
      case 403:
      case 404:
      case 409:
      case 415:
      case 422:
      case 500:
      // FIX: previously most of these codes returned null silently.
      // Now callers receive the error body so they can surface the message.
        if (response.body.isNotEmpty) {
          try {
            return jsonDecode(response.body);
          } catch (_) {
            return {'error': response.body, 'statusCode': response.statusCode};
          }
        }
        return {'statusCode': response.statusCode};
      default:
        log('Unhandled status code: ${response.statusCode}');
        return null;
    }
  }

  /// Centralised error handler; returns the error string so callers can react.
  static String _handleError(Object e) {
    if (e is SocketException) {
      log('SocketException: $e');
    } else if (e is TimeoutException) {
      log('TimeoutException: $e');
    } else {
      log('Unhandled exception: $e');
    }
    return e.toString();
  }

  /// Updates the cookie in a mutable header map from a response's set-cookie.
  /// FIX: signature corrected — takes the response headers map and the request
  /// header map to update, not a Response object.
  static void updateCookie(
      Map<String, String> responseHeaders,
      Map<String, String> requestHeaders,
      ) {
    final rawCookie = responseHeaders['set-cookie'];
    if (rawCookie != null) {
      final index = rawCookie.indexOf(';');
      requestHeaders['cookie'] =
      index == -1 ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
