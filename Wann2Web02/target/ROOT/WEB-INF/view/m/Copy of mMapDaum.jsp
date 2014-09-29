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

	<script src="http://apis.daum.net/maps/maps3.js?apikey=f193fb2a74088c7021b15ecc6e229649e1b31613" type="text/javascript"></script>

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

	<script type="text/javascript" charset="utf-8">
	
	 	var watchId;
	 	
	 	//.live() is deprecated, suggestion is to use .on() in jQuery 1.7+ :
		$(document).on("pageinit", "#pageMain",  function() {
		
			$(".msg").html( "맵 시작");
			$("#mapCanvas").css("height",$(window).height()-240+"px");
			$("#mapCanvas").data("first", "true");
			var options = {
					timeout				: 60000, 
					maximumAge			: 120000, 
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
				
				var position = new daum.maps.LatLng(lat, lng);
				
				//다음 지도를 생성합니다.
				var map = new daum.maps.Map(document.getElementById('mapCanvas'), {
				          center: position,
				          level: 1, //작을수록 확대됨
				          mapTypeId: daum.maps.MapTypeId.ROADMAP //ROADMAP(일반2D지도), SKYVIEW(위성사진), HYBRID(위성사진과 도로명 등의 지명 표시), TERRAIN(등고선과 물의 흐름 표시)
				});

				//마커 아이콘을 표시할 위치를 지정합니다.
				var marker = new daum.maps.Marker({
					position: position
				});
				marker.setMap(map);
				
				//지도에 각종 컨트롤을 붙입니다.
				var zoomControl = new daum.maps.ZoomControl();
				var mapTypeControl = new daum.maps.MapTypeControl();
				map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
				map.addControl(mapTypeControl, daum.maps.ControlPosition.TOPRIGHT);
	
			} else {
				map.panTo(lat, lng);
				marker.setMap(map);
			}
		}
	
		function onError(error) {
			$(".msg").html( "에러코드: " + error.code + " 메러메시지: " + error.message );
		}

		function showCurrPosition(lat, lng) {
			$(".msg").html("위도:"+lat+" / 경도:"+lng);

			var position = new daum.maps.LatLng(lat, lng);
			
			//다음 지도를 생성합니다.
			var map = new daum.maps.Map(document.getElementById('mapCanvas'), {
			          center: position,
			          level: 4, //작을수록 확대됨
			          mapTypeId: daum.maps.MapTypeId.ROADMAP //ROADMAP(일반2D지도), SKYVIEW(위성사진), HYBRID(위성사진과 도로명 등의 지명 표시), TERRAIN(등고선과 물의 흐름 표시)
			});

			//원을 그립니다.
			var circle = new daum.maps.Circle({
				center : new daum.maps.LatLng(lat, lng),
				radius : 200,
				strokeColor: "#0000FF",
				strokeOpacity: 0.3,
				strokeWeight: 1,
				fillColor: "#0000FF",
				fillOpacity: 0.2
			});
			circle.setMap(map);

			//마커 아이콘을 표시할 위치를 지정합니다.
			var marker = new daum.maps.Marker({
				position: position
			});
			marker.setMap(map);
			
			//지도에 각종 컨트롤을 붙입니다.
			var zoomControl = new daum.maps.ZoomControl();
			var mapTypeControl = new daum.maps.MapTypeControl();
			map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
			map.addControl(mapTypeControl, daum.maps.ControlPosition.TOPRIGHT);
		}
		
		function showAddrLocation() {
			var addr = encodeURI($("input:text[name=addr]").val());
	        var url = "http://apis.daum.net/local/geo/addr2coord?apikey=0463eafe6662a5020b55b01578ad81f04cdba525&q="+addr+"&output=json";
	        
	        $.getJSON(url+"&callback=?", function(data) {
	        	
		        $.each(data.channel.item, function(i,item) {
		            var lat = item.lat;
		            var lng = item.lng;
					
					showCurrPosition(lat, lng);
				});
	        });
		}

	</script>
</head>
<body>
 
	<div data-role="page" id="pageMain">
		
		<div data-role="header">
			<h1>모바일웹 다음맵</h1>
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
	
</body>
</html>