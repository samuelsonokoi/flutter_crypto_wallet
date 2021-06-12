import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double> getPrice(String id) async {
  try {
    Uri url = Uri.parse('https://api.coingecko.com/api/v3/coins/' + id);
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var price = json['market_data']['current_price']['ngn'].toString();
    return double.parse(price);
  } catch (e) {
    print(e.toString());
    return 0.0;
  }
}

Future<String> getImage(String id) async {
  try {
    Uri url = Uri.parse('https://api.coingecko.com/api/v3/coins/' + id);
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    String image = json['image']['small'];
    return image;
  } catch (e) {
    print(e.toString());
    return '';
  }
}
