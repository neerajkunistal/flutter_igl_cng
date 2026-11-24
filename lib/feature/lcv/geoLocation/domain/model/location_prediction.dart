List<LocationPrediction> fromJsonToLocPrediction(var json) {
  List jsonData = json;
  return jsonData.map((map) => LocationPrediction.fromJson(map)).toList();
}

class LocationPrediction {
  String? description;
  String? placeId;

  LocationPrediction({
    this.description,
    this.placeId,
  });

  factory LocationPrediction.fromJson(Map<String, dynamic> json) {
    return LocationPrediction(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}
