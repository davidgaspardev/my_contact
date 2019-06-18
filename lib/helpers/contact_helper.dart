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

  Future<Database> get db async {
    if(_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {

    // Path from where the database will be stored
    final databasePath = await getDatabasesPath();

    // Path with file (path complete)
    final path = join(databasePath, "contacts.db");

    // Opening database
    Database newDb = await openDatabase(path, version: 1, onCreate: (Database db, int newVersion) async {

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

    return newDb;

  }

  // Methods setter and getter (Contact)
  Future<Contact> setContact(Contact contact) async {
    // Get database
    Database dbContact = await db;

    // Insert contact in database's table
    contact.id = await dbContact.insert(contactTable, contact.toMap());

    return contact;
  }

  Future<Contact> getContact(int id) async {
    // Get database
    Database dbContact = await db;

    // Get data from database (filter id)
    List<Map> contact = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn == ?",
        whereArgs: [id]
    );

    if(contact.length > 0) {
      return Contact.fromMap(contact.first);
    }else {
      return null;
    }

  }

  Future<List<Contact>> getContacts() async {
    // Get database
    Database dbContact = await db;

    List<Map> contactsMap = await dbContact.rawQuery("SELECT * FROM $contactTable");

    // Convert Map list to Contact list
    List<Contact> contacts = List();
    for(Map indexMap in contactsMap) {
      contacts.add(Contact.fromMap(indexMap));
    }

    return contacts;

  }

  Future<int> deleteContact(int id) async {
    // Get database
    Database dbContact = await db;

    // Remove data from database (filter id)
    int status = await dbContact.delete(contactTable, where: "$idColumn == ?", whereArgs: [id]);

    return status;
  }

  Future<int> updateContact(Contact contact) async {
    // Get database
    Database dbContact = await db;

    // Update data from database
    int status = await dbContact.update(contactTable, contact.toMap(), where: "$idColumn", whereArgs: [contact.id]);

    return status;
  }

  Future<int> getNumber() async {
    // Get database
    Database dbContact = await db;

    // Contacts number
    int contactsLength = Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));

    return contactsLength;
  }

  Future close() async {
    // Get database
    Database dbContact = await db;
    dbContact.close();
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