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

	<script type="text/javascript" src="https://apis.skplanetx.com/tmap/js?version=1&format=javascript&appKey=f91ec8c0-9f7f-3fa5-a9d1-8620b8f0c53e"></script>
	

	<style type="text/css">
		.msg {
			font-size: 0.9em;
		}
		.mapArea {
			padding: 10px;
			width: auto;
		}
	</style>

	<script type="text/javascript" charset="utf-8">
	
		$(document).ready(function() {
			initMap();
		});
		
		function initMap() {
			// map을 전역변수로 선언(변수명 앞에 var가 없음)
			map = new Tmap.Map({div:"mapCanvas", width:"auto", height:$(window).height()-230+"px"});
			showCurrLocation();
		}
	
		function showCurrLocation() {
			var geoOptions = {
					  enableHighAccuracy: true,
					  maximumAge        : 30000, 
					  timeout           : 27000
					};
		    if (navigator.geolocation) {
		        navigator.geolocation.getCurrentPosition(getCurrPosition, showError, geoOptions);
		    } else {
		    	$(".msg").html("이 브라우저는 Geolocation 지원하지 않습니다. Internet Explorer 9+, Firefox, Chrome, Safari and Opera만 지원합니다.");
		    }
		}

		function getCurrPosition(position) {
			var lat = position.coords.latitude; //위도
			var lng = position.coords.longitude; //경도

			showCurrPosition(lat, lng, 1);
		}

		function showError(error) {
		    switch(error.code) {
		        case error.PERMISSION_DENIED:
		        	$(".msg").html("사용자가 Geolocation 사용을 거부했습니다.");
		            break;
		        case error.POSITION_UNAVAILABLE:
		        	$(".msg").html("위치를 찾을 수 없습니다.");
		            break;
		        case error.TIMEOUT:
		        	$(".msg").html("위치를 찾는데 Time out 되었습니다.");
		            break;
		        case error.UNKNOWN_ERROR:
		        	$(".msg").html("알려지지 않은 에러가 발생했습니다.");
		            break;
		    }
		}		

		function showCurrPosition(lat, lng, flag) {
			
			var lonlat;
			
			if (flag == 1) {
				lonlat = new Tmap.LonLat(lng, lat).transform("EPSG:4326", "EPSG:3857");
			}
			if (flag == 2) {
				lonlat = new Tmap.LonLat(lng, lat);
			}
			
			map.setCenter(lonlat, 16);
			map.addControl(new Tmap.Control.KeyboardDefaults());
			map.addControl(new Tmap.Control.MousePosition());
			map.addControl(new Tmap.Control.OverviewMap());
			
			var markerLayer = new Tmap.Layer.Markers();
			map.addLayer(markerLayer);
			var size = new Tmap.Size(30,40);
			var offset = new Tmap.Pixel(-(size.w/2), -(size.h/2));
			var icon = new Tmap.Icon('/image/ico_spot_b.png', size, offset); 
			var marker = new Tmap.Marker(lonlat, icon);
			markerLayer.addMarker(marker);

			var circle = new Tmap.Geometry.Circle(lonlat.lon, lonlat.lat, 200);
			var vLayerDrag = new Tmap.Layer.Vector();
			map.addLayer(vLayerDrag);
			var circleFeature = new Tmap.Feature.Vector(circle, null);
			vLayerDrag.addFeatures([circleFeature]);
		}
		
		function showAddrLocation() {
			var city = encodeURI($("input:text[name=city]").val());
			var gu = encodeURI($("input:text[name=gu]").val());
			var dong = encodeURI($("input:text[name=dong]").val());
			var bunji = encodeURI($("input:text[name=bunji]").val());
			
			var tData = new Tmap.TData();
			tData.getGeoFromAddress(city, gu, dong, bunji, "EPSG:3857");
			tData.events.register("onComplete", tData, onCompleteGetLonlatFromAddress);
		}
		
		function onCompleteGetLonlatFromAddress(){
			var lng = jQuery(this.responseXML).find("lon").text();
			var lat = jQuery(this.responseXML).find("lat").text();
			
			showCurrPosition(lat, lng, 2);
		}

	</script>
</head>
<body>
 
	<div data-role="page">
		
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
			<div class="msg"></div>
			<div id="mapCanvas" class="mapArea"></div>
		</div>
		
		<div data-role="footer" data-position="fixed">
			<h1>Wann2 Books</h1>
		</div>
				
	</div>
 
</body>
</html>