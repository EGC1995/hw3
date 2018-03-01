package guestbook;

import java.io.IOException;
 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

import static com.googlecode.objectify.ObjectifyService.ofy;

public class SubscriberServlet extends HttpServlet {
    public void doGet(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {

	    	UserService userService = UserServiceFactory.getUserService();
	    	User user = userService.getCurrentUser();
    		Subscriber currentSubscriber = ObjectifyService.ofy().load().type(Subscriber.class).id(user.getEmail()).now();

    		String status = "none";
    		
		if (currentSubscriber == null) {
			// Add subscriber
	        Subscriber subscriber = new Subscriber(user.getEmail());
	        ofy().save().entity(subscriber).now(); 
	        status = "Added subscriber";
		} else {
			// Remove subscriber
			ofy().delete().type(Subscriber.class).id(user.getEmail()).now();
			status = "Deleted subscriber";
		}

    		resp.sendRedirect("/blog.jsp?status="+status);
    }
}