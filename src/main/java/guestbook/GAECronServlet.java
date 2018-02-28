package guestbook;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;

import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.mail.MailService.Message;
import com.googlecode.objectify.ObjectifyService;
@SuppressWarnings("serial")
public class GAECronServlet extends HttpServlet {
	
	private static final Logger _logger = Logger.getLogger(GAECronServlet.class.getName());
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
		throws IOException {
		
		ObjectifyService.register(Subscriber.class);
		List<Subscriber> SubArray = ObjectifyService.ofy().load().type(Subscriber.class).list();   
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);
		

			try {
				_logger.info("Cron Job has been executed");
				for(Subscriber sub: SubArray) {
					MimeMessage msg = new MimeMessage(session);
				 	msg.setFrom(new InternetAddress("eugene.echoe@gmail.com", "Example.com Admin"));
				 	msg.addRecipient(RecipientType.TO, new InternetAddress(sub.email, "User"));
				 	msg.setSubject("Your Example.com account has been activated");
				 	msg.setText("This is a test");
				 	Transport.send(msg);  
				}

			}
			catch (Exception ex) {
				//Log any exceptions in your Cron Job
			}
		}
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
		doGet(req, resp);
	}
}