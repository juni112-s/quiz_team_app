import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/moviename.dart'; // MovieInfo 모델 파일 경로

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // 💾 1. GetStorage 로컬 저장소
  final box = GetStorage();

  // 📝 2. 검색 컨트롤러
  final TextEditingController _searchController = TextEditingController();

  // 🔍 3. 검색된 영화 결과 리스트
  List<MovieInfo> searchResult = [];

  // 📜 4. 최근 검색어 리스트
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    // 저장된 최근 검색어 불러오기
    List? saved = box.read<List>('recentSearches');
    if (saved != null) {
      recentSearches = List<String>.from(saved);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🔎 검색 실행 및 GetStorage 저장 함수
  void _performSearch(String query) {
    String trimmed = query.trim();
    if (trimmed.isEmpty) return;

    // A. 최근 검색어 리스트에 저장 (중복 제거 후 맨 앞에 추가)
      recentSearches.remove(trimmed);
      recentSearches.insert(0, trimmed);
      setState(() {});

      // 최근 검색어 5개만 유지
      if (recentSearches.length > 5) {
        recentSearches = recentSearches.sublist(0, 5);
      }

    // B. GetStorage에 저장
    box.write('recentSearches', recentSearches);

    // C. 검색 필터링 (제목, 배우, 감독 검색)
    _filterMovies(trimmed);
  }

  // 실시간 필터링 함수
  void _filterMovies(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        searchResult = [];
      } else {
        searchResult = MovieInfo.movieList.where((movie) {
          final titleMatch = movie.title.contains(query);
          final actorMatch = movie.mainActor.contains(query);
          final directorMatch = movie.director.contains(query);
          return titleMatch || actorMatch || directorMatch;
        }).toList();
      }
    });
  }

  // 최근 검색어 삭제
  void _removeRecentSearch(String keyword) {
    setState(() {
      recentSearches.remove(keyword);
    });
    box.write('recentSearches', recentSearches);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("영화 검색"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 1. 검색 입력 창 (TextField)
            TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterMovies(value); // 타이핑할 때마다 실시간 검색
              },
              onSubmitted: (value) {
                _performSearch(value); // 키보드 엔터 눌렀을 때 저장
              },
              decoration: InputDecoration(
                hintText: "영화 제목, 배우, 감독을 입력해 보세요.",
                prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterMovies('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                ),
              ),
            ),
            SizedBox(height: 16),

            // 📜 2. 최근 검색어 칩(Chip) 보여주기 (검색어가 없을 때만 표시)
            if (_searchController.text.isEmpty && recentSearches.isNotEmpty) ...[
              Text("최근 검색어", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: recentSearches.map((keyword) {
                  return Chip(
                    label: Text(keyword),
                    deleteIcon: Icon(Icons.close, size: 16),
                    onDeleted: () => _removeRecentSearch(keyword),
                    backgroundColor: Colors.deepPurple.shade50,
                    labelStyle: TextStyle(color: Colors.deepPurple),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
            ],

            // 🎬 3. 검색 결과 목록 (ListView)
            Expanded(
              child: _searchController.text.trim().isEmpty
                  ? Center(
                      child: Text("검색어를 입력해 주세요.", style: TextStyle(color: Colors.grey)),
                    )
                  : searchResult.isEmpty
                      ? Center(
                          child: Text("검색 결과가 없습니다.", style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.builder(
                          itemCount: searchResult.length,
                          itemBuilder: (context, index) {
                            final movie = searchResult[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    movie.imageRoute,
                                    width: 50,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(width: 50, height: 70, color: Colors.black12),
                                  ),
                                ),
                                title: Text(
                                  movie.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("${movie.director} | ${movie.mainActor}"),
                                trailing: Icon(Icons.chevron_right),
                                onTap: () {
                                  // 영화 검색 결과 클릭 시 디테일 팝업 or 확인 안내
                                  Get.defaultDialog(
                                    title: movie.title,
                                    middleText: "감독: ${movie.director}\n주연: ${movie.mainActor}\n상영시간: ${movie.runTimeInMinutes}분",
                                    textConfirm: "확인",
                                    confirmTextColor: Colors.white,
                                    buttonColor: Colors.deepPurple,
                                    onConfirm: () => Get.back(),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}