import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = "contacts";
final String idColumn = "id";
final String nameColumn = "name";
final String emailColumn = "email";
final String phoneColumn = "phone";
final String imgColumn = "imagePath";

class ContactHelper {

  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper () => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get dg async {
    if(_db != null) {
      return _db;
    } else {
      _db = await initDb();
    }
  }

  Future<Database> initDb() async {

    // Path from where the database will be stored
    final databasePath = await getDatabasesPath();

    // Path with file (path complete)
    final path = join(databasePath, "contacts.db");



    Database db = await openDatabase(path, version: 1, onCreate: (Database db, int newVersion) async {

      await db.execute(
        // Code SQL
        "CREATE TABLE $contactTable("
            "$idColumn INTEGER PRIMARY KEY, "
            "$nameColumn VARCHAR(30),"
            "$emailColumn VARCHAR(45),"
            "$phoneColumn VARCHAR(20),"
            "$imgColumn VARCHAR(50))"
      );

    });

    return db;

  }

}

// Modal class
class Contact {

  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };

    if(id != null) {
      map[idColumn] = id;
    }

    return map;

  }

  @override
  String toString() {
    return "Contact (id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }

}