package guestbook;

import java.io.IOException;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.googlecode.objectify.ObjectifyService;
import java.util.Collections;
import java.util.List;
import java.util.Date;
import java.util.Iterator;

//import com.sendgrid.*;

@SuppressWarnings("serial")
public class GAECronServlet extends HttpServlet {
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		String strCallResult = "";
		resp.setContentType("text/plain");
		try {
			
			java.lang.System.out.println("Preparing to send an email");
			ObjectifyService.register(Subscriber.class);
			List<Subscriber> SubArray = ObjectifyService.ofy().load().type(Subscriber.class).list();
			
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
				return;
			}
			
			if (SubArray.isEmpty()) {
				;
			} else {
				
				for(Subscriber sub: SubArray) {
				
					String strTo = sub.getEmail();
					String strSubject = "Arnold Blog Subscriber Update";
					String strBody = "";
					for (BlogPost blogPost : blogPosts) {
						strBody = strBody + blogPost.getTitle() + " " + blogPost.getContent() + " " + blogPost.getDate() + " " + blogPost.getUser() + System.lineSeparator();
					}
					
					//Do validations here. Only basic ones i.e. cannot be null/empty
					//Currently only checking the To Email field
					if (strTo == null) throw new Exception("To field cannot be empty.");
					
					//Trim the stuff
					strTo = strTo.trim();
					if (strTo.length() == 0) throw new Exception("To field cannot be empty.");
					
					//Call the GAEJ Email Service
					Properties props = new Properties();
					Session session = Session.getDefaultInstance(props, null);
					Message msg = new MimeMessage(session);
					msg.setFrom(new InternetAddress("mkogerd@gmail.com"));
					msg.addRecipient(Message.RecipientType.TO, new InternetAddress(strTo));
					msg.setSubject(strSubject);
					msg.setText(strBody);
					java.lang.System.out.println("About to send message");
					Transport.send(msg);
					strCallResult = "Success: " + "Email has been delivered.";
					resp.getWriter().println(strCallResult);
				}
			}
		}
		catch (Exception ex) {
			strCallResult = "Fail: " + ex.getMessage();
			resp.getWriter().println(strCallResult);
		}
	}
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}
	
}