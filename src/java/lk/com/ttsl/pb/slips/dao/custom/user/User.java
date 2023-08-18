/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.custom.user;

/**
 *
 * @author Dinesh - TTS
 */
public class User
{

    private String userId;
    
    private String userLevelId;
    private String userLevelIdModify;    
    private String userLevelDesc;
    private String userLevelDescModify;
    
    private String bankCode;
    private String bankShortName;
    private String bankFullName;
    private String bankCodeModify;
    private String bankShortNameModify;
    private String bankFullNameModify;

    private String branchCode;
    private String branchName;
    private String branchCodeModify;
    private String branchNameModify;

    private String coCuId;
    private String coCuName;
    private String coCuIdModify;
    private String coCuNameModify;

    private String empId;
    private String empIdModify;
    private String name;
    private String nameModify;
    private String designation;
    private String designationModify;
    private String email;
    private String emailModify;
    private String contactNo;
    private String contactNoModify;
    private String NIC;
    private String NICModify;
    private String tokenSerial;
    private String tokenSerialModify;
    private String password;
    private String status;
    private String statusModify;
    private String remarks;
    private String remarksModify;

    private String lastPasswordResetDate;
    private String isInitialPassword;
    private String needDownloadToBIM;
    private String lastSuccessfulLogin;
    private String lastSuccessfulVisit;
    private String lastLoggingAttempt;
    private String isCurrentlyLoggedIn;
    private int unSccessfulLoggingAttempts;
    private int minPwdValidDays;
    private long timeDiff;

    private String createdBy;
    private String createdDate;
    private String authorizedBy;
    private String authorizedDate;
    private String modifiedBy;
    private String modifiedDate;
    private String modificationAuthBy;
    private String modificationAuthDate;

    public User()
    {
    }

    public User(String userId)
    {
        this.userId = userId;
    }

    public User(String userId, String password)
    {
        this.userId = userId;
        this.password = password;
    }

    public User(int unSccessfulLoggingAttempts, long timeDiff)
    {
        this.unSccessfulLoggingAttempts = unSccessfulLoggingAttempts;
        this.timeDiff = timeDiff;
    }

    public User(String userId, String password, String status)
    {
        this.userId = userId;
        this.password = password;
        this.status = status;
    }

    public User(String userLevelId, String bankCode, String branchCode, String status)
    {
        this.userLevelId = userLevelId;
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.status = status;
    }
    
    public User(String userLevelId, String bankCode, String branchCode, String coCuId, String status)
    {
        this.userLevelId = userLevelId;
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.coCuId = coCuId;
        this.status = status;
    }

    public String getUserId()
    {
        return userId;
    }

    public void setUserId(String userId)
    {
        this.userId = userId;
    }

    public String getUserLevelId()
    {
        return userLevelId;
    }

    public void setUserLevelId(String userLevelId)
    {
        this.userLevelId = userLevelId;
    }

    public String getUserLevelIdModify()
    {
        return userLevelIdModify;
    }

    public void setUserLevelIdModify(String userLevelIdModify)
    {
        this.userLevelIdModify = userLevelIdModify;
    }

    public String getUserLevelDesc()
    {
        return userLevelDesc;
    }

    public void setUserLevelDesc(String userLevelDesc)
    {
        this.userLevelDesc = userLevelDesc;
    }

    public String getUserLevelDescModify()
    {
        return userLevelDescModify;
    }

    public void setUserLevelDescModify(String userLevelDescModify)
    {
        this.userLevelDescModify = userLevelDescModify;
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

    public String getBankCodeModify()
    {
        return bankCodeModify;
    }

    public void setBankCodeModify(String bankCodeModify)
    {
        this.bankCodeModify = bankCodeModify;
    }

    public String getBankShortNameModify()
    {
        return bankShortNameModify;
    }

    public void setBankShortNameModify(String bankShortNameModify)
    {
        this.bankShortNameModify = bankShortNameModify;
    }

    public String getBankFullNameModify()
    {
        return bankFullNameModify;
    }

    public void setBankFullNameModify(String bankFullNameModify)
    {
        this.bankFullNameModify = bankFullNameModify;
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

    public String getBranchCodeModify()
    {
        return branchCodeModify;
    }

    public void setBranchCodeModify(String branchCodeModify)
    {
        this.branchCodeModify = branchCodeModify;
    }

    public String getBranchNameModify()
    {
        return branchNameModify;
    }

    public void setBranchNameModify(String branchNameModify)
    {
        this.branchNameModify = branchNameModify;
    }

    public String getCoCuId()
    {
        return coCuId;
    }

    public void setCoCuId(String coCuId)
    {
        this.coCuId = coCuId;
    }

    public String getCoCuName()
    {
        return coCuName;
    }

    public void setCoCuName(String coCuName)
    {
        this.coCuName = coCuName;
    }

    public String getCoCuIdModify()
    {
        return coCuIdModify;
    }

    public void setCoCuIdModify(String coCuIdModify)
    {
        this.coCuIdModify = coCuIdModify;
    }

    public String getCoCuNameModify()
    {
        return coCuNameModify;
    }

    public void setCoCuNameModify(String coCuNameModify)
    {
        this.coCuNameModify = coCuNameModify;
    }

    public String getEmpId()
    {
        return empId;
    }

    public void setEmpId(String empId)
    {
        this.empId = empId;
    }

    public String getEmpIdModify()
    {
        return empIdModify;
    }

    public void setEmpIdModify(String empIdModify)
    {
        this.empIdModify = empIdModify;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getNameModify()
    {
        return nameModify;
    }

    public void setNameModify(String nameModify)
    {
        this.nameModify = nameModify;
    }

    public String getDesignation()
    {
        return designation;
    }

    public void setDesignation(String designation)
    {
        this.designation = designation;
    }

    public String getDesignationModify()
    {
        return designationModify;
    }

    public void setDesignationModify(String designationModify)
    {
        this.designationModify = designationModify;
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

    public String getContactNo()
    {
        return contactNo;
    }

    public void setContactNo(String contactNo)
    {
        this.contactNo = contactNo;
    }

    public String getContactNoModify()
    {
        return contactNoModify;
    }

    public void setContactNoModify(String contactNoModify)
    {
        this.contactNoModify = contactNoModify;
    }

    public String getNIC()
    {
        return NIC;
    }

    public void setNIC(String NIC)
    {
        this.NIC = NIC;
    }

    public String getNICModify()
    {
        return NICModify;
    }

    public void setNICModify(String NICModify)
    {
        this.NICModify = NICModify;
    }

    public String getTokenSerial()
    {
        return tokenSerial;
    }

    public void setTokenSerial(String tokenSerial)
    {
        this.tokenSerial = tokenSerial;
    }

    public String getTokenSerialModify()
    {
        return tokenSerialModify;
    }

    public void setTokenSerialModify(String tokenSerialModify)
    {
        this.tokenSerialModify = tokenSerialModify;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
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

    public String getRemarks()
    {
        return remarks;
    }

    public void setRemarks(String remarks)
    {
        this.remarks = remarks;
    }

    public String getRemarksModify()
    {
        return remarksModify;
    }

    public void setRemarksModify(String remarksModify)
    {
        this.remarksModify = remarksModify;
    }

    public String getLastPasswordResetDate()
    {
        return lastPasswordResetDate;
    }

    public void setLastPasswordResetDate(String lastPasswordResetDate)
    {
        this.lastPasswordResetDate = lastPasswordResetDate;
    }

    public String getIsInitialPassword()
    {
        return isInitialPassword;
    }

    public void setIsInitialPassword(String isInitialPassword)
    {
        this.isInitialPassword = isInitialPassword;
    }

    public String getNeedDownloadToBIM()
    {
        return needDownloadToBIM;
    }

    public void setNeedDownloadToBIM(String needDownloadToBIM)
    {
        this.needDownloadToBIM = needDownloadToBIM;
    }

    public String getLastSuccessfulLogin()
    {
        return lastSuccessfulLogin;
    }

    public void setLastSuccessfulLogin(String lastSuccessfulLogin)
    {
        this.lastSuccessfulLogin = lastSuccessfulLogin;
    }

    public String getLastSuccessfulVisit()
    {
        return lastSuccessfulVisit;
    }

    public void setLastSuccessfulVisit(String lastSuccessfulVisit)
    {
        this.lastSuccessfulVisit = lastSuccessfulVisit;
    }

    public String getLastLoggingAttempt()
    {
        return lastLoggingAttempt;
    }

    public void setLastLoggingAttempt(String lastLoggingAttempt)
    {
        this.lastLoggingAttempt = lastLoggingAttempt;
    }

    public String getIsCurrentlyLoggedIn()
    {
        return isCurrentlyLoggedIn;
    }

    public void setIsCurrentlyLoggedIn(String isCurrentlyLoggedIn)
    {
        this.isCurrentlyLoggedIn = isCurrentlyLoggedIn;
    }

    public int getUnSccessfulLoggingAttempts()
    {
        return unSccessfulLoggingAttempts;
    }

    public void setUnSccessfulLoggingAttempts(int unSccessfulLoggingAttempts)
    {
        this.unSccessfulLoggingAttempts = unSccessfulLoggingAttempts;
    }

    public int getMinPwdValidDays()
    {
        return minPwdValidDays;
    }

    public void setMinPwdValidDays(int minPwdValidDays)
    {
        this.minPwdValidDays = minPwdValidDays;
    }

    public long getTimeDiff()
    {
        return timeDiff;
    }

    public void setTimeDiff(long timeDiff)
    {
        this.timeDiff = timeDiff;
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
