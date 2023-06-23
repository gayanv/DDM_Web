/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.bank;

/**
 *
 * @author Dinesh
 */
public class Bank
{

    private String bankCode;
    private String shortName;
    private String shortNameModify;
    private String bankFullName;
    private String bankFullNameModify;
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

    public Bank()
    {
    }

    public Bank(String bankCode, String authorizedBy)
    {
        this.bankCode = bankCode;
        this.authorizedBy = authorizedBy;
    }

    public Bank(String bankCode, String owdPath, String iwdPath, String modifiedBy)
    {
        this.bankCode = bankCode;
        this.modifiedBy = modifiedBy;
    }

    public Bank(String bankCode, String shortName, String bankFullName, String status, String modifiedBy)
    {
        this.bankCode = bankCode;
        this.shortName = shortName;
        this.bankFullName = bankFullName;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }

    public String getBankCode()
    {
        return bankCode;
    }

    public void setBankCode(String bankCode)
    {
        this.bankCode = bankCode;
    }

    public String getShortName()
    {
        return shortName;
    }

    public void setShortName(String shortName)
    {
        this.shortName = shortName;
    }

    public String getShortNameModify()
    {
        return shortNameModify;
    }

    public void setShortNameModify(String shortNameModify)
    {
        this.shortNameModify = shortNameModify;
    }

    public String getBankFullName()
    {
        return bankFullName;
    }

    public void setBankFullName(String bankFullName)
    {
        this.bankFullName = bankFullName;
    }

    public String getBankFullNameModify()
    {
        return bankFullNameModify;
    }

    public void setBankFullNameModify(String bankFullNameModify)
    {
        this.bankFullNameModify = bankFullNameModify;
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
