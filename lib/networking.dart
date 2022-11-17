import 'package:http/http.dart' as http;
//convertir notre chaine de caractère en json ou en objet
import 'dart:convert';

class Networking {
  String url;

  Networking({this.url});

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    print(url);
    if (response.statusCode == 200) {
      String data = response.body;
      var decodeJson = jsonDecode(data);
      return decodeJson;
//tableau[]
      int id = decodeJson['weather'][0]['id'];
      double temp = decodeJson['main']['temp'];
      String city = decodeJson['name'];
      print(decodeJson);
    } else {
      print(response.statusCode);
    }
  }
}
