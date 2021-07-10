import 'dart:async';

import 'package:allout_groceries/order.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayScreen extends StatefulWidget {
final Order order;
const PayScreen({Key? key, required this.order}) : super(key: key);


  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
 Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Color(0x44000000),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl:
                      'http://javathree99.com/s269926/alloutgroceries/php/get_bill.php?email=' +
                          widget.order.user_email +
                          '&mobile=' +
                          widget.order.phone +
                          '&name=' +
                          widget.order.name +
                          '&amount=' +
                          widget.order.amount,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}