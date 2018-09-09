import 'package:example/models/ProductModel.dart';
import 'package:flutter/material.dart';

import 'package:dva/dva.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

part 'DetailPage_g.dart';

@Router("detail")
@OnInit("product/get", data: Parameter("id"))
class DetailPage extends StatelessWidget {
  DetailPage(
      {@StateValue("product.detail") this.detail,
      @StateValue("product.error") this.error,
      @StateValue("product.loading") this.loading});

  final ProductDetail detail;

  final dynamic error;

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("产品详情"),
      ),
      body: new Column(
        children: <Widget>[],
      ),
    );
  }
}
