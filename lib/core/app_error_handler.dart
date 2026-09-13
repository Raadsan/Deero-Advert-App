import 'package:flutter/foundation.dart';

/// Centralized security and error formatting utility.
/// Prevents exposing internal IP addresses, ports, server routes,
/// or raw socket/stack traces to users.
/// All user-facing messages are strictly in concise, clean English.
class AppErrorHandler {
  // Patterns to detect IP addresses, ports, and internal URLs
  static final RegExp _ipRegex = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b');
  static final RegExp _urlRegex = RegExp(r'https?://[^\s]+', caseSensitive: false);
  static final RegExp _portRegex = RegExp(r'port\s*=\s*\d+', caseSensitive: false);

  /// Converts any exception, socket error, or server error into a clean, safe,
  /// short English message that NEVER exposes server IPs or system internals.
  static String toFriendlyMessage(dynamic error, {String? defaultMessage}) {
    if (error == null) return "";
    final raw = error.toString().trim();
    if (raw.isEmpty) {
      return defaultMessage ?? "Something went wrong. Please try again.";
    }

    final lower = raw.toLowerCase();

    // 1. Network / Socket / Timeout / DNS failures
    if (lower.contains('socketexception') ||
        lower.contains('clientexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('connection timed out') ||
        lower.contains('connection refused') ||
        lower.contains('network is unreachable') ||
        lower.contains('handshakeexception') ||
        lower.contains('certificate_verify_failed') ||
        lower.contains('timeoutexception') ||
        lower.contains('os error') ||
        lower.contains('errno =') ||
        lower.contains('no address associated with hostname') ||
        lower.contains('connection reset by peer') ||
        lower.contains('connection error')) {
      return "Unable to connect. Please check your internet.";
    }

    // 2. Server 5xx or HTML error pages
    if (lower.contains('502 bad gateway') ||
        lower.contains('504 gateway time-out') ||
        lower.contains('500 internal server error') ||
        lower.contains('503 service unavailable') ||
        lower.contains('<!doctype html>') ||
        lower.contains('<html')) {
      return "Server is currently unavailable. Please try again.";
    }

    // 3. Format / JSON parse errors
    if (lower.contains('formatexception') ||
        lower.contains('syntaxerror') ||
        lower.contains('unexpected end of json')) {
      return "Unable to process data. Please try again.";
    }

    // 4. Security scrub: If message contains an IP address, port, or URL, scrub it!
    if (_ipRegex.hasMatch(raw) || _urlRegex.hasMatch(raw) || _portRegex.hasMatch(raw)) {
      debugPrint("AppErrorHandler: Scrubbed sensitive technical error: $raw");
      return "Unable to connect. Please check your internet.";
    }

    // 5. Clean common technical prefixes
    String cleaned = raw
        .replaceAll(RegExp(r'^(Exception|Error|ClientException):\s*', caseSensitive: false), '')
        .trim();

    return cleaned.isNotEmpty
        ? cleaned
        : (defaultMessage ?? "Something went wrong. Please try again.");
  }

  /// Maps HTTP status codes to short, concise English explanations
  static String fromStatusCode(int statusCode) {
    if (statusCode >= 500) {
      return "Server error. Please try again later.";
    } else if (statusCode == 404) {
      return "Resource not found.";
    } else if (statusCode == 401 || statusCode == 403) {
      return "Access denied.";
    } else if (statusCode == 408) {
      return "Request timed out. Please try again.";
    } else {
      return "Something went wrong ($statusCode). Please try again.";
    }
  }
}
