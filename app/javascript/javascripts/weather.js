// API_KEY = "9a9c7c55a7c838cfca8bc14ad8339ab2"
// BASE_URL = 'http://api.openweathermap.org/data/2.5/forecast'
// lat = 
// lon =

// response = open(BASE_URL + "?lat=" + lat+ "&lon=" + lon + "&appid=" + API_KEY)
// puts JSON.pretty_generate(JSON.parse(response.read))




// h3.weather-text
//   = @user.prefecture

// #weather

javascript:

  $(function () {
    var API_KEY = "9a9c7c55a7c838cfca8bc14ad8339ab2"; // APIキー(環境変数)を変数に代入
    var city = "#{@user.prefecture}"; // 該当ユーザーの都道府県名を変数に代入
    // APIを読み込み変数に代入
    var url = 'https://api.openweathermap.org/data/2.5/forecast?q=' + city + ',jp&units=metric&APPID=' + API_KEY;

    $.ajax({
        url: url,
        dataType: 'json',
        type: 'GET',
      })
      .done(function (data) {
        var insertHTML = '';
        var cityName = data.city.name;
        $('#city-name').html(cityName);

        // デフォルトでは3時間ごとの天気を取得するため、
        // 8の倍数でデータを取得することにより、24時間ごとの天気を取得する
        for (var i = 0; i <= 32; i = i + 8) {
          insertHTML += buildHTML(data, i);
        }
        $('#weather').html(insertHTML);
      })
      .fail(function (data) {
        alert('天気予報取得に失敗しました');
      });
  });

  // 日本語化
  function buildHTML(data, i) {
    var Week = new Array('(日)', '(月)', '(火)', '(水)', '(木)', '(金)', '(土)');
    var date = new Date(data.list[i].dt_txt);
    date.setHours(date.getHours() + 9);
    var month = date.getMonth() + 1;
    var day = month + '/' + date.getDate() + Week[date.getDay()];
    var icon = data.list[i].weather[0].icon;
    var html =
      '<div class="weather-report">' +
        '<img src="https://openweathermap.org/img/w/' + icon + '.png">' +
        '<span class="weather-date">' + day + "</span>" +
        '<div class="weather-temp-max">' + '最高：' + Math.round(data.list[i].main.temp_max) + "℃</div>" +
        '<span class="weather-temp-min">' + '最低：' + Math.floor(data.list[i].main.temp_min) + "℃</span>" +
      '</div>';
    return html
  }







// $(function() {
//   var API_KEY = '9a9c7c55a7c838cfca8bc14ad8339ab2'
//   var city = 'Tokyo';
//   var lat = 'Tokyo';
//   var lon = 'Tokyo';
//   // var url = 'http://api.openweathermap.org/data/2.5/forecast?q=' + city + ',jp&units=metric&APPID=' + API_KEY;
//   var url = 'http://api.openweathermap.org/data/2.5/forecast?lat=' + lat + '&lon=' + lon + '&appid=' + API_key;
//   $.ajax({
//     url: url,
//     dataType: "json",
//     type: 'GET',
//   })
//   .done(function(data) {
//     var insertHTML = "";
//     var cityName = '<h2>' + data.city.name + '</h2>';
//     $('#city-name').html(cityName);
//     for (var i = 0; i <= 8; i = i + 2) {
//       insertHTML += buildHTML(data, i);
//     }
//     $('#weather').html(insertHTML);
//   })
//   .fail(function(data) {
//     console.log("失敗しました");
//   });
// });

// function buildHTML(data, i) {
//   var Week = new Array("（日）","（月）","（火）","（水）","（木）","（金）","（土）");
//   var date = new Date (data.list[i].dt_txt);
//   date.setHours(date.getHours() + 9);
//   var month = date.getMonth()+1;
//   var day = month + "月" + date.getDate() + "日" + Week[date.getDay()] + date.getHours() + "：00";
//   var icon = data.list[i].weather[0].icon;
//   var html =
//   '<div class="weather-report">' +
//     '<img src="http://openweathermap.org/img/w/' + icon + '.png">' +
//     '<div class="weather-date">' + day + '</div>' +
//     '<div class="weather-main">'+ data.list[i].weather[0].main + '</div>' +
//     '<div class="weather-temp">' + Math.round(data.list[i].main.temp) + '℃</div>' +
//   '</div>';
//   return html
// }