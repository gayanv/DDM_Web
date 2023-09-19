/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.PropertyResourceBundle;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;

/**
 *
 * @author Dinesh
 */
public class PropertyLoader
{

    private static String cert_file_path;
    private static PropertyLoader pl;
    private static String lcpl_cert_revoke_jar_path;
    private static String pb_logo_path;
    private static String ddm_csv_file_upload_path;
    private static String msg_attachment_file_path;
    private static String ddm_report_common_path;

    private static String jasperBaseFolderPath;
    private static String report_logoPath;
    private static String commonReportPath_Web;

    private static String mail_smtp_server_host;
    private static String mail_smtp_server_port;
    private static String mail_smtp_server_un;
    private static String mail_smtp_server_pw;
    private static String mail_smtp_server_auth;
    private static String mail_smtp_server_tls_enable;
    private static String mail_smtp_ssl_protocols;
    private static String mail_smtp_server_socket_factory_port;
    private static String mail_smtp_server_socket_factory_class;
    private static String mail_logo_path;

    public PropertyLoader()
    {
    }

    public static PropertyLoader getInstance()
    {
        if (pl == null)
        {
            pl = new PropertyLoader();
        }
        return pl;
    }

    public File getCommonCertPath()
    {
        File file = null;

        if (cert_file_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(DDM_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                cert_file_path = bundle.getString("CERTPATH");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                }
            }
        }

        file = new File(cert_file_path);

        return file;
    }

    public String getCommonLCPL_CertRevokeJarPath()
    {
        if (lcpl_cert_revoke_jar_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(DDM_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                lcpl_cert_revoke_jar_path = bundle.getString("CERT_REVOKE_JAR_PATH");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        return lcpl_cert_revoke_jar_path;
    }

    public File getCommonPB_LogoPath()
    {
        File file = null;

        if (pb_logo_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(DDM_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                pb_logo_path = bundle.getString("LOGOTPATH");

                //lcpl_logo_path = "/CIT/web/logo_cits.jpg";
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        file = new File(pb_logo_path);

        return file;
    }


    public String getSMTP_SSLProtocols()
    {

        if (mail_smtp_ssl_protocols == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(DDM_Constants.path_email_properties));
                bundle = new PropertyResourceBundle(fis);
                mail_smtp_ssl_protocols = bundle.getString("mail.smtp.ssl.protocols");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        return mail_smtp_ssl_protocols;
    }


    public String getCSVFileUploadPath()
    {

        if (ddm_csv_file_upload_path == null)
        {

            ddm_csv_file_upload_path = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_ddm_data_tmp_file_path);

            if (ddm_csv_file_upload_path == null || ddm_csv_file_upload_path.isEmpty())
            {
                ddm_csv_file_upload_path = DDM_Constants.path_ddm_csv_file_upload_path;

            }
        }

        return ddm_csv_file_upload_path;
    }

    public File getMessageAttachmentFilePath()
    {
        File file = null;

        if (msg_attachment_file_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle = null;

            try
            {
                fis = new FileInputStream(new File(DDM_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                msg_attachment_file_path = bundle.getString("MSG_ATTACHMENT_FILE_PATH");
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                }
            }
        }

        file = new File(msg_attachment_file_path);

        return file;
    }

    public String getJasperBasePath()
    {

        if (jasperBaseFolderPath == null)
        {
            jasperBaseFolderPath = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_ddm_jasper_file_base_path);

            if (jasperBaseFolderPath == null || jasperBaseFolderPath.isEmpty())
            {
                jasperBaseFolderPath = DDM_Constants.path_ddm_jasper_file_base_path;

            }
        }

        return jasperBaseFolderPath;
    }

    public String getReportLogoPath()
    {

        if (report_logoPath == null)
        {
            report_logoPath = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_ddm_report_logo_path);

            if (report_logoPath == null || report_logoPath.isEmpty())
            {
                report_logoPath = DDM_Constants.path_ddm_report_logo_path;

            }
        }

        return report_logoPath;
    }

    public String getReportCommonPath()
    {

        if (ddm_report_common_path == null)
        {
            ddm_report_common_path = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_ddm_report_common_file_path);

            if (ddm_report_common_path == null || ddm_report_common_path.isEmpty())
            {
                ddm_report_common_path = DDM_Constants.path_ddm_report_common_path;

            }
        }

        return ddm_report_common_path;
    }
    
    
    
    public File getMailLogoPath()
    {
        File file;

        if (mail_logo_path == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle;

            try
            {
                fis = new FileInputStream(new File(DDM_Constants.path_common_properties));
                bundle = new PropertyResourceBundle(fis);
                mail_logo_path = bundle.getString("LOGOPATH");

                //lcpl_logo_path = "/CIT/web/logo_cits.jpg";
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        file = new File(mail_logo_path);

        return file;
    }

    public String getSMTP_SVR()
    {

        if (mail_smtp_server_host == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle;

            try
            {
                mail_smtp_server_host = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_mail_smtp_host);

                if (mail_smtp_server_host == null || mail_smtp_server_host.isEmpty())
                {
                    fis = new FileInputStream(new File(DDM_Constants.path_email_properties));
                    bundle = new PropertyResourceBundle(fis);
                    mail_smtp_server_host = bundle.getString("mail.smtp.host");
                }
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        return mail_smtp_server_host;
    }

    public String getSMTP_PORT()
    {

        if (mail_smtp_server_port == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle;

            try
            {
                mail_smtp_server_port = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_mail_smtp_port);

                if (mail_smtp_server_port == null || mail_smtp_server_port.isEmpty())
                {
                    fis = new FileInputStream(new File(DDM_Constants.path_email_properties));
                    bundle = new PropertyResourceBundle(fis);
                    mail_smtp_server_port = bundle.getString("mail.smtp.port");
                }
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        return mail_smtp_server_port;
    }

    public String getSMTP_USR()
    {

        if (mail_smtp_server_un == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle;

            try
            {
                mail_smtp_server_un = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_mail_smtp_user);

                if (mail_smtp_server_un == null || mail_smtp_server_un.isEmpty())
                {
                    fis = new FileInputStream(new File(DDM_Constants.path_email_properties));
                    bundle = new PropertyResourceBundle(fis);
                    mail_smtp_server_un = bundle.getString("mail.smtp.un");
                }

            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        return mail_smtp_server_un;
    }

    public String getSMTP_PWD()
    {

        if (mail_smtp_server_pw == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle;

            try
            {
                mail_smtp_server_pw = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_mail_smtp_pwd);

                if (mail_smtp_server_pw == null || mail_smtp_server_pw.isEmpty())
                {
                    fis = new FileInputStream(new File(DDM_Constants.path_email_properties));
                    bundle = new PropertyResourceBundle(fis);
                    mail_smtp_server_pw = bundle.getString("mail.smtp.pw");

                    //mail_smtp_server_pw = "Cits@lcpl";
                }

            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        return mail_smtp_server_pw;
    }

    public boolean getSMTP_IsAuth()
    {
        boolean isAuth = false;

        if (mail_smtp_server_auth == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle;

            try
            {
                mail_smtp_server_auth = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_mail_smtp_auth);

                if (mail_smtp_server_auth == null || mail_smtp_server_auth.isEmpty())
                {
                    fis = new FileInputStream(new File(DDM_Constants.path_email_properties));
                    bundle = new PropertyResourceBundle(fis);
                    mail_smtp_server_auth = bundle.getString("mail.smtp.auth");

                    if (mail_smtp_server_auth == null || mail_smtp_server_auth.isEmpty())
                    {
                        if (mail_smtp_server_auth.equals("true"))
                        {
                            mail_smtp_server_auth = DDM_Constants.status_yes;
                        }
                        else
                        {
                            mail_smtp_server_auth = DDM_Constants.status_no;
                        }
                    }
                }
                else
                {
                    if (!mail_smtp_server_auth.equals(DDM_Constants.status_yes))
                    {
                        mail_smtp_server_auth = DDM_Constants.status_no;
                    }
                }
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        if (mail_smtp_server_auth.equals(DDM_Constants.status_yes))
        {
            isAuth = true;
        }

        return isAuth;
    }

    public boolean getSMTP_IsTLS_Enable()
    {
        boolean isEnabled = false;

        if (mail_smtp_server_tls_enable == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle;

            try
            {
                mail_smtp_server_tls_enable = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_mail_smtp_tls_enabled);

                if (mail_smtp_server_tls_enable == null || mail_smtp_server_tls_enable.isEmpty())
                {
                    fis = new FileInputStream(new File(DDM_Constants.path_email_properties));
                    bundle = new PropertyResourceBundle(fis);
                    mail_smtp_server_tls_enable = bundle.getString("mail.smtp.starttls.enable");

                    if (mail_smtp_server_tls_enable == null || mail_smtp_server_tls_enable.isEmpty())
                    {
                        if (mail_smtp_server_tls_enable.equals("true"))
                        {
                            mail_smtp_server_tls_enable = DDM_Constants.status_yes;
                        }
                        else
                        {
                            mail_smtp_server_tls_enable = DDM_Constants.status_no;
                        }
                    }
                }
                else
                {
                    if (!mail_smtp_server_tls_enable.equals(DDM_Constants.status_yes))
                    {
                        mail_smtp_server_tls_enable = DDM_Constants.status_no;
                    }
                }
            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        if (mail_smtp_server_tls_enable.equals(DDM_Constants.status_yes))
        {
            isEnabled = true;
        }

        return isEnabled;
    }

    public String getSMTP_SocketFactoryPort()
    {

        if (mail_smtp_server_socket_factory_port == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle;

            try
            {

                mail_smtp_server_socket_factory_port = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_mail_smtp_socketFactory_port);

                if (mail_smtp_server_socket_factory_port == null || mail_smtp_server_socket_factory_port.isEmpty())
                {
                    fis = new FileInputStream(new File(DDM_Constants.path_email_properties));
                    bundle = new PropertyResourceBundle(fis);
                    mail_smtp_server_socket_factory_port = bundle.getString("mail.smtp.socketFactory.port");
                }

            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        return mail_smtp_server_socket_factory_port;
    }

    public String getSMTP_SocketFactoryClass()
    {
        if (mail_smtp_server_socket_factory_class == null)
        {
            FileInputStream fis = null;
            PropertyResourceBundle bundle;

            try
            {

                mail_smtp_server_socket_factory_class = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_mail_smtp_socketFactory_class);

                if (mail_smtp_server_socket_factory_class == null || mail_smtp_server_socket_factory_class.isEmpty())
                {
                    fis = new FileInputStream(new File(DDM_Constants.path_email_properties));
                    bundle = new PropertyResourceBundle(fis);
                    mail_smtp_server_socket_factory_class = bundle.getString("mail.smtp.socketFactory.class");
                }

            }
            catch (IOException e)
            {
                System.out.println(e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        return mail_smtp_server_socket_factory_class;
    }

}
