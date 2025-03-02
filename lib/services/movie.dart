import 'dart:convert';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/models/response_data_list.dart';
import 'package:movie_app/models/response_data_map.dart';
import 'package:movie_app/models/user_login.dart';
import 'package:movie_app/services/url.dart' as url;
import 'package:http/http.dart' as http;


class MovieService {
  Future<ResponseDataList> getMovie() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      return ResponseDataList(status: false, message: 'anda belum login / token invalid');
    }

    var uri = Uri.parse(url.BaseUrl + "/get_movie"); // Perbaiki URL di sini
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
    };

    var getMovie = await http.get(uri, headers: headers);

    if (getMovie.statusCode == 200) {
      var data = json.decode(getMovie.body);

      if (data["status"] == true) {
        List movie = data["data"].map((r) => MovieModel.fromJson(r)).toList();
        return ResponseDataList(status: true, message: 'success load data', data: movie);
      } else {
        return ResponseDataList(status: false, message: 'Failed load data');
      }
    } else {
      return ResponseDataList(
        status: false,
        message: "gagal load movie dengan code error ${getMovie.statusCode}",
      );
    }
  }
  Future insertMovie(request, image, id) async {
  var user = await UserLogin().getUserLogin();
  if (user.status == false) {
    return ResponseDataList(status: false, message: 'anda belum login / token invalid');
  }

  Map<String, String> headers = {
    "Authorization": 'Bearer ${user.token}',
  };

  var uri = id == null 
      ? Uri.parse("${url.BaseUrl}/register_movie") 
      : Uri.parse("${url.BaseUrl}/update_movie/$id");

  var requestMultipart = http.MultipartRequest('POST', uri);
  requestMultipart.headers.addAll(headers);

  // Menambahkan field ke request
  requestMultipart.fields['title'] = request["title"].toString();
  requestMultipart.fields['voteaverage'] = request["voteaverage"].toString();
  requestMultipart.fields['overview'] = request["overview"].toString();



  // Menambahkan gambar jika ada
  if (image != null) {
  requestMultipart.files.add(
    http.MultipartFile(
      'posterpath',
      image.readAsBytes().asStream(),
      image.lengthSync(),
      filename: image.path.split('/').last,
    ),
  );
}


  // Mengirim request
  var response = await requestMultipart.send();
  var result = await http.Response.fromStream(response);

  print("Response Code: ${response.statusCode}");
  print("Response Body: ${result.body}");

  if (response.statusCode == 200) {
    var data = json.decode(result.body);
    if (data["status"] == true) {
      return ResponseDataMap(status: true, message: 'success insert / update data');
    } else {
      return ResponseDataMap(status: false, message: data["message"] ?? 'Failed insert / update data');
    }
  } else {
    return ResponseDataMap(status: false, message: "gagal load movie dengan code error ${response.statusCode}");
  }
}

  Future hapusMovie(context, id) async {
    var uri = Uri.parse(url.BaseUrl + "/hapus_movie/$id");
    var user = await UserLogin().getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
          status: false, message: 'anda belum login / token invalid');
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
    };
    var hapusMovie = await http.delete(uri, headers: headers);


    if (hapusMovie.statusCode == 200) {
      var result = json.decode(hapusMovie.body);
      if (result["status"] == true) {
        ResponseDataList response =
            ResponseDataList(status: true, message: 'success hapus data');
        return response;
      } else {
        ResponseDataList response =
            ResponseDataList(status: false, message: 'Failed hapus data');
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
          status: false,
          message:
              "gagal hapus movie dengan code error ${hapusMovie.statusCode}");
      return response;
    }
  }

  }