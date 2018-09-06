

import 'dart:async';
import 'dart:convert';

import 'package:example/models/ProductModel.dart';

import 'package:http/http.dart' as http;

class ProductService{
  Future<List<Product>> products() async{
    http.Response response = await http.get("http://www.baidu.com");
    List data = json.decode(response.body);
    return data.map((vo){
      return new Product(
        id:vo['id']
      );
    }).toList();
  }

  Future<ProductDetail> get(String id) async{
    http.Response response = await http.get("http://www.baidu.com");
    var data = json.decode(response.body);
    return new ProductDetail(
      id: data['id']
    );
  }

}