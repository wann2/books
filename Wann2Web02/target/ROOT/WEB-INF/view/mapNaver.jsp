<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<title>완투의 웹&amp;하이브리드앱 - 지도(Map) 구현</title>
	<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
	<link rel="stylesheet" href="/css/layout.css">
	
	<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
	<script src="http://code.jquery.com/ui/1.11.1/jquery-ui.js"></script>

	<script type="text/javascript" src="http://openapi.map.naver.com/openapi/naverMap.naver?ver=2.0&key=b37f67029df29035ca76ce97c158fd83"></script>

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
			
            var myPoint = new nhn.api.map.LatLng(lat, lng);
            nhn.api.map.setDefaultPoint('LatLng'); // 기본 좌표계 설정
            myMap = new nhn.api.map.Map("mapCanvas", {
				point : myPoint, // 지도 중심점의 좌표
				zoom : 11, // 지도의 축척 레벨(클수록 확대됨)
				enableWheelZoom : true, // 마우스 휠 동작으로 지도를 확대/축소할지 여부
				enableDragPan : true, // 마우스로 끌어서 지도를 이동할지 여부
				enableDblClickZoom : false, // 더블클릭으로 지도를 확대할지 여부
				mapMode : 0, // 지도 모드(0 : 일반 지도, 1 : 겹침 지도, 2 : 위성 지도)
				activateTrafficMap : false, // 실시간 교통 활성화 여부
				activateBicycleMap : false, // 자전거 지도 활성화 여부
				minMaxLevel : [ 1, 14 ], // 지도의 최소/최대 축척 레벨
				detectCoveredMarker : true, // 겹쳐 있는 마커를 클릭했을 때 겹친 마커 목록 표시 여부
			});
            
            // Zoom 컨트롤
            var slider = new nhn.api.map.ZoomControl();
            myMap.addControl(slider);
            slider.setPosition({ top:15, left:15 });
            
            //아래는 위에서 지정한 좌표에 마커를 표시하는 소스 입니다.
            var size = new nhn.api.map.Size(28, 37);
            var offset = new nhn.api.map.Size(14, 37);
            var icon = new nhn.api.map.Icon("http://static.naver.com/maps2/icons/pin_spot2.png", size, offset);
            
            //Icon 표시
            var marker = new nhn.api.map.Marker(icon); 
            marker.setPoint(myPoint);
            myMap.addOverlay(marker);
            
			// 원 그리기
            var circle = new nhn.api.map.Circle({
            	strokeColor: "#0000FF",
				strokeOpacity: 0.3,
				strokeWeight: 1,
                fillColor: "#0000FF",
                fillOpacity : 0.2
	        });
	        var radius = 300; // 단위: 미터
	        circle.setCenterPoint(myPoint); // 중심점을 지정
	        circle.setRadius(radius); // 반지름을 지정하며 단위는 미터
	        circle.setStyle("strokeColor", "#0000FF"); // 선 색깔
	        circle.setStyle("strokeWidth", 1); // 선 두께
	        circle.setStyle("strokeOpacity", 0.3); //선의 투명도
	        circle.setStyle("fillColor", "#0000FF"); // 채우기 색상 지정. none:투명
	        circle.setStyle("fillOpacity", 0.2);
	        myMap.addOverlay(circle);
		}
		
		function showAddrLocation() {
			var addr = $("input:text[name=addr]").val();
			
			if (addr != "") {
				$.ajax({
					url      : "/getDataForMapNaver",
					cache    : true,
					async    : false,
					data     : { 
						addr : encodeURI(addr) 
					},
					type     : "post",
					dataType : "json",
					contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
					success  : function(data, status) {
						
						lat = data.item[0].point.y;
						lng = data.item[0].point.x;
						
						showCurrPosition(lat, lng);
						return false;
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