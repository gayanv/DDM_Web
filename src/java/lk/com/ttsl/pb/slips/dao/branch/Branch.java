/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.branch;

/**
 *
 * @author Dinesh
 */
public class Branch
{
    private String branchCode;
    private String branchName;
    private String branchNameModify;
    private String bankCode;
    private String bankShortName;
    private String bankFullName;
    private String status;
    private String statusModify;
    private String systemEffectiveDate;
    private String systemEffectiveDateModify;
    private String createdBy;
    private String createdDate;
    private String authorizedBy;
    private String authorizedDate;
    private String modifiedBy;
    private String modifiedDate;
    private String modificationAuthBy;
    private String modificationAuthDate;

    public Branch()
    {
    }

    public Branch(String bankCode, String branchCode, String authorizedBy)
    {
        this.branchCode = branchCode;
        this.bankCode = bankCode;
        this.authorizedBy = authorizedBy;
    }

    public Branch(String bankCode, String branchCode, String branchName, String status, String modifiedBy)
    {
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.branchName = branchName;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }

    public Branch(String bankCode, String branchCode, String branchName, String status, String systemEffectiveDate, String modifiedBy)
    {
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.branchName = branchName;
        this.status = status;
        this.systemEffectiveDate = systemEffectiveDate;
        this.modifiedBy = modifiedBy;
    }

    public String getBranchCode()
    {
        return branchCode;
    }

    public void setBranchCode(String branchCode)
    {
        this.branchCode = branchCode;
    }

    public String getBranchName()
    {
        return branchName;
    }

    public void setBranchName(String branchName)
    {
        this.branchName = branchName;
    }

    public String getBranchNameModify()
    {
        return branchNameModify;
    }

    public void setBranchNameModify(String branchNameModify)
    {
        this.branchNameModify = branchNameModify;
    }

    public String getBankCode()
    {
        return bankCode;
    }

    public void setBankCode(String bankCode)
    {
        this.bankCode = bankCode;
    }

    public String getBankShortName()
    {
        return bankShortName;
    }

    public void setBankShortName(String bankShortName)
    {
        this.bankShortName = bankShortName;
    }

    public String getBankFullName()
    {
        return bankFullName;
    }

    public void setBankFullName(String bankFullName)
    {
        this.bankFullName = bankFullName;
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

    public String getSystemEffectiveDate()
    {
        return systemEffectiveDate;
    }

    public void setSystemEffectiveDate(String systemEffectiveDate)
    {
        this.systemEffectiveDate = systemEffectiveDate;
    }

    public String getSystemEffectiveDateModify()
    {
        return systemEffectiveDateModify;
    }

    public void setSystemEffectiveDateModify(String systemEffectiveDateModify)
    {
        this.systemEffectiveDateModify = systemEffectiveDateModify;
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
