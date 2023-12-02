class GatewayTransaction {

  static final String CREATED = "CREATED";
  static final String SUCCESSFUL = "SUCCESSFUL";
  static final String FAILED = "FAILED";
  static final String PENDING = "PENDING";
  static final String INITIATED = "INITIATED";

  String? merchantAppId;
  String? reference;
  num? amount;
  String? currencyCode;
  String? recipientNumber;
  String? recipientName;
  String? recipientEmail;
  String? recipientPhotoUrl;
  String? designation;
  String? status;
  num? fees;
  String? paymentUrl;
  String? merchantTransId;
  String? merchantTransData; //merchant_trans_data
  bool? isPayin;
  bool? isWaiting;
  bool? isCompleted;
  String? merchantId;
  String? failureReason; //failure_reason
  String? operatorTransUrl; //operator_trans_url
  String? servicePaymentUrl; //service_payment_url
  String? operatorCode;
  String? webhookUrl;
  String? returnUrl;
  String? cancelUrl;
  String? updatedAt;
  String? createdAt;
  String? id;


  GatewayTransaction({
    this.id,
    this.merchantAppId,
    this.reference,
    this.amount,
    this.currencyCode,
    this.recipientNumber,
    this.recipientName,
    this.recipientEmail,
    this.recipientPhotoUrl,
    this.designation,
    this.status,
    this.fees,
    this.paymentUrl,
    this.merchantTransId,
    this.merchantTransData,
    this.isPayin,
    this.isWaiting,
    this.isCompleted,
    this.merchantId,
    this.failureReason,
    this.operatorTransUrl,
    this.webhookUrl,
    this.returnUrl,
    this.cancelUrl,
    this.servicePaymentUrl,
    this.operatorCode,
    this.updatedAt,
    this.createdAt
   });

  /**
   *  "id": "9aa74126-5244-487f-a61b-54e51f6e813c",
      "merchant_app_id": "884dc528-828d-11ee-9091-3e1ccfbb3bf4",
      "reference": "2303515291",
      "amount": 10,
      "currency_code": "XOF",
      "recipient_number": "2250556888385",
      "recipient_name": "Ange Bagui",
      "recipient_email": "angebagui@adjemin.com",
      "recipient_photo_url": null,
      "designation": "Paiement de facture",
      "status": "PENDING",
      "operator_trans_token": null,
      "fees": 0,
      "merchant_trans_id": "efffac20-db06-4e3c-92f1-3ddabb6ff306",
      "merchant_trans_data": null,
      "is_payin": true,
      "failure_reason": null,
      "operator_trans_url": "https://proxy.momoapi.mtn.com/collection/v1_0/requesttopay/9aa74126-5244-487f-a61b-54e51f6e813c",
      "webhook_url": "https://api.adjem.in/v3/invoice_payments/gateway/notify",
      "return_url": "https://successurl.com",
      "cancel_url": "https://failedurl.com",
      "is_waiting": true,
      "is_completed": false,
      "service_payment_url": "https://pay.adjemin.com/payments/2303515291",
      "operator_code": "mtn_ci",
      "created_at": "2023-11-19T22:03:52.000000Z",
      "updated_at": "2023-11-19T22:04:32.000000Z",
      "deleted_at": null
   */
  GatewayTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantAppId = json['merchant_app_id'];
    reference = json['reference'];
    amount = json['amount'];
    currencyCode = json['currency_code'];
    recipientNumber = json['recipient_number'];
    recipientName = json['recipient_name'];
    recipientEmail = json['recipient_email'];
    recipientPhotoUrl = json['recipient_photo_url'];
    designation = json['designation'];
    status = json['status'];
    fees = json['fees'];
    merchantTransId = json['merchant_trans_id'];
    merchantTransData = json['merchant_trans_data'];
    isPayin = json['is_payin'];
    failureReason = json['failure_reason'];
    operatorTransUrl = json['operator_trans_url'];
    webhookUrl = json['webhook_url'];
    returnUrl = json['return_url'];
    cancelUrl = json['cancel_url'];
    isWaiting = json['is_waiting'];
    isCompleted = json['is_completed'];
    servicePaymentUrl = json['service_payment_url'];
    operatorCode = json['operator_code'];
    merchantId = json['merchant_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchant_app_id'] = this.merchantAppId;
    data['reference'] = this.reference;
    data['amount'] = this.amount;
    data['currency_code'] = this.currencyCode;
    data['recipient_number'] = this.recipientNumber;
    data['recipient_name'] = this.recipientName;
    data['recipient_email'] = this.recipientEmail;
    data['recipient_photo_url'] = this.recipientPhotoUrl;
    data['designation'] = this.designation;
    data['status'] = this.status;
    data['fees'] = this.fees;
    data['merchant_trans_id'] = this.merchantTransId;
    data['merchant_trans_data'] = this.merchantTransData;
    data['is_payin'] = this.isPayin;
    data['failure_reason'] = this.failureReason;
    data['operator_trans_url'] = this.operatorTransUrl;
    data['webhook_url'] = this.webhookUrl;
    data['return_url'] = this.returnUrl;
    data['cancel_url'] = this.cancelUrl;
    data['is_waiting'] = this.isWaiting;
    data['is_completed'] = this.isCompleted;
    data['merchant_id'] = this.merchantId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

