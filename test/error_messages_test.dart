import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:journey/core/ai/ai_service.dart';
import 'package:journey/core/utils/error_messages.dart';

void main() {
  group('userFacingErrorMessage', () {
    test('maps socket exceptions to offline message', () {
      expect(
        userFacingErrorMessage(const SocketException('Failed host lookup')),
        contains('offline'),
      );
    });

    test('maps AI auth failures to settings hint', () {
      expect(
        userFacingErrorMessage(
          const AiServiceException('NanoGPT: Invalid API key'),
        ),
        contains('API key'),
      );
    });

    test('maps network-like AI errors', () {
      expect(
        userFacingErrorMessage(
          const AiServiceException('ClientException: Connection closed'),
        ),
        contains('offline'),
      );
    });
  });
}
