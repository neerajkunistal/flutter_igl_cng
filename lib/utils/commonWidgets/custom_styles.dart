import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/utils/res/app_color.dart';

class CustomStyleText{
  static TextStyle appBarStyle = TextStyle(
      color: Colors.blue.shade900,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat');


  static TextStyle navBarStyle = TextStyle(
      fontSize: 13.0,
      fontFamily: 'Montserrat'
  );

  static TextStyle checkOutStyle = TextStyle(
      fontSize: 18,
      color: Colors.pink
  );

  static TextStyle logOutStyle =  new TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat');

  static TextStyle logDialogStyle =  new TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat'
  );

  static TextStyle logInStyle =  TextStyle(
      color:Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      fontFamily:'Montserrat'
  );
  static TextStyle changeCompanyStyle = TextStyle(
      color:Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      fontFamily:'Montserrat'
  );
  static TextStyle changePasswordStyle = TextStyle(
      color:Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      fontFamily:'Montserrat'
  );
  static TextStyle yesNoStyle = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat'
  );

  static TextStyle loginStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold
  );
  static TextStyle checkInStyle = TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold
  );
  static TextStyle checkInOutDateInStyle = TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontFamily: 'Montserrat'
  );

  static TextStyle employeeDetailsStyle = TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold
  );

  static TextStyle presentStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold
  );

  static TextStyle userPresentStyle = TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold
  );
  static TextStyle leaveStatusStyle = TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold
  );

  static TextStyle leaveReasonStyle = TextStyle(
      color: Colors.black,
      fontSize: 12.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500
  );

  static TextStyle leaveTypeStyle = TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold
  );

  static TextStyle showSnackBarStyle = TextStyle(
      color: Colors.pink,
      fontSize: 14.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600
  );
  static TextStyle statusStyle = TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);
  static TextStyle updateStatusStyle = TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);
  static TextStyle remakeStyle = TextStyle(color: Colors.black,fontSize: 12.0, fontFamily: 'Montserrat',);

  static TextStyle haajriButtonStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);
  static TextStyle hrmMitraStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat');
  static TextStyle logoutTitleStyle = TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat');
  static TextStyle logoutStyle = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat');

  static TextStyle dataTableStyle = TextStyle(
    fontStyle: FontStyle.italic,
    color: Colors.white,
  );

  static TextStyle viewStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold
  );
  static TextStyle viewDetailsStyle = TextStyle(color: Colors.white,
      fontSize: 14.0,
      fontFamily: 'Montserrat'
  );
  static TextStyle submitStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);

}



Widget styleAppBar (){
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFF2D3194), Color(0xFF02A7E7)])),
  );
}

BoxDecoration gradientDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[AppColor.themeColor, AppColor.themeColor,])
);

BoxDecoration gradientGrayColorDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[Color(0xFFEEEDED), Color(0xFF8D8D8D)])
);

LinearGradient gradientColor =  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF2D3194), Color(0xFF02A7E7)]
);

BoxDecoration buttonFlat = BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
        color: AppColor.themeColor,
        width: 1),
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColor.white])
);