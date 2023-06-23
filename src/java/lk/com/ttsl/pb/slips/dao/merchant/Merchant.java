/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.merchant;

import java.util.Collection;
import lk.com.ttsl.pb.slips.dao.merchant.accnomap.MerchantAccNoMap;

/**
 *
 * @author Dinesh
 */
public class Merchant
{

    private String merchantID;
    private String merchantName;
    private String merchantNameModify;
    private String email;
    private String emailModify;
    private String primaryTP;
    private String primaryTPModify;
    private String secondaryTP;
    private String secondaryTPModify;
    private String password;
    private String passwordModify;
    private String bankCode;
    private String bankCodeModify;
    private String bankName;
    private String bankNameModify;
    private String bankShortName;
    private String bankShortNameModify;
    private String branchCode;
    private String branchCodeModify;
    private String branchName;
    private String branchNameModify;
    private String primaryAccountNo;
    private String primaryAccountNoModify;
    private String primaryAccountName;
    private String primaryAccountNameModify;
    private String id;
    private String idModify;
    private String status;
    private String statusModify;
    private String createdBy;
    private String createdDate;
    private String authorizedBy;
    private String authorizedDate;
    private String modificationRemarks;
    private String modifiedBy;
    private String modifiedDate;
    private String modificationAuthBy;
    private String modificationAuthDate;

    private Collection<MerchantAccNoMap> colAccNoMap;

    public Merchant()
    {
    }

    public Merchant(String merchantID, String merchantName, String email, String primaryTP, String secondaryTP, String password, String bankCode, String branchCode, String primaryAccountNo, String primaryAccountName, String id, String status, String modifiedBy)
    {
        this.merchantID = merchantID;
        this.merchantName = merchantName;
        this.email = email;
        this.primaryTP = primaryTP;
        this.secondaryTP = secondaryTP;
        this.password = password;
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.primaryAccountNo = primaryAccountNo;
        this.primaryAccountName = primaryAccountName;
        this.id = id;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }

    public Merchant(String merchantID, String merchantName, String email, String primaryTP, String secondaryTP, String password, String bankCode, String branchCode, String primaryAccountNo, String primaryAccountName, String id, String status, String modificationRemarks, String modifiedBy)
    {
        this.merchantID = merchantID;
        this.merchantName = merchantName;
        this.email = email;
        this.primaryTP = primaryTP;
        this.secondaryTP = secondaryTP;
        this.password = password;
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.primaryAccountNo = primaryAccountNo;
        this.primaryAccountName = primaryAccountName;
        this.id = id;
        this.status = status;
        this.modificationRemarks = modificationRemarks;
        this.modifiedBy = modifiedBy;
    }

    public Merchant(String merchantID, String authorizedBy)
    {
        this.merchantID = merchantID;
        this.authorizedBy = authorizedBy;
    }

    public String getMerchantID()
    {
        return merchantID;
    }

    public void setMerchantID(String merchantID)
    {
        this.merchantID = merchantID;
    }

    public String getMerchantName()
    {
        return merchantName;
    }

    public void setMerchantName(String merchantName)
    {
        this.merchantName = merchantName;
    }

    public String getMerchantNameModify()
    {
        return merchantNameModify;
    }

    public void setMerchantNameModify(String merchantNameModify)
    {
        this.merchantNameModify = merchantNameModify;
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

    public String getPrimaryTP()
    {
        return primaryTP;
    }

    public void setPrimaryTP(String primaryTP)
    {
        this.primaryTP = primaryTP;
    }

    public String getPrimaryTPModify()
    {
        return primaryTPModify;
    }

    public void setPrimaryTPModify(String primaryTPModify)
    {
        this.primaryTPModify = primaryTPModify;
    }

    public String getSecondaryTP()
    {
        return secondaryTP;
    }

    public void setSecondaryTP(String secondaryTP)
    {
        this.secondaryTP = secondaryTP;
    }

    public String getSecondaryTPModify()
    {
        return secondaryTPModify;
    }

    public void setSecondaryTPModify(String secondaryTPModify)
    {
        this.secondaryTPModify = secondaryTPModify;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }

    public String getPasswordModify()
    {
        return passwordModify;
    }

    public void setPasswordModify(String passwordModify)
    {
        this.passwordModify = passwordModify;
    }

    public String getBankCode()
    {
        return bankCode;
    }

    public void setBankCode(String bankCode)
    {
        this.bankCode = bankCode;
    }

    public String getBankCodeModify()
    {
        return bankCodeModify;
    }

    public void setBankCodeModify(String bankCodeModify)
    {
        this.bankCodeModify = bankCodeModify;
    }

    public String getBankName()
    {
        return bankName;
    }

    public void setBankName(String bankName)
    {
        this.bankName = bankName;
    }

    public String getBankNameModify()
    {
        return bankNameModify;
    }

    public void setBankNameModify(String bankNameModify)
    {
        this.bankNameModify = bankNameModify;
    }

    public String getBankShortName()
    {
        return bankShortName;
    }

    public void setBankShortName(String bankShortName)
    {
        this.bankShortName = bankShortName;
    }

    public String getBankShortNameModify()
    {
        return bankShortNameModify;
    }

    public void setBankShortNameModify(String bankShortNameModify)
    {
        this.bankShortNameModify = bankShortNameModify;
    }

    public String getBranchCode()
    {
        return branchCode;
    }

    public void setBranchCode(String branchCode)
    {
        this.branchCode = branchCode;
    }

    public String getBranchCodeModify()
    {
        return branchCodeModify;
    }

    public void setBranchCodeModify(String branchCodeModify)
    {
        this.branchCodeModify = branchCodeModify;
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

    public String getPrimaryAccountNo()
    {
        return primaryAccountNo;
    }

    public void setPrimaryAccountNo(String primaryAccountNo)
    {
        this.primaryAccountNo = primaryAccountNo;
    }

    public String getPrimaryAccountNoModify()
    {
        return primaryAccountNoModify;
    }

    public void setPrimaryAccountNoModify(String primaryAccountNoModify)
    {
        this.primaryAccountNoModify = primaryAccountNoModify;
    }

    public String getPrimaryAccountName()
    {
        return primaryAccountName;
    }

    public void setPrimaryAccountName(String primaryAccountName)
    {
        this.primaryAccountName = primaryAccountName;
    }

    public String getPrimaryAccountNameModify()
    {
        return primaryAccountNameModify;
    }

    public void setPrimaryAccountNameModify(String primaryAccountNameModify)
    {
        this.primaryAccountNameModify = primaryAccountNameModify;
    }

    public String getId()
    {
        return id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    public String getIdModify()
    {
        return idModify;
    }

    public void setIdModify(String idModify)
    {
        this.idModify = idModify;
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

    public String getModificationRemarks()
    {
        return modificationRemarks;
    }

    public void setModificationRemarks(String modificationRemarks)
    {
        this.modificationRemarks = modificationRemarks;
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

    public Collection<MerchantAccNoMap> getColAccNoMap()
    {
        return colAccNoMap;
    }

    public void setColAccNoMap(Collection<MerchantAccNoMap> colAccNoMap)
    {
        this.colAccNoMap = colAccNoMap;
    }

}
