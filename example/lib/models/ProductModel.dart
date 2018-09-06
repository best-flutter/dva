

import 'dart:async';

import 'package:dva/dva.dart';
import 'package:example/services/ProductService.dart';
import 'package:redux/redux.dart';

class Product{
  final String id;

  Product({
    this.id
});
}



class ProductDetail{
  final String id;

  ProductDetail({
    this.id
  });
}

class ProductState{

  List<Product> products;
  bool loading;
  dynamic error;
  ProductDetail detail;

  ProductState({
    this.products : const <Product>[],
    this.loading : false,
    this.detail

});
}


class ProductModel extends BaseModel<ProductState>{

  ProductService productService = new ProductService();

  @override
  ProductState getInitialState() {
    return new ProductState();
  }

  @override
  String getName() {
    return "product";
  }

  ProductState loading(ProductState state,bool loading){
    return state..loading = loading;
  }

  ProductState detail(ProductState state,ProductDetail detail){
    return state..detail = detail;
  }


  Future get(Store store,String id) async{
    store.dispatch(new Action("product/loading",true));
    ProductDetail product = await productService.get(id);
    store.dispatch(new Action("product/loading",false));
    store.dispatch(new Action("product/detail",product));
  }

  @override
  Map<String, Function> getInvokers() {
    // TODO: implement getInvokers
  }

}