import 'dart:convert';
import 'package:allout_groceries/loginscreen.dart';
import 'package:allout_groceries/useraccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'cartpage.dart';
import 'user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

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
  int sortButton = 1;
  late final String title;
  TextEditingController _srcController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _testasync();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text('Groceries Store'),
          backgroundColor: Colors.blue,
          actions: [
            TextButton.icon(
                onPressed: () => {_goToCart()},
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                label: Text(
                  cartitem.toString(),
                  style: TextStyle(color: Colors.white),
                )),
          ]),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("MENU",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              decoration: BoxDecoration(color: Colors.blueGrey[400]),
            ),
            ListTile(
              title: Text("Products", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: widget.user)));
              },
            ),
            ListTile(
              title: Text("My Account", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => UserAccount(user: widget.user)));
              },
            ),
            ListTile(
                title: Text("Logout", style: TextStyle(fontSize: 16)),
                onTap: _logout),
          ],
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 60,
                  width: screenWidth / 1.4,
                  child: TextFormField(
                    style: TextStyle(fontSize: 15),
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
                )
              ],
            ),
          ),
          if (_productList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(
                child: Center(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.85,
                        children: List.generate(_productList.length, (index) {
                          return Padding(
                              padding: const EdgeInsets.all(3),
                              child: Card(
                                elevation: 10,
                                child: SingleChildScrollView(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: screenHeight / 5,
                                      width: screenWidth / 1.1,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://javathree99.com/s269926/alloutgroceries/images/product/${_productList[index]['prid']}.jpg",
                                      ),
                                    ),
                                    Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Text(
                                                titleSub(_productList[index]
                                                    ['prname']),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Text(
                                              _productList[index]['prtype'][0]
                                                      .toUpperCase() +
                                                  _productList[index]['prtype']
                                                      .substring(1),
                                              style: TextStyle(fontSize: 16)),
                                          Text(
                                              "Qty:" +
                                                  _productList[index]['prqty'],
                                              style: TextStyle(fontSize: 16)),
                                          Text(
                                              "RM " +
                                                  double.parse(
                                                          _productList[index]
                                                              ['prprice'])
                                                      .toStringAsFixed(2),
                                              style: TextStyle(fontSize: 16)),
                                          Container(
                                            alignment: Alignment.center,
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  {_addtoCart(index)},
                                              child: Text("Add to Cart"),
                                            ),
                                          ),
                                        ]))
                                  ],
                                )),
                              ));
                        })))),
        ],
      )),
    ));
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

  /*void _loademaildialog() {
    TextEditingController _emailController = new TextEditingController();
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: new Text(
                  'Your Email',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.white24)),
                              )),
                          ElevatedButton(
                              onPressed: () async {
                                String _email =
                                    _emailController.text.toString();
                                prefs = await SharedPreferences.getInstance();
                                await prefs.setString("email", _email);
                                email = _email;
                                Fluttertoast.showToast(
                                    msg: "Email stored",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromRGBO(191, 30, 46, 50),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.of(context).pop();
                              },
                              child: Text("Proceed"))
                        ],
                      ),
                    ),
                  ),
                ]),
        context: context);
  }*/

  _addtoCart(int index) async {
    if (email == '') {
      //_loademaildialog();
    } else {
      ProgressDialog progressDialog = ProgressDialog(context,
          message: Text("Add to cart"), title: Text("In Progress..."));
      progressDialog.show();
      await Future.delayed(Duration(seconds: 1));
      String prid = _productList[index]['prid'];
      http.post(
          Uri.parse(
              "https://javathree99.com/s269926/alloutgroceries/php/add_cart.php"),
          body: {
            "email": email,
            "prid": prid,
          }).then((response) {
        print(response.body);
        if (response.body == "failed") {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          _loadCart();
        }
      });
      progressDialog.dismiss();
    }
  }

  void _loadCart() {
    print(email);
    http.post(
        Uri.parse(
            "https://javathree99.com/s269926/alloutgroceries/php/load_cart.php"),
        body: {"email": email}).then((response) {
      setState(() {
        cartitem = int.parse(response.body);
        print(cartitem);
      });
    });
  }

  _goToCart() async {
    if (email == "") {
      Fluttertoast.showToast(
          msg: "Please set your email first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      //_loademaildialog();
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CartPage(
            email: email,
            user: widget.user,
          ),
        ),
      );
      _loadProduct();
    }
  }

  Future<void> _testasync() async {
    await _loadPref();
    _loadProduct();
    _loadCart();
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email") ?? '';
    print(email);
    if (email == '') {
      //_loademaildialog();
    } else {}
  }

  String titleSub(String title) {
    if (title.length > 15) {
      return title.substring(0, 15) + "...";
    } else {
      return title;
    }
  }

  void _logout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }
}
