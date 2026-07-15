List<ComplaintDescriptionModel> complaintDescriptionList(var json) {
   return List<ComplaintDescriptionModel>.from((json.map((x) => ComplaintDescriptionModel.fromJson(x))));
}

class ComplaintDescriptionModel {
  dynamic id;
  String? description;
  String? compTypeId;

  ComplaintDescriptionModel({this.id, this.compTypeId, this.description});

  factory ComplaintDescriptionModel.fromJson(Map<String, dynamic> json) {
    return ComplaintDescriptionModel(
       id: json['id'] ?? "",
       description : json['description'] ?? "",
       compTypeId: json['comp_type_id'] ?? "",
    );
  }

}
