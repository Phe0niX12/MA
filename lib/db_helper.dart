
import "package:sqflite/sqflite.dart" as sql;

class SQLHelper{
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE transport (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      driver_name TEXT NOT NULL,
      start_point TEXT NOT NULL,
      end_point TEXT NOT NULL,
      estimated_time INTEGER NO NULL,
      product TEXT NOT NULL,
      createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTEMP
    )""");
  }
  static Future<sql.Database> db() async{
    return sql.openDatabase(
      "TransportDatabase.db",
      version: 1,
      onCreate: (sql.Database database,int version) async{
        await createTables(database);
      }
    );
  }
  static Future<int> createData(String driver_name, String start_point, String end_point, int estimated_time, String product) async{
    final db = await SQLHelper.db();
    final data = {'driver_name': driver_name, 'start_point':start_point, 'end_point': end_point, 'estimated_time': estimated_time, 'product':product};
    final id = await db.insert('transport', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
  static Future<List<Map<String, dynamic>>> getAllData() async{
    final db = await SQLHelper.db();
    return db.query('transport', orderBy: 'id');
  }
  static Future<List<Map<String, dynamic>>> getSingleData(int id) async{
    final db = await SQLHelper.db();
    return db.query('transport', where: "id = ?", whereArgs: [id], limit: 1);
  
  }
  static Future<int> updateData(int id, String driver_name, String start_point, String end_point, int estimated_time, String product) async{
    final db = await SQLHelper.db();
    final data = {
      'driver_name': driver_name, 
      'start_point':start_point, 
      'end_point': end_point, 
      'estimated_time': estimated_time, 
      'product':product
      };
    final result = await db.update('transport', data, where: "id = ?", whereArgs: [id]);
    return result;
  }
  static Future<void> deleteData(int id) async{
    final db = await SQLHelper.db();
    try{
      await db.delete('transport', where: "id = ?", whereArgs: [id]);
    }catch(e){
      
    }
  }
}