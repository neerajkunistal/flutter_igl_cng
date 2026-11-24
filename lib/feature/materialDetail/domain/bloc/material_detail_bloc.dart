import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/materialDetail/domain/model/igl_model.dart';
import 'package:flutter_igl_cng/feature/materialDetail/domain/model/material_detail_model.dart';
import 'package:flutter_igl_cng/feature/materialDetail/helper/material_detail_helper.dart';

part 'material_detail_event.dart';
part 'material_detail_state.dart';

class MaterialDetailBloc extends Bloc<MaterialDetailEvent, MaterialDetailState> {
  List<MaterialDetailModel> materialDetailList = [];
  IglModel iglData =  IglModel();
  bool isLoader =  false;
  TextEditingController searchController =  TextEditingController();
  
  MaterialDetailBloc() : super(MaterialDetailInitial()) {
    on<MaterialDetailPageLoadEvent>(_pageLoad);
    on<MaterialDetailSearchEvent>(_search);
  }
  
  _pageLoad(MaterialDetailPageLoadEvent event, emit) async {
    emit(MaterialDetailPageLoadState());
    materialDetailList = [];
    searchController.text = "";
    isLoader =  false;
    if(iglData.url == null) {
      var iglRes =  await MaterialDetailHelper.fetchIglApiData(apiType: "Material Details");
      if(iglRes != null){
        iglData = iglRes;
      }
    }
    _completeEvent(emit);
  }

  _search(MaterialDetailSearchEvent event, emit) async {
    if(searchController.text.toString().isNotEmpty){
      materialDetailList = [];
      isLoader =  true;
      _completeEvent(emit);
      var res =  await MaterialDetailHelper.fetchData(context: event.context,
          materialNo: searchController.text.toString(), iglData: iglData);
      if(res != null) {
        materialDetailList =  res;
      }
      isLoader =  false;
      _completeEvent(emit);
    }
  }
  
  _completeEvent(Emitter<MaterialDetailState> emit) {
    emit(FetchMaterialDetailDataState(
        isLoader: isLoader,
        materialDetailList: materialDetailList,
        searchController : searchController
    ));
  }
}
