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

  void checkLocationPermission()async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.deniedForever)return;
    }
    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      getCurrentLocation();
    }
  }

Future<void> getCurrentLocation() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();

      position ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium, 
          timeLimit: Duration(seconds: 5),    
        ),
      );

      currentPosition = position;

      setState(() {
        latData = currentPosition.latitude;
        longData = currentPosition.longitude;
        canrun = true;
      });

//      print("=========> lat : $latData, long : $longData===");
    } catch (e) {
//      print("위치 수신 실패: $e");
    }
  }
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
                  kindChoice = value;
                  //현위치 표시
                  if(kindChoice == 0){  // (0 번째의 위치 나의 위치)
                    getCurrentLocation();
                    latData = currentPosition.latitude;
                    longData = currentPosition.longitude;
                    mapController.move(
                      latlng.LatLng(latData, longData), 
                      17.0
                    );
                  }else if(kindChoice == 1){
                    // 1번째 좌표값
                    latData = 37.65243153;
                    longData = 127.0276397;
                    mapController.move(
                      latlng.LatLng(latData, longData), 
                      17.0
                    );
                  }else{
                    // 2번째 좌표값
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



  // ========================Fuction====================================
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