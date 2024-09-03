part of 'request_bloc.dart';

abstract class RequestState extends Equatable {
  const RequestState();
}

class RequestInitial extends RequestState {
  @override
  List<Object> get props => [];
}

class RequestPageLoadState extends RequestState {
  @override
  List<Object> get props => [];
}

class FetchRequestDataState extends RequestState {
  final bool isLoader;
  final List<RequestModel> requestList;
  final double currentLat;
  final double currentLong;
  final Set<Marker> currentLocationMarker;
  final Set<Polyline> polylines;
  final RequestModel requestData;
  final List<AssignmentModel> assignmentList;
  final File uploadTruckImage;
  final File uploadPhotoImage;
  final File uploadSlipImage;
  final bool isStartRoute;
  final TextEditingController scmQuantityController;

  const FetchRequestDataState({
    required this.isLoader,
    required this.requestList,
    required this.currentLat,
    required this.currentLong,
    required this.currentLocationMarker,
    required this.polylines,
    required this.requestData,
    required this.assignmentList,
    required this.uploadTruckImage,
    required this.uploadPhotoImage,
    required this.uploadSlipImage,
    required this.isStartRoute,
    required this.scmQuantityController,
  });

  @override
  List<Object> get props => [
        isLoader,
        requestList,
        currentLat,
        currentLong,
        currentLocationMarker,
        polylines,
        requestData,
        assignmentList,
        uploadPhotoImage,
        uploadTruckImage,
        isStartRoute,
        uploadSlipImage,
        scmQuantityController,
      ];
}
