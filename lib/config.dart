library wdtk;

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'dart:convert';

// Config class for wdtk generated frontend config files
class Config {
  String _gatewayIp = "";

  // Read the configuration file 'FrontendConfig.json'
  Future<bool> read() async {
    var logger = Logger('wdtk.Config');

    String configString;

    // Load and decode
    try {
      configString = await rootBundle.loadString("FrontendConfig.json");
    } catch (_) {
      logger.severe("loadString threw an exception");
      return false;
    }

    final data = json.decode(configString);

    // Check if necessary keys exist
    if (!data.containsKey("gatewayIp")) {
      logger.severe("config json doesn't contain key 'gatewayIp'");
      return false;
    }

    _gatewayIp = data["gatewayIp"];

    return true;
  }

  // Get the gateway address
  String gateway() {
    return _gatewayIp;
  }
}
