/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.certificateinfo;

/**
 *
 * @author Dinesh
 */
public class CertificateInfo
{
    // General Details

    private boolean isExpired;
    private boolean isValid;

    // Other Details
    private String userID;
    private String bankCode;
    private String bankName;
    private String certificateserial;
    private String validFrom;
    private String validTo;
    private String tokenserial;
    private String deviceId;
    private String strIsValid;
    private String strIsExpired;
    private int noOfDaysToExpire;

    public CertificateInfo()
    {
    }

    public CertificateInfo(String userID, String strIsValid, String strIsExpired)
    {
        this.userID = userID;
        this.strIsValid = strIsValid;
        this.strIsExpired = strIsExpired;
    }

    public CertificateInfo(boolean isExpired, boolean isValid, String userID, int noOfDaysToExpire)
    {
        this.isExpired = isExpired;
        this.isValid = isValid;
        this.userID = userID;
        this.noOfDaysToExpire = noOfDaysToExpire;
    }

    public boolean isIsExpired()
    {
        return isExpired;
    }

    public void setIsExpired(boolean isExpired)
    {
        this.isExpired = isExpired;
    }

    public boolean isIsValid()
    {
        return isValid;
    }

    public void setIsValid(boolean isValid)
    {
        this.isValid = isValid;
    }

    public String getUserID()
    {
        return userID;
    }

    public void setUserID(String userID)
    {
        this.userID = userID;
    }

    public String getBankCode()
    {
        return bankCode;
    }

    public void setBankCode(String bankCode)
    {
        this.bankCode = bankCode;
    }

    public String getBankName()
    {
        return bankName;
    }

    public void setBankName(String bankName)
    {
        this.bankName = bankName;
    }

    public String getCertificateserial()
    {
        return certificateserial;
    }

    public void setCertificateserial(String certificateserial)
    {
        this.certificateserial = certificateserial;
    }

    public String getValidFrom()
    {
        return validFrom;
    }

    public void setValidFrom(String validFrom)
    {
        this.validFrom = validFrom;
    }

    public String getValidTo()
    {
        return validTo;
    }

    public void setValidTo(String validTo)
    {
        this.validTo = validTo;
    }

    public String getTokenserial()
    {
        return tokenserial;
    }

    public void setTokenserial(String tokenserial)
    {
        this.tokenserial = tokenserial;
    }

    public String getStrIsValid()
    {
        return strIsValid;
    }

    public void setStrIsValid(String strIsValid)
    {
        this.strIsValid = strIsValid;
    }

    public String getStrIsExpired()
    {
        return strIsExpired;
    }

    public void setStrIsExpired(String strIsExpired)
    {
        this.strIsExpired = strIsExpired;
    }

    public int getNoOfDaysToExpire()
    {
        return noOfDaysToExpire;
    }

    public void setNoOfDaysToExpire(int noOfDaysToExpire)
    {
        this.noOfDaysToExpire = noOfDaysToExpire;
    }

    public String getDeviceId()
    {
        return deviceId;
    }

    public void setDeviceId(String deviceId)
    {
        this.deviceId = deviceId;
    }

}
