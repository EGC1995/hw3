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


<html>
	<head>
  		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
	</head>
	<body>
		<img style="width:100%" src="https://i2-prod.mirror.co.uk/incoming/article10353628.ece/ALTERNATES/s810/MAIN-Arnold-Schwarzenegger.jpg">
	
		<%
		    String blogPostName = request.getParameter("blogPostName");
		    if (blogPostName == null) {
		    		blogPostName = "default";
		    }

	    		pageContext.setAttribute("blogPostName", blogPostName);
	    		UserService userService = UserServiceFactory.getUserService();
	    		User user = userService.getCurrentUser();
	    		if (user != null) {
	    			pageContext.setAttribute("user", user);
		%>
		<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
		<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
		<!-- a href="/blogcreate.jsp">Create Post</a-->
		<p>Currently blogPostName is ${fn:escapeXml(blogPostName)}</p>
		<form action="blogcreate.jsp" method="post">
		    <input type="submit" value="Create Post" />
		    <input type="hidden" name="blogPostName" value="${fn:escapeXml(blogPostName)}"/>
		</form>
		
		<% 
		// Subscribe or Unsubscribe depending on subscription status
		Subscriber currentSubscriber = ObjectifyService.ofy().load().type(Subscriber.class).id(user.getEmail()).now();
		if (currentSubscriber != null) {
		    %>
		    <form action="subscribe" method="post">
			    <input type="submit" value="Unsubscribe" />
			    <input type="hidden" name="email" value="${fn:escapeXml(user.email)}"/>
			    <input type="hidden" name="action" value="unsubscribe"/>
			</form>
		    <%
		} else {
			%>
			<form action="subscribe" method="post">
			    <input type="submit" value="Subscribe" />
			    <input type="hidden" name="email" value="${fn:escapeXml(user.email)}"/>
			    <input type="hidden" name="action" value="subscribe"/>
			</form>
			<%
		}
		%>
		
		<form action="showall.jsp" method="post">
		    <input type="submit" value="Show all posts" />
		    <input type="hidden" name="blogPostName" value="${fn:escapeXml(blogPostName)}"/>
		</form>
		
		<%
			} else {
		%>
		<p>Hello!
		<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
		to include your name with greetings you post.</p>
		<%
		    }
		%>
		
<%
  
	// Blog posts
	ObjectifyService.register(BlogPost.class);
	List<BlogPost> blogPosts = ObjectifyService.ofy().load().type(BlogPost.class).list();   
	Collections.sort(blogPosts);
	int counter = 0;
	
    if (blogPosts.isEmpty()) {
        %>
        <p>'${fn:escapeXml(blogPostName)}' has no blog posts.</p>
        <%
    } else {
        %>
        <p>Blog posts for '${fn:escapeXml(blogPostName)}'.</p>
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
                pageContext.setAttribute("blogPost_user",
                							blogPost.getUser());
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
	for (Subscriber subscriber : subscribers) {
		pageContext.setAttribute("subscriber_email", subscriber.getEmail());
		%>
		<p>${fn:escapeXml(subscriber_email)}</p>
		<%
	}
}

%>
	</body>
</html>

