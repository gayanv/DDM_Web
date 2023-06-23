/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap;

/**
 *
 * @author Dinesh
 */
public class CorporateCustomerAccNoMap
{

    private String coCuID;
    private String accNo;
    private String accName;
    private String accAddress;
    private String accBranch;
    private String accStatus;
    private String accStatusDesc;
    private String accType;
    private String accTypeDesc;
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

    public CorporateCustomerAccNoMap()
    {
    }

    public CorporateCustomerAccNoMap(String coCuID, String authorizedBy)
    {
        this.coCuID = coCuID;
        this.authorizedBy = authorizedBy;
    }

    public CorporateCustomerAccNoMap(String coCuID, String accNo, String status, String modifiedBy)
    {
        this.coCuID = coCuID;
        this.accNo = accNo;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }
    
    

    public String getCoCuID()
    {
        return coCuID;
    }

    public void setCoCuID(String coCuID)
    {
        this.coCuID = coCuID;
    }

    public String getAccNo()
    {
        return accNo;
    }

    public void setAccNo(String accNo)
    {
        this.accNo = accNo;
    }

    public String getAccName()
    {
        return accName;
    }

    public void setAccName(String accName)
    {
        this.accName = accName;
    }

    public String getAccAddress()
    {
        return accAddress;
    }

    public void setAccAddress(String accAddress)
    {
        this.accAddress = accAddress;
    }

    public String getAccBranch()
    {
        return accBranch;
    }

    public void setAccBranch(String accBranch)
    {
        this.accBranch = accBranch;
    }

    public String getAccStatus()
    {
        return accStatus;
    }

    public void setAccStatus(String accStatus)
    {
        this.accStatus = accStatus;
    }

    public String getAccStatusDesc()
    {
        return accStatusDesc;
    }

    public void setAccStatusDesc(String accStatusDesc)
    {
        this.accStatusDesc = accStatusDesc;
    }

    public String getAccType()
    {
        return accType;
    }

    public void setAccType(String accType)
    {
        this.accType = accType;
    }

    public String getAccTypeDesc()
    {
        return accTypeDesc;
    }

    public void setAccTypeDesc(String accTypeDesc)
    {
        this.accTypeDesc = accTypeDesc;
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
