/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface CorporateCustomerAccNoMapDAO
{

    public String getMsg();

    public Collection<CorporateCustomerAccNoMap> getCorporateCustomerAccounts(String ccID, String status);

    public boolean addCorporateCustomerAccNoMap(CorporateCustomerAccNoMap ccanm);

    public boolean modifyCorporateCustomerAccNoMap(CorporateCustomerAccNoMap ccanm);

    public boolean doAuthorizedCorporateCustomerAccNoMap(CorporateCustomerAccNoMap ccanm);

    public boolean doAuthorizeModifiedCorporateCustomerAccNoMap(CorporateCustomerAccNoMap ccanm);

}
