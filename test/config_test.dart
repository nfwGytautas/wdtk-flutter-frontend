import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';

import 'package:wdtk/config.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler("flutter/assets", (message) async {
      print("Loading AssetManifest.json");
      final data = await File('test/FrontendConfig.json').readAsBytes();
      return Future.value(ByteData.sublistView(data));
    });
  });

  test('read', () async {
    final config = Config();

    if (!await config.read()) {
      fail("Failed to read config");
    }

    expect(config.gateway(), "127.0.0.1:8080");
  });
}
