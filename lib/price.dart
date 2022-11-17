import 'price_screen.dart';
import 'main.dart';
import 'networking.dart';

const apiKey = '4C1F385C-FE21-4AD5-8B18-42320200D789';
const url = 'https://rest.coinapi.io/';

Future getPriceCrypto() async {
  Price price = Price();
  await price.getPrice();

  var price = null;
  var name = null;

  Networking network =
      Networking(url: '$url?pri=$price&nam=$name&appid=$apiKey&units=metric');

  var priceData = await network.getData();

  return priceData;
}
