import 'reservation_info.dart';
import 'review_info.dart';

class UserInfo {
  String userID;
  List<ReviewInfo> reviewList;
  List<ReservationInfo> reservationList;

  UserInfo({
    required this.userID,
    List<ReviewInfo>? reviewList,
    List<ReservationInfo>? reservationList
  }): reviewList = reviewList ?? [],
      reservationList = reservationList ?? [];
}