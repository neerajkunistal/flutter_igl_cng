import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_igl_cng/feature/home/helper/home_helper.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  List<BottomNavigationBarItem> _bottomNavigationBarItemList = [];
  List<BottomNavigationBarItem> get bottomNavigationBarItemList => _bottomNavigationBarItemList;

  int _bottomTabIndex = 0;
  int get bottomTabIndex => _bottomTabIndex;

  bool _isLoader =  false;
  bool get isLoader => _isLoader;

  RoleType _roleType =  RoleType.stationUser;
  RoleType get roleType => _roleType;

  List<Widget> _pageWidgetList = [];
  List<Widget> get pageWidgetList => _pageWidgetList;

  LoginDataModel _userData =  UserInfo.instance!.userData!;
  LoginDataModel get userData => _userData;

  List<DrawerModel> _drawerList = [];
  List<DrawerModel> get drawerList => _drawerList;

  Widget _childWidget = Container();
  Widget get childWidget => _childWidget;

  String _title =  "";
  String get title => _title;

  Widget _actionButtonWidget =  const SizedBox.shrink();
  Widget get actionButtonWidget => _actionButtonWidget;

  List<DrawerSubModel> _restaurantMenu = [];
  List<DrawerSubModel> get restaurantMenu => _restaurantMenu;


  HomeBloc() : super(HomeInitial()) {
     on<HomePageLoadEvent>(_pageLoad);
     on<HomeDrawerItemSelectedEvent>(_drawerItemSelected);
     on<HomeDrawerItemSubListSelectedEvent>(_drawerSublistSelected);
     on<HomeChangeBottomNavigationItemEvent>(_changeBottomNavigationBarIndex);
  }

  _pageLoad(HomePageLoadEvent event, emit) async {
    emit(HomePageLoadState());
    _bottomTabIndex = 0;
    _userData =  UserInfo.instance!.userData!;
    _roleType =  userData.roleType!;
    _bottomNavigationBarItemList = [];
    _restaurantMenu = [];
    _pageWidgetList = [];
    _title =  "Complaint ( ${userData.name} - ${userData.role} )";
    _childWidget = const DashboardPage();
    _actionButtonWidget =  const SizedBox.shrink();
    _drawerList  =  await HomeHelper.fetchDrawerList(context: event.context);
    _eventCompleted(emit);
  }


  _drawerItemSelected(HomeDrawerItemSelectedEvent event, emit) async {

    List<DrawerModel> tempList = drawerList;
    _drawerList = [];
    _eventCompleted(emit);

    for(int i = 0; i < tempList.length; i++){
      if(i == event.index){
        tempList[event.index].isSelected =  event.isSelected;
        if(tempList[event.index].sublist.isEmpty){
          _childWidget =  tempList[event.index].widget;
          _title  =  tempList[event.index].label;
          _actionButtonWidget = tempList[event.index].actionButtonWidget ??  const SizedBox.shrink();
        }
      } else{
        tempList[i].isSelected =  false;
        for(int j = 0; j < tempList[i].sublist.length; j++ ){
          tempList[i].sublist[j].isSelected =  false;
        }
      }
    }
    _drawerList = [];
    _eventCompleted(emit);
    _drawerList = tempList;
    _eventCompleted(emit);
  }

  _drawerSublistSelected(HomeDrawerItemSubListSelectedEvent event, emit) {
    List<DrawerModel> tempList = drawerList;
    _drawerList = [];
    _eventCompleted(emit);

    for(int i = 0; i < tempList.length; i++){
      if(i == event.listIndex){
        for(int j = 0; j <  tempList[i].sublist.length; j++ ){
          if(j == event.index){
            tempList[i].sublist[j].isSelected =  event.isSelected;
            _childWidget =  tempList[i].sublist[j].widget!;
            _title  =  tempList[i].sublist[j].label.toString();
            _actionButtonWidget = tempList[i].sublist[j].actionButtonWidget ?? const SizedBox.shrink();
          } else{
            tempList[i].sublist[j].isSelected =  false;
          }
        }
      }else{
        for(int j = 0; j <  tempList[i].sublist.length; j++ ){
          tempList[i].sublist[j].isSelected =  false;
        }
      }
    }
    _drawerList = tempList;
    _eventCompleted(emit);
  }

  _changeBottomNavigationBarIndex(HomeChangeBottomNavigationItemEvent event, emit) async {
    _bottomTabIndex =  event.index;
    _eventCompleted(emit);
  }

  _eventCompleted( Emitter<HomeState>emit )  {
    emit(FetchHomeDataState(isLoader: isLoader,
        bottomNavigationBarItemList: bottomNavigationBarItemList,
        bottomTabIndex: bottomTabIndex,
        roleType:  roleType,
        pageWidgetList:  pageWidgetList,
        drawerList: drawerList,
        childWidget: childWidget,
        title: title,
        actionButtonWidget: actionButtonWidget,
    ));
  }


}
