import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
part 'complaint_number_event.dart';

part 'complaint_number_state.dart';

class ComplaintNumberBloc
    extends Bloc<ComplaintNumberEvent, ComplaintNumberState> {

  bool isLoader = false;
  TextEditingController complaintNumberController = TextEditingController();
  String assignType = "";
  String complaintId = "";
  String vendorComplaintNumber = "";
  String complaintNumber = "";

  ComplaintNumberBloc() : super(ComplaintNumberInitial()) {
    on<ComplaintNumberPageLoadEvent>(_pageLoad);
    on<ComplaintNumberSubmitEvent>(_submit);
  }

  _pageLoad(ComplaintNumberPageLoadEvent event, emit) async {
    emit(ComplaintNumberPageState());
    isLoader = false;
    assignType = event.assignType;
    complaintId = event.complaintId;
    complaintNumberController.text = "";
    complaintNumber = "";
    vendorComplaintNumber = event.vendorComplaintNumber;
    complaintNumberController.text =  vendorComplaintNumber;
    _eventComplete(emit);
  }

  _submit(ComplaintNumberSubmitEvent event, emit) async {
    BuildContext context =  event.context;
    if(complaintNumberController.text.toString().isEmpty){
      SnackBarErrorWidget(context).show(message: "Please enter complaint number");
      return;
    }
    isLoader =  true;
    complaintNumber = "";
    _eventComplete(emit);
    var res =  await ComplaintNumberHelper.addComplaintNumber(context: context,
        assignType: assignType, complaintId: complaintId,
        complaintNumber: complaintNumberController.text.toString());
    isLoader =  false;
    if(res != null)
    {
      vendorComplaintNumber =  complaintNumberController.text.toString();
      complaintNumber = vendorComplaintNumber;
      _eventComplete(emit);
/*      if (!event.context.mounted) return;
      Navigator.pop(event.context, "Completed");*/
    }
    complaintNumber = "";
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ComplaintNumberState> emit) {
    emit(FetchComplaintNumberDataState(assignType: assignType,
        complaintNumberController: complaintNumberController,
        isLoader: isLoader,
        complaintId: complaintId,
        vendorComplaintNumber: vendorComplaintNumber,
        complaintNumber: complaintNumber,
    ));
  }

}
