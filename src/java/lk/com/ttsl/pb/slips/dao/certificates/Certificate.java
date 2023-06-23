/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.certificates;

/**
 *
 * @author Dinesh
 */
public class Certificate
{
    // General Details

    private boolean isExpired;
    private boolean isValid;
    private String name;
    private String fileName;
    private String originalFileName;

    // Cert Details
    private String version;
    private String serialNumber;
    private String signatureAlgorithm;
    private String issuer;
    private String validFrom;
    private String validTo;
    private String subject;
    private String publicKey;
    private String authKeyIdentifier;
    private String authInfoAccess;
    private String enhancedKeyUsage;
    private String subjectAlternativeName;
    private String keyUsage;
    private String thumbPrintAlgorithm;
    private String thumbPrint;
    // Sub Details
    private String id;
    private String bankCode;
    private String bankName;
    private String email;
    private String customerName;
    private String customerLevel;
    private String locality;

    // Other Details
    private String type;
    private String tokenSerial;
    private String status;
    private String commonPath;
    private String iwdPath;
    private String tempPath;
    private String isDefault;
    private String remarks;
    private String uploadedBy;
    private String uploadedDate;
    private String approvalRemarks;
    private String approvedBy;
    private String approvedDate;
    private String defaultRequestBy;
    private String defaultRequestTime;
    private String defaultApprovalRemarks;
    private String defaultApprovedBy;
    private String defaultApprovedTime;
    private int noOfDaysToExpire;

    public Certificate()
    {
    }

    public Certificate(boolean isExpired, boolean isValid, String fileName)
    {
        this.isExpired = isExpired;
        this.isValid = isValid;
        this.fileName = fileName;
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

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getFileName()
    {
        return fileName;
    }

    public void setFileName(String fileName)
    {
        this.fileName = fileName;
    }

    public String getOriginalFileName()
    {
        return originalFileName;
    }

    public void setOriginalFileName(String originalFileName)
    {
        this.originalFileName = originalFileName;
    }

    public String getVersion()
    {
        return version;
    }

    public void setVersion(String version)
    {
        this.version = version;
    }

    public String getSerialNumber()
    {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber)
    {
        this.serialNumber = serialNumber;
    }

    public String getSignatureAlgorithm()
    {
        return signatureAlgorithm;
    }

    public void setSignatureAlgorithm(String signatureAlgorithm)
    {
        this.signatureAlgorithm = signatureAlgorithm;
    }

    public String getIssuer()
    {
        return issuer;
    }

    public void setIssuer(String issuer)
    {
        this.issuer = issuer;
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

    public String getSubject()
    {
        return subject;
    }

    public void setSubject(String subject)
    {
        this.subject = subject;
    }

    public String getPublicKey()
    {
        return publicKey;
    }

    public void setPublicKey(String publicKey)
    {
        this.publicKey = publicKey;
    }

    public String getAuthKeyIdentifier()
    {
        return authKeyIdentifier;
    }

    public void setAuthKeyIdentifier(String authKeyIdentifier)
    {
        this.authKeyIdentifier = authKeyIdentifier;
    }

    public String getAuthInfoAccess()
    {
        return authInfoAccess;
    }

    public void setAuthInfoAccess(String authInfoAccess)
    {
        this.authInfoAccess = authInfoAccess;
    }

    public String getEnhancedKeyUsage()
    {
        return enhancedKeyUsage;
    }

    public void setEnhancedKeyUsage(String enhancedKeyUsage)
    {
        this.enhancedKeyUsage = enhancedKeyUsage;
    }

    public String getSubjectAlternativeName()
    {
        return subjectAlternativeName;
    }

    public void setSubjectAlternativeName(String subjectAlternativeName)
    {
        this.subjectAlternativeName = subjectAlternativeName;
    }

    public String getKeyUsage()
    {
        return keyUsage;
    }

    public void setKeyUsage(String keyUsage)
    {
        this.keyUsage = keyUsage;
    }

    public String getThumbPrintAlgorithm()
    {
        return thumbPrintAlgorithm;
    }

    public void setThumbPrintAlgorithm(String thumbPrintAlgorithm)
    {
        this.thumbPrintAlgorithm = thumbPrintAlgorithm;
    }

    public String getThumbPrint()
    {
        return thumbPrint;
    }

    public void setThumbPrint(String thumbPrint)
    {
        this.thumbPrint = thumbPrint;
    }

    public String getId()
    {
        return id;
    }

    public void setId(String id)
    {
        this.id = id;
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

    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public String getCustomerName()
    {
        return customerName;
    }

    public void setCustomerName(String customerName)
    {
        this.customerName = customerName;
    }

    public String getCustomerLevel()
    {
        return customerLevel;
    }

    public void setCustomerLevel(String customerLevel)
    {
        this.customerLevel = customerLevel;
    }

    public String getLocality()
    {
        return locality;
    }

    public void setLocality(String locality)
    {
        this.locality = locality;
    }

    public String getType()
    {
        return type;
    }

    public void setType(String type)
    {
        this.type = type;
    }

    public String getTokenSerial()
    {
        return tokenSerial;
    }

    public void setTokenSerial(String tokenSerial)
    {
        this.tokenSerial = tokenSerial;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getCommonPath()
    {
        return commonPath;
    }

    public void setCommonPath(String commonPath)
    {
        this.commonPath = commonPath;
    }

    public String getIwdPath()
    {
        return iwdPath;
    }

    public void setIwdPath(String iwdPath)
    {
        this.iwdPath = iwdPath;
    }

    public String getTempPath()
    {
        return tempPath;
    }

    public void setTempPath(String tempPath)
    {
        this.tempPath = tempPath;
    }

    public String getIsDefault()
    {
        return isDefault;
    }

    public void setIsDefault(String isDefault)
    {
        this.isDefault = isDefault;
    }

    public String getRemarks()
    {
        return remarks;
    }

    public void setRemarks(String remarks)
    {
        this.remarks = remarks;
    }

    public String getUploadedBy()
    {
        return uploadedBy;
    }

    public void setUploadedBy(String uploadedBy)
    {
        this.uploadedBy = uploadedBy;
    }

    public String getUploadedDate()
    {
        return uploadedDate;
    }

    public void setUploadedDate(String uploadedDate)
    {
        this.uploadedDate = uploadedDate;
    }

    public String getApprovalRemarks()
    {
        return approvalRemarks;
    }

    public void setApprovalRemarks(String approvalRemarks)
    {
        this.approvalRemarks = approvalRemarks;
    }

    public String getApprovedBy()
    {
        return approvedBy;
    }

    public void setApprovedBy(String approvedBy)
    {
        this.approvedBy = approvedBy;
    }

    public String getApprovedDate()
    {
        return approvedDate;
    }

    public void setApprovedDate(String approvedDate)
    {
        this.approvedDate = approvedDate;
    }

    public String getDefaultRequestBy()
    {
        return defaultRequestBy;
    }

    public void setDefaultRequestBy(String defaultRequestBy)
    {
        this.defaultRequestBy = defaultRequestBy;
    }

    public String getDefaultRequestTime()
    {
        return defaultRequestTime;
    }

    public void setDefaultRequestTime(String defaultRequestTime)
    {
        this.defaultRequestTime = defaultRequestTime;
    }

    public String getDefaultApprovalRemarks()
    {
        return defaultApprovalRemarks;
    }

    public void setDefaultApprovalRemarks(String defaultApprovalRemarks)
    {
        this.defaultApprovalRemarks = defaultApprovalRemarks;
    }

    public String getDefaultApprovedBy()
    {
        return defaultApprovedBy;
    }

    public void setDefaultApprovedBy(String defaultApprovedBy)
    {
        this.defaultApprovedBy = defaultApprovedBy;
    }

    public String getDefaultApprovedTime()
    {
        return defaultApprovedTime;
    }

    public void setDefaultApprovedTime(String defaultApprovedTime)
    {
        this.defaultApprovedTime = defaultApprovedTime;
    }

    public int getNoOfDaysToExpire()
    {
        return noOfDaysToExpire;
    }

    public void setNoOfDaysToExpire(int noOfDaysToExpire)
    {
        this.noOfDaysToExpire = noOfDaysToExpire;
    }

    

}
