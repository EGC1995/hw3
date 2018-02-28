package guestbook;

import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity
public class Subscriber{
    //@Id Long id;
    //@Index String email;
    @Id String email;
    
    private Subscriber() {}
    public Subscriber(String email) {
        this.email = email;
    }
    public String getEmail() {
        return email;
    }

}