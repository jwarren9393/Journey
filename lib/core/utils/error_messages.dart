import 'dart:io';

import 'package:journey/core/ai/ai_service.dart';

/// Converts exceptions into short, user-facing messages.
String userFacingErrorMessage(Object error) {
  if (error is AiServiceException) {
    return _friendlyAiMessage(error.message);
  }

  if (error is SocketException) {
    return 'You appear to be offline. Check your connection and try again.';
  }

  if (error is IOException) {
    return 'A local storage error occurred. Try restarting the app.';
  }

  final message = error.toString();

  if (_looksLikeNetworkError(message)) {
    return 'Could not reach the server. Check your internet connection and try again.';
  }

  if (message.contains('401') || message.contains('403')) {
    return 'Authentication failed. Check your API key in Settings.';
  }

  if (message.contains('429')) {
    return 'Rate limit reached. Wait a moment and try again.';
  }

  return message
      .replaceFirst('Exception: ', '')
      .replaceFirst('AiServiceException: ', '');
}

bool _looksLikeNetworkError(String message) {
  final lower = message.toLowerCase();
  return lower.contains('clientexception') ||
      lower.contains('failed host lookup') ||
      lower.contains('connection refused') ||
      lower.contains('connection reset') ||
      lower.contains('network is unreachable') ||
      lower.contains('timed out') ||
      lower.contains('timeout');
}

String _friendlyAiMessage(String message) {
  final lower = message.toLowerCase();

  if (_looksLikeNetworkError(lower)) {
    return 'AI request failed — you may be offline. Check your connection and try again.';
  }

  if (lower.contains('invalid') && lower.contains('api key')) {
    return 'Invalid API key. Check your key in Settings.';
  }

  if (lower.contains('401') || lower.contains('403')) {
    return 'AI authentication failed. Verify your API key and model in Settings.';
  }

  if (lower.contains('429') || lower.contains('quota') || lower.contains('rate')) {
    return 'AI rate limit reached. Wait a moment or try a different model.';
  }

  return message;
}
