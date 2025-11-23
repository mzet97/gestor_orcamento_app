// Facade for IsarDatabase with conditional exports for web and IO
export 'isar_database_io.dart' if (dart.library.html) 'isar_database_web_stub.dart';