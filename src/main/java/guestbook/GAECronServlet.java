package guestbook;
import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.*;
@SuppressWarnings("serial")
public class GAECronServlet extends HttpServlet {
	
	private static final Logger _logger = Logger.getLogger(GAECronServlet.class.getName());
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
		throws IOException {
			try {
				_logger.info("Cron Job has been executed");
					//Put your logic here
					//BEGIN
					//END
				 Message msg = new MimeMessage(session);
				  msg.setFrom(new InternetAddress("admin@example.com", "Example.com Admin"));
				  msg.addRecipient(Message.RecipientType.TO,
				                   new InternetAddress("user@example.com", "Mr. User"));
				  msg.setSubject("Your Example.com account has been activated");
				  msg.setText("This is a test");
				  Transport.send(msg);

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