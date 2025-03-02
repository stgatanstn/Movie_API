import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Untuk Web
import 'package:image_picker/image_picker.dart'; // Untuk Android/iOS
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/movie.dart';
import 'package:movie_app/widgets/alert.dart';

class TambahMovieView extends StatefulWidget {
  final String title;
  final MovieModel? item;
  TambahMovieView({required this.title, required this.item});

  @override
  State<TambahMovieView> createState() => _TambahMovieViewState();
}

class _TambahMovieViewState extends State<TambahMovieView> {
  MovieService movie = MovieService();
  final formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController voteAverage = TextEditingController();
  TextEditingController overView = TextEditingController();
  File? selectedImage;
  Uint8List? webImage; // Untuk menyimpan gambar di Web
  bool isLoading = false;

  Future<void> getImage() async {
    setState(() {
      isLoading = true;
    });

    if (kIsWeb) {
      // Gunakan file_picker untuk Web
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {
          webImage = result.files.first.bytes; // Simpan sebagai Uint8List
          selectedImage = null; // Pastikan tidak ada File yang terpakai
        });
      }
    } else {
      // Gunakan image_picker untuk Android/iOS
      var img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        setState(() {
          selectedImage = File(img.path);
          webImage = null; // Pastikan tidak ada Uint8List yang terpakai
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      title.text = widget.item!.title!;
      voteAverage.text = widget.item!.voteAverage!.toString();
      overView.text = widget.item!.overview!;
      selectedImage = null;
      webImage = null;
    } else {
      title.clear();
      voteAverage.clear();
      overView.clear();
      selectedImage = null;
      webImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: title,
                  decoration: InputDecoration(label: Text("Title")),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Harus diisi';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: voteAverage,
                  decoration: InputDecoration(label: Text("Vote Average")),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Harus diisi';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: overView,
                  decoration: InputDecoration(label: Text("Overview")),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Harus diisi';
                    }
                    return null;
                  },
                ),
                TextButton(
                  onPressed: getImage,
                  child: Text("Select Picture"),
                ),
                // Menampilkan gambar yang dipilih
                if (selectedImage != null)
                  Image.file(selectedImage!, width: double.infinity, height: 200, fit: BoxFit.cover)
                else if (webImage != null)
                  Image.memory(webImage!, width: double.infinity, height: 200, fit: BoxFit.cover)
                else if (isLoading)
                  CircularProgressIndicator()
                else
                  Center(child: Text("Please Get the Images")),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var data = {
                        "title": title.text,
                        "voteaverage": voteAverage.text,
                        "overview": overView.text,
                      };
                      var result;
                      if (widget.item != null) {
                        result = await movie.insertMovie(
                          data, selectedImage, widget.item!.id!,
                        );
                      } else {
                        result = await movie.insertMovie(
                          data, selectedImage, null,
                        );
                      }

                      if (result.status == true) {
                        AlertMessage().showAlert(context, result.message, true);
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/movie');
                      } else {
                        AlertMessage().showAlert(context, result.message, false);
                      }
                    }
                  },
                  child: Text("Simpan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
