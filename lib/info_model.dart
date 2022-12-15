import 'package:local_database_project/constants.dart';

class InfoModel {
  int? id;
  String? name;
  String? email;
  String? phone;

  InfoModel({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  InfoModel.fromDB(Map<String, dynamic> data) {
    id = data[columnID];
    name = data[columnName];
    email = data[columnEmail];
    phone = data[columnPhone];
  }

  Map<String, dynamic> toDB() => {
        columnName: name,
        columnEmail: email,
        columnPhone: phone,
      };
}
