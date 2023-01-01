import 'package:http/http.dart' as http;
import 'package:weather/models/aqi_model.dart';
import 'package:weather/models/quotesmodel.dart';
class Remote_aqi{
  String latitude;
  String longitude;
  Remote_aqi(this.latitude,this.longitude);
  Future<Aqi?> getPosts() async{
    var httpclient=http.Client();
    var uri=Uri.parse('https://api.openweathermap.org/data/2.5/air_pollution?lat='+latitude+'&lon='+longitude+'&appid=2b211e9ed69b3b9398972ac748f29698');
    var response=await httpclient.get(uri);
    if(response.statusCode==200)
    {
      var json=response.body;
      return aqiFromJson(json);
    }
    else
    {
      return null;
    }
  }
}