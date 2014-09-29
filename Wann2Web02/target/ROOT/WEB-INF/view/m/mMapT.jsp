<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<title>완투의 웹&amp;하이브리드앱 - 지도(Map) 구현</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="http://code.jquery.com/mobile/1.4.3/jquery.mobile-1.4.3.min.css" rel="stylesheet"/>
	<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
	<script src="http://code.jquery.com/mobile/1.4.3/jquery.mobile-1.4.3.min.js"></script>

	<script src="https://apis.skplanetx.com/tmap/js?version=1&format=javascript&appKey=f91ec8c0-9f7f-3fa5-a9d1-8620b8f0c53e" type="text/javascript"></script>

	<style type="text/css">
		#msg {
			font-size: 0.9em;
		}
		.mapArea {
			padding: 10px;
			width: auto;
		}
	</style>
</head>
<body>
 
	<div data-role="page" id="pageMain">
		
		<div data-role="header">
			<h1>모바일웹 T-맵</h1>
		</div>
		
		<div data-role="navbar">
			<ul>
				<c:forEach items="${listNavi}" var="list" varStatus="status">
					<c:if test="${status.index == menuIdx}">
						<li><a href="/m/mMap${list.mapType}" class="ui-btn-active" data-ajax="false">${list.menuNm}</a></li>
					</c:if>
					<c:if test="${status.index != menuIdx}">
						<li><a href="/m/mMap${list.mapType}" data-ajax="false">${list.menuNm}</a></li>
					</c:if>
				</c:forEach>
			</ul>
		</div>
		
		<div data-role="main" class="ui-content" style="height:100%;padding:4px;">
			<div class="ui-grid-c">
				<div class="ui-block-a" data-type="horizontal" data-mini="true">
					<input type="text" name="city" value="" placeholder="시/군" data-mini="true" style="margin:0;padding:0">
				</div>
				<div class="ui-block-b" data-type="horizontal" data-mini="true">
					<input type="text" name="gu" value="" placeholder="구" data-mini="true" style="margin:0;padding:0">
				</div>
				<div class="ui-block-c" data-type="horizontal" data-mini="true">
					<input type="text" name="dong" value="" placeholder="동" data-mini="true" style="margin:0;padding:0">
				</div>
				<div class="ui-block-d" data-type="horizontal" data-mini="true">
					<input type="text" name="bunji" value="" placeholder="번지" data-mini="true" style="margin:0;padding:0">
				</div>
			</div>
			<div class="ui-grid-a">
				<div class="ui-block-a" data-type="horizontal" data-mini="true">
					<button onclick="showAddrLocation()" style="margin:0;padding:0">주소위치</button>
				</div>
				<div class="ui-block-b" data-type="horizontal" data-mini="true">
					<button onclick="showCurrLocation()" style="margin:0;padding:0">현위치</button>
				</div>
			</div>
			<div id="msg" class="msg"></div>
			<div id="mapCanvas" class="mapArea"></div>
			<div id="msg2" class="msg"></div>
			<div id="mapCanvas2" class="mapArea"></div>
		</div>
		
		<div data-role="footer" data-position="fixed">
			<h1>Wann2 Books</h1>
		</div>
				
	</div>
 
	<script type="text/javascript" charset="utf-8">
	
	 	var watchId;
	 	
	 	//.live() is deprecated, suggestion is to use .on() in jQuery 1.7+ :
		$(document).on("pageinit", "#pageMain",  function() {
			
			if (!navigator.geolocation){
				$("#msg").html("사용자의 브라우저는 지오로케이션을 지원하지 않습니다.");
			    return;
			}
			
			$("#msg").html( "맵 준비");
			$("#mapCanvas").css("height",$(window).height()-370+"px");
			$("#mapCanvas2").css("height",$(window).height()-370+"px");
			$("#mapCanvas").data("first", "true");
			$("#mapCanvas2").data("first", "true");
			
			var options = {
					timeout				: 60000, 
					maximumAge			: 0, //0: 캐시 사용하지않고 현재 위치 수집 
					enableHighAccuracy	: true
			};

			watchId = navigator.geolocation.watchPosition(onSuccess, onError, options);
		});
	
		$(document).on("pageremove", "#pageMain",  function() {
			$("#msg").html( "맵 제거");
			navigator.geolocation.clearWatch(watchId);
		});
	
		var markerLayer;
		
		function onSuccess(position) {
			
			lat = position.coords.latitude;
			lng = position.coords.longitude;
			
			$("#msg").html( "위도: " + lat + " / 경도: " + lng );
	
			if( $("#mapCanvas").data("first") == "true" ) {
				$("#mapCanvas").data("first", "false");

				// 변수명 앞에 var를 없애 map을 전역변수로 선언
				map = new Tmap.Map({div:"mapCanvas", width:"auto", height:$(window).height()-370+"px"});
			}

			var lonlat = new Tmap.LonLat(lng, lat).transform("EPSG:4326", "EPSG:3857");
			
			map.setCenter(lonlat, 19);
			map.addControl(new Tmap.Control.KeyboardDefaults());
			map.addControl(new Tmap.Control.MousePosition());
			map.addControl(new Tmap.Control.OverviewMap());
			
			var markerLayer = new Tmap.Layer.Markers();
			map.addLayer(markerLayer);
			
			var size = new Tmap.Size(10, 10);
			var offset = new Tmap.Pixel(-(size.w/2), -(size.h/2));
			var icon = new Tmap.Icon('/image/ico_spot_b.png', size, offset); 
			var marker = new Tmap.Marker(lonlat, icon);
			markerLayer.addMarker(marker);
		}
	
		function onError(error) {
			$("#msg").html( "에러코드: " + error.code + " 메러메시지: " + error.message );
		}
	
		function showCurrPosition(lat, lng) {
			
			if( $("#mapCanvas2").data("first") == "true" ) {
				$("#mapCanvas2").data("first", "false");

				// 변수명 앞에 var를 없애 map을 전역변수로 선언
				map2 = new Tmap.Map({div:"mapCanvas2", width:"auto", height:$(window).height()-370+"px"});
			}

			var lonlat = new Tmap.LonLat(lng, lat);
			
			map2.setCenter(lonlat, 16);
			map2.addControl(new Tmap.Control.KeyboardDefaults());
			map2.addControl(new Tmap.Control.MousePosition());
			map2.addControl(new Tmap.Control.OverviewMap());
			
			var markerLayer = new Tmap.Layer.Markers();
			map2.addLayer(markerLayer);
			var size = new Tmap.Size(30,40);
			var offset = new Tmap.Pixel(-(size.w/2), -(size.h/2));
			var icon = new Tmap.Icon('/image/ico_spot_b.png', size, offset); 
			var marker = new Tmap.Marker(lonlat, icon);
			markerLayer.addMarker(marker);

			var circle = new Tmap.Geometry.Circle(lonlat.lon, lonlat.lat, 100);
			var vLayerDrag = new Tmap.Layer.Vector();
			map2.addLayer(vLayerDrag);
			var circleFeature = new Tmap.Feature.Vector(circle, null);
			vLayerDrag.addFeatures([circleFeature]);
		}
		
		function showAddrLocation() {
			var city = $("input:text[name=city]").val();
			var gu = $("input:text[name=gu]").val();
			var dong = $("input:text[name=dong]").val();
			var bunji = $("input:text[name=bunji]").val();
			
			if (city != "" && gu != "" && dong != "") {
				var tData = new Tmap.TData();
				tData.getGeoFromAddress(encodeURI(city), encodeURI(gu), encodeURI(dong), encodeURI(bunji), "EPSG:3857");
				tData.events.register("onComplete", tData, onCompleteGetLonlatFromAddress);
			}
		}
		
		function onCompleteGetLonlatFromAddress(){
			var lng = jQuery(this.responseXML).find("lon").text();
			var lat = jQuery(this.responseXML).find("lat").text();
			
			showCurrPosition(lat, lng);
		}

	</script>

</body>
</html>