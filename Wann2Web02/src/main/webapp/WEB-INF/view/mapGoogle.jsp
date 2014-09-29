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

	<script src="http://maps.google.com/maps/api/js?sensor=false&language=ko" type="text/javascript"></script>
	<script src="/js/jquery-ui-map-3.0-rc/ui/min/jquery.ui.map.full.min.js" type="text/javascript"></script>
	<script src="/js/jquery-ui-map-3.0-rc/ui/jquery.ui.map.extensions.js" type="text/javascript"></script>

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
		        navigator.geolocation.getCurrentPosition(
		        		getCurrPosition, showError, geoOptions);
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
			  radius: 300,
			  strokeColor: "#0000FF",
			  strokeOpacity: 0.3,
			  strokeWeight: 1,
			  fillColor: "#0000FF",
			  fillOpacity: 0.2
		});
		myCity.setMap(map);
	}
	
	function showAddrLocation() {
		var addr = $("input:text[name=addr]").val();
		var lat = ""; //위도
		var lng = ""; //경도

		if (addr != "") {
			$.ajax({
				url      : "http://maps.googleapis.com/maps/api/geocode/json?address="+encodeURI(addr)
						  +"&language=ko&sensor=false",
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
	}
</script>
</head>
<body>

 	<c:forEach items="${listNavi}" var="list" varStatus="status">
 	
		<button onclick="javascript:self.location='/map${list.mapType}'">
			<span>${list.menuNm}</span>
		</button>
	
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