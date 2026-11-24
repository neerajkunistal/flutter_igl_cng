part of 'view_user_bloc.dart';

abstract class ViewUserState extends Equatable {
  const ViewUserState();
}

class ViewUserInitial extends ViewUserState {
  @override
  List<Object> get props => [];
}

class ViewUserPageLoadState extends ViewUserInitial {
  @override
  List<Object> get props => [];
}

class FetchViewUserDateState extends ViewUserInitial {
  final List<UserModel> userList;

  FetchViewUserDateState({required this.userList});

  @override
  List<Object> get props => [userList];
}
