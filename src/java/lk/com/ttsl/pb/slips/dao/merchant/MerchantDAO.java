/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.merchant;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface MerchantDAO
{
    public String getMsg();
    
    public Collection<Merchant> getMerchant(String merchantID, String bank, String branch, String status);
    
    public Merchant getMerchantDetails(String merchantID);
    
    public Collection<Merchant> getMerchantAll();
    
    public Collection<Merchant> getMerchantBasicDetails(String status, String bank, String branch);
    
    public Collection<Merchant> getMerchantNotInStatus(String status, String bank, String branch);
    
    public Collection<Merchant> getMerchantNotInStatusBasicDetails(String status, String bank, String branch);
    
    public Collection<Merchant> getAuthPendingMerchant(String createdUser);
    
    public Collection<Merchant> getAuthPendingModifiedMerchant(String modifiedUser);   

    public boolean addMerchant(Merchant cc);

    public boolean modifyMerchant(Merchant cc);  

    public boolean doAuthorizedMerchant(Merchant cc);
    
    public boolean doAuthorizeModifiedMerchant(Merchant cc);
    
    
    
    
    
}
