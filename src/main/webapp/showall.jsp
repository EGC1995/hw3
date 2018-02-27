<html>
	<head>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="java.util.Collections" %>
<%@ page import="guestbook.BlogPost" %>	
	
	</head>

	<body>
	
<%
	ObjectifyService.register(BlogPost.class);
	List<BlogPost> blogPosts = ObjectifyService.ofy().load().type(BlogPost.class).list();   
	Collections.sort(blogPosts);
	
    if (blogPosts.isEmpty()) {
        %>
        <p>'${fn:escapeXml(blogPostName)}' has no blog posts.</p>
        <%
    } else {
        %>
        <p>Blog posts</p>
        <%
        for (BlogPost blogPost : blogPosts) {
        	
            pageContext.setAttribute("blogPost_title",
            							blogPost.getTitle());
            pageContext.setAttribute("blogPost_content",
									blogPost.getContent());
            pageContext.setAttribute("blogPost_date",
									blogPost.getDate());
            if (blogPost.getUser() == null) {
	            	%>
	                <p>An anonymous person wrote something here, which shouldn't be possible.</p>
	            <%
            } else {
                pageContext.setAttribute("blogPost_user",
                							blogPost.getUser());
                %>
                <div class="blogPost" style="border:2px; border-color:black; border-style: solid;">
	                <h2>${fn:escapeXml(blogPost_title)}</h2>
	                <blockquote>${fn:escapeXml(blogPost_content)}</blockquote>
	                <p><b>${fn:escapeXml(blogPost_user.nickname)}</b> on ${fn:escapeXml(blogPost_date)}</p>
                </div>
                <%
            }
            
        }
    }
%>	
	
	
	
	
	
	
	
	
	
	</body>
</html>