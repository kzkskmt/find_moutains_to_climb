let map;
let marker = [];
let infoWindow = [];
// マーカーを消すためのcurrentInfoWindow
let currentInfoWindow;
let geocoder;

// 「InvalidValueError: initMap is not a function」への対策(api読込後、initMapしないとこのエラーが出る)
// window.onloadはページや画像などのリソース類を読み込んでから処理を実行する。
// googlemapを表示しないページでは実行しない（表示しない場合はcenter_of_mapが定義されていない）
window.onload = function () {
  if (typeof center_of_map !== 'undefined') {
    initMap();
  }
}

function initMap(){
  // geocoderを初期化
  // geocoder = new google.maps.Geocoder()

  // 地図の作成、中心位置の設定
  map = new google.maps.Map(document.getElementById('googlemap'), {
    center: center_of_map, // 日本の中心に緯度経度を設定
    zoom: zoom_level_of_map
  });

  // 検索窓の作成とリンクの設定
  const input = document.getElementById("pac-input");
  const searchBox = new google.maps.places.SearchBox(input);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
  // 検索結果から表示範囲を変更する
  map.addListener("bounds_changed", () => {
    searchBox.setBounds(map.getBounds());
  });
  // 検索予測が選択された場合、その情報を取得し表示する
  searchBox.addListener("places_changed", () => {
    const places = searchBox.getPlaces();

    if (places.length == 0) {
    return;
    }
    const bounds = new google.maps.LatLngBounds();
    places.forEach((place) => {
    if (!place.geometry || !place.geometry.location) {
      console.log("Returned place contains no geometry");
      return;
    }
    console.log(place.geometry.viewport)

    if (place.geometry.viewport) {
      bounds.union(place.geometry.viewport);
    } else {
      bounds.extend(place.geometry.location);
    }
    });
    map.fitBounds(bounds);
  });

  // markerDataに入っているデータのピンを立てる。(googlemapに@mountainsのピンを立てる)
  for (let i = 0; i < markerData.length; i++) {
    markerLatLng = new google.maps.LatLng({lat: markerData[i]['lat'], lng: markerData[i]['lng']}); // 緯度経度のデータ作成
    marker[i] = new google.maps.Marker({ // マーカーの追加
      position: markerLatLng, // マーカーを立てる位置を指定
      map: map // マーカーを立てる地図を指定
    });

    // マーカーに表示する内容を設定
    contentStr = 
      '<div name="marker" class="map">' +
      '<a href="/mountains/' + markerData[i]['id'] + '" data-turbolinks="false">' +
        markerData[i]['name'] +
      '</a>' +
      '<p class="mb-0">' + '標　高：' + markerData[i]['elevation'] + 'm' + '</p>' +
      '<p class="mb-0">' + '難易度：' + markerData[i]['level'] + '</p>' +
      '</div>'
      ;

    // 吹き出しの追加
    infoWindow[i] = new google.maps.InfoWindow({
      content: contentStr // 吹き出しに表示する内容をセット
    });

    markerEvent(i); // マーカーにクリックイベントを追加
  }
}

// マーカーにクリックイベントを追加
function markerEvent(i) {
  marker[i].addListener('click', function() { // マーカーをクリックしたとき
  if (currentInfoWindow) { // 表示している吹き出しがあれば閉じる
    currentInfoWindow.close();
  }
  infoWindow[i].open(map, marker[i]); // 吹き出しの表示
  currentInfoWindow = infoWindow[i]
  });
}

// 住所から座標変換してくれるgeocode
// function codeAddress(){
//   // 入力を取得
//   let inputAddress = document.getElementById('address').value;

//   // geocodingしたあとmapを移動
//   geocoder.geocode( { 'address': inputAddress}, function(results, status) {
//   if (status == 'OK') {
//     // map.setCenterで地図が移動
//     map.setCenter(results[0].geometry.location);
//     map.setZoom(10);
//   } else {
//     alert('Geocode was not successful for the following reason: ' + status);
//   }
//   });
// }