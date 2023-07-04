library wdtk;

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:wdtk/config.dart';

/// A backend utility class for making requests into a server etc.
class Backend {
  static final Backend _instance = Backend._internal();

  final Config _cfg = Config();
  final Logger _logger = Logger("wdtk.Backend");
  Future? _cfgReady;
  late http.BaseClient _client;

  factory Backend() {
    return _instance;
  }

  Backend._internal() {
    _cfgReady = _cfg.read();
    _client = http.Client() as http.BaseClient;
  }

  void setHttpClient(http.BaseClient client) {
    _logger.warning("Overriding default HTTP client");
    _client = client;
  }

  // Make a GET request
  Future<String> get(String service, String endpoint) async {
    if (!await _cfgReady) {
      return "";
    }

    final url = Uri.parse('http://${_cfg.gateway()}/$service/$endpoint/');
    _logger.info('[GET] ${url.toString()}');

    final response = await _client.get(url);
    return response.body;
  }
}
