import 'package:flutter/material.dart';
import 'package:movie_app/services/movie.dart';
import 'package:movie_app/views/tambah_movie_view.dart';
import 'package:movie_app/widgets/alert.dart';
import 'package:movie_app/widgets/bottomnav.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  MovieService movie = MovieService();
  List action = ["update", "Hapus"];
  List? film;
  bool isLoading = true; // Tambahkan flag loading

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    var result = await movie.getMovie();
    if (result.status == true) {
      setState(() {
        film = result.data;
        isLoading = false; // Selesai loading
      });
    } else {
      setState(() {
        isLoading = false; // Selesai loading, tapi gagal
      });
      // Tampilkan pesan error jika perlu
      print(result.message);
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TambahMovieView(title: "Tambah Movie", item: null)));
              },
              icon: Icon(Icons.add))
        ],

      ),
      body: film != null
          ? ListView.builder(
              itemCount: film!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading:
                        Image(image: NetworkImage(film![index].posterPath)),
                     title: Text(film![index].title),
                    trailing:
                        PopupMenuButton(itemBuilder: (BuildContext context) {
                      return action.map((r) {
                        return PopupMenuItem(
                            onTap: () async {
                              if (r == "Update") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TambahMovieView(
                                            title: "Update Movie",
                                            item: film![index])));
                              } else {
                                var results = await AlertMessage()
                                    .showAlertDialog(context);
                                if (results != null &&
                                    results.containsKey('status')) {
                                  if (results['status'] == true) {
                                    var res = await movie.hapusMovie(
                                        context, film![index].id);
                                    if (res.status == true) {
                                      AlertMessage().showAlert(
                                          context, res.message, true);
                                      fetchMovies();
                                    } else {
                                      AlertMessage().showAlert(
                                          context, res.message, false);
                                    }
                                  }
                                }
                              }
                            },
                            value: r,
                            child: Text(r));
                      }).toList();
                    }),

                  ),
                );
              })
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}