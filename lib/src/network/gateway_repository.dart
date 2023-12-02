import 'dart:convert';

import 'package:adjeminpay_flutter_sdk/adjeminpay_flutter_sdk.dart';
import 'package:adjeminpay_flutter_sdk/src/models/gateway_transaction.dart';
import 'package:adjeminpay_flutter_sdk/src/network/gateway_credentials.dart';
import 'package:adjeminpay_flutter_sdk/src/network/gateway_exception.dart';
import 'package:http/http.dart';

abstract class IGatewayRepository{

  Future<GatewayTransaction> createCheckout(
      {
        required String clientId,
        required String clientSecret,
        required String merchantTransId,
        String? merchantTransData,
        required double amount,
        required String currencyCode,
        required String designation,
        String? customerFirstName,
        String? customerLastName,
        String? customerEmail,
        String? customerRecipientNumber,
        String? webhookUrl,
        String? returnUrl,
        String? cancelUrl,

      });
  Future<GatewayTransaction> completeCheckout(
      {
        required String clientId,
        required String clientSecret,
        required String merchantTransId,
        String? customerFirstName,
        String? customerLastName,
        String? customerEmail,
        required String  customerRecipientNumber,
        required String paymentMethodCode,
        String? otp,
      });

  Future<GatewayTransaction> createPayout(
      {
        required String clientId,
        required String clientSecret,
        required String merchantTransId,
        String? merchantTransData,
        required double amount,
        required String currencyCode,
        required String paymentMethodCode,
        required String designation,
        String? customerFirstName,
        String? customerLastName,
        String? customerEmail,
        required String customerRecipientNumber,
        String? webhookUrl
      });

  Future<GatewayTransaction> getPaymentStatus({
    required String clientId,
    required String clientSecret,
    required String merchantTransactionId
  });

  Future<List<GatewayOperator>> findOperatorsByCountry({
    required String clientId,
    required String clientSecret,
    required String countryIso
   });

}

class GatewayRepository implements IGatewayRepository{

  static final String BASE_URL = "https://api.adjeminpay.com";
  static final String VERSION = "v3";
  static final String API_URL = "$BASE_URL/$VERSION";


  @override
  Future<GatewayTransaction> getPaymentStatus({
    required String clientId,
    required String clientSecret,
    required String merchantTransactionId
   })async {

    final authCredential = await GatewayCredentials().getAccessToken(baseUrl:BASE_URL, clientId: clientId, clientSecret: clientSecret);

    final url = Uri.parse("$API_URL/merchants/payment/$merchantTransactionId");

    final response = await get(url,headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authCredential.accessToken}'
    });

    print('checkPaymentStatus() =>>> REQ => ${response.body}');

    if(response.statusCode == 200){
      final Map<String, dynamic> json  = jsonDecode(response.body);
      final bool success = json['success'];
      if(success){
        final Map<String, dynamic> data = json['data'];
        return GatewayTransaction.fromJson(data);
      }else{

        throw GatewayException(
            message: json.containsKey('message')?json['message']:'',
            error: json.containsKey('error')?json['error']:'',
            code: json.containsKey('code')?json['code']:'',
            status: json.containsKey('status')?json['status']:''
        );
      }
    }else{

      if(response.headers['content-type'] == 'application/json'){
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


  @override
  Future<List<GatewayOperator>> findOperatorsByCountry({
    required String clientId,
    required String clientSecret,
    required String countryIso
  })async {
   final url = Uri.parse("$API_URL/operators/${countryIso.toUpperCase()}");

   final authCredential = await GatewayCredentials().getAccessToken(baseUrl:BASE_URL, clientId: clientId, clientSecret: clientSecret);

   final response = await get(url,headers: {
     'Accept': 'application/json',
     'Authorization': 'Bearer ${authCredential.accessToken}'
   });
   if(response.statusCode == 200){
     final Map<String, dynamic> json  = jsonDecode(response.body);
     final bool success = json['success'];
     if(success){
       final List list = json['data'];
       return list.map((e) => GatewayOperator.fromJson(e as Map<String, dynamic>)).toList();
     }else{
       throw response;
     }
   }else{
     throw response;
   }
  }

  @override
  Future<GatewayTransaction> createCheckout({
    required String clientId,
    required String clientSecret,
    required String merchantTransId,
    String? merchantTransData,
    required double amount,
    required String currencyCode,
    required String designation,
    String? customerFirstName,
    String? customerLastName,
    String? customerEmail,
    String? customerRecipientNumber,
    String? webhookUrl,
    String? returnUrl,
    String? cancelUrl,})async {

    final authCredential = await GatewayCredentials().getAccessToken(baseUrl: BASE_URL, clientId: clientId, clientSecret: clientSecret);

    final requestBody = <String, dynamic>{
      "amount":currencyCode.toUpperCase()=="XOF"?amount.toInt():amount,
      "currency_code":currencyCode,
      "merchant_trans_id": merchantTransId,
      "designation": designation,
    };

    if(merchantTransData != null){
      requestBody['merchant_trans_data'] = merchantTransData;
    }

    if(customerRecipientNumber != null){
      requestBody['customer_recipient_number'] = customerRecipientNumber;
    }

    if(customerEmail != null){
      requestBody['customer_email'] = customerEmail;
    }

    if(customerFirstName != null){
      requestBody['customer_firstname'] = customerFirstName;
    }

    if(customerLastName != null){
      requestBody['customer_lastname'] = customerLastName;
    }

    if(webhookUrl != null){
      requestBody['webhook_url'] = webhookUrl;
    }

    if(returnUrl != null){
      requestBody['return_url'] = returnUrl;
    }

    if(cancelUrl != null){
      requestBody['cancel_url'] = cancelUrl;
    }

    final String url = "$API_URL/merchants/create_checkout";
    final Response response = await post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {
          'Authorization': 'Bearer ${authCredential.accessToken}',
          'Accept':'application/json',
          'Content-Type': 'application/json'
        }
    );

    print("makePayment() ==>>> BODY ${response.body}");

    if(response.statusCode == 200){
      final Map<String, dynamic> json  = jsonDecode(response.body);
      final bool success = json['success'];
      if(success){
        final Map<String, dynamic> data = json['data'];
        return GatewayTransaction.fromJson(data);
      }else{

        throw GatewayException(
          message: json.containsKey('message')?json['message']:'',
          error: json.containsKey('error')?json['error']:'',
          code: json.containsKey('code')?json['code']:'',
          status: json.containsKey('status')?json['status']:''
        );
      }
    }else{

      if(response.headers['content-type'] == 'application/json'){
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

  @override
  Future<GatewayTransaction> completeCheckout({required String clientId, required String clientSecret, required String merchantTransId, String? customerFirstName, String? customerLastName, String? customerEmail, required String customerRecipientNumber, required String paymentMethodCode, String? otp}) async{

    final authCredential = await GatewayCredentials().getAccessToken(baseUrl: BASE_URL, clientId: clientId, clientSecret: clientSecret);

    final requestBody = <String, dynamic>{
      "customer_recipient_number":customerRecipientNumber,
      "operator_code":paymentMethodCode
    };

    if(customerEmail != null){
      requestBody['customer_email'] = customerEmail;
    }

    if(customerFirstName != null){
      requestBody['customer_firstname'] = customerFirstName;
    }

    if(customerLastName != null){
      requestBody['customer_lastname'] = customerLastName;
    }


    if(otp != null){
      requestBody['otp'] = otp;
    }

    final url = Uri.parse("$API_URL/merchants/complete_checkout/$merchantTransId");
    final Response response = await put(
        url,
        body: jsonEncode(requestBody),
        headers: {
          'Authorization' : 'Bearer ${authCredential.accessToken}',
          'Accept':'application/json',
          'Content-Type': 'application/json'
        }
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> json  = jsonDecode(response.body);
      final bool success = json['success'];
      if(success){
        final Map<String, dynamic> data = json['data'];
        return GatewayTransaction.fromJson(data);
      }else{

        throw GatewayException(
            message: json.containsKey('message')?json['message']:'',
            error: json.containsKey('error')?json['error']:'',
            code: json.containsKey('code')?json['code']:'',
            status: json.containsKey('status')?json['status']:''
        );
      }
    }else{

      if(response.headers['content-type'] == 'application/json'){
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

  @override
  Future<GatewayTransaction> createPayout({
    required String clientId,
    required String clientSecret,
    required String merchantTransId,
    String? merchantTransData,
    required double amount,
    required String currencyCode,
    required String paymentMethodCode,
    required String designation,
    String? customerFirstName,
    String? customerLastName,
    String? customerEmail,
    required String customerRecipientNumber,
    String? webhookUrl
  })async {

    final authCredential = await GatewayCredentials().getAccessToken(baseUrl: BASE_URL, clientId: clientId, clientSecret: clientSecret);

    final requestBody = <String, dynamic>{
      "amount":currencyCode.toUpperCase()=="XOF"?amount.toInt():amount,
      "currency_code":currencyCode,
      "operator_code":paymentMethodCode,
      "merchant_trans_id": merchantTransId,
      "designation": designation,
      "customer_recipient_number":customerRecipientNumber
    };

    if(merchantTransData != null){
      requestBody['merchant_trans_data'] = merchantTransData;
    }

    if(customerEmail != null){
      requestBody['customer_email'] = customerEmail;
    }

    if(customerFirstName != null){
      requestBody['customer_firstname'] = customerFirstName;
    }

    if(customerLastName != null){
      requestBody['customer_lastname'] = customerLastName;
    }

    if(webhookUrl != null){
      requestBody['webhook_url'] = webhookUrl;
    }

    final url = Uri.parse("$API_URL/merchants/create_payout");

    final response = await post(url,
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authCredential.accessToken}'
        }
    );
    if(response.statusCode == 200){
      final Map<String, dynamic> json  = jsonDecode(response.body);
      final bool success = json['success'];
      if(success){
        final Map<String, dynamic> data = json['data'];
        return GatewayTransaction.fromJson(data);
      }else{

        throw GatewayException(
            message: json.containsKey('message')?json['message']:'',
            error: json.containsKey('error')?json['error']:'',
            code: json.containsKey('code')?json['code']:'',
            status: json.containsKey('status')?json['status']:''
        );
      }
    }else{

      if(response.headers['content-type'] == 'application/json'){
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


}