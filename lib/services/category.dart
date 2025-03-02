import 'dart:convert';
import 'package:movie_app/models/response_data_map.dart';
import 'package:movie_app/services/url.dart' as url;
import 'package:http/http.dart' as http;


class CategoryService {
  Future registerCategory(data) async {
    var uri = Uri.parse(url.BaseUrl + "/register_category");
    var register = await http.post(uri, body: data);


    if (register.statusCode == 200) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
            status: true, message: "Sukses menambah category", data: data);
        return response;
      } else {
        var message = '';
        for (String key in data["message"].keys) {
          message += data["message"][key][0].toString() + '\n';
        }
        ResponseDataMap response =
            ResponseDataMap(status: false, message: message);
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message:
              "gagal menambah category dengan code error ${register.statusCode}");
      return response;
    }
  }
}
