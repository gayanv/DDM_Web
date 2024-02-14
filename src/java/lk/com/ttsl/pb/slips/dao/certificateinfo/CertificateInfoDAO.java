/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.certificateinfo;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface CertificateInfoDAO
{

    public String getMsg();

    public Collection<CertificateInfo> getCertDetails(String bankCode, String validity);

    public CertificateInfo getCertificateDetails(String userID);

    public boolean updateCertDetails(CertificateInfo cert);

}
