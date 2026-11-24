part of 'request_bloc.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();
}

class RequestPageEvent extends RequestEvent {
  final BuildContext context;

  RequestPageEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class RequestSetRoutesEvent extends RequestEvent {
  final int index;
  final BuildContext context;

  RequestSetRoutesEvent({required this.index, required this.context});

  @override
  List<Object?> get props => [index, context];
}

class RequestUpdateStatusEvent extends RequestEvent {
  final int index;
  final BuildContext context;

  RequestUpdateStatusEvent({required this.index, required this.context});

  @override
  List<Object?> get props => [index, context];
}

class RequestUploadPhotoEvent extends RequestEvent {
  final int photoIndex;
  final BuildContext context;

  RequestUploadPhotoEvent({required this.photoIndex, required this.context});

  @override
  List<Object?> get props => [photoIndex, context];
}

class RequestImagePikerEvent extends RequestEvent {
  final BuildContext context;
  final String filePath;

  RequestImagePikerEvent({required this.context, required this.filePath});

  @override
  List<Object?> get props => [context, filePath];
}

class RequestConfirmEvent extends RequestEvent {
  final BuildContext context;
  final int index;

  RequestConfirmEvent({required this.index, required this.context});

  @override
  List<Object?> get props => [index, context];
}
