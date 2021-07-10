import 'dart:convert';

import 'package:allout_groceries/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

import 'checkoutpage.dart';

class CartPage extends StatefulWidget {
  final String email;
  final User user;

  const CartPage({Key? key, required this.email, required this.user}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _titlecenter = "Loading your cart";
  List _cartList = [];
  double _totalprice = 0.0;
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    _loadMyCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            children: [
              if (_cartList.isEmpty)
                Flexible(child: Center(child: Text(_titlecenter)))
              else
                Flexible(
                    child: OrientationBuilder(builder: (context, orientation) {
                  return GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: 2.5 / 1,
                      children: List.generate(_cartList.length, (index) {
                        return Padding(
                            padding: EdgeInsets.all(1),
                            child: Container(
                                child: Card(
                                    child: Row(children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  height: orientation == Orientation.portrait
                                      ? 100
                                      : 150,
                                  width: orientation == Orientation.portrait
                                      ? 100
                                      : 150,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://javathree99.com/s269926/alloutgroceries/images/product/${_cartList[index]['prid']}.jpg",
                                  ),
                                ),
                              ),
                              Container(
                                  height: 100,
                                  child: VerticalDivider(color: Colors.grey)),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_cartList[index]['prname'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text("RM " +
                                          double.parse(
                                                  _cartList[index]['prprice'])
                                              .toStringAsFixed(2) +
                                          " /unit"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () {
                                              _modQty(index, "removecart");
                                            },
                                          ),
                                          Text(_cartList[index]['cartqty']),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              _modQty(index, "addcart");
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "RM " +
                                            (int.parse(_cartList[index]
                                                        ['cartqty']) *
                                                    double.parse(
                                                        _cartList[index]
                                                            ['prprice']))
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteCartDialog(index);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ]))));
                      }));
                })),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.red,
                        height: 1,
                        thickness: 10.0,
                      ),
                      Text(
                        "TOTAL RM " + _totalprice.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _payDialog();
                        },
                        child: Text("CHECKOUT"),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }

  Future<void> _modQty(int index, String op) async {

    quantity = int.parse(_cartList[index]['cartqty']);
    if (op == "addcart") {
      quantity ++;
    }
    if (op == "removecart") {
      quantity--;
      if(quantity == 0) {
        _deleteCartDialog(index);
        return;
      }
    }
    // ProgressDialog progressDialog = ProgressDialog(context,
    //     message: Text("Update cart"), title: Text("Progress..."));
    // progressDialog.show();
    await Future.delayed(Duration(seconds: 1));
    http.post(
        Uri.parse(
            "https://javathree99.com/s269926/alloutgroceries/php/update_usercart.php"),
        body: {
          "email": widget.email,
          "prid": _cartList[index]['prid'],
          "quantity": quantity.toString(),
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadMyCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      //progressDialog.dismiss();
    });
  }

  void _loadMyCart() {
    http.post(
        Uri.parse(
            "https://javathree99.com/s269926/alloutgroceries/php/load_usercart.php"),
        body: {"email": widget.email}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No item";
        _cartList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _cartList = jsondata["cart"];
        _titlecenter = "";
        _totalprice = 0.0;
        for (int i = 0; i < _cartList.length; i++) {
          _totalprice = _totalprice +
              double.parse(_cartList[i]['prprice']) *
                  int.parse(_cartList[i]['cartqty']);
        }
      }
      setState(() {});
    });
  }

  void _deleteCartDialog(int index) {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Delete from your cart?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteCart(index);
                    },
                  ),
                  TextButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }

  void _payDialog() {
    if (_totalprice == 0.0) {
      Fluttertoast.showToast(
          msg: "Amount not payable",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
           builder: (context) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: new Text(
                    'Proceed with checkout?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckOutPage(
                                total: _totalprice, user: widget.user),
                          ),
                        );
                      },
                    ),
                    TextButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]),
          context: context);
    }
  }

  Future<void> _deleteCart(int index) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("Delete from cart"), title: Text("Progress..."));
    progressDialog.show();
    await Future.delayed(Duration(seconds: 1));
    http.post(Uri.parse("https://javathree99.com/s269926/alloutgroceries/php/delete_usercart.php"),
        body: {
          "email": widget.email,
          "prid": _cartList[index]['prid']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadMyCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      progressDialog.dismiss();
    });
  }

}
