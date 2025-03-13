import 'dart:convert';
import 'package:movie_app/models/response_data_map.dart';
import 'package:movie_app/models/user_login.dart';
import 'package:movie_app/services/url.dart' as url;
import 'package:http/http.dart' as http;

class UserService {
  Future registerUser(data) async {
    var uri = Uri.parse("${url.BaseUrl}/register_admin");
    var register = await http.post(uri, body: data);

    if (register.statusCode == 200) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
            status: true, message: "Sukses menambah user", data: data);
        return response;
      } else {
        var message = '';
        for (String key in data["message"].keys) {
          message += '${data["message"][key][0]}\n';
        }
        ResponseDataMap response =
            ResponseDataMap(status: false, message: message);
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message:
              "gagal menambah user dengan code error ${register.statusCode}");
      return response;
    }
  }

  Future loginUser(data) async {
    var uri = Uri.parse("${url.BaseUrl}/login");
    var response = await http.post(uri, body: data);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      print("Response API: $responseData"); // Debugging

      if (responseData["status"] == true) {
        // Cek apakah "data" ada dan bukan null
        if (responseData.containsKey("data") &&
            responseData["data"] != null &&
            responseData["data"] is Map) {
          UserLogin userLogin = UserLogin(
            status: responseData["status"],
            token:
                responseData["authorisation"]?["token"] ?? "", // Sesuaikan key
            message: responseData["message"] ?? "Login berhasil",
            id: responseData["data"]?["id"] ?? 0,
            name: responseData["data"]?["name"] ?? "Unknown",
            email: responseData["data"]?["email"] ?? "Unknown",
            role: responseData["data"]?["role"] ?? "Unknown",
          );
          await userLogin.prefs();

          return ResponseDataMap(
              status: true, message: "Sukses login user", data: responseData);
        } else {
          return ResponseDataMap(
              status: false,
              message: "Data user tidak ditemukan dalam response.");
        }
      } else {
        return ResponseDataMap(
            status: false, message: 'Email dan password salah');
      }
    } else {
      return ResponseDataMap(
          status: false,
          message: "Gagal login dengan code error ${response.statusCode}");
    }
  }
}
