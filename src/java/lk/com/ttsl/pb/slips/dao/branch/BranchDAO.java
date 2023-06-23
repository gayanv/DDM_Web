/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.branch;

import java.util.Collection;
import lk.com.ttsl.pb.slips.dao.bank.Bank;

/**
 *
 * @author Dinesh
 */
public interface BranchDAO
{
    public String getMsg();

    public Branch getBranchDetails(String bankCode, String branchCode);

    public Collection<Branch> getBranch(String bankCode, String status);

    public Collection<Branch> getBranchNotInStatus(String bankCode, String status);

    public Collection<Bank> getBanksListOfAuthPendingBranches(String createdUser);
    
    public Collection<Branch> getAuthPendingBranches(String bankCode, String createdUser);

    public Collection<Bank> getBanksListOfAuthPendingModifiedBranches(String createdUser);
    
    public Collection<Branch> getAuthPendingModifiedBranches(String bankCode, String createdUser);

    public Collection<Branch> getBranch(String bankCode);

    public boolean addBranch(Branch branch);

    public boolean addBranchWithBankBranchFile(Branch branch);

    public boolean updateAllBranchStatus(String bankCode, String status, String modifiedBy);

    public boolean modifyBranch(Branch branch);

    public boolean doAuthorizedBranch(Branch branch);

    public boolean doAuthorizedModifiedBranch(Branch branch);
}
