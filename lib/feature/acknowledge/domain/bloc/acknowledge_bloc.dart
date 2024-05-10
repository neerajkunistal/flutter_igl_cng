import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

part 'acknowledge_event.dart';

part 'acknowledge_state.dart';

class AcknowledgeBloc extends Bloc<AcknowledgeEvent, AcknowledgeState> {
  bool isLoader = false;
  List<AcknowledgeModel> acknowledgeList = [];

  AcknowledgeBloc() : super(AcknowledgeInitial()) {
    on<AcknowledgePageLoadEvent>(_pageLoad);
  }

  _pageLoad(AcknowledgePageLoadEvent event, emit) async {
    emit(AcknowledgePageLoadState());
    isLoader = false;
    acknowledgeList = [];

    var resAckow = await AddAcknowledgeComplaintHelper.fetchAcknowledgeData();
    if (resAckow != null) {
      acknowledgeList = resAckow;
    }
    _eventComplete(emit);
  }

  _eventComplete(Emitter<AcknowledgeState> emit) {
    emit(FetchAcknowledgeDataState(
      acknowledgeList: acknowledgeList,
      isLoader: isLoader,
    ));
  }
}
