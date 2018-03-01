<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="java.util.Collections" %>
<%@ page import="guestbook.BlogPost" %>
<%@ page import="guestbook.Subscriber" %>

<%
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
%>

<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
	</head>
	<body>
		<header class="title">
			<h1>Arnold blog</h1>
		</header>
		<nav>
			<a href="/showall.jsp">All Posts</a> 
			<%
if (user != null) {
	//Subscriber subscriber = ObjectifyService.ofy().load().type(Subscriber.class).id(user.getEmail()).now();
	Subscriber subscriber = null;
			%> |
			<a href="/blogcreate.jsp">Create Post</a> |
			<a href="/subscribe?ret="><%= (subscriber == null) ? "Subscribe" : "Unsubscribe" %></a> |
			<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign Out</a>
			<%
} else {
			%>
			| <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign In</a>
			<%
}
			%>
		</nav>	
		<%

if (user != null) {
	pageContext.setAttribute("user", user);
	
		%>
		<p>Hello, ${fn:escapeXml(user.nickname)}!</p>
		<% 
		
} else {
			%>
			<p>Hello! Sign in to create posts and subscribe.</p>
			<%
}
			%>
		
			<%
// Blog posts
ObjectifyService.register(BlogPost.class);
List<BlogPost> blogPosts = ObjectifyService.ofy().load().type(BlogPost.class).list();   
//Collections.sort(blogPosts);
int counter = 0;

if (blogPosts.isEmpty()) {
			%>
			<p>No blog posts.</p>
			<%
} else {
			%>
			<p>Blog posts:</p>
			<%
	for (BlogPost blogPost : blogPosts) {
		if(counter == 3){
			break;
		}
       		
		pageContext.setAttribute("blogPost_title", blogPost.getTitle());
		pageContext.setAttribute("blogPost_content", blogPost.getContent());
		pageContext.setAttribute("blogPost_date", blogPost.getDate());
           
		if (blogPost.getUser() == null) {
			%>
			<p>An anonymous person wrote something here, which shouldn't be possible.</p>
			<%
		} else {
			pageContext.setAttribute("blogPost_user", blogPost.getUser());
			%>
			<article class="blogPost">
				<header><h2>${fn:escapeXml(blogPost_title)}</h2></header>
				<section>${fn:escapeXml(blogPost_content)}</section>
				<footer><p><b>${fn:escapeXml(blogPost_user.nickname)}</b> on ${fn:escapeXml(blogPost_date)}</p></footer>
			</article>
			<%
		}
		counter = counter + 1;
	}
}
    
// DEBUG: list subscribers
ObjectifyService.register(Subscriber.class);
List<Subscriber> subscribers = ObjectifyService.ofy().load().type(Subscriber.class).list(); 
	
if (subscribers.isEmpty()) {
			%>
			<p>No subscribers.</p>
			<%
} else {
			%>
			<p>Subscribers:</p>
			<%
	for (Subscriber sub : subscribers) {
		pageContext.setAttribute("subscriber_email", sub.getEmail());
			%>
			<p>${fn:escapeXml(subscriber_email)}</p>
			<%
	}
}
			%>
	</body>
</html>

