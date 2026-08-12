import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
// 데이터를 추가 시키기위해 사용한다. ( pll 로 표시하면 뜬다.)뒤에 as latlng을 넣어준다.
import 'package:latlong2/latlong.dart' as latlng;
class GpsMap extends StatefulWidget {
  const GpsMap({super.key});

  @override
  State<GpsMap> createState() => _GpsMapState();
}

class _GpsMapState extends State<GpsMap> {
  //Property

  late Position currentPosition; 
  late int kindChoice;
  late double latData;  // 위도 정보
  late double longData; // 경도 정보
  late MapController mapController;
  late bool canrun;     // GPS의 신호를 받앗는지 안받았는지에 대한 참,거짓
  late List location;   // 지도에 글씨 쓰기


  Map<int, Widget> segmentWidgets = {
    0 : SizedBox(                         // 0번인 현위치 제작
      child:Text(
        '현위치',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ) ,
    ),
    1 : SizedBox(                         // 1번인 둘리뮤지엄 제작
      child:Text(
        '둘리뮤지엄',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ) ,
    ),
    2 : SizedBox(                         // 2번인 서대문형무소 제작
      child:Text(
        '서대문형무소역사관',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ) ,
    ),
  };

  
  @override
  void initState() {
    super.initState();
    kindChoice = 0;
    mapController = MapController();
    canrun = false;  // true 로 가져올 경우에 지도를 보여준다.
    location = ['현재 위치', '둘리 뮤지엄', '서대문 형무소 역사관'];
    checkLocationPermission(); // 함수를 하나 가지고 온다.
  }

// 함수를 실행시에는 위치 사용할지 말지 창이 뜨게끔 만들어준다.
  void checkLocationPermission()async{
      // 창을 하나 띄우기 위한 코드 입력
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      // 한번더 물어보는 코드
      permission = await Geolocator.requestPermission();
      // 아무것도 하지 않겟다는 코드  (아무것도 실행하지 않을경우 나의 위치는 사용되지 않는다.)
      if(permission == LocationPermission.deniedForever)return;
    }
    // 둘중에 하나를 고르게 되면 GPS 신호를 가져온다.
    // GPS를 쓴다고 할때 실행할 함수를 하나 만들어준다.
    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      getCurrentLocation();
    }
  }

Future<void> getCurrentLocation() async {
    try {
      // 1. 휴대폰에 기록된 마지막 위치를 먼저 가져옵니다 (수신 속도가 매우 빠름)
      Position? position = await Geolocator.getLastKnownPosition();

      // 2. 마지막 위치 정보가 없을 경우에만 5초 동안 새로운 GPS 수신 시도
      position ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium, // 실내에서도 수신 가능한 중간 정밀도
          timeLimit: Duration(seconds: 5),    // 5초 지나면 자동 타임아웃
        ),
      );

      currentPosition = position;

      setState(() {
        latData = currentPosition.latitude;
        longData = currentPosition.longitude;
        canrun = true;
      });

      print("=========> lat : $latData, long : $longData===");
    } catch (e) {
      print("위치 수신 실패: $e");
    }
  }

//   void getCurrentLocation()async{
//     // 신호를 가져올때까지 기다리는 코드
//     Position position = await Geolocator.getCurrentPosition();
//     // 순서를 알려주는 코드
//     currentPosition = position;
//     // 지도의 신호를 가져온다는 표시로 true 사용
//     canrun = true;

//     latData = currentPosition.latitude;
//     longData = currentPosition.longitude;
// //    print("=========> lat : $latData, long : $longData===");
//     setState(() {});
//   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Center(
          child: Column(
            children: [
              Text('GPS & Map'),
              CupertinoSegmentedControl(
                groupValue: kindChoice,
                children: segmentWidgets, 
                onValueChanged: (value) {
                  //위에서 만든 순서를 불러온다.
                  kindChoice = value;
                  // 현위치
                  if(kindChoice == 0){  // (0 번째의 위치 나의 위치)
                    getCurrentLocation();
                    latData = currentPosition.latitude;
                    longData = currentPosition.longitude;
                    // 지도가 움직이게 해주는 기능
                    mapController.move(
                      latlng.LatLng(latData, longData), 
                      17.0
                    );
                  }else if(kindChoice == 1){
                    // 좌표값 입력 (1 번째의 위치 둘리 뮤지엄)
                    latData = 37.65243153;
                    longData = 127.0276397;
                    mapController.move(
                      latlng.LatLng(latData, longData), 
                      17.0
                    );
                  }else{
                    // 좌표값 입력 (2 번째의 위치 서대문 형문소 역사관)
                    latData = 37.57244171;
                    longData = 126.9595412;
                    mapController.move(
                      latlng.LatLng(latData, longData), 
                      17.0
                    );
                  }
                  //print("asdasdasdasda");
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),

      // 삼항 연산자를 사용
      // GPS에서 신호를 받아왔을 경우 참인지 거짓인지 알려주기 위하여 작성
      body: canrun
      ? flutterMap()
      : Center(child: CircularProgressIndicator(),),
    );
  }// build
  Widget flutterMap(){
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: latlng.LatLng(latData,longData),
        initialZoom: 17.0
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.mega.gpsmapapp',
        ),
        MarkerLayer(
          markers : [
          Marker(
            width: 80,
            height: 80,
            point: latlng.LatLng(latData, longData), 
            child: Column(
              children: [
                SizedBox(
                  child: Text(
                    location[kindChoice],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Icon(Icons.pin_drop,
                size: 50,
                color: Colors.red,)
              ],
            )
            ),
          ],
        ),
      ]
    );
  }
}