// lib/utils/logger.dart
class _Logger {
  void i(String msg) => _log('INFO', msg);
  void e(String msg) => _log('ERROR', msg);
  void w(String msg) => _log('WARN', msg);
  void _log(String level, String msg) {
    // ignore: avoid_print
    print('[$level] $msg');
  }
}
final appLogger = _Logger();
