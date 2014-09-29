<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<title>Wann2</title>
	<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
	<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
	<script src="http://code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
</head>
<body>
 
 <!-- 본 샘플은 완투에 의해 누구나 쉽게 개발할 수 있도록 제공하기 위해 시리즈로 제작됩니다. -->
 
<div id="tabs">

	<ul>
		<c:forEach items="${listTest}" var="list" varStatus="status">
			<li>
				<a href="#fragment-${list.id}"><span>${list.title}</span></a>
			</li>
		</c:forEach>
	</ul>

  	<c:forEach items="${listTest}" var="list" varStatus="status">
		<div id="fragment-${list.id}">
			<p>${list.content}</p>
		</div>
	</c:forEach>

</div>
 
<script>
$( "#tabs" ).tabs();
</script>
 
</body>
</html>