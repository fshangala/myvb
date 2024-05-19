import 'package:http/http.dart' as http;

class AirtelSDK {
  final _clientId = "399fb168-3306-4896-a912-eedd69e91c32";
  final _clientSecrete = "****************************";
  final _merchantId = "J5V0BBBW";

  //final baseUrl = "https://openapi.airtel.africa";
  final baseUrl = "https://openapiuat.airtel.africa";

  String? _accessToken;

  authorization() async {
    var req = http.Request("POST", Uri.parse("$baseUrl/auth/oauth2/token"));
    req.headers.addAll({"Content-Type": "application/json", "Accept": "*/*"});
    req.body = '''
    {
      "client_id": "$_clientId",
      "client_secret": "$_clientSecrete",
      "grant_type": "client_credentials"
    }
    ''';

    var response = await req.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    }

    return null;
  }
}
