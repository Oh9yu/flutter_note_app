import 'package:archive_idea/data/idea_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database database;

  //database init
  Future<void> initDatabase() async {
    //database path
    String path = join(await getDatabasesPath(), 'archive_idea.db');

    //create path
    database = await openDatabase(path, version: 1, onCreate: (db, version) {
      //db data create action
      db.execute('''
        CREATE TABLE IF NOT EXIST tb_idea (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        motive TEXT,
        content TEXT,
        priority INTEGER,
        feedback TEXT,
        createdAt INTEGER
      )
      ''');
    },);
  }

  //IdeaInfo data insert
  Future<int> insertIdeaInfo(IdeaInfo idea) async {
    return await database.insert('tb_idea', idea.toMap());
  }

  //IdeaInfo data select
  Future<List<IdeaInfo>> getAllIdeaInfo() async {
    final List<Map<String, dynamic>> result = await database.query('tb_idea');
    return List.generate(result.length, (index) {
      return IdeaInfo.fromMap(result[index]);
    },);
  }

  //IdeaInfo data update
  Future<int> updateIdeaInfo(IdeaInfo idea) async {
    return await database.update(
      'tb_idea',
      idea.toMap(),
      //where : 수정하고 싶은 데이터 id
      where: 'id = ?',
      whereArgs: [idea.id], // where의 ? 값에 할당
    );
  }
  //IdeaInfo data delete
  Future<int> deleteIdeaInfo(int id) async {
    return await database.delete(
      'tb_idea',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //close db = 자원낭비 방지
  Future<void> closeDatabase() async{
    await database.close();
  }
}

