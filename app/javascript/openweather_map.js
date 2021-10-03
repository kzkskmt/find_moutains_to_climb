// $(function(){ ... }); は
// jQuery(document).ready(function(){ ... }); と同じ
// 渡された関数オブジェクトは、DOMの準備が完了した時に実行される。
// そして、この渡した関数オブジェクトは、実行時に「jQuery」そのものを受け取ることができる。
$(function () {
  if (typeof gon !== 'undefined') {
    const key = gon.openweather_map_key;
    const lat = gon.center_of_map_lat;
    const lng = gon.center_of_map_lng;

    if (typeof key !== 'undefined') {
      // APIリクエストurl作成（「onecall」では7日間の天気を取得できるが日付文字列データ(dt_txt)がレスポンスに入っていないため、「5dayweatherforecast」を利用する）
      const openweather_url = 'https://api.openweathermap.org/data/2.5/forecast?lat=' + lat + '&lon=' + lng + '&units=metric&appid=' + key;
      
      $.ajax({
        url: openweather_url,
        dataType: 'json',
        type: 'GET',
      })
      .done(function (data) {
        let insertHTML = '';
        let temp_tomorrow = '';

        // デフォルトでは3時間ごとの天気を取得するため、
        // 8の倍数でデータを取得することにより、24時間ごとの天気を取得する
        for (let i = 0; i <= 32; i = i + 8) {
          insertHTML += buildHTML(data, i);
        }
        $('#openweather').html(insertHTML);
        
        // 登山口周辺の天気予報も表示する。
        const city_id = data.city.id;
        const url_city = 'https://api.openweathermap.org/data/2.5/forecast?id=' + city_id + '&units=metric&appid=' + key;
        $.ajax({
          url: url_city,
          dataType: 'json',
          type: 'GET',
        })
        .done(function (data) {
          let insertHTML_city = '';
          for (let i = 0; i <= 32; i = i + 8) {
            insertHTML_city += buildHTML(data, i);
            // 明日（24時間後なので、i == 8の時）の気温を取得
            if (i == 8) {
            temp_tomorrow = data.list[i].main.temp;
          }
          }
          $('#openweather_city').html(insertHTML_city);

          const temp_summer = gon.outfit_1.lower_limit_temp;
          const temp_spring = gon.outfit_2.lower_limit_temp;

          // 明日の気温と服装の下限気温を比較し、最適な服装を表示
          if ( temp_summer < temp_tomorrow ){
            const outfit_1 = "<img class=\"img-fluid mb-3 mb-lg-0\" src=\"" + gon.outfit_1.image.url + "\" />";
            const outfit_1_link = "<p class=\"text-black-50\">こんな感じの服装でどうでしょうか。服装については<a data-turbolinks=\"false\" href=\"/outfits#" + gon.outfit_1.id + "\">こちら</a>から。</p>";
            $("#best_outfit").html(outfit_1);
            $("#best_outfit_link").html(outfit_1_link);
          } else if ( temp_spring < temp_tomorrow ) {
            const outfit_2 = "<img class=\"img-fluid mb-3 mb-lg-0\" src=\"" + gon.outfit_2.image.url + "\" />";
            const outfit_2_link = "<p class=\"text-black-50\">こんな感じの服装でどうでしょうか。服装については<a data-turbolinks=\"false\" href=\"/outfits#" + gon.outfit_2.id + "\">こちら</a>から。</p>";
            $("#best_outfit").html(outfit_2);
            $("#best_outfit_link").html(outfit_2_link);
          } else {
            const not_found = '<h4>...ぴったりな服装が見つかりませんでした。</h4>';
            const not_found_link = '<p class="text-black-50">服装については<a data-turbolinks="false" href="../outfits">こちら</a>から。</p>';
            $("#best_outfit").html(not_found);
            $("#best_outfit_link").html(not_found_link);
          }
        })
      })

      .fail(function (data) {
        alert('天気予報取得に失敗しました');
      });
    }
  }
});



// 日本語化 最高気温は四捨五入、最低気温は切り捨て
function buildHTML(data, i) {
  const Week = new Array('(日)', '(月)', '(火)', '(水)', '(木)', '(金)', '(土)');
  const date = new Date(data.list[i].dt_txt);
  date.setHours(date.getHours() + 9);
  const month = date.getMonth() + 1;
  const day = month + '/' + date.getDate() + Week[date.getDay()];
  const icon = data.list[i].weather[0].icon;
  const html =
  '<div class="weather-report text-black-50 mx-auto">' +
    '<img src="https://openweathermap.org/img/w/' + icon + '.png">' +
    '<span class="weather-date">' + day + "</span>" +
    '<div class="weather-temp-max">' + '最高：' + Math.round(data.list[i].main.temp_max) + "℃</div>" +
    '<span class="weather-temp-min">' + '最低：' + Math.floor(data.list[i].main.temp_min) + "℃</span>" +
  '</div>';
  return html
}