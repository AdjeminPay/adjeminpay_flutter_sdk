class GatewayOperator {
  String? name;
  String? slug;
  String? countryCode;
  String? currencyCode;
  bool? isActivePayin;
  bool? isActivePayout;
  String? image;

  GatewayOperator(
      {
        this.name,
        this.slug,
        this.countryCode,
        this.currencyCode,
        this.isActivePayin,
        this.isActivePayout,
        this.image,
      });

  GatewayOperator.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    countryCode = json['country_code'];
    currencyCode = json['currency_code'];
    isActivePayin = json['is_active_payin'];
    isActivePayout = json['is_active_payout'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['country_code'] = this.countryCode;
    data['currency_code'] = this.currencyCode;
    data['is_active_payin'] = this.isActivePayin;
    data['is_active_payout'] = this.isActivePayout;
    data['image'] = this.image;
    return data;
  }
}