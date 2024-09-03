List<RegistrationModel> registrationListResponse(var json) {
  return List<RegistrationModel>.from(
      json.map((x) => RegistrationModel.fromJson(x)));
}

class RegistrationModel {
  String? id;
  String? intentName;
  String? isDisplay;
  String? redirectUrl;
  dynamic label;
  String? showOnDashboard;
  dynamic displayOrder;

  RegistrationModel(
      {this.id,
      this.intentName,
      this.isDisplay,
      this.redirectUrl,
      this.label,
      this.showOnDashboard,
      this.displayOrder});

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      id: json['id'] ?? "",
      intentName: json['intent_name'] ?? "",
      isDisplay: json['is_display'] ?? "",
      redirectUrl: json['redirect_url'] ?? "",
      label: json['label'] ?? "",
      showOnDashboard: json['show_on_dashboard'] ?? "",
      displayOrder: json['display_order'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['intent_name'] = this.intentName;
    data['is_display'] = this.isDisplay;
    data['redirect_url'] = this.redirectUrl;
    data['label'] = this.label;
    data['show_on_dashboard'] = this.showOnDashboard;
    data['display_order'] = this.displayOrder;
    return data;
  }
}
