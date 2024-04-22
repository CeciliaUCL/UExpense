import 'package:uexpense/tool/DBTool.dart';
import 'package:uexpense/entity/RecordDetails.dart';

class DBExTool {
  static String dbName = "db.db";

  static Map<String, String> tableMap = {
    "record_details": "CREATE TABLE record_details("
        " id INTEGER PRIMARY KEY autoincrement,"
        " entryType TEXT,"
        " description TEXT, "
        " amount REAL,"
        " expenseType TEXT,"
        " date TEXT,"
        " time TEXT,"
        " imgPath TEXT)",
  };

  init() async {
    await DBTool().initDB(dbName, tableMap);
  }

  Future<List<Map>> selRecordDetailsByAll() async {
    return await DBTool().select("select * from record_details");
  }

  Future<List<Map>> selRecordDetailsById(int id) async {
    return await DBTool().select("select * from record_details where id=$id");
  }

  Future<List<Map>> selRecordDetailsByEntryType(String entryType) async {
    return await DBTool()
        .select("select * from record_details where entryType='$entryType'");
  }

  Future<bool> insertRecordDetails(RecordDetails recordDetails) async {
    return await DBTool().insert(
        "insert into record_details(entryType,description,amount,expenseType,date,time,imgPath) values("
        "'${recordDetails.entryType}',"
        "'${recordDetails.description}',"
        " ${recordDetails.amount},"
        "'${recordDetails.expenseType}',"
        "'${recordDetails.date}',"
        "'${recordDetails.time}',"
        "'${recordDetails.imgPath}')");
  }

  Future<bool> updateRecordDetailsById(
      int id, RecordDetails recordDetails) async {
    return await DBTool().update("update record_details set "
        "entryType='${recordDetails.entryType}',"
        "description='${recordDetails.description}',"
        "amount=${recordDetails.amount},"
        "expenseType='${recordDetails.expenseType}',"
        "date='${recordDetails.date}',"
        "time='${recordDetails.time}',"
        "imgPath='${recordDetails.imgPath}' "
        "where id=$id");
  }

  Future<bool> deleteRecordDetailsById(int id) async {
    return await DBTool().delete("delete from record_details where id=$id");
  }
}
