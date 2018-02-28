package guestbook;

import java.io.IOException;
 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import static com.googlecode.objectify.ObjectifyService.ofy;

public class SubscriberServlet extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {

        String email = req.getParameter("email");
		
		if (req.getParameter("action").equals("subscribe")) {
			// Add subscriber
	        Subscriber subscriber = new Subscriber(email);
	        ofy().save().entity(subscriber).now(); 
		} 
		else if(req.getParameter("action").equals("unsubscribe")) {
			// Remove subscriber
			ofy().delete().type(Subscriber.class).id(email).now();
		}

    		resp.sendRedirect("/blog.jsp");
    }
}