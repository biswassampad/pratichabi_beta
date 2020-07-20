import 'package:pratichabi/models/logs.dart';

abstract class LogInterface{
  init();

  addLogs(Log log);

  // returns a list of logs
  Future<List<Log>> getLogs();

  deleteLogs(int logId);

  close();
}