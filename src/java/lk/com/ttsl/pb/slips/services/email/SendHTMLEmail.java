/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.email;

import java.util.Collection;
import java.util.Date;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;
import lk.com.ttsl.pb.slips.dao.custom.user.User;
import lk.com.ttsl.pb.slips.dao.parameter.Parameter;
import lk.com.ttsl.pb.slips.services.utils.PropertyLoader;
import lk.com.ttsl.pb.slips.services.utils.RandomOTPGenerator;

/**
 *
 * @author Dinesh
 */
public class SendHTMLEmail
{

    private static SendHTMLEmail sendHTML_Email;
    private static String emailSentDate;

    private String msg = null;
    private String email = null;

    public SendHTMLEmail()
    {
    }

    public String getMsg()
    {
        return msg;
    }

    public static SendHTMLEmail getInstance()
    {
        if (sendHTML_Email == null)
        {
            String isSendEmailsForPwdExpiry = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_send_email_pwd_expiry);

            if (isSendEmailsForPwdExpiry != null && isSendEmailsForPwdExpiry.equalsIgnoreCase(DDM_Constants.status_yes))
            {
                String lastEmailSentDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_last_date_email_pwd_expiry_sent);
                String currentDate = DateFormatter.doFormat(new Date().getTime(), DDM_Constants.simple_date_format_yyyyMMdd);

                if (lastEmailSentDate == null)
                {
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
                                String webURL = "";

                                if (usr.getUserLevelId().equals(DDM_Constants.user_type_merchant_op) || usr.getUserLevelId().equals(DDM_Constants.user_type_merchant_su))
                                {
                                    webURL = "<a href=\"https://www.salpay.peoplesbank.lk\" title=\"LankaPay DDM System - Login\">Login To LankaPay DDM System</a>";
                                }
                                else
                                {
                                    webURL = "<a href=\"https://pbccd/slipsweb/\" title=\"LankaPay DDM System - Login\">Login To LankaPay DDM System</a>";
                                }

                                if (usr.getMinPwdValidDays() == 0)
                                {
                                    //new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Warning - SLIPS BCM Password Will Expire Today", "This is the final reminder you will get and your <b>SLIPS BCM</b> system password will be expired after today!", " Please change the password immediately.");
                                    new SendHTMLEmail().sendEmailForPasswordExpiry(usr.getEmail(), "Warning - LankaPay DDM System Password Will Expire Today", "Dear " + (usr.getName() != null ? usr.getName() : "LankaPay DDMCorporate Customer") + ",<br/><br/>This is the final reminder you will get and your password of <b>LankaPay DDM System</b> will be expired after today!", "<br/><br/>If your password expires, you will not be able to login to SLIPS System and perform your work. So please change the password immediately. <br/><br/> You can reset your password by visiting <b>'My Profile'</b> page of LankaPay DDM System.<br/><br/>In order to reset your password please click on the below link to login to the LankaPay DDM System,<br/><br/>" + webURL);
                                }
                                else if ((usr.getMinPwdValidDays() > 0) && (usr.getMinPwdValidDays() <= pwdExpireWarningDays))
                                {
                                    //new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Alert - SLIPS BCM Password Will Expire Soon!", " Your password for the <b>SLIPS BCM</b> system will be expired within " + usr.getMinPwdValidDays() + " days!", " Please change the password.");
                                    new SendHTMLEmail().sendEmailForPasswordExpiry(usr.getEmail(), "Alert - LankaPay DDM System Password Will Expire Soon!", "Dear " + (usr.getName() != null ? usr.getName() : "LankaPay DDMUser") + ",<br/><br/>The password of <b>LankaPay DDM System</b> needs to be reset within next " + usr.getMinPwdValidDays() + " days!", "<br/><br/>If your password expires, you will not be able to login to SLIPS System and perform your work. <br/><br/> Please reset your password by visiting <b>'My Profile'</b> page of LankaPay DDM System.<br/><br/>In order to reset your password please click on the below link to login to the LankaPay DDM System,<br/><br/>" + webURL);
                                }
                            }
                        }

                    }
                }
                else
                {
                    if (!lastEmailSentDate.equals(currentDate))
                    {
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
                                    String webURL = "";

                                    if (usr.getUserLevelId().equals(DDM_Constants.user_type_merchant_op) || usr.getUserLevelId().equals(DDM_Constants.user_type_merchant_su))
                                    {
                                        webURL = "<a href=\"https://www.salpay.peoplesbank.lk\" title=\"LankaPay DDM System - Login\">Login To LankaPay DDM System</a>";
                                    }
                                    else
                                    {
                                        webURL = "<a href=\"https://pbccd/slipsweb/\" title=\"LankaPay DDM System - Login\">Login To LankaPay DDM System</a>";
                                    }

                                    if (usr.getMinPwdValidDays() == 0)
                                    {
                                        //new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Warning - SLIPS BCM Password Will Expire Today", "This is the final reminder you will get and your <b>SLIPS BCM</b> system password will be expired after today!", " Please change the password immediately.");
                                        new SendHTMLEmail().sendEmailForPasswordExpiry(usr.getEmail(), "Warning - LankaPay DDM System Password Will Expire Today!", "Dear " + (usr.getName() != null ? usr.getName() : "LankaPay DDMUser") + ",<br/><br/>This is the final reminder you will get and your password of the <b>LankaPay DDM System</b> will be expired after today!", "<br/><br/>If your password expires, you will not be able to login to SLIPS System and perform your work. So please change the password immediately. <br/><br/> You can reset your password by visiting <b>'My Profile'</b> page of LankaPay DDM System.<br/><br/>In order to reset your password please click on the below link to login to the LankaPay DDM System,<br/><br/>" + webURL);
                                    }
                                    if (usr.getMinPwdValidDays() == 1)
                                    {
                                        //new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Warning - SLIPS BCM Password Will Expire Today", "This is the final reminder you will get and your <b>SLIPS BCM</b> system password will be expired after today!", " Please change the password immediately.");
                                        new SendHTMLEmail().sendEmailForPasswordExpiry(usr.getEmail(), "Warning - LankaPay DDM System Password Will Expire Soon!", "Dear " + (usr.getName() != null ? usr.getName() : "LankaPay DDMUser") + ",<br/><br/>The password of the <b>LankaPay DDM System</b> needs to be reset needs to be reset before the end of tomorrow!", "<br/><br/>If your password expires, you will not be able to login to SLIPS System and perform your work. So please change the password immediately. <br/><br/> You can reset your password by visiting <b>'My Profile'</b> page of LankaPay DDM System.<br/><br/>In order to reset your password please click on the below link to login to the LankaPay DDM System,<br/><br/>" + webURL);
                                    }
                                    else if ((usr.getMinPwdValidDays() > 1) && (usr.getMinPwdValidDays() <= pwdExpireWarningDays))
                                    {
                                        //new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Alert - SLIPS BCM Password Will Expire Soon!", " Your password for the <b>SLIPS BCM</b> system will be expired within " + usr.getMinPwdValidDays() + " days!", " Please change the password.");
                                        new SendHTMLEmail().sendEmailForPasswordExpiry(usr.getEmail(), "Alert - LankaPay DDM System Password Will Expire Soon!", "Dear " + (usr.getName() != null ? usr.getName() : "LankaPay DDMUser") + ",<br/><br/>The password of the <b>LankaPay DDM System</b> needs to be reset within next " + usr.getMinPwdValidDays() + " days!", "<br/><br/>If your password expires, you will not be able to login to SLIPS System and perform your work. <br/><br/> Please reset your password by visiting <b>'My Profile'</b> page of LankaPay DDM System.<br/><br/>In order to reset your password please click on the below link to login to the LankaPay DDM System,<br/><br/>" + webURL);
                                    }
                                }
                            }

                        }

                    }

                }

            }

            sendHTML_Email = new SendHTMLEmail();
            emailSentDate = DateFormatter.doFormat(new Date().getTime(), DDM_Constants.simple_date_format_yyyyMMdd);
            DAOFactory.getParameterDAO().updateLastEmailSentDate(new Parameter(DDM_Constants.param_id_last_date_email_pwd_expiry_sent, emailSentDate, DDM_Constants.param_id_user_system));

        }
        else
        {
            String isSendEmailsForPwdExpiry = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_send_email_pwd_expiry);

            if (isSendEmailsForPwdExpiry != null && isSendEmailsForPwdExpiry.equalsIgnoreCase(DDM_Constants.status_yes))
            {
                String currentDate = DateFormatter.doFormat(new Date().getTime(), DDM_Constants.simple_date_format_yyyyMMdd);

                if (emailSentDate != null && !emailSentDate.equals(currentDate))
                {
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
                            catch (NumberFormatException e)
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
                                String webURL = "";

                                if (usr.getUserLevelId().equals(DDM_Constants.user_type_merchant_op) || usr.getUserLevelId().equals(DDM_Constants.user_type_merchant_su))
                                {
                                    webURL = "<a href=\"https://www.salpay.peoplesbank.lk\" title=\"LankaPay DDM System - Login\">Login To LankaPay DDM System</a>";
                                }
                                else
                                {
                                    webURL = "<a href=\"https://pbccd/slipsweb/\" title=\"LankaPay DDM System - Login\">Login To LankaPay DDM System</a>";
                                }

                                if (usr.getMinPwdValidDays() == 0)
                                {
                                    //new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Warning - SLIPS BCM Password Will Expire Today", "This is the final reminder you will get and your <b>SLIPS BCM</b> system password will be expired after today!", " Please change the password immediately.");
                                    new SendHTMLEmail().sendEmailForPasswordExpiry(usr.getEmail(), "Warning - LankaPay DDM System Password Will Expire Today", "Dear " + (usr.getName() != null ? usr.getName() : "LankaPay DDMCorporate Customer") + ",<br/><br/>This is the final reminder you will get and your password of <b>LankaPay DDM System</b> will be expired after today!", "<br/><br/>If your password expires, you will not be able to login to SLIPS System and perform your work. So please change the password immediately. <br/><br/> You can reset your password by visiting <b>'My Profile'</b> page of LankaPay DDM System.<br/><br/>In order to reset your password please click on the below link to login to the LankaPay DDM System,<br/><br/>" + webURL);
                                }
                                else if ((usr.getMinPwdValidDays() > 0) && (usr.getMinPwdValidDays() <= pwdExpireWarningDays))
                                {
                                    //new SendHTMLEmail2().sendEmailForPasswordExpiry(usr.getEmail(), "Alert - SLIPS BCM Password Will Expire Soon!", " Your password for the <b>SLIPS BCM</b> system will be expired within " + usr.getMinPwdValidDays() + " days!", " Please change the password.");
                                    new SendHTMLEmail().sendEmailForPasswordExpiry(usr.getEmail(), "Alert - LankaPay DDM System Password Will Expire Soon!", "Dear " + (usr.getName() != null ? usr.getName() : "LankaPay DDMUser") + ",<br/><br/>The password of <b>LankaPay DDM System</b> needs to be reset within next " + usr.getMinPwdValidDays() + " days!", "<br/><br/>If your password expires, you will not be able to login to SLIPS System and perform your work. <br/><br/> Please reset your password by visiting <b>'My Profile'</b> page of LankaPay DDM System.<br/><br/>In order to reset your password please click on the below link to login to the LankaPay DDM System,<br/><br/>" + webURL);
                                }
                            }
                        }
                    }

                    emailSentDate = currentDate;
                    DAOFactory.getParameterDAO().updateLastEmailSentDate(new Parameter(DDM_Constants.param_id_last_date_email_pwd_expiry_sent, emailSentDate, DDM_Constants.param_id_user_system));

                }
            }
        }

        return sendHTML_Email;
    }
    
    public boolean sendEmailForApprovedNewUsers(String toEmail, String subject, String bodyContentPart1, String bodyContentPart2)
    {
        final Session mailSession = Session.getInstance(this.getEmailProperties(), new Authenticator()
        {

            @Override
            protected PasswordAuthentication getPasswordAuthentication()
            {
                return new PasswordAuthentication(PropertyLoader.getInstance().getSMTP_USR(), PropertyLoader.getInstance().getSMTP_PWD());
            }

        });

        try
        {
            System.out.println("Start sending mail (sendEmailForApprovedNewUsers) --> 1");

            mailSession.setDebug(true);
            //Transport transport = mailSession.getTransport("smtp");

            System.out.println("Start sending mail --> 2");

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress("LankaPay DDM System - New User Account! <" + PropertyLoader.getInstance().getSMTP_USR() + ">"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
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

            strBuilBodyContent.append("<img src=\"cid:image\" height=\"58\" width=\"150\" >");

            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");

            messageBodyPart.setContent(strBuilBodyContent.toString(), "text/html");

            multipart.addBodyPart(messageBodyPart);

            // second part (the image)  
            messageBodyPart = new MimeBodyPart();

            System.out.println("PropertyLoader.getInstance().getMailLogoPath() ---->" + PropertyLoader.getInstance().getMailLogoPath());

            DataSource fds = new FileDataSource(PropertyLoader.getInstance().getMailLogoPath());

            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setHeader("Content-ID", "<image>");

            // add it  
            multipart.addBodyPart(messageBodyPart);
            System.out.println("addBodyPart");

            // put everything together  
            message.setContent(multipart);
            System.out.println("setContent");
            message.setSentDate(new Date());

            //transport.connect();
            System.out.println("sendEmailForApprovedNewUsers (" + toEmail + ") : Sending...");
            Transport.send(message);
            System.out.println("sendEmailForApprovedNewUsers (" + toEmail + ") : Done");
            //transport.close();

            return true;

        }
        catch (MessagingException e)
        {
            e.printStackTrace();

            return false;
        }
    }

    public boolean sendEmailForPasswordExpiry(String toEmail, String subject, String bodyContentPart1, String bodyContentPart2)
    {

        final Session mailSession = Session.getInstance(this.getEmailProperties(),
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
            mailSession.setDebug(true);
            //Transport transport = mailSession.getTransport("smtp");

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress("LankaPay DDM System - Password Expire Alert <" + PropertyLoader.getInstance().getSMTP_USR() + ">"));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail.trim()));

            message.setSubject(subject);
            message.setHeader("X-Priority", "1");

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

            strBuilBodyContent.append("<img src=\"cid:image\" height=\"58\" width=\"150\" >");

            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");

            messageBodyPart.setContent(strBuilBodyContent.toString(), "text/html");

            multipart.addBodyPart(messageBodyPart);

            // second part (the image)  
            messageBodyPart = new MimeBodyPart();

            DataSource fds = new FileDataSource(PropertyLoader.getInstance().getMailLogoPath());

            //System.out.println("PropertyLoader.getInstance().getMailLogoPath() ---->" + PropertyLoader.getInstance().getMailLogoPath());
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setHeader("Content-ID", "<image>");
            messageBodyPart.setFileName(fds.getName());
            messageBodyPart.setDisposition(MimeBodyPart.INLINE);

            // add it  
            multipart.addBodyPart(messageBodyPart);
            //System.out.println("addBodyPart");

            // put everything together  
            message.setContent(multipart);
            message.setSentDate(new Date());

            //transport.connect();
            System.out.println("sendEmailForPasswordExpiry (" + toEmail + ") : Start Sending");
            Transport.send(message);
            System.out.println("sendEmailForPasswordExpiry (" + toEmail + ") : Done");
            //transport.close();

            return true;

        }
        catch (MessagingException e)
        {
            msg = e.getMessage();
            System.out.println("Sending 'LankaPay DDM System Password Expire Alert' to - " + toEmail + " was failed due to - " + msg);
            return false;
        }
    }

    public boolean sendEmailForPasswordReset(String toEmail, String subject, String bodyContentPart1, String bodyContentPart2)
    {
        final Session mailSession = Session.getInstance(this.getEmailProperties(),
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
            mailSession.setDebug(true);
            //Transport transport = mailSession.getTransport("smtp");

            //System.out.println("transport --> " + transport);
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress("LankaPay DDM System - Password Reset Alert <" + PropertyLoader.getInstance().getSMTP_USR() + ">"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));

            message.setSubject(subject);
            message.setHeader("X-Priority", "1");

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

            strBuilBodyContent.append("<img src=\"cid:image\" height=\"58\" width=\"150\" >");

            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");

            messageBodyPart.setContent(strBuilBodyContent.toString(), "text/html");

            multipart.addBodyPart(messageBodyPart);

            // second part (the image)  
            messageBodyPart = new MimeBodyPart();

            DataSource fds = new FileDataSource(PropertyLoader.getInstance().getMailLogoPath());

            //System.out.println("PropertyLoader.getInstance().getMailLogoPath() ---->" + PropertyLoader.getInstance().getMailLogoPath());
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setHeader("Content-ID", "<image>");
            messageBodyPart.setFileName(fds.getName());
            messageBodyPart.setDisposition(MimeBodyPart.INLINE);

            // add it  
            multipart.addBodyPart(messageBodyPart);
            //System.out.println("addBodyPart");

            // put everything together  
            message.setContent(multipart);
            message.setSentDate(new Date());

            //transport.connect();
            System.out.println("sendEmailForPasswordReset (" + toEmail + ") : Start Sending");
            Transport.send(message);
            System.out.println("sendEmailForPasswordReset (" + toEmail + ") : Done");
            //transport.close();

            return true;

        }
        catch (MessagingException e)
        {
            msg = e.getMessage();
            System.out.println("Sending 'LankaPay DDM System Password Reset Alert' to - " + toEmail + " was failed due to - " + msg);
            return false;
        }
    }

    public boolean sendOTP(String userId, String toName, String toEmail)
    {
        String subject = "";
        String newOTP = "";
        String bodyContentPart1 = "";
        String bodyContentPart2 = "";
        int otpExpMinutes = 3;

        newOTP = RandomOTPGenerator.generateAvgOTP();

        try
        {
            otpExpMinutes = Integer.parseInt(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_otp_exp_minutes));
        }
        catch (NumberFormatException e)
        {
            otpExpMinutes = 3;
        }

//        if (DAOFactory.getUserDAO().updateOTP(userId, newOTP, otpExpMinutes))
//        {
//            System.out.println("1. New OTP successfuly updated in the user table.....");
//            msg = newOTP.substring(0, 3);
//            System.out.println("1. OTP ====> " + newOTP);
//        }

        subject = "Alert - LankaPay DDM System Login OTP";
        bodyContentPart1 = "Dear " + (toName != null ? toName : "LankaPay DDM User") + ", <br/><br/> The OTP code for <b>LankaPay DDM System</b> login is : <br/><br/><h2>" + newOTP.substring(0, 3) + " - " + newOTP.substring(3) + "</h2>";
        bodyContentPart2 = "<br/>Please login to the system using above OTP code. <br/><br/> Please don't share your OTP to anyone else and note that this OTP valid only for " + otpExpMinutes + " minutes.<br/>You will not be able login to the system after the OTP expired!<br/>";

        Session mailSession = Session.getInstance(this.getEmailProperties(),
                new javax.mail.Authenticator()
        {
            @Override
            protected PasswordAuthentication getPasswordAuthentication()
            {
                //return new PasswordAuthentication(username, password);
                return new PasswordAuthentication(PropertyLoader.getInstance().getSMTP_USR(), PropertyLoader.getInstance().getSMTP_PWD());
            }

        });

        try
        {
            mailSession.setDebug(true);

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress("LankaPay DDM System - Login OTP <" + PropertyLoader.getInstance().getSMTP_USR() + ">"));

            toEmail = toEmail.replaceAll(",", ";");

            if (toEmail.indexOf(";") > 0)
            {
                String[] saToEmail = toEmail.split(";");

                for (String strToEmail : saToEmail)
                {
                    message.addRecipient(Message.RecipientType.BCC, new InternetAddress(strToEmail.trim()));
                }

            }
            else
            {
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail.trim()));
            }

            message.setSubject(subject);
            message.setHeader("X-Priority", "1");

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

            strBuilBodyContent.append("<img src=\"cid:image\" height=\"58\" width=\"150\" >");

            strBuilBodyContent.append("<br/>");
            strBuilBodyContent.append("<br/>");

            messageBodyPart.setContent(strBuilBodyContent.toString(), "text/html");

            multipart.addBodyPart(messageBodyPart);

            // second part (the image)  
            messageBodyPart = new MimeBodyPart();

            System.out.println("PropertyLoader.getInstance().getMailLogoPath() ---->" + PropertyLoader.getInstance().getMailLogoPath());
            DataSource fds = new FileDataSource(PropertyLoader.getInstance().getMailLogoPath());

            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setHeader("Content-ID", "<image>");
            messageBodyPart.setFileName(fds.getName());
            messageBodyPart.setDisposition(MimeBodyPart.INLINE);

            multipart.addBodyPart(messageBodyPart);

            //Set the multipart message to the email message
            message.setContent(multipart);
            message.setSentDate(new Date());

            //transport.connect();
            System.out.println("sendEmailForLoginOTP (" + toEmail + ") : Start Sending");
            Transport.send(message);
            System.out.println("sendEmailForLoginOTP (" + toEmail + ") : Done");
            //transport.close();

            System.out.println("Start update new OTP in the user table.....");

            if (DAOFactory.getUserDAO().updateOTP(userId, newOTP, otpExpMinutes))
            {
                System.out.println("New OTP successfuly updated in the user table.....");
                msg = newOTP.substring(0, 3);
                return true;
            }
            else
            {
                System.out.println("New OTP successfuly updated in the user table.....");
                return false;
            }

        }
        catch (MessagingException e)
        {
            msg = e.getMessage();
            System.out.println("Sending 'LankaPay DDM System Password Reset Alert' to - " + toEmail + " was failed due to - " + msg);
            
            //msg = newOTP.substring(0, 3);
            
            return false;
        }
    }

    public Properties getEmailProperties()
    {
        Properties props = new Properties();

        System.out.println("mail.smtp.Username - " + PropertyLoader.getInstance().getSMTP_USR());
        System.out.println("mail.smtp.password - " + PropertyLoader.getInstance().getSMTP_PWD());
        System.out.println("mail.smtp.auth - " + PropertyLoader.getInstance().getSMTP_IsAuth());
        //System.out.println("mail.smtp.socketFactory.port - " + PropertyLoader.getInstance().getSMTP_SocketFactoryPort());
        //System.out.println("mail.smtp.socketFactory.class - " + PropertyLoader.getInstance().getSMTP_SocketFactoryClass());
        System.out.println("mail.smtp.host - " + PropertyLoader.getInstance().getSMTP_SVR());
        System.out.println("mail.smtp.port - " + PropertyLoader.getInstance().getSMTP_PORT());
        System.out.println("mail.smtp.starttls.enable - " + PropertyLoader.getInstance().getSMTP_IsTLS_Enable());

        props.put("mail.smtp.host", PropertyLoader.getInstance().getSMTP_SVR());
        props.put("mail.smtp.port", PropertyLoader.getInstance().getSMTP_PORT());

        if (PropertyLoader.getInstance().getSMTP_IsAuth())
        {
            props.put("mail.smtp.auth", PropertyLoader.getInstance().getSMTP_IsAuth());
        }

        if (PropertyLoader.getInstance().getSMTP_IsTLS_Enable())
        {
            props.put("mail.smtp.starttls.enable", PropertyLoader.getInstance().getSMTP_IsTLS_Enable());
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        }

        if (PropertyLoader.getInstance().getSMTP_SocketFactoryClass() != null && !PropertyLoader.getInstance().getSMTP_SocketFactoryClass().equals(DDM_Constants.status_no))
        {
            props.put("mail.smtp.socketFactory.class", PropertyLoader.getInstance().getSMTP_SocketFactoryClass());
        }

        if (PropertyLoader.getInstance().getSMTP_SocketFactoryPort() != null && !PropertyLoader.getInstance().getSMTP_SocketFactoryPort().equals(DDM_Constants.status_no))
        {
            props.put("mail.smtp.socketFactory.port", PropertyLoader.getInstance().getSMTP_SocketFactoryPort());
        }

        return props;
    }

    public Properties getEmailProperties2()
    {
        Properties props = new Properties();

        props.put("mail.smtp.host", PropertyLoader.getInstance().getSMTP_SVR());
        props.put("mail.smtp.port", PropertyLoader.getInstance().getSMTP_PORT());

        if (PropertyLoader.getInstance().getSMTP_IsAuth())
        {
            props.put("mail.smtp.auth", PropertyLoader.getInstance().getSMTP_IsAuth());
        }

        if (PropertyLoader.getInstance().getSMTP_IsTLS_Enable())
        {
            props.put("mail.smtp.starttls.enable", PropertyLoader.getInstance().getSMTP_IsTLS_Enable());
        }

        if (PropertyLoader.getInstance().getSMTP_SSLProtocols() != null && !PropertyLoader.getInstance().getSMTP_SSLProtocols().equals(DDM_Constants.status_no))
        {
            props.put("mail.smtp.ssl.protocols", PropertyLoader.getInstance().getSMTP_SSLProtocols());
        }

        return props;
    }

    public Properties getEmailProperties3()
    {
        Properties props = new Properties();

        System.out.println("mail.smtp.Username - " + PropertyLoader.getInstance().getSMTP_USR());
        System.out.println("mail.smtp.password - " + PropertyLoader.getInstance().getSMTP_PWD());
        System.out.println("mail.smtp.auth - " + PropertyLoader.getInstance().getSMTP_IsAuth());
        System.out.println("mail.smtp.host - " + PropertyLoader.getInstance().getSMTP_SVR());
        System.out.println("mail.smtp.port - " + PropertyLoader.getInstance().getSMTP_PORT());
        System.out.println("mail.smtp.socketFactory.port - " + PropertyLoader.getInstance().getSMTP_SocketFactoryPort());
        System.out.println("mail.smtp.socketFactory.class - " + PropertyLoader.getInstance().getSMTP_SocketFactoryClass());

        props.put("mail.smtp.host", PropertyLoader.getInstance().getSMTP_SVR());
        props.put("mail.smtp.port", PropertyLoader.getInstance().getSMTP_PORT());

        if (PropertyLoader.getInstance().getSMTP_IsAuth())
        {
            props.put("mail.smtp.auth", PropertyLoader.getInstance().getSMTP_IsAuth());
        }

        if (PropertyLoader.getInstance().getSMTP_IsTLS_Enable())
        {
            props.put("mail.smtp.starttls.enable", PropertyLoader.getInstance().getSMTP_IsTLS_Enable());
        }

        if (PropertyLoader.getInstance().getSMTP_SSLProtocols() != null && !PropertyLoader.getInstance().getSMTP_SSLProtocols().equals(DDM_Constants.status_no))
        {
            props.put("mail.smtp.ssl.protocols", PropertyLoader.getInstance().getSMTP_SSLProtocols());
        }

        if (PropertyLoader.getInstance().getSMTP_SocketFactoryClass() != null && !PropertyLoader.getInstance().getSMTP_SocketFactoryClass().equals(DDM_Constants.status_no))
        {
            props.put("mail.smtp.socketFactory.class", PropertyLoader.getInstance().getSMTP_SocketFactoryClass());
        }

        if (PropertyLoader.getInstance().getSMTP_SocketFactoryPort() != null && !PropertyLoader.getInstance().getSMTP_SocketFactoryPort().equals(DDM_Constants.status_no))
        {
            props.put("mail.smtp.socketFactory.port", PropertyLoader.getInstance().getSMTP_SocketFactoryPort());
        }

        return props;
    }

//    public static void main(String[] args)
//    {
//        new SendHTMLEmail().sendOTP("System", "dineshnilu96@gmail.com", "Dinesh Hettiarachchi");
//    }
}
