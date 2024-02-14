/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.certificates;

import java.util.Collection;
import java.util.Hashtable;

/**
 *
 * @author Dinesh
 */
public interface CertificateDAO
{
    public String getMsg();
    
    public Hashtable<String, Collection<Certificate>> analyze(String bankCode, String status);
    
    public Collection<Certificate> getCertDetails(String bankCode,String status);
    
}
