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

	<script type="text/javascript" src="http://openapi.map.naver.com/openapi/naverMap.naver?ver=2.0&key=b37f67029df29035ca76ce97c158fd83"></script>

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
	
		$(document).ready(function() {
			$("#mapCanvas").css("height",$(window).height()-230+"px");
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
	        var radius = 200; // 단위: 미터
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
			$.ajax({
				url      : "/getDataForMapNaver",
				cache    : true,
				async    : false,
				data     : { 
					addr : encodeURI($("input:text[name=addr]").val()) 
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
		
	</script>
</head>
<body>
 
	<div data-role="page">
		
		<div data-role="header">
			<h1>모바일웹 네이버맵</h1>
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
					<button onclick="showAddrLocation()" style="margin:0;padding:0;">주소위치</button>
				</div>
				<div class="ui-block-b" data-type="horizontal" data-mini="true">
					<button onclick="showCurrLocation()" style="margin:0;padding:0;">현위치</button>
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