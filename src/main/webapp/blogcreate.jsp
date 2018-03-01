<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="guestbook.Subscriber" %>

<%
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
ObjectifyService.register(Subscriber.class);
Subscriber subscriber = ObjectifyService.ofy().load().type(Subscriber.class).id(user.getEmail()).now();
%>

<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
		<title>Create Blog Post</title>
	</head>
	<body>
		<header class="title">
			<h1>Arnold blog</h1>
		</header>
		<nav>
			<a href="/">Home</a> |
			<a href="/showall.jsp">All Posts</a> |
			<a href="/subscribe?ret=blogcreate.jsp"><%= (subscriber == null) ? "Subscribe" : "Unsubscribe" %></a> |
			<a href="<%= userService.createLogoutURL("/") %>">Sign Out</a>
		</nav>
		
		<p>
		<%= request.getRequestURI()%>
		</p>
    		<h1>Create a new blog post!</h1>
		<form action="blogcreate" method="post">
			<table>
				<tr>
					Title:<br>
					<input type="text" name="title"></input>
					<br>
				</tr>
				<tr>
					Content:<br>
					<textarea name="content" rows="3" cols="60"></textarea>
					<br>
				</tr>
      		
      			<tr>
        				<td><input type="submit" value="Submit"></input></td>
					<td><input type="reset" value="Clear"></input></td>
      			</tr>
    			</table>
		</form>
		
	</body>
</html>
