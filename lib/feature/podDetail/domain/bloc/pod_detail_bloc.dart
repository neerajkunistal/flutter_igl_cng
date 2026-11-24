import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/feature/materialDetail/domain/model/igl_model.dart';
import 'package:flutter_igl_cng/feature/materialDetail/helper/material_detail_helper.dart';
import 'package:flutter_igl_cng/feature/podDetail/domain/model/pod_detail_model.dart';
import 'package:flutter_igl_cng/feature/podDetail/helper/pod_detail_helper.dart';

part 'pod_detail_event.dart';
part 'pod_detail_state.dart';

class PodDetailBloc extends Bloc<PodDetailEvent, PodDetailState> {
  List<PodDetailModel> podDetailList = [];
  IglModel iglData =  IglModel();
  bool isLoader =  false;
  TextEditingController searchController =  TextEditingController();

  PodDetailBloc() : super(PodDetailInitial()) {
    on<PodDetailPageLoadEvent>(_pageLoad);
    on<PodDetailSearchEvent>(_search);
  }

  _pageLoad(PodDetailPageLoadEvent event, emit) async {
    emit(PodDetailPageLoadState());
    podDetailList = [];
    searchController.text = "";
    isLoader =  false;
    if(iglData.url == null) {
      var iglRes =  await MaterialDetailHelper.fetchIglApiData(apiType: "PODetails");
      if(iglRes != null){
        iglData = iglRes;
      }
    }
    _completeEvent(emit);
  }

  _search(PodDetailSearchEvent event, emit) async {
    if(searchController.text.toString().isNotEmpty){
      podDetailList = [];
      isLoader =  true;
      _completeEvent(emit);
      var res =  await PodDetailHelper.fetchData(context: event.context,
          podNumber: searchController.text.toString(), iglData: iglData);
      if(res != null) {
        podDetailList =  res;
      }
      isLoader =  false;
      _completeEvent(emit);
    }
  }

  _completeEvent(Emitter<PodDetailState> emit) {
    emit(FetchPodDetailDataState(
        isLoader: isLoader,
        podDetailList: podDetailList,
        searchController : searchController
    ));
  }
}