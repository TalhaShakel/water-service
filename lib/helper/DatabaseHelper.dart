import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final _databaseName = "water_drinking_reminder_app.db";
  static final _databaseVersion = 1;

  static final tableContainer = 'tbl_container_details';
  static final tableDrinkDetails = 'tbl_drink_details';
  static final tableAlarmDetails = 'tbl_alarm_details';
  static final tableAlarmSubDetails = 'tbl_alarm_sub_details';


  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {

    //print("_onCreate");

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableContainer (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ContainerID INTEGER DEFAULT 0,
            ContainerValue TEXT,
            ContainerValueOZ TEXT,
            ContainerMeasure TEXT,
            IsOpen TEXT,
            IsCustom INTEGER DEFAULT 0
          )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableDrinkDetails (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ContainerValue TEXT,
            ContainerValueOZ TEXT,
            ContainerMeasure TEXT,
            DrinkDate TEXT,
            DrinkTime TEXT,
            DrinkDateTime TEXT,
            TodayGoal TEXT,
            TodayGoalOZ TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableAlarmDetails (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            AlarmTime TEXT,
            AlarmId TEXT,
            AlarmType TEXT,
            AlarmInterval TEXT,
            
            IsOff INTEGER DEFAULT 0,
            
            Sunday INTEGER DEFAULT 1,
            Monday INTEGER DEFAULT 1,
            Tuesday INTEGER DEFAULT 1,
            Wednesday INTEGER DEFAULT 1,
            Thursday INTEGER DEFAULT 1,
            Friday INTEGER DEFAULT 1,
            Saturday INTEGER DEFAULT 1,
            
            
            SundayAlarmId TEXT,
            MondayAlarmId TEXT,
            TuesdayAlarmId TEXT,
            WednesdayAlarmId TEXT,
            ThursdayAlarmId TEXT,
            FridayAlarmId TEXT,
            SaturdayAlarmId TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableAlarmSubDetails (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            AlarmTime TEXT,
            AlarmId TEXT,
            SuperId TEXT
          )
          ''');

    //print("_onCreate 2");


 }

 loadDefaultData() async{
   var dd=await queryRowCount(tableContainer);

   print("_onCreate 3");

   print(dd);
   if((await queryRowCount(tableContainer))==0){

     List<int> cval=[50,100,150,200,250,300,500,600,700,800,900,1000];
     List<int> cval2=[2,3,5,7,8,10,17,20,24,27,30,34];
     List<int> iop=[1,1,1,1,1,1,1,1,0,0,0,0];

     for(int k=0;k<cval.length;k++){
       Map<String, dynamic> params =
       {
       'ContainerID': (k+1).toString(),
       'ContainerValue': cval[k],
       'ContainerValueOZ': cval2[k],
       'IsOpen': iop[k],
       };

       await insert(tableContainer, params);
     }
   }
 }

  // Helper methods

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> update(String table, Map<String, dynamic> row, String columnName) async {
    Database db = await instance.database;
    var id = row[columnName];
    return await db.update(table, row, where: '$columnName = ?', whereArgs: [id]);
  }

  Future<int> updateQuery(String table, Map<String, dynamic> row, String where) async {
    Database db = await instance.database;
    String query="UPDATE $table SET ";
    row.forEach((key, value) {
      query+=key+"='"+value+"' ";
    });

    query=query+" WHERE $where";

    return await db.rawUpdate(query);
  }

  Future<List<Map<String, dynamic>>> query(String table, String query) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table $query').catchError((onError){
      print("ERROR FROM DB : "+onError.toString());
    });
  }

  Future<List<Map<String, dynamic>>> rowQuery(String query) async {
    Database db = await instance.database;
    return await db.rawQuery(query).catchError((onError){
      print("ERROR FROM DB : "+onError.toString());
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryWhere(String table, String where) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $where').catchError((onError){
      print("ERROR FROM DB : "+onError.toString());
    });
  }

  Future<List<Map<String, dynamic>>> queryWhereBySort(String table, String where, String order) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $where ORDER BY $order');
  }

  Future<List<Map<String, dynamic>>> queryAllBySort(String table, String order) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY $order');
  }

  Future<int> queryRowCount(String table) async {
    //print('SELECT COUNT(*) FROM $table');
    print("dsgfdgf");
    Database db = await instance.database;
    print('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<bool> isExists(String table, String where) async {
    Database db = await instance.database;
    int count=Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table WHERE $where"));
    if(count==null)
      return false;
    return count>0;
  }

  Future<String> getLastId(String table) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> allRows= await db.rawQuery('SELECT * FROM $table');

    String str="";
    allRows.forEach((row)
    {
      str = row["id"].toString();
    });

    return str;
  }

  Future<int> getLastContainerId() async {
    Database db = await instance.database;
    int count=Sqflite.firstIntValue(await db.rawQuery("SELECT MAX(ContainerID) FROM $tableContainer"));
    if(count==null)
      return 1;
    return count+1;
  }

  /*Future<String> getLastContainerId(String table) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> allRows= await db.rawQuery('SELECT * FROM $table');

    String str="";
    allRows.forEach((row)
    {
      str = row["ContainerID"].toString();
    });

    return str;
  }*/




 /* Future<int> queryUnReadRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE Isread=0'));
  }

  Future<bool> isExists(String table, String title) async {
    Database db = await instance.database;
    int count=Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table WHERE Title=?", [title]));
    if(count==null)
      return false;
    return count>0;
  }*/

  /*Future<int> update(String table, Map<String, dynamic> row, String columnName) async {
    Database db = await instance.database;
    int id = row[columnName];
    return await db.update(table, row, where: '$columnName = ?', whereArgs: [id]);
  }*/

  /*Future<int> readAll() async {

    Map<String, dynamic> param =
    {
      'Isread': 1,
    };

    Database db = await instance.database;
    return await db.update(tableNotifications, param, where: 'Isread = ?', whereArgs: ["0"]);
  }*/

  Future<int> deleteQuery(String table, String where) async {
    Database db = await instance.database;
    //print('DELETE FROM $table WHERE $where');
    return await db.rawDelete('DELETE FROM $table WHERE $where');
  }

  Future<int> delete(String table, String fieldName, String fieldValue) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$fieldName = ?', whereArgs: [fieldValue]);
  }

  Future<int> deleteAll(String table) async {
    Database db = await instance.database;
    return await db.delete(table).catchError((onError){
      print("deleteAll = "+onError.toString());
    });
  }
}