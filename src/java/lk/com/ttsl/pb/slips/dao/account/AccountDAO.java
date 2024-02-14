/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.account;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface AccountDAO
{

    /**
     *
     * @return
     */
    public String getMsg();

    /**
     *
     * @param bankCode
     * @param branchCode
     * @param accountNo
     * @param type
     * @param status
     * @return
     */    
    public Collection<Account> findAccounts(String bankCode, String branchCode, String accountNo, String type, String status);

//    /**
//     *
//     * @param branchCode
//     * @param accountNo
//     * @param status
//     * @return
//     */
//    public Account getAccountDetails(String branchCode, String accountNo, String status);

    /**
     *
     * @param bankCode
     * @param branchCode
     * @param accountNo
     * @param type
     * @param status
     * @return
     */
    public Collection<Account> getAccounts(String bankCode, String branchCode, String accountNo, String type, String status);
    

}
