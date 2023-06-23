/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.corporatecustomer;

import java.util.Collection;
import lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap.CorporateCustomerAccNoMap;

/**
 *
 * @author Dinesh
 */
public class CorporateCustomer
{

    private String coCuID;
    private String coCuName;
    private String coCuNameModify;
    private String coCuBranch;
    private String coCuBranchName;
    private String primaryAccNo;
    private String primaryAccNoModify;

    private String coCuAddress;
    private String coCuAddressModify;
    private String email;
    private String emailModify;
    private String telephone;
    private String telephoneModify;
    private String extension;
    private String extensionModify;
    private String fax;
    private String faxModify;

    private Collection<CorporateCustomerAccNoMap> colAccNoMap;
    private String is_CUST1_Allowed;
    private String is_CUST1_AllowedModify;
    private String is_CUSTOUT_Allowed;
    private String is_CUSTOUT_AllowedModify;
    private String is_DSLIPS_Allowed;
    private String is_DSLIPS_AllowedModify;
    private String is_FSLIPS_Allowed;
    private String is_FSLIPS_AllowedModify;
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

    public CorporateCustomer()
    {
    }

    public CorporateCustomer(String coCuID, String coCuName, String primaryAccNo, String coCuAddress, String email, String telephone, String extension, String fax, String is_CUST1_Allowed, String is_CUSTOUT_Allowed, String is_DSLIPS_Allowed, String is_FSLIPS_Allowed, String status, String modifiedBy)
    {
        this.coCuID = coCuID;
        this.coCuName = coCuName;
        this.primaryAccNo = primaryAccNo;
        this.coCuAddress = coCuAddress;
        this.email = email;
        this.telephone = telephone;
        this.extension = extension;
        this.fax = fax;
        this.is_CUST1_Allowed = is_CUST1_Allowed;
        this.is_CUSTOUT_Allowed = is_CUSTOUT_Allowed;
        this.is_DSLIPS_Allowed = is_DSLIPS_Allowed;
        this.is_FSLIPS_Allowed = is_FSLIPS_Allowed;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }

    public CorporateCustomer(String coCuID, String authorizedBy)
    {
        this.coCuID = coCuID;
        this.authorizedBy = authorizedBy;
    }

    public String getCoCuID()
    {
        return coCuID;
    }

    public void setCoCuID(String coCuID)
    {
        this.coCuID = coCuID;
    }

    public String getCoCuName()
    {
        return coCuName;
    }

    public void setCoCuName(String coCuName)
    {
        this.coCuName = coCuName;
    }

    public String getCoCuNameModify()
    {
        return coCuNameModify;
    }

    public void setCoCuNameModify(String coCuNameModify)
    {
        this.coCuNameModify = coCuNameModify;
    }

    public String getCoCuBranch()
    {
        return coCuBranch;
    }

    public void setCoCuBranch(String coCuBranch)
    {
        this.coCuBranch = coCuBranch;
    }

    public String getCoCuBranchName()
    {
        return coCuBranchName;
    }

    public void setCoCuBranchName(String coCuBranchName)
    {
        this.coCuBranchName = coCuBranchName;
    }

    public String getPrimaryAccNo()
    {
        return primaryAccNo;
    }

    public void setPrimaryAccNo(String primaryAccNo)
    {
        this.primaryAccNo = primaryAccNo;
    }

    public String getPrimaryAccNoModify()
    {
        return primaryAccNoModify;
    }

    public void setPrimaryAccNoModify(String primaryAccNoModify)
    {
        this.primaryAccNoModify = primaryAccNoModify;
    }

    public String getCoCuAddress()
    {
        return coCuAddress;
    }

    public void setCoCuAddress(String coCuAddress)
    {
        this.coCuAddress = coCuAddress;
    }

    public String getCoCuAddressModify()
    {
        return coCuAddressModify;
    }

    public void setCoCuAddressModify(String coCuAddressModify)
    {
        this.coCuAddressModify = coCuAddressModify;
    }

    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public String getEmailModify()
    {
        return emailModify;
    }

    public void setEmailModify(String emailModify)
    {
        this.emailModify = emailModify;
    }

    public String getTelephone()
    {
        return telephone;
    }

    public void setTelephone(String telephone)
    {
        this.telephone = telephone;
    }

    public String getTelephoneModify()
    {
        return telephoneModify;
    }

    public void setTelephoneModify(String telephoneModify)
    {
        this.telephoneModify = telephoneModify;
    }

    public String getExtension()
    {
        return extension;
    }

    public void setExtension(String extension)
    {
        this.extension = extension;
    }

    public String getExtensionModify()
    {
        return extensionModify;
    }

    public void setExtensionModify(String extensionModify)
    {
        this.extensionModify = extensionModify;
    }

    public String getFax()
    {
        return fax;
    }

    public void setFax(String fax)
    {
        this.fax = fax;
    }

    public String getFaxModify()
    {
        return faxModify;
    }

    public void setFaxModify(String faxModify)
    {
        this.faxModify = faxModify;
    }

    public Collection<CorporateCustomerAccNoMap> getColAccNoMap()
    {
        return colAccNoMap;
    }

    public void setColAccNoMap(Collection<CorporateCustomerAccNoMap> colAccNoMap)
    {
        this.colAccNoMap = colAccNoMap;
    }

    public String getIs_CUST1_Allowed()
    {
        return is_CUST1_Allowed;
    }

    public void setIs_CUST1_Allowed(String is_CUST1_Allowed)
    {
        this.is_CUST1_Allowed = is_CUST1_Allowed;
    }

    public String getIs_CUST1_AllowedModify()
    {
        return is_CUST1_AllowedModify;
    }

    public void setIs_CUST1_AllowedModify(String is_CUST1_AllowedModify)
    {
        this.is_CUST1_AllowedModify = is_CUST1_AllowedModify;
    }

    public String getIs_CUSTOUT_Allowed()
    {
        return is_CUSTOUT_Allowed;
    }

    public void setIs_CUSTOUT_Allowed(String is_CUSTOUT_Allowed)
    {
        this.is_CUSTOUT_Allowed = is_CUSTOUT_Allowed;
    }

    public String getIs_CUSTOUT_AllowedModify()
    {
        return is_CUSTOUT_AllowedModify;
    }

    public void setIs_CUSTOUT_AllowedModify(String is_CUSTOUT_AllowedModify)
    {
        this.is_CUSTOUT_AllowedModify = is_CUSTOUT_AllowedModify;
    }

    public String getIs_DSLIPS_Allowed()
    {
        return is_DSLIPS_Allowed;
    }

    public void setIs_DSLIPS_Allowed(String is_DSLIPS_Allowed)
    {
        this.is_DSLIPS_Allowed = is_DSLIPS_Allowed;
    }

    public String getIs_DSLIPS_AllowedModify()
    {
        return is_DSLIPS_AllowedModify;
    }

    public void setIs_DSLIPS_AllowedModify(String is_DSLIPS_AllowedModify)
    {
        this.is_DSLIPS_AllowedModify = is_DSLIPS_AllowedModify;
    }

    public String getIs_FSLIPS_Allowed()
    {
        return is_FSLIPS_Allowed;
    }

    public void setIs_FSLIPS_Allowed(String is_FSLIPS_Allowed)
    {
        this.is_FSLIPS_Allowed = is_FSLIPS_Allowed;
    }

    public String getIs_FSLIPS_AllowedModify()
    {
        return is_FSLIPS_AllowedModify;
    }

    public void setIs_FSLIPS_AllowedModify(String is_FSLIPS_AllowedModify)
    {
        this.is_FSLIPS_AllowedModify = is_FSLIPS_AllowedModify;
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
