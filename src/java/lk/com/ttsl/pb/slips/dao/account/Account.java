/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.account;

/**
 *
 * @author Dinesh
 */
public class Account
{

    private String bankCode;
    private String bankFullName;
    private String bankShortName;
    private String branchCode;
    private String branchName;
    private String accountNo;
    private String accountType;
    private String accountTypeDesc;
    private String accountSubType;
    private String isPowerAccount;
    private String accountStatus;
    private String accountStatusDesc;
    private long noOfAccountHolders;
    private String accountHolderName;
    private String accountHoderAddress1;
    private String accountHoderAddress2;
    private String accountHoderAddress3;
    private String accountHoderAddress4;
    private String NIC_No;
    private String contactNo;
    private String secondaryAccountHolderName;
    private String secondaryAccountHoderAddress;
    private String secondaryNIC_No;
    private String secondaryContactNo;
    private String thirdAccountHolderName;
    private String thirdAccountHoderAddress;
    private String thirdNIC_No;
    private String thirdContactNo;
    private String chequeBookCategory;
    private String isNamePrePrintedOnCheques;
    private String remarks;
    private String modifiedBy;
    private String modifiedDate;

    public Account()
    {
    }

    public Account(String bankCode, String branchCode, String accountNo, String accountHolderName, String accountHoderAddress1, String accountHoderAddress2, String accountHoderAddress3, String accountHoderAddress4, String accountType, String accountStatus, String modifiedBy)
    {
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.accountNo = accountNo;
        this.accountHolderName = accountHolderName;
        this.accountHoderAddress1 = accountHoderAddress1;
        this.accountHoderAddress2 = accountHoderAddress2;
        this.accountHoderAddress3 = accountHoderAddress3;
        this.accountHoderAddress4 = accountHoderAddress4;
        this.accountType = accountType;
        this.accountStatus = accountStatus;
        this.modifiedBy = modifiedBy;
    }

    public Account(String bankCode, String branchCode, String accountNo, String accountType, String accountStatus, String accountHolderName, String accountHoderAddress1, String accountHoderAddress2, String accountHoderAddress3, String accountHoderAddress4, String contactNo, String secondaryAccountHolderName, String secondaryAccountHoderAddress, String secondaryContactNo, String isNamePrePrintedOnCheques, String remarks, String modifiedBy)
    {
        this.bankCode = bankCode;
        this.branchCode = branchCode;
        this.accountNo = accountNo;
        this.accountType = accountType;
        this.accountStatus = accountStatus;
        this.accountHolderName = accountHolderName;
        this.accountHoderAddress1 = accountHoderAddress1;
        this.accountHoderAddress2 = accountHoderAddress2;
        this.accountHoderAddress3 = accountHoderAddress3;
        this.accountHoderAddress4 = accountHoderAddress4;
        this.contactNo = contactNo;
        this.secondaryAccountHolderName = secondaryAccountHolderName;
        this.secondaryAccountHoderAddress = secondaryAccountHoderAddress;
        this.secondaryContactNo = secondaryContactNo;
        this.isNamePrePrintedOnCheques = isNamePrePrintedOnCheques;
        this.remarks = remarks;
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

    public String getBankFullName()
    {
        return bankFullName;
    }

    public void setBankFullName(String bankFullName)
    {
        this.bankFullName = bankFullName;
    }

    public String getBankShortName()
    {
        return bankShortName;
    }

    public void setBankShortName(String bankShortName)
    {
        this.bankShortName = bankShortName;
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

    public String getAccountNo()
    {
        return accountNo;
    }

    public void setAccountNo(String accountNo)
    {
        this.accountNo = accountNo;
    }

    public String getAccountType()
    {
        return accountType;
    }

    public void setAccountType(String accountType)
    {
        this.accountType = accountType;
    }

    public String getAccountTypeDesc()
    {
        return accountTypeDesc;
    }

    public void setAccountTypeDesc(String accountTypeDesc)
    {
        this.accountTypeDesc = accountTypeDesc;
    }

    public String getAccountSubType()
    {
        return accountSubType;
    }

    public void setAccountSubType(String accountSubType)
    {
        this.accountSubType = accountSubType;
    }

    
    /**
     * 
     * @return 
     * edited by dinesh for handle power account types
     */
    public String getIsPowerAccount()
    {
        return isPowerAccount;
    }

    /**
     * 
     * @param isPowerAccount
     * edited by dinesh for handle power account types
     */
    public void setIsPowerAccount(String isPowerAccount)
    {
        this.isPowerAccount = isPowerAccount;
    }

    public String getAccountStatus()
    {
        return accountStatus;
    }

    public void setAccountStatus(String accountStatus)
    {
        this.accountStatus = accountStatus;
    }

    public String getAccountStatusDesc()
    {
        return accountStatusDesc;
    }

    public void setAccountStatusDesc(String accountStatusDesc)
    {
        this.accountStatusDesc = accountStatusDesc;
    }

    public String getAccountHolderName()
    {
        return accountHolderName;
    }

    public void setAccountHolderName(String accountHolderName)
    {
        this.accountHolderName = accountHolderName;
    }

    public String getAccountHoderAddress1()
    {
        return accountHoderAddress1;
    }

    public void setAccountHoderAddress1(String accountHoderAddress1)
    {
        this.accountHoderAddress1 = accountHoderAddress1;
    }

    public String getAccountHoderAddress2()
    {
        return accountHoderAddress2;
    }

    public void setAccountHoderAddress2(String accountHoderAddress2)
    {
        this.accountHoderAddress2 = accountHoderAddress2;
    }

    public String getAccountHoderAddress3()
    {
        return accountHoderAddress3;
    }

    public void setAccountHoderAddress3(String accountHoderAddress3)
    {
        this.accountHoderAddress3 = accountHoderAddress3;
    }

    public String getAccountHoderAddress4()
    {
        return accountHoderAddress4;
    }

    public void setAccountHoderAddress4(String accountHoderAddress4)
    {
        this.accountHoderAddress4 = accountHoderAddress4;
    }

    public String getContactNo()
    {
        return contactNo;
    }

    public void setContactNo(String contactNo)
    {
        this.contactNo = contactNo;
    }

    public String getSecondaryAccountHolderName()
    {
        return secondaryAccountHolderName;
    }

    public void setSecondaryAccountHolderName(String secondaryAccountHolderName)
    {
        this.secondaryAccountHolderName = secondaryAccountHolderName;
    }

    public String getSecondaryAccountHoderAddress()
    {
        return secondaryAccountHoderAddress;
    }

    public void setSecondaryAccountHoderAddress(String secondaryAccountHoderAddress)
    {
        this.secondaryAccountHoderAddress = secondaryAccountHoderAddress;
    }

    public String getSecondaryContactNo()
    {
        return secondaryContactNo;
    }

    public void setSecondaryContactNo(String secondaryContactNo)
    {
        this.secondaryContactNo = secondaryContactNo;
    }

    public String getChequeBookCategory()
    {
        return chequeBookCategory;
    }

    public void setChequeBookCategory(String chequeBookCategory)
    {
        this.chequeBookCategory = chequeBookCategory;
    }

    public String getIsNamePrePrintedOnCheques()
    {
        return isNamePrePrintedOnCheques;
    }

    public void setIsNamePrePrintedOnCheques(String isNamePrePrintedOnCheques)
    {
        this.isNamePrePrintedOnCheques = isNamePrePrintedOnCheques;
    }

    public String getRemarks()
    {
        return remarks;
    }

    public void setRemarks(String remarks)
    {
        this.remarks = remarks;
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

    public long getNoOfAccountHolders()
    {
        return noOfAccountHolders;
    }

    public void setNoOfAccountHolders(long noOfAccountHolders)
    {
        this.noOfAccountHolders = noOfAccountHolders;
    }

    public String getThirdAccountHolderName()
    {
        return thirdAccountHolderName;
    }

    public void setThirdAccountHolderName(String thirdAccountHolderName)
    {
        this.thirdAccountHolderName = thirdAccountHolderName;
    }

    public String getThirdAccountHoderAddress()
    {
        return thirdAccountHoderAddress;
    }

    public void setThirdAccountHoderAddress(String thirdAccountHoderAddress)
    {
        this.thirdAccountHoderAddress = thirdAccountHoderAddress;
    }

    public String getThirdContactNo()
    {
        return thirdContactNo;
    }

    public void setThirdContactNo(String thirdContactNo)
    {
        this.thirdContactNo = thirdContactNo;
    }

    public String getNIC_No()
    {
        return NIC_No;
    }

    public void setNIC_No(String NIC_No)
    {
        this.NIC_No = NIC_No;
    }

    public String getSecondaryNIC_No()
    {
        return secondaryNIC_No;
    }

    public void setSecondaryNIC_No(String secondaryNIC_No)
    {
        this.secondaryNIC_No = secondaryNIC_No;
    }

    public String getThirdNIC_No()
    {
        return thirdNIC_No;
    }

    public void setThirdNIC_No(String thirdNIC_No)
    {
        this.thirdNIC_No = thirdNIC_No;
    }

}
