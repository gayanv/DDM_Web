/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.corporatecustomer;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface CorporateCustomerDAO
{
    public String getMsg();
    
    public Collection<CorporateCustomer> findCoCu(String branchCode, String cocuId, String status);
    
    public CorporateCustomer getCorporateCustomerDetails(String ccID);
    
    public Collection<CorporateCustomer> getCorporateCustomer();

    public Collection<CorporateCustomer> getCorporateCustomer(String status, String branch);
    
    public Collection<CorporateCustomer> getCorporateCustomerBasicDetails(String status, String branch);
    
    public Collection<CorporateCustomer> getCorporateCustomerNotInStatus(String status, String branch);
    
    public Collection<CorporateCustomer> getCorporateCustomerNotInStatusBasicDetails(String status, String branch);
    
    public Collection<CorporateCustomer> getAuthPendingCorporateCustomer(String createdUser);
    
    public Collection<CorporateCustomer> getAuthPendingModifiedCorporateCustomer(String modifiedUser);

    

    public boolean addCorporateCustomer(CorporateCustomer cc);

    public boolean modifyCorporateCustomer(CorporateCustomer cc);  

    public boolean doAuthorizedCorporateCustomer(CorporateCustomer cc);
    
    public boolean doAuthorizeModifiedCorporateCustomer(CorporateCustomer cc);
}
