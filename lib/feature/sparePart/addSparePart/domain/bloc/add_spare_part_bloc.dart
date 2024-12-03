import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/helper/mi_complaint_helper.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/helper/add_spare_part_helper.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/model/part_%20model.dart';

part 'add_spare_part_event.dart';
part 'add_spare_part_state.dart';

class AddSparePartBloc extends Bloc<AddSparePartEvent, AddSparePartState> {

  SparesModel sparesData =  SparesModel();
  UomTypeModel uomTypeData =  UomTypeModel();
  TextEditingController qtyController = TextEditingController();
  TextEditingController materialCodeController = TextEditingController();
  TextEditingController remarkCodeController = TextEditingController();
  bool isLoader = false;
  List<SparesModel> sparePartList = [];
  List<PartModel> partList = [];

  AddSparePartBloc() : super(AddSparePartInitial()) {
    on<AddSparePartPageLoadEvent>(_pageLoad);
    on<AddSparePartSelectPartEvent>(_selectSparePart);
    on<AddSparePartDeletePartEvent>(_deletePart);
    on<AddSparePartSubmitEvent>(_submit);
  }

  _pageLoad(AddSparePartPageLoadEvent event, emit) async {
    emit(AddSparePartPageLoadState());
    sparesData =  SparesModel();
    uomTypeData =  UomTypeModel();
    qtyController.text = "";
    materialCodeController.text = "";
    remarkCodeController.text = "";
    isLoader =  false;
    sparePartList = [];
    partList = [];
    var res = await MiComplaintHelper.fetchSpareData();
    if (res != null) {
      sparePartList = res;
    }
    _eventComplete(emit);

  }

  _selectSparePart(AddSparePartSelectPartEvent event, emit) {
      sparesData =  event.sparesData;
      _eventComplete(emit);
  }

  _deletePart(AddSparePartDeletePartEvent event, emit) {
    isLoader =  true;
    _eventComplete(emit);
    partList.removeAt(event.index);
    isLoader =  false;
    _eventComplete(emit);
  }

  _submit(AddSparePartSubmitEvent event, emit) async {
    var textFiledValidation =  await AddSparePartHelper.textFiledValidation(sparesData: sparesData,
        uomTypeData: uomTypeData,
        qty: qtyController.text.toString(),
        materialCode: materialCodeController.text.toString(),
        remarkCode: remarkCodeController.text.toString(), context: event.context);
    if(textFiledValidation == false){
      return;
    }
    isLoader =  true;
    _eventComplete(emit);

    partList.add(
      PartModel(
        sparesData: sparesData,
        qty: qtyController.text.toString(),
        materialCode: materialCodeController.text.toString(),
        remarkCode: remarkCodeController.text.toString(),
        uomTypeData: uomTypeData,
      )
    );
    isLoader =  false;
    _eventComplete(emit);
    Navigator.pop(!event.context.mounted ? event.context: event.context);
  }

  _eventComplete(Emitter<AddSparePartState> emit) {
    emit(FetchAddSparePartDataState(
        remarkCodeController: remarkCodeController,
        materialCodeController: materialCodeController,
        qtyController: qtyController,
        sparesData: sparesData,
        uomTypeData: uomTypeData,
        isLoader: isLoader,
        sparePartList: sparePartList,
        partList: partList,
    ));
  }
}
