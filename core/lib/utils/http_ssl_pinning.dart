import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await Shared.createLEClient();
  static http.Client? _clientInstance;

  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}

class Shared {
  static Future<http.Client> createLEClient() async {
    SecurityContext context = SecurityContext(withTrustedRoots: false);
    try {
      List<int> bytes = [];
      bytes = (await rootBundle.load('certificates/themoviedb.pem'))
          .buffer
          .asUint8List();
      context.setTrustedCertificatesBytes(bytes);
    } catch (e) {
      // Handle or log error
    }
    HttpClient httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(httpClient);
  }
}
