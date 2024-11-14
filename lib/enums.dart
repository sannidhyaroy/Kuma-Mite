enum AuthMethod {
  NONE(''),
  HTTP_BASIC('basic'),
  NTLM('ntlm'),
  MTLS('mtls'),
  OAUTH2_CC('oauth2-cc');

  final String value;

  const AuthMethod(this.value);
}

enum MonitorStatus {
  DOWN(0),
  UP(1),
  PENDING(2),
  MAINTENANCE(3);

  final int value;

  const MonitorStatus(this.value);
}
