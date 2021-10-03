/////////////////////// GoogleMapの表示 ///////////////////////

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
  if (typeof gon !== 'undefined') {
    initMap();
  }
}

function initMap(){
  // geocoderを初期化
  // geocoder = new google.maps.Geocoder()

  // 表示する地図の中心位置とズームレベルを定義
  let center_of_map = {
    lat: parseFloat(gon.center_of_map_lat),
    lng: parseFloat(gon.center_of_map_lng)
  };
  let zoom_level_of_map = gon.zoom_level_of_map;

  // 地図の作成、中心位置の設定
  map = new google.maps.Map(document.getElementById('googlemap'), {
    center: center_of_map,
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

  let mountains_on_map = gon.mountains_on_map;
  // 各mountainデータを格納する箱 obj
  let obj = {};
  // mountainデータを格納する箱 markerData
  let markerData = [];
  // markerDataにmountainデータをループ処理で格納
  for (let i = 0; i < mountains_on_map.length; i++) {
    obj = {
      id: mountains_on_map[i]['id'],
      name: mountains_on_map[i]['name'],
      elevation: mountains_on_map[i]['elevation'],
      lat: parseFloat(mountains_on_map[i]['peak_location_lat']),
      lng: parseFloat(mountains_on_map[i]['peak_location_lng'])
    };
    switch (mountains_on_map[i]['level']) {
      case "easy":
        obj['level'] = '初級';
        break;
      case "normal":
        obj['level'] = '中級';
        break;
      case "hard":
        obj['level'] = '上級';
        break;
    }
  markerData.push(obj)
  }

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


/////////////////////// 周辺施設検索 ///////////////////////

//位置情報を使って周辺検索
function getPlaces(){
  const lat = parseFloat(gon.center_of_map_lat);
  const lng = parseFloat(gon.center_of_map_lng);
  const location = new google.maps.LatLng(lat, lng);
  
  //初期化
  document.getElementById('results').innerHTML = "";
  placesList = new Array();
  
  //Mapインスタンス生成
  const map = new google.maps.Map(
    document.getElementById('googlemap'),
    {
      zoom: 13,
      center: location
    }
    );

  //登山口マーカーの表示
  //const location = new google.maps.LatLng(lat, lng);
  //const start_point_marker = new google.maps.Marker({
    //position: location,
    //map: map
  //  });

  //入力した検索範囲を取得
  const obj = document.getElementById("radiusInput");
  const radiusInput = Number(obj.options[obj.selectedIndex].value);
  
  //PlacesServiceインスタンス生成
  const service = new google.maps.places.PlacesService(map);

  //入力したKeywordを取得
  const keywordInput = document.getElementById("keywordInput").value;
  
  //周辺検索
  service.nearbySearch(
    {
      location: location,
      radius: radiusInput,
      keyword: keywordInput,
      language: 'ja'
    },
    // 以下で定義したdisplayResultsメソッドを使って検索結果の表示
    displayResults
  );

  //検索範囲の円を描く
  const circle = new google.maps.Circle(
    {
      map: map,
      center: location,
      radius: radiusInput,
      fillColor: '#ff0000',
      fillOpacity: 0.3,
      strokeColor: '#ff0000',
      strokeOpacity: 0.5,
      strokeWeight: 1
    }
  );
}

// webpackerでは、ビューからJavaScriptで宣言した関数は呼び出せない。
// js側でクリックを検知する。
document.addEventListener('DOMContentLoaded', () => {
  const button = document.getElementById("nearby-search")
  if (!button){ return false;}
  button.addEventListener("click", () => { getPlaces() })
})

/*
周辺検索の結果表示
※nearbySearchのコールバック関数
  results : 検索結果
  status ： 実行結果ステータス
  pagination : ページネーション
*/
function displayResults(results, status, pagination) {
    
  if(status == google.maps.places.PlacesServiceStatus.OK) {
  
    //検索結果をplacesList配列に連結
    placesList = placesList.concat(results);
    
    //pagination.hasNextPage==trueの場合、
    //続きの検索結果あり
    if (pagination.hasNextPage) {
      
      //pagination.nextPageで次の検索結果を表示する
      //※連続実行すると取得に失敗するので、
      //1秒くらい間隔をおく
      setTimeout(pagination.nextPage(), 1000);
    
    //pagination.hasNextPage==falseになったら
    //全ての情報が取得できているので、
    //結果を表示する
    } else {

      //ソートを正しく行うため、
      //ratingが設定されていないものを
      //一旦「-1」に変更する。
      for (let i = 0; i < placesList.length; i++) {
        if(placesList[i].rating == undefined){
          placesList[i].rating = -1;
        }
      }
      
      //ratingの降順でソート（連想配列ソート）
      placesList.sort(function(a,b){
        if(a.rating > b.rating) return -1;
        if(a.rating < b.rating) return 1;
        return 0;
      });
      
      //placesList配列をループして、
      //結果表示のHTMLタグを組み立てる
      let resultHTML = "<ul>";
      
      for (let i = 0; i < placesList.length; i++) {
        place = placesList[i];
        
        //ratingが-1のものは「---」に表示、それ以外は小数点第一位まで表示
        let rating = place.rating;
        if(rating == -1) {
            rating = "---";
        } else {
            rating = rating.toFixed(1);
        };
        
        //表示内容（評価＋名称）
        let content = "【評価:" + rating + "】 " + place.name;
        
        //クリック時にMapにマーカー表示するようにAタグを作成
      　resultHTML += "<li>" +
                    　"<a href=\"javascript: void(0);\"" +
                    　" onclick=\"createMarker(" +
                    　"'" + place.name + "'," +
                    　"'" + place.vicinity + "'," +
                    　place.geometry.location.lat() + "," +
                    　place.geometry.location.lng() + ")\">" +
                    　content +
                    　"</a>" +
                    　"</li>";
      }
      
      resultHTML += "</ul>";
      
      //結果表示
      document.getElementById("results").innerHTML = resultHTML;
    }
  
  } else {
    //エラー表示
    let results = document.getElementById("results");
    if(status == google.maps.places.PlacesServiceStatus.ZERO_RESULTS) {
      results.innerHTML = "見つかりませんでした。";
    } else if(status == google.maps.places.PlacesServiceStatus.ERROR) {
      results.innerHTML = "サーバ接続に失敗しました。";
    } else if(status == google.maps.places.PlacesServiceStatus.INVALID_REQUEST) {
      results.innerHTML = "リクエストが無効でした。";
    } else if(status == google.maps.places.PlacesServiceStatus.OVER_QUERY_LIMIT) {
      results.innerHTML = "リクエストの利用制限回数を超えました。";
    } else if(status == google.maps.places.PlacesServiceStatus.REQUEST_DENIED) {
      results.innerHTML = "サービスが使えない状態でした。";
    } else if(status == google.maps.places.PlacesServiceStatus.UNKNOWN_ERROR) {
      results.innerHTML = "原因不明のエラーが発生しました。";
    }

  }
}


//マーカー作成(vicinity : 近辺住所)
// windowで明示的にグローバル関数として定義
window.createMarker = function(name, vicinity, lat, lng){
  
  //マーカー表示する位置のMap表示
  const map = new google.maps.Map(document.getElementById('googlemap'), {
    zoom: 15,
    center: new google.maps.LatLng(lat, lng)
  });
  
  //マーカー表示
  const marker = new google.maps.Marker({
    map: map,
    position: new google.maps.LatLng(lat, lng)
  });
  
  //情報窓の設定
  const info = "<div style=\"min-width: 100px\">" +
            name + "<br />" + vicinity + "<br />" +
            "<a href=\"https://maps.google.co.jp/maps?q=" + encodeURIComponent(name + " " + vicinity) + "&z=15&iwloc=A\"" +
            " target=\"_blank\">⇒詳細表示</a><br />" +
            "<a href=\"https://www.google.com/maps/dir/?api=1&destination=" + lat + "," + lng + "\"" +
            " target=\"_blank\">⇒ルート検索</a>" +
            "</div>";
  
  //情報窓の表示
  const infoWindow = new google.maps.InfoWindow({
    content: info
  });
  infoWindow.open(map, marker);
  
  //マーカーのクリック時にも情報窓を表示する
  marker.addListener("click", function(){
    infoWindow.open(map, marker);
  });
}
