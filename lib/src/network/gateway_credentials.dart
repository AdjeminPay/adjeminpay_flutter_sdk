import 'dart:convert';

import 'package:adjeminpay_flutter_sdk/src/models/access_token.dart';
import 'package:adjeminpay_flutter_sdk/src/network/gateway_exception.dart';
import 'package:adjeminpay_flutter_sdk/src/utils/jwt_decoder.dart';
import 'package:http/http.dart';

abstract class IGatewayCredentials{

  Future<AccessToken> getAccessToken({
    required String baseUrl,
    required String clientId,
    required String clientSecret,
  });
}

class GatewayCredentials implements IGatewayCredentials{

 static final GatewayCredentials _singleton = GatewayCredentials._internal();
 static AccessToken? _token;

 factory GatewayCredentials() {
   return _singleton;
 }

 GatewayCredentials._internal();

  @override
  Future<AccessToken> getAccessToken({
    required String baseUrl,
    required String clientId,
    required String clientSecret}) async {

    if(_token == null ){
      _token = await _obtainAccessToken(baseUrl: baseUrl, clientId: clientId, clientSecret: clientSecret);
    }

    if(_token != null){

      //check if the token has expired
      print("Check if the token has expired");
     final bool hasExpired = JwtDecoder.isExpired(_token!.accessToken!);

      if(hasExpired){//Token has expired
        print("Token has expired so we are obtaining a new one.");
        _token =  await _obtainAccessToken(baseUrl: baseUrl, clientId: clientId, clientSecret: clientSecret);
      }

    }



    return _token!;
  }

 Future<AccessToken> _obtainAccessToken({
   required String baseUrl,
   required String clientId,
   required String clientSecret}) async{

   final url = Uri.parse("$baseUrl/oauth/token");

   final response = await post(url,
       body: {
         "client_id":clientId,
         "client_secret":clientSecret,
         "grant_type":"client_credentials"
       },
     headers: {
       'Accept': 'application/json',
       'Content-Type': 'application/x-www-form-urlencoded'
     }
   );

     if(response.statusCode == 200){
       final Map<String, dynamic>? json  = jsonDecode(response.body);

       if(json != null){
         return AccessToken.fromJson(json);
       }

     }

     if(response.statusCode != 200 && response.headers['content-type'] == 'application/json'){
       final Map<String, dynamic> json  = jsonDecode(response.body);
       throw GatewayException(
           message: json.containsKey('message')?json['message']:'',
           error: json.containsKey('error')?json['error']:'',
           code: json.containsKey('code')?json['code']:'',
           status: json.containsKey('status')?json['status']:''
       );
     }else{
       throw response;
     }
 }

}