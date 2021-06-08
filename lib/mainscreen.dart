import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _titlecenter = "Loading...";
  List _productList = [];
  late double screenHeight, screenWidth;
  late SharedPreferences prefs;
  String email = "";
  int cartitem = 0;
  late final String title;
  TextEditingController _srcController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Groceries Store'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
            child: Column(
          children: [
            TextFormField(
              controller: _srcController,
              decoration: InputDecoration(
                hintText: "Search product",
                suffixIcon: IconButton(
                  onPressed: () => _searchProduct(_srcController.text),
                  icon: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            if (_productList.isEmpty)
              Flexible(child: Center(child: Text(_titlecenter)))
            else
              Flexible(
                  child: Center(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (screenWidth / screenHeight) / 1,
                          children: List.generate(_productList.length, (index) {
                            return Padding(
                                padding: const EdgeInsets.all(7),
                                child: Card(
                                  elevation: 10,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: screenHeight / 5,
                                        width: screenWidth / 1.1,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://javathree99.com/s269926/alloutgroceries/images/product/${_productList[index]['prid']}.jpg",
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                              "ID: " +
                                                  _productList[index]['prid'],
                                              style: TextStyle(fontSize: 16))),
                                      SizedBox(height: 2),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                              "Name: " +
                                                  _productList[index]['prname'],
                                              style: TextStyle(fontSize: 16))),
                                      SizedBox(height: 2),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                              "Price:RM " +
                                                  _productList[index]
                                                      ['prprice'],
                                              style: TextStyle(fontSize: 16))),
                                      SizedBox(height: 2),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                              "Type: " +
                                                  _productList[index]['prtype'],
                                              style: TextStyle(fontSize: 16))),
                                      SizedBox(height: 2),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                              "Quantity: " +
                                                  _productList[index]['prqty'],
                                              style: TextStyle(fontSize: 16))),
                                      SizedBox(height: 2),
                                    ],
                                  )),
                                ));
                          })))),
          ],
        )),
      ),
    );
  }

  _loadProduct() {
    http.post(
        Uri.parse(
            "https://javathree99.com/s269926/alloutgroceries/php/loadproduct.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        _productList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _productList = jsondata["products"];
        _titlecenter = "";
        setState(() {});
      }
    });
  }

  _searchProduct(String prname) {
    http.post(
        Uri.parse(
            "https://javathree99.com/s269926/alloutgroceries/php/loadproduct.php"),
        body: {"prname": prname}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        _productList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _productList = jsondata["products"];
        _titlecenter = "";
        setState(() {});
      }
    });
  }

  void _loademaildialog() {}
}
