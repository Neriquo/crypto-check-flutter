import 'package:http/http.dart' as http;
import 'dart:convert';

class Networking {
  String url;

  Networking({this.url});

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    print(url);

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedJson = jsonDecode(data);

      return decodedJson;
    } else {
      print(response.statusCode);
    }
  }
}
