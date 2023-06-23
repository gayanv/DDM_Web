/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.emaillist;

/**
 *
 * @author Dinesh
 */
public class EmailList
{

    private String bankCode;
    private String bankShortName;
    private String bankFullName;
    private String notificationType;
    private String notificationTypeDesc;
    private String notificationTypeSetBankOnly;
    private String emailAddress;
    private String emailAddressModify;
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

    public EmailList()
    {
    }

    public EmailList(String bankCode, String notificationType, String authorizedBy)
    {
        this.bankCode = bankCode;
        this.notificationType = notificationType;
        this.authorizedBy = authorizedBy;
    }   

    public EmailList(String bankCode, String notificationType, String emailAddress, String status, String modifiedBy)
    {
        this.bankCode = bankCode;
        this.notificationType = notificationType;
        this.emailAddress = emailAddress;
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

    public String getNotificationType()
    {
        return notificationType;
    }

    public void setNotificationType(String notificationType)
    {
        this.notificationType = notificationType;
    }

    public String getNotificationTypeDesc()
    {
        return notificationTypeDesc;
    }

    public void setNotificationTypeDesc(String notificationTypeDesc)
    {
        this.notificationTypeDesc = notificationTypeDesc;
    }

    public String getNotificationTypeSetBankOnly()
    {
        return notificationTypeSetBankOnly;
    }

    public void setNotificationTypeSetBankOnly(String notificationTypeSetBankOnly)
    {
        this.notificationTypeSetBankOnly = notificationTypeSetBankOnly;
    }

    public String getEmailAddress()
    {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress)
    {
        this.emailAddress = emailAddress;
    }

    public String getEmailAddressModify()
    {
        return emailAddressModify;
    }

    public void setEmailAddressModify(String emailAddressModify)
    {
        this.emailAddressModify = emailAddressModify;
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
