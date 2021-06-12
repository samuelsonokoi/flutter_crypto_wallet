import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double> getPrice(String id) async {
  try {
    dynamic url = 'https://api.coingecko.com/api/v2/' + id;
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var price = json['market_data']['curren_price']['usd'].toString();
    return double.parse(price);
  } catch (e) {
    print(e.toString());
    return 0.0;
  }
}
