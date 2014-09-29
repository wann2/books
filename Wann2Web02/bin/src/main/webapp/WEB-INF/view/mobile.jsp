<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="ko">
<head>
	<title>Wann2 Mobile</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.3/jquery.mobile-1.4.3.min.css" />
	<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
	<script src="http://code.jquery.com/mobile/1.4.3/jquery.mobile-1.4.3.min.js"></script>
</head>
<body>
 
<c:forEach items="${listTest}" var="list" varStatus="status">

	<div data-role="page" id="page${list.id}">
		
		<div data-role="header">
			<h1>Mobile Web</h1>
		</div>
		
		<div data-role="navbar">
			<ul>
				<c:forEach items="${listTest}" var="list2" varStatus="status2">
					<c:if test="${status.index == status2.index}">
						<li><a href="#page${list2.id}" class="ui-btn-active">${list2.title}</a></li>
					</c:if>
					<c:if test="${status.index != status2.index}">
						<li><a href="#page${list2.id}">${list2.title}</a></li>
					</c:if>
				</c:forEach>
			</ul>
		</div>
		
		<div data-role="main" class="ui-content">
			<h2>${list.content}</h2>
		</div>
		
		<div data-role="footer" data-position="fixed">
			<h1>Wann2</h1>
		</div>
				
	</div>

</c:forEach> 

</body>
</html>
