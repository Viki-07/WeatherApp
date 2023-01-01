import './models/post.dart';
import 'package:http/http.dart' as http;
class RemoteService{
  String CityName;
  RemoteService(this.CityName);
  Future<Post?> getPosts() async{
    var httpclient=http.Client();
    var uri=Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$CityName&appid=2b211e9ed69b3b9398972ac748f29698');
    var response=await httpclient.get(uri);
    if(response.statusCode==200)
    {
      var json=response.body;
      return postFromJson(json);
    }
     else
    {
      return null;
    }
  }
}