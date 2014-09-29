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

	<script src="http://maps.google.com/maps/api/js?sensor=false&language=ko" type="text/javascript"></script>
	<script src="/js/jquery-ui-map-3.0-rc/ui/min/jquery.ui.map.full.min.js" type="text/javascript"></script>
	<script src="/js/jquery-ui-map-3.0-rc/ui/jquery.ui.map.extensions.js" type="text/javascript"></script>

	<style type="text/css">
		.msg {
			font-size: 0.9em;
		}
		.mapArea {
			padding: 10px;
			width: auto;
			border: 1px solid gray;
		}
	</style>

</head>
<body>

	<div data-role="page" id="pageMain">
		
		<div data-role="header">
			<h1>모바일웹 구글맵</h1>
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
			<input type="text" name="addr" value="${listNavi[menuIdx].address}" data-mini="true" style="margin:0;padding:0">
			<div class="ui-grid-a">
				<div class="ui-block-a" data-type="horizontal" data-mini="true">
					<button onclick="showAddrLocation()" style="margin:0;padding:0">주소위치</button>
				</div>
				<div class="ui-block-b" data-type="horizontal" data-mini="true">
					<button onclick="javascript:location.reload();" style="margin:0;padding:0">현위치</button>
				</div>
			</div>
			<div class="msg"></div>
			<div id="mapCanvas" class="mapArea"></div>
		</div>
		
		<div data-role="footer" data-position="fixed">
			<h1>Wann2 Books</h1>
		</div>
				
	</div>

	<script type="text/javascript" charset="utf-8">
	
	 	var watchId;
	 	
	 	//.live() is deprecated, suggestion is to use .on() in jQuery 1.7+ :
		$(document).on("pageinit", "#pageMain",  function() {
		
			$(".msg").html( "맵 시작");
			$("#mapCanvas").css("height",$(window).height()-240+"px");
			$("#mapCanvas").data("first", "true");
			var options = {
					timeout				: 60000, 
					maximumAge			: 0, //지정된 캐시를 사용하지 말고 반드시 실제 현재 위치를 수집 
					enableHighAccuracy	: true
			};
			watchId = navigator.geolocation.watchPosition(onSuccess, onError, options);
		});
	
		$(document).on("pageremove", "#pageMain",  function() {
			$(".msg").html( "맵 제거");
			navigator.geolocation.clearWatch(watchId);
		});

		function onSuccess(position) {
			
			lat = position.coords.latitude;
			lng = position.coords.longitude;
			
			$(".msg").html( "위도: " + lat + " / 경도: " + lng );
	
			if( $("#mapCanvas").data("first") == "true" ) {
				
				$("#mapCanvas").data("first", "false");
				
				var latlng = new google.maps.LatLng(lat, lng);
				$("#mapCanvas").gmap("destroy");
				$("#mapCanvas").gmap({
					"center"		: latlng, 
					"zoom"			: 15
				});
				
				var landMark = "http://google-maps-icons.googlecode.com/files/walking-tour.png";
		
				$("#mapCanvas").gmap("addMarker", {
					"position"		: latlng, 
					"icon"			: landMark
				});
				
				$("#mapCanvas").gmap("addMarker", {
					"position"		:latlng
				}).click(function() {
					$("#mapCanvas").gmap("openInfoWindow", {
						"content"	: "출발지점"
					}, this);
				});
				
				$("#mapCanvas").gmap("addShape", "Circle", { 
					"strokeWeight"	: 0, 
					"fillColor"		: "#008595", 
					"fillOpacity"	: 0.25, 
					"center"		: latlng, 
					"radius"		: 100, 
					"clickable"		: false 
				});

			} else {
				
				var latlng = new google.maps.LatLng(lat, lng);
				$("#mapCanvas").gmap("get", "map").panTo(latlng);
				$("#mapCanvas").gmap("get", "markers")[0].setPosition(latlng);
			}
		}
	
		function onError(error) {
			$(".msg").html( "에러코드: " + error.code + " 메러메시지: " + error.message );
		}

		function showCurrPosition(lat, lng) {
			$(".msg").html("위도:"+lat+" / 경도:"+lng);
			var myLatlng = new google.maps.LatLng(lat, lng);
			var myOptions = {
				zoom: 16,
				center: myLatlng,
				mapTypeId: google.maps.MapTypeId.ROADMAP //ROADMAP(일반2D지도), SATELLITE(위성사진), HYBRID(위성사진과 도로명 등의 지명 표시), TERRAIN(등고선과 물의 흐름 표시)
			}
			var map = new google.maps.Map(document.getElementById("mapCanvas"), myOptions);
			
			var marker = new google.maps.Marker( {
				position: myLatlng, 
				map: map 
			});
			marker.setMap(map);
	
			var myCity = new google.maps.Circle({
				  center: myLatlng,
				  radius: 200,
				  strokeColor: "#0000FF",
				  strokeOpacity: 0.3,
				  strokeWeight: 1,
				  fillColor: "#0000FF",
				  fillOpacity: 0.2
			});
			myCity.setMap(map);
		}
		
		function showAddrLocation() {
			var addr = encodeURI($("input:text[name=addr]").val());
			var lat = ""; //위도
			var lng = ""; //경도
	
			$.ajax({
				url      : "http://maps.googleapis.com/maps/api/geocode/json?address="+addr
						  +"&language=ko&sensor=true",
				cache    : true,
				async    : false,
				type     : "get",
				dataType : "json",
				contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
				success  : function(data, status) {
	
						lat = data.results[0].geometry.location.lat;
						lng = data.results[0].geometry.location.lng;
						
						showCurrPosition(lat, lng);
				},
				error: function (xhr, ajaxOptions, thrownError) {
					$(".msg").html("주소에 해당하는 위도/경도 좌표를 얻을 수 없습니다.");
				}
			});
		}
	</script>

</body>
</html>