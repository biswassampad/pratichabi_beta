import 'package:senger/models/logs.dart';

abstract class LogInterface {

  openDb(dbName);
  
  init();

  addLogs(Log log);

  // returns a list of logs
  Future<List<Log>> getLogs();

  deleteLogs(int logId);

  close();
}