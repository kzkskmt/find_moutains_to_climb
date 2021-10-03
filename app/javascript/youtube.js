//参照 : https://developers.google.com/youtube/v3/docs/search/list

$(function () {
  if (typeof gon !== 'undefined') {
  const key = gon.youtube_key;
  const keyword = gon.youtube_keyword;
  const maxresult = gon.youtube_maxresult;
  const youtube_url = encodeURI('https://www.googleapis.com/youtube/v3/search?key=' + key + '&type=vodeo&maxResults=' + maxresult + '&q=' + keyword );

    if (typeof key !== 'undefined') {
      $.ajax({
        type: 'GET',
        url: youtube_url,
        datatype: 'json',
        success: function(json){
          num = json.items.length;
          for(let i = 0; i < num ; i++){
              let ID = json.items[i].id.videoId;
              $("#player").append('<div class="col-lg-6 mb-3"><iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/' + ID + '" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>');
          }
        },
        error: function(){
          alert('動画を取得できませんでした');
        }
      });
    }
  }
});