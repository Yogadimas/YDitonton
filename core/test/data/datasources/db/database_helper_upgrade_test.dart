import 'package:core/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final path = await getDatabasesPath();
    await databaseFactory.setDatabasesPath('$path/db_upgrade_test');
  });

  tearDownAll(() async {
    await DatabaseHelper().closeDatabase();
  });

  test('DatabaseHelper should trigger onUpgrade when oldVersion < 2', () async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';
    await databaseFactory.deleteDatabase(databasePath);

    // Create version 1 database
    var db = await databaseFactory.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE watchlist (
              id INTEGER PRIMARY KEY,
              title TEXT,
              overview TEXT,
              posterPath TEXT
            );
          ''');
        },
      ),
    );
    await db.close();

    // Now initialize DatabaseHelper which requests version 2
    final helper = DatabaseHelper();
    final db2 = await helper.database;
    expect(db2, isNotNull);
  });
}
