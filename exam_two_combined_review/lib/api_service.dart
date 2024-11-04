import 'package:http/http.dart' as http;
import 'constants.dart';
import 'product_model.dart'; //path of product_model.dart

class ApiService{

  Future<List<Product>?> getProducts() async{

    try{
      var url = Uri.parse(ApiConstants.baseURL + ApiConstants.productsEndPoint);
      var response = await http.get(url);

      if(response.statusCode == 200){
        List<Product> _model=userModelFromJson(response.body);
        return _model;
      }
    } catch (e){
      print(e.toString());
    }
  }
}