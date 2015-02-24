== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.

== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.

## proccess
add gemfile

	gem "gmaps4rails"
	gem "geocoder"

モデル作成

	$ rails g scaffold Album title:string description:string address:string latitude:float longitude:float date:string -f

モデルを編集

	class Post < ActiveRecord::Base
	  geocoded_by :address
	  after_validation :geocode
	end

JSのURLを指定

views/layouts/application.html.erbに以下をHEAD内に追加

	<script src="//maps.google.com/maps/api/js?v=3.13&amp;sensor=false&amp;libraries=geometry" type="text/javascript"></script>
	<script src='//google-maps-utility-library-v3.googlecode.com/svn/tags/markerclustererplus/2.0.14/src/markerclusterer_packed.js' type='text/javascript'></script>

unserscore.jsをhttp://underscorejs.org/underscore-min.jsからコピーしvender/assts/javascripts/underscore.jsとして保存

assets/javascripts/application.jsに以下を追記

	//= require underscore
	//= require gmaps/google

app/assets/stylesheets/scaffolds.css.scssの中身をコメントアウトしておく


写真を保存する用のモデル(post_picture)を作成

	$ rails g model picture picture_id:integer picture:string
	$ rake db:migrate

モデルを編集(album.rb)

	$ vi app/models/album.rb

	class Album < ActiveRecord::Base
	  geocoded_by :address
	  after_validation :geocode

	  has_many :pictures
	  accepts_nested_attributes_for :pictures
	end


モデルを編集(post_picture.rb)

	$ vi app/models/picture.rb

	class PostPicture < ActiveRecord::Base
	  mount_uploader :picture, PictureUploader
	  belongs_to :post
	end

## 地図ページを用意する

	$ rails g controller map index

表示するページを作成

	$ views/map/index.html.erb

	<div style='width: 800px;'>
	  <div id="map" style='width: 800px; height: 400px;'></div>
	</div>

	<script type="text/javascript">
	    handler = Gmaps.build('Google');
	    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
	      markers = handler.addMarkers(<%=raw @hash.to_json %>);
	      handler.bounds.extendWith(markers);
	      handler.fitMapToBounds();
	    });
	</script>

コントローラーを編集

	$ vi controllers/map_controller.rb

	class MapController < ApplicationController
	  def index
	    @albums = Album.all
	    @hash = Gmaps4rails.build_markers(@albums) do |album, marker|
	      marker.lat album.latitude
	      marker.lng album.longitude
	      marker.infowindow album.description
	      marker.json({title: album.title})
	    end
	  end
	end


## bootstrap3の適用
	http://techracho.bpsinc.jp/kazumasa-ogawa/2014_03_27/15892

Gemfileに以下を追加

	$ vi Gemfile

	gem 'twitter-bootstrap3-rails'

	$ bundle install
	
CSSとJSを追加する

	$ rails generate bootstrap:install static

レイアウトを作成

	$ rails g bootstrap:layout application fluid #レスポンシブ

グローバルメニューを追加、レスポンシブ

	$ vi app/views/layouts/application.html.erb

	<!DOCTYPE html>
	<html lang="en">
	  <head>
	    <meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title><%= content_for?(:title) ? yield(:title) : "YokohamaApp" %></title>
	    <%= csrf_meta_tags %>

	    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
	    <!--[if lt IE 9]>
	      <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/3.6.1/html5shiv.js" type="text/javascript"></script>
	    <![endif]-->

	    <%= stylesheet_link_tag "application", :media => "all" %>

	    <!-- For third-generation iPad with high-resolution Retina display: -->
	    <!-- Size should be 144 x 144 pixels -->
	    <%= favicon_link_tag 'apple-touch-icon-144x144-precomposed.png', :rel => 'apple-touch-icon-precomposed', :type => 'image/png', :sizes => '144x144' %>

	    <!-- For iPhone with high-resolution Retina display: -->
	    <!-- Size should be 114 x 114 pixels -->
	    <%= favicon_link_tag 'apple-touch-icon-114x114-precomposed.png', :rel => 'apple-touch-icon-precomposed', :type => 'image/png', :sizes => '114x114' %>

	    <!-- For first- and second-generation iPad: -->
	    <!-- Size should be 72 x 72 pixels -->
	    <%= favicon_link_tag 'apple-touch-icon-72x72-precomposed.png', :rel => 'apple-touch-icon-precomposed', :type => 'image/png', :sizes => '72x72' %>

	    <!-- For non-Retina iPhone, iPod Touch, and Android 2.1+ devices: -->
	    <!-- Size should be 57 x 57 pixels -->
	    <%= favicon_link_tag 'apple-touch-icon-precomposed.png', :rel => 'apple-touch-icon-precomposed', :type => 'image/png' %>

	    <!-- For all other devices -->
	    <!-- Size should be 32 x 32 pixels -->
	    <%= favicon_link_tag 'favicon.ico', :rel => 'shortcut icon' %>

	    <%= javascript_include_tag "application" %>
	    <script src="//maps.google.com/maps/api/js?v=3.13&amp;sensor=false&amp;libraries=geometry" type="text/javascript"></script>
	    <script src='//google-maps-utility-library-v3.googlecode.com/svn/tags/markerclustererplus/2.0.14/src/markerclusterer_packed.js' type='text/javascript'></script>
	  </head>
	  <body>

	<nav class="navbar navbar-default" role="navigation">
	  <div class="container-fluid">
	    <!-- Brand and toggle get grouped for better mobile display -->
	    <div class="navbar-header">
	      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
	        <span class="sr-only">Toggle navigation</span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	      </button>
	      <%= link_to "よこはま旅ナビ", { :controller => :top_pages, :action => :home }, { :class => "navbar-brand"} %>
	    </div>

	    <!-- Collect the nav links, forms, and other content for toggling -->
	    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
	      <ul class="nav navbar-nav">
	        <li class="active"><a href="#">Link <span class="sr-only">(current)</span></a></li>
	        <li><a href="#">Link</a></li>
	        <li class="dropdown">
	          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span></a>
	          <ul class="dropdown-menu" role="menu">
	            <li><a href="#">Action</a></li>
	            <li><a href="#">Another action</a></li>
	            <li><a href="#">Something else here</a></li>
	            <li class="divider"></li>
	            <li><a href="#">Separated link</a></li>
	            <li class="divider"></li>
	            <li><a href="#">One more separated link</a></li>
	          </ul>
	        </li>
	      </ul>
	      <form class="navbar-form navbar-left" role="search">
	        <div class="form-group">
	          <input type="text" class="form-control" placeholder="Search">
	        </div>
	        <button type="submit" class="btn btn-default">Submit</button>
	      </form>
	      <ul class="nav navbar-nav navbar-right">
	        <li><a href="#">Link</a></li>
	        <li class="dropdown">
	          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span></a>
	          <ul class="dropdown-menu" role="menu">
	            <li><a href="#">Action</a></li>
	            <li><a href="#">Another action</a></li>
	            <li><a href="#">Something else here</a></li>
	            <li class="divider"></li>
	            <li><a href="#">Separated link</a></li>
	          </ul>
	        </li>
	      </ul>
	    </div><!-- /.navbar-collapse -->
	  </div><!-- /.container-fluid -->
	</nav> 

	    <div class="container">
	      <div class="row">
	        <div class="col-lg-9">
	          <%= bootstrap_flash %>
	          <%= yield %>
	        </div>
	      </div><!--/row-->

	      <footer>
	        <p>&copy; W & S Company 2014</p>
	      </footer>

	    </div> <!-- /container -->

	  </body>
	</html>


## 静的ページを作成

	$ rails generate controller TopPages home --no-test-framework

トップページを編集し、地図ページヘリンクを貼る

	$ vi app/views/top_pages/home.html.erb

	<div class="jumbotron">
	  <h1>観光スポットを検索</h1>
	  <p><%= link_to "地図から探す", {:controller => :map, :action => :index}, { :class => "btn btn-primary btn-lg", :role => "button" } %></p>
	  <p><a class="btn btn-primary btn-lg" href="#" role="button">写真から</a></p>
	</div>


## 位置情報を取得させてマップ上に表示する

### DBからコントローラーが取得した値をjavascriptに渡す
DBからスポット情報をコントローラーが取得し、javascriptで参照してgoogle map上にピンを表示する  

Gemを追加

	# https://github.com/gazay/gon
	gem 'gon'

コントローラーでjsに渡したい値をgonに代入

	gon.albums = @albums

これでjs側でgon.albumsを呼びだせばok


#### 現在地とスポットをマップ上に表示する

	$ vi views/map/index.html.erb

	<div style='width: 90%;'>
	  <div id="map_canvas" style='height: 400px; width: 90%'></div>
	</div>

	<div id="area_name"></div>


	<script type="text/javascript">
		var image = new google.maps.MarkerImage(
			'http://waox.main.jp/png/source-bluedot.png',
			null, // size
			null, // origin
			new google.maps.Point( 8, 8 ), // anchor (move to center of marker)
			new google.maps.Size( 17, 17 ) // scaled size (required for Retina display icon)
		);

		var mapCanvas = new google.maps.Map(document.getElementById("map_canvas"));

		jQuery(function($) {
	 
	    // gps に対応しているかチェック
	    if (! navigator.geolocation) {
	        $('#map_canvas').text('GPSに対応したブラウザでお試しください');
	        return false;
	    }
	 
	    $('#map_canvas').text('GPSデータを取得します...');
	 
	    // gps取得開始
	    navigator.geolocation.getCurrentPosition(function(pos) {
	        // gps 取得成功
	        // google map 初期化
	        var mapCanvas = new google.maps.Map($('#map_canvas').get(0), {
	            center: new google.maps.LatLng(pos.coords.latitude, pos.coords.longitude),
	            mapTypeId: google.maps.MapTypeId.ROADMAP,
	            zoom: 17
	        });

	        // 現在位置にピンをたてる
	        var currentPos = new google.maps.LatLng(pos.coords.latitude, pos.coords.longitude);
	        var currentMarker = new google.maps.Marker({
				flat: true,//・・・・・・アイコンにtrueで影を付けない
				icon: image,
				map: mapCanvas,
				optimized: false,
				title: '現在地',  
				visible: true,
	            position: currentPos
	        });

	        currentMarker.setMap(mapCanvas);
	 
	        // 誤差を円で描く
	        new google.maps.Circle({
	            map: mapCanvas,
	            center: currentPos,
	            radius: pos.coords.accuracy, // 単位はメートル
	            strokeColor: '#0088ff',
	            strokeOpacity: 0.8,
	            strokeWeight: 1,
	            fillColor: '#0088ff',
	            fillOpacity: 0.2
	        });
	 
	        // 現在地にスクロールさせる
	       	mapCanvas.panTo(currentPos);

	       	//DBに登録されているスポットをマップ上にマーカー表示
	       	draw_spot(mapCanvas);

	       	//現在地の逆ジオコーディング(座標から住所)
	       	get_area_name(currentPos);
	 
	    }, function() {
	        // gps 取得失敗
	        $('#mapCanvas').text('GPSデータを取得できませんでした');
	        return false;
	   	});
	});

		function get_area_name(latLng_now){
			// 座標から住所名を取得
			var geocoder = new google.maps.Geocoder();
			geocoder.geocode({latLng: latLng_now}, function(results, status){
				if(status == google.maps.GeocoderStatus.OK){
				document.getElementById("area_name").innerHTML = results[0].formatted_address+'付近にいます';
				}
				else {
				// エラーの場合
				}
			});
		}

		function draw_spot(map) {
			var albums = gon.albums;
			console.log(mapCanvas);
			for (var i = 0; i < albums.length; i++) {
				var marker = new google.maps.Marker({
		    		position : new google.maps.LatLng(albums[i].latitude, albums[i].longitude),
		    		map: map
		    	});      		
			}
		}
	</script>

## CSSは別ファイルへ
mapのピンをスマホのgoogle mapっぽく表示  

[http://waox.main.jp/news/?p=3722](http://waox.main.jp/news/?p=3722)
	$ vi app/assets/stylesheets/map_index.css

	@-moz-keyframes pulsate {
	   from {
	        -moz-transform: scale(0.25);
	        opacity: 1.0;
	    }
	    95% {
	        -moz-transform: scale(1.3);
	        opacity: 0;
	    }
	    to {
	        -moz-transform: scale(0.3);
	        opacity: 0;
	    }
	}
	@-webkit-keyframes pulsate {
	    from {
	        -webkit-transform: scale(0.25);
	        opacity: 1.0;
	    }
	    95% {
	        -webkit-transform: scale(1.3);
	        opacity: 0;
	    }
	    to {
	        -webkit-transform: scale(0.3);
	        opacity: 0;
	    }
	}

	#map_canvas div[title="現在地"] {
	    -moz-animation: pulsate 1.5s ease-in-out infinite;
	    -webkit-animation: pulsate 1.5s ease-in-out infinite;
	    border:1pt solid #fff;
	    /* make a circle */
	    -moz-border-radius:51px;
	    -webkit-border-radius:51px;
	    border-radius:51px;
	    /* multiply the shadows, inside and outside the circle */
	    -moz-box-shadow:inset 0 0 5px #06f, inset 0 0 5px #06f, inset 0 0 5px #06f, 0 0 5px #06f, 0 0 5px #06f, 0 0 5px #06f;
	    -webkit-box-shadow:inset 0 0 5px #06f, inset 0 0 5px #06f, inset 0 0 5px #06f, 0 0 5px #06f, 0 0 5px #06f, 0 0 5px #06f;
	    box-shadow:inset 0 0 5px #06f, inset 0 0 5px #06f, inset 0 0 5px #06f, 0 0 5px #06f, 0 0 5px #06f, 0 0 5px #06f;
	    /* set the ring's new dimension and re-center it */
	    height:51px!important;
	    margin:-18px 0 0 -18px;
	    width:51px!important;
	}

	#map_canvas div[title="現在地"] img {
	    display:none;
	}

	@media only screen and (-webkit-min-device-pixel-ratio: 1.5), only screen and (device-width: 768px) {
	    #map_canvas div[title="現在地"] {
	        margin:-10px 0 0 -10px;
	    }
	}
