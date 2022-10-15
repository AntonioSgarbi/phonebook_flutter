class Contact {
  static const String tableName = 'contact';
  static const String colunmNameName = 'name';
  static const String colunmNamePhone = 'phone';

  final String name;
  final String phone;

  Contact({required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {Contact.colunmNameName: name, Contact.colunmNamePhone: phone};
  }





}