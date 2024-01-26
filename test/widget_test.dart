// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:adjeminpay_flutter_sdk/adjeminpay_flutter_sdk.dart';
import 'package:adjeminpay_flutter_sdk/src/network/gateway_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  GatewayTransaction? trans= null;

  test("Create checkout", ()async {
    trans = await GatewayRepository().createCheckout(
        clientId: "9abeadc0-7c34-44cb-a1c9-dbd78dade934",
        clientSecret: "XXiBGNqQFYxDVlfFMxE3VnzCluUJfsoXBKGQ77PU",
        merchantTransId: "${DateTime.now().microsecond}",
        amount: 100,
        currencyCode: "XOF",
        designation: "Paiement entrant");

    expect(trans is GatewayTransaction, true);
  });

  test("Complete checkout", ()async {
   if(trans != null){
     trans = await GatewayRepository().completeCheckout(
         clientId: "9abeadc0-7c34-44cb-a1c9-dbd78dade934",
         clientSecret: "XXiBGNqQFYxDVlfFMxE3VnzCluUJfsoXBKGQ77PU",
         merchantTransId: trans!.merchantTransId!,
         customerRecipientNumber: "2250556888385",
         paymentMethodCode: "mtn_ci");
     expect(trans is GatewayTransaction, true);
   }
  });
}
