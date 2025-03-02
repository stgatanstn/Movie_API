import 'package:shared_preferences/shared_preferences.dart';


class UserLogin {
  bool? status = false;
  String? token;
  String? message;
  int? id;
  String? name;
  String? email;
  String? role;
  UserLogin(
      {this.status,
      this.token,
      this.message,
      this.id,
      this.name,
      this.email,
      this.role});

       Future prefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("status", status!);
    prefs.setString("token", token!);
    prefs.setString("message", message!);
    prefs.setInt("id", id!);
    prefs.setString("name", name!);
    prefs.setString("email", email!);
    prefs.setString("role", role!);
  }

 Future getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserLogin userLogin = UserLogin(
        status: prefs.getBool("status")!,
        token: prefs.getString("token")!,
        message: prefs.getString("message")!,
        id: prefs.getInt("id")!,
        name: prefs.getString("name")!,
        email: prefs.getString("email")!,
        role: prefs.getString("role")!);
    return userLogin;
  }

}

