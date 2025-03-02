import 'package:flutter/material.dart';
import 'package:movie_app/services/category.dart';
import 'package:movie_app/widgets/alert.dart';

class RegisterCategoryView extends StatefulWidget {
  const RegisterCategoryView({super.key});

  @override
  State<RegisterCategoryView> createState() => _RegisterCategoryViewState();
}

class _RegisterCategoryViewState extends State<RegisterCategoryView> {
  CategoryService category = CategoryService();
final formKey = GlobalKey<FormState>();
TextEditingController category_name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Category"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Text(
                "Register Category",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: category_name,
                        decoration: InputDecoration(label: Text("Category_Name")),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Category_Name harus diisi';
                          } else {
                            return null;
                          }
                        },
                      ),
                      MaterialButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              var data = {
                                "category_name": category_name.text,
                              };
                              var result = await category.registerCategory(data);
                              if (result.status == true) {
                                category_name.clear();
                                setState(() {
                                });
                                AlertMessage()
                                    .showAlert(context, result.message, true);
                              } else {
                                AlertMessage()
                                    .showAlert(context, result.message, false);
                              }
                            }
                          },
                          child: Text("Register"),
                          color: Colors.lightGreen)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
