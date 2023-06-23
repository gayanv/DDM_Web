/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.merchant.accnomap;

/**
 *
 * @author Dinesh
 */
public class MerchantAccNoMap
{

    private String merchantID;
    private String bank;
    private String bankName;
    private String bankShortName;
    private String branch;
    private String branchName;
    private String acNo;
    private String acName;
    private String isPrimary;
    private String status;
    private String statusModify;
    private String createdBy;
    private String createdDate;
    private String authorizedBy;
    private String authorizedDate;
    private String modifiedBy;
    private String modifiedDate;
    private String modificationAuthBy;
    private String modificationAuthDate;

    public MerchantAccNoMap()
    {
    }

    public MerchantAccNoMap(String merchantID, String authorizedBy)
    {
        this.merchantID = merchantID;
        this.authorizedBy = authorizedBy;
    }

    public MerchantAccNoMap(String merchantID, String acNo, String status, String modifiedBy)
    {
        this.merchantID = merchantID;
        this.acNo = acNo;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }

    public MerchantAccNoMap(String merchantID, String bank, String branch, String acNo, String acName, String isPrimary, String status, String modifiedBy)
    {
        this.merchantID = merchantID;
        this.bank = bank;
        this.branch = branch;
        this.acNo = acNo;
        this.acName = acName;
        this.isPrimary = isPrimary;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }
    
    

    public String getMerchantID()
    {
        return merchantID;
    }

    public void setMerchantID(String merchantID)
    {
        this.merchantID = merchantID;
    }

    public String getBank()
    {
        return bank;
    }

    public void setBank(String bank)
    {
        this.bank = bank;
    }

    public String getBankName()
    {
        return bankName;
    }

    public void setBankName(String bankName)
    {
        this.bankName = bankName;
    }

    public String getBankShortName()
    {
        return bankShortName;
    }

    public void setBankShortName(String bankShortName)
    {
        this.bankShortName = bankShortName;
    }

    public String getBranch()
    {
        return branch;
    }

    public void setBranch(String branch)
    {
        this.branch = branch;
    }

    public String getBranchName()
    {
        return branchName;
    }

    public void setBranchName(String branchName)
    {
        this.branchName = branchName;
    }

    public String getAcNo()
    {
        return acNo;
    }

    public void setAcNo(String acNo)
    {
        this.acNo = acNo;
    }

    public String getAcName()
    {
        return acName;
    }

    public void setAcName(String acName)
    {
        this.acName = acName;
    }

    public String getIsPrimary()
    {
        return isPrimary;
    }

    public void setIsPrimary(String isPrimary)
    {
        this.isPrimary = isPrimary;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getStatusModify()
    {
        return statusModify;
    }

    public void setStatusModify(String statusModify)
    {
        this.statusModify = statusModify;
    }

    public String getCreatedBy()
    {
        return createdBy;
    }

    public void setCreatedBy(String createdBy)
    {
        this.createdBy = createdBy;
    }

    public String getCreatedDate()
    {
        return createdDate;
    }

    public void setCreatedDate(String createdDate)
    {
        this.createdDate = createdDate;
    }

    public String getAuthorizedBy()
    {
        return authorizedBy;
    }

    public void setAuthorizedBy(String authorizedBy)
    {
        this.authorizedBy = authorizedBy;
    }

    public String getAuthorizedDate()
    {
        return authorizedDate;
    }

    public void setAuthorizedDate(String authorizedDate)
    {
        this.authorizedDate = authorizedDate;
    }

    public String getModifiedBy()
    {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy)
    {
        this.modifiedBy = modifiedBy;
    }

    public String getModifiedDate()
    {
        return modifiedDate;
    }

    public void setModifiedDate(String modifiedDate)
    {
        this.modifiedDate = modifiedDate;
    }

    public String getModificationAuthBy()
    {
        return modificationAuthBy;
    }

    public void setModificationAuthBy(String modificationAuthBy)
    {
        this.modificationAuthBy = modificationAuthBy;
    }

    public String getModificationAuthDate()
    {
        return modificationAuthDate;
    }

    public void setModificationAuthDate(String modificationAuthDate)
    {
        this.modificationAuthDate = modificationAuthDate;
    }

    

}
