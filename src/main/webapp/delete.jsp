<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.util.List" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="java.util.Collections" %>
<%@ page import="guestbook.BlogPost" %>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
yo, we deleting.
<%
ObjectifyService.register(BlogPost.class);
List<BlogPost> blogPosts = ObjectifyService.ofy().load().type(BlogPost.class).list(); 
ObjectifyService.ofy().delete().entity(blogPosts.get(0));
//List<BlogPost> blogPosts = null;
ObjectifyService.ofy().delete().type(BlogPost.class);
System.out.println(ObjectifyService.ofy().delete().type(BlogPost.class));
if (blogPosts == null) {
		System.out.println("they be null");
} else {
	int i = 0;
	for (BlogPost blogPost : blogPosts) {
		System.out.println(i);
		i++;
		ObjectifyService.ofy().delete();
		
	}
}
   		
%>

</body>
</html>