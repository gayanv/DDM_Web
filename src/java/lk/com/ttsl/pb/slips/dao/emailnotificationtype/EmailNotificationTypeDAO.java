/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.emailnotificationtype;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface EmailNotificationTypeDAO
{
    public String getMsg();
    
    public EmailNotificationType getEmailNotificationType(String id);

    public Collection<EmailNotificationType> getEmailNotificationTypeDetails();
    
    public Collection<EmailNotificationType> getEmailNotificationTypeDetails(String setBankOnly);
}
