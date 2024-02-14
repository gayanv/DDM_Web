/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.utils;

import java.io.*;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class CertificateReader
{

    public static X509Certificate readCertificate(File fileName)
    {
        CertificateFactory cf = null;
        X509Certificate cert = null;
        InputStream is = null;
        BufferedInputStream bis = null;

        try
        {
            is = new FileInputStream(fileName);
            bis = new BufferedInputStream(is);
            cf = CertificateFactory.getInstance(DDM_Constants.cert_type);
            cert = (X509Certificate) cf.generateCertificate(bis);

        }
        catch (CertificateException e)
        {
            System.out.println("CertificateException - " + e.getMessage());
        }
        catch (FileNotFoundException e)
        {
            System.out.println("FileNotFoundException - " + e.getMessage());
        }
        finally
        {
            try
            {
                if (bis != null)
                {
                    bis.close();
                }
                if (is != null)
                {
                    is.close();
                }
            }
            catch (IOException e)
            {
                System.out.println("IOException - " + e.getMessage());
            }
        }

        return cert;
    }
}
