import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:wdtk/wdtk.dart';

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

  setUp(() {
    final Backend backend = Backend();

    var client = MockClient((request) async {
      if (request.method == "GET") {
        return http.Response("test", 200);
      }

      return http.Response("", 404);
    });

    backend.setHttpClient(client);
  });

  test('get', () async {
    final Backend backend = Backend();

    final result = await backend.get("Authentication", "Login");
    expect(result, "test");
  });
}
