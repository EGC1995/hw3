<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
		<title>Create Blog Post</title>
	</head>
	<body>  
		<% String blogPostName = request.getParameter("blogPostName"); %>
    		<h1>Create a new blog post!</h1>
    		<% 
    		if (blogPostName == null) {
		    		blogPostName = "no_name";
		}
    		pageContext.setAttribute("blogPostName", blogPostName);
    		%>
    		<p>DEBUG: Currently blogPostName is ${fn:escapeXml(blogPostName)}</p>
    		
		<form action="blogcreate" method="post">
			<input type="hidden" name="blogPostName" value="${fn:escapeXml(blogPostName)}"/>
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
