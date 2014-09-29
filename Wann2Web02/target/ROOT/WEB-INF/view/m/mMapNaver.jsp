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

	<script src="http://openapi.map.naver.com/openapi/naverMap.naver?ver=2.0&key=b37f67029df29035ca76ce97c158fd83" type="text/javascript"></script>

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
<body onload="showAddrLocation()">
 
	<div data-role="page" id="pageMain">
		
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
		
			$("#mapCanvas").data("first", "true");
			
			if (!navigator.geolocation){
				$("#msg").html("사용자의 브라우저는 지오로케이션을 지원하지 않습니다.");
			    return;
			}
			
			$("#msg").html( "맵 준비");
			$("#mapCanvas").css("height",$(window).height()-380+"px");
			$("#mapCanvas2").css("height",$(window).height()-380+"px");
			$("#mapCanvas").data("first", "true");
			
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
	
		function onSuccess(position) {
			
			lat = position.coords.latitude;
			lng = position.coords.longitude;
			
			$("#msg").html( "위도: " + lat + " / 경도: " + lng );
	
			var latlng = new nhn.api.map.LatLng(lat, lng);
            nhn.api.map.setDefaultPoint('LatLng'); // 기본 좌표계 설정
    	 	
			if( $("#mapCanvas").data("first") == "true" ) {
				$("#mapCanvas").data("first", "false");

	    		myMap = new nhn.api.map.Map("mapCanvas", {
					center : latlng, // 지도 중심점의 좌표
	    			zoom : 14, // 지도의 축척 레벨(클수록 확대됨)
	    			enableWheelZoom : true, // 마우스 휠 동작으로 지도를 확대/축소할지 여부
	    			enableDragPan : true, // 마우스로 끌어서 지도를 이동할지 여부
	    			enableDblClickZoom : false, // 더블클릭으로 지도를 확대할지 여부
	    			mapMode : 0, // 지도 모드(0 : 일반 지도, 1 : 겹침 지도, 2 : 위성 지도)
	    			activateTrafficMap : false, // 실시간 교통 활성화 여부
	    			activateBicycleMap : false, // 자전거 지도 활성화 여부
	    			minMaxLevel : [ 1, 14 ], // 지도의 최소/최대 축척 레벨
	    			detectCoveredMarker : true, // 겹쳐 있는 마커를 클릭했을 때 겹친 마커 목록 표시 여부
	    		});
			}

    		myMap.setCenter(latlng);

            // Zoom 컨트롤
            var slider = new nhn.api.map.ZoomControl();
            myMap.addControl(slider);
            slider.setPosition({ top:15, left:15 });
            
            //아래는 위에서 지정한 좌표에 마커를 표시하는 소스 입니다.
            var size = new nhn.api.map.Size(10, 10);
            var offset = new nhn.api.map.Size(14, 37);
            var icon = new nhn.api.map.Icon("http://static.naver.com/maps2/icons/pin_spot2.png", size, offset);
            
            //Icon 표시
            var marker = new nhn.api.map.Marker(icon); 
            marker.setPoint(latlng);
            myMap.addOverlay(marker);
		}
	
		function onError(error) {
			$("#msg").html( "에러코드: " + error.code + " 메러메시지: " + error.message );
		}
	
		function showCurrPosition(lat, lng) {
			$("#msg2").html("위도:"+lat+" / 경도:"+lng);
			
            var latlng = new nhn.api.map.LatLng(lat, lng);
            nhn.api.map.setDefaultPoint('LatLng'); // 기본 좌표계 설정

            myMap2 = new nhn.api.map.Map("mapCanvas2", {
				center : latlng, // 지도 중심점의 좌표
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
			
    		myMap2.setCenter(latlng);

            // Zoom 컨트롤
            var slider = new nhn.api.map.ZoomControl();
            myMap2.addControl(slider);
            slider.setPosition({ top:15, left:15 });
            
            //아래는 위에서 지정한 좌표에 마커를 표시하는 소스 입니다.
            var size = new nhn.api.map.Size(28, 37);
            var offset = new nhn.api.map.Size(14, 37);
            var icon = new nhn.api.map.Icon("http://static.naver.com/maps2/icons/pin_spot2.png", size, offset);
            
            //Icon 표시
            var marker = new nhn.api.map.Marker(icon); 
            marker.setPoint(latlng);
            myMap2.addOverlay(marker);
            
			// 원 그리기
            var circle = new nhn.api.map.Circle({
            	strokeColor: "#0000FF",
				strokeOpacity: 0.3,
				strokeWeight: 1,
                fillColor: "#0000FF",
                fillOpacity : 0.2
	        });
	        var radius = 100; // 단위: 미터
	        circle.setCenterPoint(latlng); // 중심점을 지정
	        circle.setRadius(radius); // 반지름을 지정하며 단위는 미터
	        circle.setStyle("strokeColor", "#0000FF"); // 선 색깔
	        circle.setStyle("strokeWidth", 1); // 선 두께
	        circle.setStyle("strokeOpacity", 0.3); //선의 투명도
	        circle.setStyle("fillColor", "#0000FF"); // 채우기 색상 지정. none:투명
	        circle.setStyle("fillOpacity", 0.2);
	        myMap2.addOverlay(circle);
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
						$("#msg2").html("주소에 해당하는 위도/경도 좌표를 얻을 수 없습니다.");
					}
				});
			}
		}
		
	</script>
	
</body>
</html>