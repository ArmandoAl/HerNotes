import 'package:her_notes/Domain/models/complete_user_model.dart';

class ModelForControlUsertype {
  String usertype;
  CompleteUserModel user;

  ModelForControlUsertype({
    required this.usertype,
    required this.user,
  });

  factory ModelForControlUsertype.fromJson(Map<String, dynamic> json) =>
      ModelForControlUsertype(
        usertype: json["userType"],
        user: CompleteUserModel.fromJson(json["user"]),
      );
}
