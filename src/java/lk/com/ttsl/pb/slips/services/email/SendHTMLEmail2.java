/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.email;

import java.io.IOException;
import java.security.cert.Certificate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.StringTokenizer;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;
import lk.com.ttsl.pb.slips.dao.custom.user.User;
import lk.com.ttsl.pb.slips.services.utils.PropertyLoader;

/**
 *
 * @author Dinesh
 */
public class SendHTMLEmail2
{

    private static String is_pwdExpMailSent;
    private static SendHTMLEmail2 sendHTML_Email2;

//    public static void main(String[] args)
//    {
//        SendHTMLEmail2.sendEmailForNewAlerts("dineshnilu96@gmail.com", "AIA140807 - Informational Alert 2014 BBBBBB", "#FFDB0F\">Informational Alert", "Hold Security firm claims - Russian Crime Ring Amasses over a Billion Credentials");
//    }
    public SendHTMLEmail2()
    {
    }

    public static SendHTMLEmail2 getInstance()
    {
        if (sendHTML_Email2 == null)
        {
            sendHTML_Email2 = new SendHTMLEmail2();

            Collection<User> colUser = DAOFactory.getUserDAO().getUserDetails(DDM_Constants.status_active);

            if (colUser != null && colUser.size() > 0)
            {
                int pwdExpireWarningDays;

                String strPwdExpireWarningDays = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_PwdExpireWarningDays);

                if (strPwdExpireWarningDays != null)
                {
                    try
                    {
                        pwdExpireWarningDays = Integer.parseInt(strPwdExpireWarningDays);
                    }
                    catch (Exception e)
                    {
                        pwdExpireWarningDays = DDM_Constants.default_pwd_expire_warning_days;
                    }
                }
                else
                {
                    pwdExpireWarningDays = DDM_Constants.default_pwd_expire_warning_days;
                }

                for (User usr : colUser)
                {
                    if (usr != null && (usr.getEmail() != null && usr.getEmail().length() > 0))
                    {
                        if (usr.getMinPwdValidDays() == 0)
                        {
                            //new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Warning - SLIPS BCM Password Will Expire Today", "This is the final reminder you will get and your <b>SLIPS BCM</b> system password will be expired after today!", " Please change the password immediately.");
                            new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Warning - LankaPay DDM System Password Will Expire Today", "Dear " + (usr.getName() != null ? usr.getName() : "PB SLIPS User") + ",This is the final reminder you will get and your password of <b>LankaPay DDM System</b> will be expired after today!", "<br/><br/>If your password expires, you will not be able to login to SLIPS System and perform your work. So please change the password immediately. <br/><br/> You can reset your password via <b>'My Profile'</b> function of People's Bank SLIPS Web Module.");
                        }
                        else if ((usr.getMinPwdValidDays() > 0) && (usr.getMinPwdValidDays() <= pwdExpireWarningDays))
                        {
                            //new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Alert - SLIPS BCM Password Will Expire Soon!", " Your password for the <b>SLIPS BCM</b> system will be expired within " + usr.getMinPwdValidDays() + " days!", " Please change the password.");
                            new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Alert - LankaPay DDM System Password Will Expire Soon!", "Dear " + (usr.getName() != null ? usr.getName() : "PB SLIPS User") + ", <br/><br/> The password of <b>LankaPay DDM System</b> needs to be reset within next " + usr.getMinPwdValidDays() + " days!", "<br/><br/>If your password expires, you will not be able to login to SLIPS System and perform your work. <br/><br/> Please reset your password via <b>'My Profile'</b> function of People's Bank SLIPS Web Module.");
                        }
                    }
                }

            }

        }

        return sendHTML_Email2;
    }

    public boolean sendEmailForPasswordExpiry(String toEmail, String subject, String bodyContentPart1, String bodyContentPart2)
    {

        Properties props = new Properties();
        props.put("mail.smtp.auth", PropertyLoader.getInstance().getSMTP_IsAuth());
        props.put("mail.smtp.socketFactory.port", PropertyLoader.getInstance().getSMTP_SocketFactoryPort());
        props.put("mail.smtp.socketFactory.class", PropertyLoader.getInstance().getSMTP_SocketFactoryClass());
        props.put("mail.smtp.host", PropertyLoader.getInstance().getSMTP_SVR());
        props.put("mail.smtp.port", PropertyLoader.getInstance().getSMTP_PORT());

        Session mailSession = Session.getInstance(props,
                new javax.mail.Authenticator()
                {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication()
                    {
                        //return new PasswordAuthentication(DDM_Constants.csirt_mail_smtp_server_un, DDM_Constants.csirt_mail_smtp_server_pw);                        
                        return new PasswordAuthentication(PropertyLoader.getInstance().getSMTP_USR(), PropertyLoader.getInstance().getSMTP_PWD());
                    }
                });

        try
        {
            //mailSession.setDebug(true);
            Transport transport = mailSession.getTransport("smtp");

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress("LankaPay DDM System - Password Expire Alert <" + DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_eMailAdd_Alt) + ">"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);

            MimeMultipart multipart = new MimeMultipart("related");

            BodyPart messageBodyPart = new MimeBodyPart();

            StringBuilder strBuilBodyContent = new StringBuilder();
            strBuilBodyContent.append(bodyContentPart1);
            strBuilBodyContent.append(bodyContentPart2);

            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");

            strBuilBodyContent.append("This is a system generated email and please don't reply! ");

            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");

            strBuilBodyContent.append("<img src=\"cid:image\" height=\"109\" width=\"94\" >");

            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");

            messageBodyPart.setContent(strBuilBodyContent.toString(), "text/html");

            multipart.addBodyPart(messageBodyPart);

            // second part (the image)  
            messageBodyPart = new MimeBodyPart();

            DataSource fds = new FileDataSource(PropertyLoader.getInstance().getCommonPB_LogoPath());

            //System.out.println("PropertyLoader.getInstance().getCommonLCPL_LogoPath() ---->" + PropertyLoader.getInstance().getCommonLCPL_LogoPath());
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setHeader("Content-ID", "<image>");

            // add it  
            multipart.addBodyPart(messageBodyPart);
            //System.out.println("addBodyPart");

            // put everything together  
            message.setContent(multipart);
            //System.out.println("setContent");

            transport.connect();
            System.out.println("sendEmailForPasswordExpiry (" + toEmail + ") : Sending");
            transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
            System.out.println("sendEmailForPasswordExpiry (" + toEmail + ") : Done");
            transport.close();

            return true;

        }
        catch (MessagingException e)
        {
            e.printStackTrace();

            return false;
        }
    }

    public boolean sendEmailForBankBranchUpdate(String toEmail, String subject, String bodyContentPart1, String bodyContentPart2)
    {
        Properties props = new Properties();
        props.put("mail.smtp.auth", PropertyLoader.getInstance().getSMTP_IsAuth());
        props.put("mail.smtp.socketFactory.port", PropertyLoader.getInstance().getSMTP_SocketFactoryPort());
        props.put("mail.smtp.socketFactory.class", PropertyLoader.getInstance().getSMTP_SocketFactoryClass());
        props.put("mail.smtp.host", PropertyLoader.getInstance().getSMTP_SVR());
        props.put("mail.smtp.port", PropertyLoader.getInstance().getSMTP_PORT());

        Session mailSession = Session.getInstance(props,
                new javax.mail.Authenticator()
                {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication()
                    {
                        //return new PasswordAuthentication(DDM_Constants.csirt_mail_smtp_server_un, DDM_Constants.csirt_mail_smtp_server_pw);                        
                        return new PasswordAuthentication(PropertyLoader.getInstance().getSMTP_USR(), PropertyLoader.getInstance().getSMTP_PWD());
                    }

                });

        try
        {
            //mailSession.setDebug(true);
            Transport transport = mailSession.getTransport("smtp");

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress("LankaPay DDM System - Bank Branch Update Alert <" + DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_eMailAdd_Alt) + ">"));

            InternetAddress[] toAddress = null;

            if (toEmail != null && toEmail.length() > 0)
            {
                String[] toList = toEmail.split(";");
                toAddress = new InternetAddress[toList.length];
                int count = 0;
                for (String recipient : toList)
                {
                    toAddress[count] = new InternetAddress(recipient.trim());
                    count++;
                }
            }

            message.setRecipients(Message.RecipientType.TO, toAddress);
            message.setSubject(subject);

            MimeMultipart multipart = new MimeMultipart("related");

            BodyPart messageBodyPart = new MimeBodyPart();

            StringBuilder strBuilBodyContent = new StringBuilder();
            strBuilBodyContent.append(bodyContentPart1);
            strBuilBodyContent.append(bodyContentPart2);
            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");

            strBuilBodyContent.append("This is a system generated email and please don't reply! ");

            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");

            strBuilBodyContent.append("<img src=\"cid:image\" height=\"109\" width=\"94\" >");

            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");

            messageBodyPart.setContent(strBuilBodyContent.toString(), "text/html");

            multipart.addBodyPart(messageBodyPart);

            // second part (the image)  
            messageBodyPart = new MimeBodyPart();

            DataSource fds = new FileDataSource(PropertyLoader.getInstance().getCommonPB_LogoPath());

            //System.out.println("PropertyLoader.getInstance().getCommonLCPL_LogoPath() ---->" + PropertyLoader.getInstance().getCommonLCPL_LogoPath());
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setHeader("Content-ID", "<image>");

            // add it  
            multipart.addBodyPart(messageBodyPart);
            //System.out.println("addBodyPart");

            // put everything together  
            message.setContent(multipart);
            //System.out.println("setContent");

            transport.connect();
            System.out.println("sendEmailForBankBranchUpdate (" + toEmail + ") : Sending");
            transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
            System.out.println("sendEmailForBankBranchUpdate (" + toEmail + ") : Done");
            transport.close();

            return true;
        }
        catch (MessagingException e)
        {
            e.printStackTrace();
            return false;
        }
    }

    public boolean sendEmailForCertificateChange(String toEmail, String subject, String bodyContentPart1, String bodyContentPart2)
    {
        Properties props = new Properties();
        props.put("mail.smtp.auth", false);
//        props.put("mail.smtp.host", DDM_Constants.csirt_mail_smtp_server_host);
//        props.put("mail.smtp.port", DDM_Constants.csirt_mail_smtp_server_port);
        props.put("mail.smtp.host", PropertyLoader.getInstance().getSMTP_SVR());
        props.put("mail.smtp.port", PropertyLoader.getInstance().getSMTP_PORT());

        Session mailSession = Session.getInstance(props,
                new javax.mail.Authenticator()
                {
                    protected PasswordAuthentication getPasswordAuthentication()
                    {
                        //return new PasswordAuthentication(DDM_Constants.csirt_mail_smtp_server_un, DDM_Constants.csirt_mail_smtp_server_pw);                        
                        return new PasswordAuthentication(PropertyLoader.getInstance().getSMTP_USR(), PropertyLoader.getInstance().getSMTP_PWD());
                    }

                });

        try
        {
            //mailSession.setDebug(true);
            Transport transport = mailSession.getTransport("smtp");

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress("CITOS - Certificate Change Alert <" + DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_eMailAdd_Alt) + ">"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setRecipients(Message.RecipientType.CC, InternetAddress.parse(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_eMailAdd_Helpdesk)));
            message.setSubject(subject);

            MimeMultipart multipart = new MimeMultipart("related");

            BodyPart messageBodyPart = new MimeBodyPart();

            StringBuilder strBuilBodyContent = new StringBuilder();

            //System.out.println("bodyContentPart1 ---->" + bodyContentPart1);
            //strBuilBodyContent.append(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_p1));
            strBuilBodyContent.append(bodyContentPart1);
            //strBuilBodyContent.append(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_p2));

            //System.out.println("bodyContentPart2 ---->" + bodyContentPart2);
            strBuilBodyContent.append(bodyContentPart2);
            //strBuilBodyContent.append(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_p3));

            messageBodyPart.setContent(strBuilBodyContent.toString(), "text/html");

// add it  
            //System.out.println("messageBodyPart ---->" + messageBodyPart);
            multipart.addBodyPart(messageBodyPart);

            // second part (the image)  
            messageBodyPart = new MimeBodyPart();

            DataSource fds = new FileDataSource(PropertyLoader.getInstance().getCommonPB_LogoPath());

            //System.out.println("PropertyLoader.getInstance().getCommonLCPL_LogoPath() ---->" + PropertyLoader.getInstance().getCommonLCPL_LogoPath());
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setHeader("Content-ID", "<image>");

            // add it  
            multipart.addBodyPart(messageBodyPart);
            //System.out.println("addBodyPart");

            // put everything together  
            message.setContent(multipart);
            //System.out.println("setContent");

            transport.connect();
            System.out.println("sendEmailForCertificateChange (" + toEmail + ") : Sending");
            transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
            transport.sendMessage(message, message.getRecipients(Message.RecipientType.CC));
            System.out.println("sendEmailForCertificateChange (" + toEmail + ") : Done");
            System.out.println("Done");
            transport.close();

            return true;

        }
        catch (MessagingException e)
        {
            e.printStackTrace();

            return false;
        }
    }

    public boolean sendEmailForNewCertificateUpload(String toEmail, String subject, String bodyContentPart1, String bodyContentPart2)
    {
        Properties props = new Properties();
        props.put("mail.smtp.auth", false);
//        props.put("mail.smtp.host", DDM_Constants.csirt_mail_smtp_server_host);
//        props.put("mail.smtp.port", DDM_Constants.csirt_mail_smtp_server_port);
        props.put("mail.smtp.host", PropertyLoader.getInstance().getSMTP_SVR());
        props.put("mail.smtp.port", PropertyLoader.getInstance().getSMTP_PORT());

        Session mailSession = Session.getInstance(props,
                new javax.mail.Authenticator()
                {
                    protected PasswordAuthentication getPasswordAuthentication()
                    {
                        //return new PasswordAuthentication(DDM_Constants.csirt_mail_smtp_server_un, DDM_Constants.csirt_mail_smtp_server_pw);                        
                        return new PasswordAuthentication(PropertyLoader.getInstance().getSMTP_USR(), PropertyLoader.getInstance().getSMTP_PWD());
                    }

                });

        try
        {
            //mailSession.setDebug(true);
            Transport transport = mailSession.getTransport("smtp");

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress("CITOS - New Certificate Upload Alert <" + DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_eMailAdd_Alt) + ">"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setRecipients(Message.RecipientType.CC, InternetAddress.parse(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_eMailAdd_Helpdesk)));
            message.setSubject(subject);

            MimeMultipart multipart = new MimeMultipart("related");

            BodyPart messageBodyPart = new MimeBodyPart();

            StringBuilder strBuilBodyContent = new StringBuilder();

            //System.out.println("bodyContentPart1 ---->" + bodyContentPart1);
            //strBuilBodyContent.append(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_p1));
            strBuilBodyContent.append(bodyContentPart1);
            //strBuilBodyContent.append(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_p2));

            //System.out.println("bodyContentPart2 ---->" + bodyContentPart2);
            strBuilBodyContent.append(bodyContentPart2);
            //strBuilBodyContent.append(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_p3));

            messageBodyPart.setContent(strBuilBodyContent.toString(), "text/html");

// add it  
            //System.out.println("messageBodyPart ---->" + messageBodyPart);
            multipart.addBodyPart(messageBodyPart);

            // second part (the image)  
            messageBodyPart = new MimeBodyPart();

            DataSource fds = new FileDataSource(PropertyLoader.getInstance().getCommonPB_LogoPath());

            //System.out.println("PropertyLoader.getInstance().getCommonLCPL_LogoPath() ---->" + PropertyLoader.getInstance().getCommonLCPL_LogoPath());
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setHeader("Content-ID", "<image>");

            // add it  
            multipart.addBodyPart(messageBodyPart);
            //System.out.println("addBodyPart");

            // put everything together  
            message.setContent(multipart);
            //System.out.println("setContent");

            transport.connect();
            System.out.println("sendEmailForCertificateChange (" + toEmail + ") : Sending");
            transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
            transport.sendMessage(message, message.getRecipients(Message.RecipientType.CC));
            System.out.println("sendEmailForCertificateChange (" + toEmail + ") : Done");
            System.out.println("Done");
            transport.close();

            return true;

        }
        catch (MessagingException e)
        {
            e.printStackTrace();

            return false;
        }
    }

}
