<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="java.util.Collections" %>
<%@ page import="guestbook.BlogPost" %>
<%@ page import="guestbook.Subscriber" %>

<html>
	<head>
  		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
	</head>
	<body>
	<%
// Get blog posts
ObjectifyService.register(BlogPost.class);
List<BlogPost> blogPosts = ObjectifyService.ofy().load().type(BlogPost.class).list();   
Collections.sort(blogPosts);

// Remove all blogs not posted within last 24 hours
Date yesterday = new Date(System.currentTimeMillis() - (24 * 60 * 60 * 1000));
Iterator<BlogPost> i = blogPosts.iterator();
while (i.hasNext()) {
	BlogPost post = i.next();
	if (post.getDate().before(yesterday)) i.remove();
}
	
if (blogPosts.isEmpty()) {
		%>
		<p>No new blog posts.</p>
		<%
} else {
		%>
		<p>New blog posts:</p>
		<%
	for (BlogPost blogPost : blogPosts) {
		pageContext.setAttribute("blogPost_title", blogPost.getTitle());
		pageContext.setAttribute("blogPost_content", blogPost.getContent());
		pageContext.setAttribute("blogPost_date", blogPost.getDate());
		pageContext.setAttribute("blogPost_user", blogPost.getUser());
		%>
		<article class="blogPost">
			<header><h2>${fn:escapeXml(blogPost_title)}</h2></header>
			<section>${fn:escapeXml(blogPost_content)}</section>
			<footer><p><b>${fn:escapeXml(blogPost_user.nickname)}</b> on ${fn:escapeXml(blogPost_date)}</p></footer>
		</article>
		<%
				
	}
}
		%>
	</body>
</html>
