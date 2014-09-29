<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<title>완투의 웹&amp;하이브리드앱 - 지도(Map) 구현</title>
	<link href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css" rel="stylesheet">
	<link href="/css/layout.css" rel="stylesheet">
	
	<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
	<script src="http://code.jquery.com/ui/1.11.1/jquery-ui.js"></script>

	<script src="http://apis.daum.net/maps/maps3.js?apikey=f193fb2a74088c7021b15ecc6e229649e1b31613" type="text/javascript"></script>

	<style type="text/css">
		.msg {
			padding: 10px;
		}
		.mapArea {
			padding: 10px;
			width: auto;
			height: 100%;
			border: 1px solid gray;
		}
	</style>

	<script type="text/javascript" charset="utf-8">
	
		$(document).ready(function() {
			showCurrLocation();
		});
		
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

			showCurrPosition(lat, lng);
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

		function showCurrPosition(lat, lng) {
			$(".msg").html("위도:"+lat+" / 경도:"+lng);

			var latlng = new daum.maps.LatLng(lat, lng);
			var zoomControl = new daum.maps.ZoomControl();
			var mapTypeControl = new daum.maps.MapTypeControl();
			
			//다음 지도를 생성합니다.
			var map = new daum.maps.Map(document.getElementById('mapCanvas'), {
			          center: latlng,
			          level: 4, //작을수록 확대됨
			          mapTypeId: daum.maps.MapTypeId.ROADMAP //ROADMAP(일반2D지도), SKYVIEW(위성사진), HYBRID(위성사진과 도로명 등의 지명 표시), TERRAIN(등고선과 물의 흐름 표시)
			});

			//원을 그립니다.
			var circle = new daum.maps.Circle({
				center : latlng,
				radius : 300,
				strokeColor: "#0000FF",
				strokeOpacity: 0.3,
				strokeWeight: 1,
				fillColor: "#0000FF",
				fillOpacity: 0.2
			});
			circle.setMap(map);

			//마커 아이콘을 표시할 위치를 지정합니다.
			var marker = new daum.maps.Marker({
				position: latlng
			});
			marker.setMap(map);
			
			//지도에 각종 컨트롤을 붙입니다.
			map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
			map.addControl(mapTypeControl, daum.maps.ControlPosition.TOPRIGHT);
		}
		
		function showAddrLocation() {
			var addr = $("input:text[name=addr]").val();
	        var url = "http://apis.daum.net/local/geo/addr2coord?apikey=0463eafe6662a5020b55b01578ad81f04cdba525&q="
	        		+encodeURI(addr)+"&output=json";
	        
	        if (addr != "") {
		        $.getJSON(url+"&callback=?", function(data) {
		        	
			        $.each(data.channel.item, function(i,item) {
			            var lat = item.lat;
			            var lng = item.lng;
						
						showCurrPosition(lat, lng);
					});
		        });
	        }
		}

	</script>
</head>
<body>
 
	<c:forEach items="${listNavi}" var="list" varStatus="status">
		<button onclick="javascript:self.location='/map${list.mapType}'"><span>${list.menuNm}</span></button>
	</c:forEach>
	<hr>
	
	<div id="map" style="height:80%;">
		<div>
			<button onclick="showCurrLocation()">현재 위치</button>
			<input type="text" name="addr" value="${listNavi[menuIdx].address}" placeholder="주소를 입력하세요.">
			<button onclick="showAddrLocation()">주소지 위치</button>
		</div>
		<div class="msg"></div>
		<div id="mapCanvas" class="mapArea"></div>
	</div>
	
</body>
</html>