import 'package:url_launcher/url_launcher.dart';

const Set<String> _blockedExecutableExtensions = {
  'apk',
  'aab',
  'apks',
  'xapk',
  'dex',
  'jar',
  'so',
};

const Set<String> safeDocumentExtensions = {
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'ppt',
  'pptx',
  'txt',
  'csv',
};

const String _legacyApiHost = '178.18.241.5';

String _extensionFromPath(String path) {
  final fileName = path.split('/').last.toLowerCase();
  final dot = fileName.lastIndexOf('.');
  return dot < 0 ? '' : fileName.substring(dot + 1);
}

bool containsExecutableFileReference(Uri uri) {
  final candidates = <String>[
    uri.path,
    ...uri.queryParameters.values,
  ];
  return candidates.any(
    (value) => _blockedExecutableExtensions.contains(_extensionFromPath(value)),
  );
}

bool isSafeExternalUri(Uri uri) {
  final isHttps = uri.scheme == 'https';
  final isLegacyApi = uri.scheme == 'http' && uri.host == _legacyApiHost;
  return uri.host.isNotEmpty &&
      (isHttps || isLegacyApi) &&
      !containsExecutableFileReference(uri);
}

bool isSafeDocumentUri(Uri uri) {
  return isSafeExternalUri(uri) &&
      safeDocumentExtensions.contains(_extensionFromPath(uri.path));
}

Future<bool> launchSafeExternalUrl(String rawUrl) async {
  final uri = Uri.tryParse(rawUrl.trim());
  if (uri == null || !isSafeExternalUri(uri)) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
