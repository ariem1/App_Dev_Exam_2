import 'package:http/http.dart' as http;
import 'constants.dart';
import 'package:rest_api/user_model.dart'; //path of user_model.dart

class ApiService{

  Future<List<UserModel>?> getUsers() async{

    try{
      var url = Uri.parse(Apiconstants.baseURL + Apiconstants.usersEndPoints);
      var response = await http.get(url);

      if(response.statusCode == 200){
        List<UserModel> _model=userModelFromJson(response.body);
        return _model;
    }
    } catch (e){
      print(e.toString());
    }
  }
}