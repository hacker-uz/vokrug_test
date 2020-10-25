import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:vokrug/models/messages.dart';
import 'package:vokrug/models/user.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  String messageTable = 'Message';
  String messageId = 'id';
  String columnText = 'text';
  String columnUserId = 'userId';

  String userTable = "User";
  String userId = 'id';
  String login = 'login';
  String password = 'password';

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'Vokrug.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database database, int version) async {
    await database.execute(
        'CREATE TABLE $userTable($userId INTEGER PRIMARY KEY AUTOINCREMENT, $login TEXT, $password TEXT)');
    await database.execute(
        'CREATE TABLE $messageTable($messageId INTEGER PRIMARY KEY AUTOINCREMENT, $columnText TEXT, $columnUserId INTEGER)');
  }

  //чтения messages
  Future<List<Message>> getMessages(int userId) async {
    Database database = await this.database;
    final List<Map<String, dynamic>> messagesMapList =
        await database.query(messageTable, where: 'userId = ?', whereArgs: [userId]);
    final List<Message> messagesList = [];

    messagesMapList.forEach((messageMap) {
      messagesList.add(Message.fromMap(messageMap));
    });
    return messagesList;
  }

  //insert message
  Future<Message> insertMessage(Message msg) async {
    Database db = await this.database;
    msg.id = await db.insert(messageTable, msg.toMap());
    return msg;
  }

  //обновления
  Future<int> updateMessage(Message msg) async {
    Database database = await this.database;
    return await database.update(
      messageTable,
      msg.toMap(),
      where: '$messageId = ?',
      whereArgs: [msg.id],
    );
  }

  //удаления message
  Future<int> deleteMessage(int id) async {
    Database database = await this.database;
    return await database.delete(
      messageTable,
      where: '$messageId = ?',
      whereArgs: [id],
    );
  }

  //insert user
  Future<User> insertUser(User user) async {
    Database db = await this.database;
    user.id = await db.insert(userTable, user.toMap());
    return user;
  }

  Future<bool> userExist(String username) async  {
    Database db =  await this.database;
    return db.query(userTable, where: "$login = ?", whereArgs: [username]).then((value) => value.length > 0);
  }

  Future<User> authUser(String username, String pass) async  {
    Database db =  await this.database;
    var val  = await db.query(userTable, where: "$login = ? and $password = ?", whereArgs: [username, pass]);
    User user;
    val.forEach((element) {
      user = User.fromMap(element);
    });
    return user;
  }

  //чтения
  Future<List<User>> getUsers() async {
    Database database = await this.database;
    final List<Map<String, dynamic>> userMapList =
        await database.query(userTable);
    final List<User> usersList = [];

    userMapList.forEach((userMap) {
      usersList.add(User.fromMap(userMap));
    });
    return usersList;
  }

  Future<User> getUserByLogin(String username) async  {
    Database db = await this.database;
    var val = await db.query(userTable, where: "$login = ?", whereArgs: [username]);
    User user;
    val.forEach((element) {
      user = User.fromMap(element);
    });
    return user;
  }
}
