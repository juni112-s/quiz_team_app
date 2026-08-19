class ReviewInfo {
  final String writer;
  final String content;

  ReviewInfo({
    required this.writer,
    required this.content, required movieTitle,
  });


  Map<String, dynamic> toJson() => {
        'writer': writer,
        'movieTitle': movieTitle,
        'content': content,
      };

  factory ReviewInfo.fromJson(Map<String, dynamic> json) {
    return ReviewInfo(
      writer: json['writer'] ?? 'User',
      movieTitle: json['movieTitle'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Null get movieTitle => null;
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
  
  static List<MovieInfo> movieList = [
      MovieInfo(
        imageRoute: "images/spiderman.png",
        title: '스파이더맨: 브랜드 뉴 데이',
        mainActor: '톰 홀랜드',
        director: '감독 이름',
        runTimeInMinutes: 145,
        firstReleaseDate: DateTime(2026, 7, 29),
        genre: 0,
      ),
      MovieInfo(
        imageRoute: "images/theoutlaws.png",
        title: '범죄도시',
        mainActor: '마동석',
        director: '강윤성',
        runTimeInMinutes: 120,
        firstReleaseDate: DateTime(2023, 5, 31),
        genre: 0,
      ),
      MovieInfo(
        imageRoute: "images/odyssey.png",
        title: '오디세이',
        mainActor: '주연 배우',
        director: '강윤성',
        runTimeInMinutes: 130,
        firstReleaseDate: DateTime(2026, 8, 1),
        genre: 0,
      ),
      MovieInfo(
        imageRoute: "images/titanic.png",
        title: '타이타닉',
        mainActor: '레오나르도 디카프리오',
        director: '제임스 카메론',
        runTimeInMinutes: 195,
        firstReleaseDate: DateTime(1998, 2, 20),
        genre: 2,
      ),
      MovieInfo(
        imageRoute: "images/abouttime.png",
        title: '어바웃 타임',
        mainActor: '돔놀 글리슨',
        director: '리처드 커티스',
        runTimeInMinutes: 123,
        firstReleaseDate: DateTime(2013, 12, 5),
        genre: 2,
      ),
      MovieInfo(
        imageRoute: "images/oncewewereus.png",
        title: '원스 위 워 어스',
        mainActor: '주연 배우',
        director: '감독 이름',
        runTimeInMinutes: 115,
        firstReleaseDate: DateTime(2026, 7, 1),
        genre: 2,
      ),      
      MovieInfo(
        imageRoute: "images/backroom.png",
        title: '백룸',
        mainActor: '추이텔 에지오프',
        director: '케인 파슨스',
        runTimeInMinutes: 100,
        firstReleaseDate: DateTime(2026, 5, 27),
        genre: 1,
      ),
      MovieInfo(
        imageRoute: "images/getout.png",
        title: '겟아웃',
        mainActor: '다니엘 칼루야',
        director: '조던 필',
        runTimeInMinutes: 104,
        firstReleaseDate: DateTime(2017, 5, 17),
        genre: 1,
      ),
      MovieInfo(
        imageRoute: "images/salmokji.png",
        title: '살목지',
        mainActor: '주연 배우',
        director: '감독 이름',
        runTimeInMinutes: 110,
        firstReleaseDate: DateTime(2026, 6, 1),
        genre: 1,
      ),      
  ];
}

// 예매 데이터 모델
class BookingInfo {
  String movieTitle;
  String bookingDate;

  BookingInfo({
    required this.movieTitle,
    required this.bookingDate,
  });

  Map<String, dynamic> toJson() => {
        'movieTitle': movieTitle,
        'bookingDate': bookingDate,
      };

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      movieTitle: json['movieTitle'] ?? '',
      bookingDate: json['bookingDate'] ?? '',
    );
  }
}

