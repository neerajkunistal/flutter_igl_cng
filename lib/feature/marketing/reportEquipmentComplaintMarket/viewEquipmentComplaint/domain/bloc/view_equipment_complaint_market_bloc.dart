import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/domain/model/complaint_market_list_model.dart';
import 'package:flutter_igl_cng/feature/marketing/addAcknowledgeMarket/addAcknowledgeMarketComplaint/helper/add_acknowledge_market_helper.dart';
import 'package:flutter_igl_cng/feature/marketing/reviewComplaintMarket/domain/bloc/review_complaint_market_bloc.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/page/review_complaint_page.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:vibration/vibration.dart';

part 'view_equipment_complaint_market_event.dart';

part 'view_equipment_complaint_market_state.dart';


class ViewEquipmentComplaintMarketBloc extends Bloc<ViewEquipmentComplaintMarketEvent, ViewEquipmentComplaintMarketState> {

  List<ComplaintMarketModel> listOfComplaintData = [];
  final Map<int, List<ComplaintMarketModel>> _marketCache = {};

  static const int _marketTabCount = 4;

  int _selectTabIndex = 0;
  int get selectTabIndex => _selectTabIndex;

  MarketComplaintTab _tabFromIndex(int i) {
    if (i < 0 || i >= MarketComplaintTab.values.length) {
      return MarketComplaintTab.newComplaint;
    }
    return MarketComplaintTab.values[i];
  }

  MarketComplaintTab get currentMarketTab => _tabFromIndex(_selectTabIndex);


  String get currentTabName => currentMarketTab.name;

  LoginDataModel userData = LoginDataModel();

  DateTime startDate = DateTime.now().subtract(const Duration(days: 5));
  DateTime endDate = DateTime.now();

  List<int> complaintCount = [];

  bool isLoader = false;

  int index = 0;

  TextEditingController remarkController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController rectifyByController = TextEditingController();
  EquipmentComplaintType equipmentComplaintType = EquipmentComplaintType.marketing;


  final List<ReviewComplaintModel> _emptyReviewList = <ReviewComplaintModel>[];
  final ReviewComplaintModel _emptyReviewData = ReviewComplaintModel();

  ViewEquipmentComplaintMarketBloc() : super(ViewEquipmentComplaintMarketInitial()) {
    on<ViewEquipmentComplaintMarketPageLoadEvent>(_pageLoad);
    on<ViewEquipmentComplaintMarketSelectedTabIndexMarketEvent>(_selectTabMarket);
    on<ViewEquipmentComplaintMarketOpenMarketDetailEvent>(_openMarketDetail);
    on<ViewEquipmentComplaintMarketSelectedDateRangeEvent>(_selectDateRangeFilter);
    on<ViewEquipmentComplaintMarketSearchEvent>(_search);
    on<ViewEquipmentComplaintMarketSelectedComplaintEvent>(_selectComplaint);
    on<ViewEquipmentComplaintMarketSelectDateData>(_selectDate);
    on<ViewEquipmentComplaintMarketSelectTimeData>(_selectTime);
  }

  Future<List<ComplaintMarketModel>> _fetchMarketTab(MarketComplaintTab tab) async {
    switch (tab) {
      case MarketComplaintTab.newComplaint:
        return await AddAcknowledgeMarketComplaintHelper.fetchPendingAckData() ?? [];
      case MarketComplaintTab.ack:
        return await AddAcknowledgeMarketComplaintHelper.fetchAssignedListData() ?? [];
      case MarketComplaintTab.close:
        return await AddAcknowledgeMarketComplaintHelper.fetchPendingFinalClosureData() ?? [];
      case MarketComplaintTab.complete:
        return await AddAcknowledgeMarketComplaintHelper.fetchComplaintDetailData(
          fromDate: startDate.toString(),
          toDate: endDate.toString()) ?? [];
    }
  }

  Future<void> _loadAllMarketTabs() async {
    final results = await Future.wait<List<ComplaintMarketModel>>([
      for (int i = 0; i < _marketTabCount; i++) _fetchMarketTab(_tabFromIndex(i)),
    ]);
    for (int i = 0; i < results.length; i++) {
      _marketCache[i] = results[i];
    }
    listOfComplaintData = _marketCache[selectTabIndex] ?? [];
    _rebuildMarketCounts();
  }

  void _rebuildMarketCounts() {
    complaintCount = [
      for (int i = 0; i < _marketTabCount; i++) _marketCache[i]?.length ?? 0
    ];
  }



  _pageLoad(ViewEquipmentComplaintMarketPageLoadEvent event, emit) async {
    emit(ViewEquipmentComplaintMarketPageLoadState());
    listOfComplaintData = [];
    _marketCache.clear();
    complaintCount = [];
    isLoader = false;
    remarkController.text = "";
    dateController.text = "";
    timeController.text = "";
    rectifyByController.text = "";
    userData = UserInfo.instanceInit()!.userData!;
    index = 0;
    _selectTabIndex = 0;
    equipmentComplaintType = event.equipmentComplaintType;

    startDate = DateTime.now().subtract(const Duration(days: 5));
    endDate = DateTime.now();

    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    timeController.text =
        DateFormat('HH:mm:ss').format(DateTime.now()).toString();

    await _loadAllMarketTabs();
    _eventComplete(emit);
  }

  _selectTabMarket(ViewEquipmentComplaintMarketSelectedTabIndexMarketEvent event, emit) async {
    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 100);
    }
    _selectTabIndex = event.selectedTabIndex;

    listOfComplaintData = _marketCache[selectTabIndex] ?? [];
    _rebuildMarketCounts();
    _eventComplete(emit);

    emit(ViewEquipmentComplaintMarketPageLoadState());
    final fresh = await _fetchMarketTab(currentMarketTab);
    _marketCache[selectTabIndex] = fresh;
    listOfComplaintData = fresh;
    _rebuildMarketCounts();
    _eventComplete(emit);
  }

  // ── Market complaint tap -> uska hi ComplaintMarketModel review page ko de
  _openMarketDetail(
      ViewEquipmentComplaintMarketOpenMarketDetailEvent event, emit) async {
    BlocProvider.of<AddSparePartBloc>(event.context)
        .add(AddSparePartClearSparePartEvent());
    BlocProvider.of<AddScrapBloc>(event.context)
        .add(AddScrapClearScrapDataEvent(context: event.context));

    BlocProvider.of<ReviewComplaintMarketBloc>(event.context).add(
      ReviewComplaintMarketPageLoadEvent(
        context: event.context,
        equipmentComplaintType: equipmentComplaintType,
        complaintMarketData: event.marketData,
        complaintId: event.marketData.id.toString(),
      ),
    );

    BlocProvider.of<AddSparePartBloc>(event.context)
        .add(AddSparePartPageLoadEvent(context: event.context));

    var result = await Navigator.push(
      event.context,
      FadeRoute(page: ReviewComaplintPage(equipmentComplaintType: equipmentComplaintType)),
    );

    if (!event.context.mounted) return;
    if (result.toString() == "Completed") {
      add(ViewEquipmentComplaintMarketPageLoadEvent(
        context: event.context,
        equipmentComplaintType: equipmentComplaintType,
      ));
    } else {
      _eventComplete(emit);
    }
  }

  _search(ViewEquipmentComplaintMarketSearchEvent event, emit) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final k = event.keyword.toLowerCase();

    final base = _marketCache[selectTabIndex] ?? [];
    listOfComplaintData = event.keyword.isEmpty
        ? base
        : base.where((e) {
      return (e.tokenNo ?? '').toLowerCase().contains(k) ||
          (e.ticketNo ?? '').toLowerCase().contains(k) ||
          (e.complaintDescription ?? '').toLowerCase().contains(k) ||
          (e.complainantName ?? '').toLowerCase().contains(k) ||
          (e.complainDateTime ?? '').toLowerCase().contains(k);
    }).toList();
    _rebuildMarketCounts();
    _eventComplete(emit);
  }

  _selectDateRangeFilter(
      ViewEquipmentComplaintMarketSelectedDateRangeEvent event, emit) async {
    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 100);
    }
    listOfComplaintData = [];
    _marketCache.clear();
    startDate = event.fromDate;
    endDate = event.toDate;
    _eventComplete(emit);
    emit(ViewEquipmentComplaintMarketPageLoadState());

    await _loadAllMarketTabs();
    _eventComplete(emit);
  }

  _selectComplaint(ViewEquipmentComplaintMarketSelectedComplaintEvent event, emit) {
    index = event.index;
    _eventComplete(emit);
  }

  _selectDate(ViewEquipmentComplaintMarketSelectDateData event, emit) async {
    try {
      final DateTime? picked = await showDatePicker(
          context: event.context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime.now());
      if (picked != null) {
        dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectTime(ViewEquipmentComplaintMarketSelectTimeData event, emit) async {
    try {
      DateTime initialDate = timeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm:ss').parse(timeController.text.toString())
          : DateTime.now();

      final DateTime? time = await showCupertinoDatePicker(
        context: event.context,
        initialDateTime: initialDate,
      );

      if (time != null) {
        timeController.text = DateFormat('HH:mm:ss').format(time).toString();
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _eventComplete(Emitter<ViewEquipmentComplaintMarketState> emit) {
    emit(FetchViewEquipmentComplaintMarketDataState(
      reviewComplaintList: _emptyReviewList,   // placeholder (market unused)
      listOfComplaintData: listOfComplaintData,
      selectedTabIndex: selectTabIndex,
      startDate: startDate,
      endDate: endDate,
      isLoader: isLoader,
      complaintCount: complaintCount,
      remarkController: remarkController,
      index: index,
      reviewComplaintData: _emptyReviewData,   // placeholder (market unused)
      dateController: dateController,
      rectifyByController: rectifyByController,
      timeController: timeController,
    ));
  }
}
