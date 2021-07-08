// //初期値
// var map;
// var marker = [];
// var data = [];
// var windows = [];
// var currentInfoWindow = null;

// function initMap() {
//   map = new google.maps.Map(document.getElementById('map'), { //GoogleMapを呼び出す処理
//     //GoogleMapの初期値を設定
//     center: { lat: 38.6460251, lng: 140.3427782 }, //中心点（緯度・経度）
//     zoom: 6.13, //拡大率
//     clickableIcons: false, //GoogleMapの標準のクリック機能をOFFにする。
//     // GoogleMapのスタイルを変更
//     styles: [
//       {
//             "stylers": [
//               { "visibility": "simplified" }
//             ]
//           },
//           {
//             "featureType": "water",
//             "elementType": "geometry.fill",
//             "stylers": [
//               { "hue": "#003bff" }
//             ]
//           },{
//             "featureType": "road.highway",
//             "stylers": [
//               { "visibility": "off" }
//             ]
//           },{
//             "featureType": "landscape",
//             "stylers": [
//               { "color": "#dbe8e5" }
//             ]
//           },{
//         "featureType": "poi.park",
//         "elementType": "labels.text",
//             "stylers": [
//               { "color": "#e6e6e6","visibility": "off" }
//             ]
//           },{
//             "featureType": "water",
//             "stylers": [
//               { "color": "#8ecdf0" }
//             ]
//           },{
//             "featureType": "transit.line",
//             "stylers": [
//               { "visibility": "off" }
//             ]
//           },{
//         "featureType": "poi.business",
//         "elementType": "labels.text",
//         "stylers": [
//           {
//             "visibility": "off"
//           }
//         ]
//       }
//     ]
//   });
//   //お城情報を読み込み
//   $.ajax({
//     url: "castles.json",
//     success: function (json) {
//       for (var i = 0; i <= json.length - 1; i++) {
//         data.push(
//           {
//             'location': json[i].location,
//             'name': json[i].name,
//             'lng': json[i].lng,
//             'lat': json[i].lat,
//             'comment': json[i].comment
//           }
//         );
//       };
//       for (var i = 0; i < data.length; i++) {
//         //吹き出しの追加
//         markerLatLng = { lng: data[i]['lng'], lat: data[i]['lat'] };
//         marker[i] = new google.maps.Marker({
//           position: markerLatLng,
//           map: map,
//           icon: 'icon.png' //オリジナルのアイコン名
//         });
//         function markerEvent(i) {
//           marker[i].addListener('click', function () { // マーカーをクリックしたとき
//             //開いているウィンドウがある場合は閉じる
//             if (currentInfoWindow) {
//               currentInfoWindow.close();
//             }
//             windows[i].open(map, marker[i]); // 吹き出しの表示
//             currentInfoWindow = windows[i];
//           });
//         }
//         windows[i] = new google.maps.InfoWindow({ //吹き出しの中身
//           content: '<p class="location">' + data[i]['location'] +'&nbsp;'+ data[i]['name'] + '</p><img class="pic" src="' + data[i]['pic'] + '"/><p>' + data[i]['comment'] + '</p></div>'
//         });
//         markerEvent(i); // マーカーにクリックイベントを追加
//       }
//     }
//   });
//   ajax
// }