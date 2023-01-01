import 'package:http/http.dart' as http;
import 'package:weather/models/quotesmodel.dart';
class RemoteQuote{
  Future<QuotesPost?> getPosts() async{
    var httpclient=http.Client();
    var uri=Uri.parse('https://api.quotable.io/random?maxLength=70');
    var response=await httpclient.get(uri);
    if(response.statusCode==200)
    {
      var json=response.body;
      return quotesPostFromJson(json);
    }
    
  }
}