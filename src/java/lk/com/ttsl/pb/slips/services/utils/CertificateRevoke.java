/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.utils;

import java.io.IOException;
import java.io.InputStream;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;
import lk.com.ttsl.pb.slips.dao.certificateinfo.CertificateInfo;
import lk.com.ttsl.pb.slips.dao.certificateinfo.CertificateInfoDAO;
import lk.com.ttsl.pb.slips.dao.custom.user.User;
import lk.com.ttsl.pb.slips.dao.custom.user.UserDAO;

/**
 *
 * @author Dinesh
 */
public class CertificateRevoke
{

    public boolean revokeCert(String userId)
    {
        boolean status = false;

        CertificateInfoDAO certDAO = DAOFactory.getCertificateInfoDAO();
        CertificateInfo certInfo = certDAO.getCertificateDetails(userId);

        UserDAO userDAO = DAOFactory.getUserDAO();
        User usrDetails = userDAO.getUserDetails(userId, DDM_Constants.status_all);

        String strParms = null;
        String JUSTPAY_CODE = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_justpay_code);
        String LCPL_JUSTPAYHOSTIP = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_justpay_url);
        String jarPath = "/opt/glassfish4/glassfish/domains/domain1/lib/BCMLCServiceConnector.jar";

        if (PropertyLoader.getInstance().getCommonLCPL_CertRevokeJarPath() != null)
        {
            jarPath = PropertyLoader.getInstance().getCommonLCPL_CertRevokeJarPath();
        }

        if (certInfo != null && usrDetails != null)
        {
            strParms = certInfo.getTokenserial() + "|" + certInfo.getDeviceId() + "#" + JUSTPAY_CODE + "#" + usrDetails.getNIC() + "#" + usrDetails.getEmail() + "#" + usrDetails.getContactNo() + "#" + "4" + "#" + LCPL_JUSTPAYHOSTIP + "#" + " " + userId;
        }

        try
        {
            Process proc = Runtime.getRuntime().exec("java -jar " + jarPath + " " + strParms);            
            System.out.println("Revokation String :- " + "java -jar " + jarPath + " " + strParms);            

            proc.waitFor();

            // Then retreive the process output
            InputStream in = proc.getInputStream();
            InputStream err = proc.getErrorStream();

            byte[] b = new byte[in.available()];
            in.read(b, 0, b.length);

            String strOutPutSuccess = new String(b);
            System.out.println(strOutPutSuccess);

            if (strOutPutSuccess != null && strOutPutSuccess.length() > 0)
            {
                status = true;
            }

            byte[] c = new byte[err.available()];
            err.read(c, 0, c.length);

            String strOutPutError = new String(c);
            System.out.println(strOutPutError);

            if (strOutPutError != null && strOutPutError.length() > 0)
            {
                status = false;
            }

        }
        catch (IOException e)
        {
            System.out.println("Error occured while revoke the certificate when user deactivate - " + e.getMessage());
        }
        catch (InterruptedException e)
        {
            System.out.println("Error occured while revoke the certificate when user deactivate - " + e.getMessage());
        }

        return status;
        
    }

}
