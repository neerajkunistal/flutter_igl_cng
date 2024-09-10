List<PodDetailModel> podDetailListResponse(var json) {
  return List<PodDetailModel>.from(json.map((x) => PodDetailModel.fromJson(x)));
}

class PodDetailModel {
  dynamic pONo;
  String? lineItem;
  String? shortTextDescription;
  String? lineItemNetValue;
  String? consumedValue;
  String? consumedPercentage;

  PodDetailModel(
      {this.pONo,
        this.lineItem,
        this.shortTextDescription,
        this.lineItemNetValue,
        this.consumedValue,
        this.consumedPercentage});

  PodDetailModel.fromJson(Map<String, dynamic> json) {
    pONo = json['PONo'] ?? "";
    lineItem = json['LineItem'] ?? "";
    shortTextDescription = json['ShortTextDescription'] ?? "";
    lineItemNetValue = json['LineItemNetValue'] ?? "";
    consumedValue = json['ConsumedValue'] ?? "";
    consumedPercentage = json['ConsumedPercentage'] ?? "";
  }
}