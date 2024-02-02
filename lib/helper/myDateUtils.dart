import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDateUtils{
  // For getting Formatted time
  static String getFormattedTime({required BuildContext context,required String time}){
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    

    return TimeOfDay.fromDateTime(date).format(context);
  }

  // Get last message time(used in chat user card
  static Object getLastMessageTime({required BuildContext context,required String time}){
    final DateTime senttime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
final DateTime nowtime = DateTime.now();
if(nowtime.day == senttime.day && nowtime.month == senttime.month && nowtime.year == senttime.year){
  return TimeOfDay.fromDateTime(nowtime).format(context);
}
return '${senttime.day},$senttime.month';



}
// get month name from month index
static String _getMonth(DateTime date){
    switch(date.month){
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
        case 3:
      return 'Mar';
      case 4:
      return 'Apr';
      case 5:
      return 'May';
      case 6:
      return 'Jun';
      case 7:
      return 'Jul';

      case 8:
      return 'Aug';
      case 9:
      return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
}
}