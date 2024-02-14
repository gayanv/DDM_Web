/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.merchant.accnomap;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface MerchantAccNoMapDAO
{

    /**
     * 
     * @return 
     */
    public String getMsg();
    
    /**
     * 
     * @param concatPK
     * @return 
     */
    public MerchantAccNoMap getMerchantAccount(String concatPK);
    
    /**
     * 
     * @param merchantID
     * @param bankCode
     * @param branchCode
     * @param accNo
     * @return 
     */
    public MerchantAccNoMap getMerchantAccount(String merchantID, String bankCode, String branchCode, String accNo);

    /**
     * 
     * @param merchantID
     * @param status
     * @return 
     */
    public Collection<MerchantAccNoMap> getMerchantAccounts(String merchantID, String status);

    /**
     * 
     * @param manm
     * @return 
     */
    public boolean addMerchantAccNoMap(MerchantAccNoMap manm);

    /**
     * 
     * @param manm
     * @return 
     */
    public boolean modifyMerchantAccNoMap(MerchantAccNoMap manm);

    /**
     * 
     * @param manm
     * @return 
     */
    public boolean doAuthorizedMerchantAccNoMap(MerchantAccNoMap manm);

    /**
     * 
     * @param manm
     * @return 
     */
    public boolean doAuthorizeModifiedMerchantAccNoMap(MerchantAccNoMap manm);

}
