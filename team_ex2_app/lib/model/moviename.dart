class ReviewInfo {
  final String writer;
  final String content;

  ReviewInfo({
    required this.writer,
    required this.content,
  });
}



  class MovieInfo {
    
  List<ReviewInfo> reviewList;
  String title, mainActor, director, imageRoute;
  DateTime firstReleaseDate;
  int runTimeInMinutes;
  ///장르 인덱스 정보
  ///0 : 액션 / 1 : 스릴러,공포 / 2 : 로맨스
  int genre;

  MovieInfo({
  List<ReviewInfo>? reviewList,
  required this.imageRoute,
  required this.firstReleaseDate,
  required this.title,
  required this.genre,
  required this.runTimeInMinutes,
  required this.mainActor,
  required this.director
  }):reviewList = reviewList ?? [];
  }