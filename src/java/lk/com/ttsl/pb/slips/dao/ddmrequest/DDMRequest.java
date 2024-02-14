/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.ddmrequest;

/**
 *
 * @author Dinesh
 */
public class DDMRequest
{

    private String DDA_ID;
    private String merchantID;
    private String merchantName;

    private String issuningBankCode;
    private String issuningBankName;
    private String issuningBankShortName;
    private String issuningBranch;
    private String issuningBranchName;
    private String issuningAccountNumber;
    private String issuningAccountName;

    private String acquiringBankCode;
    private String acquiringBankName;
    private String acquiringBankShortName;
    private String acquiringBranch;
    private String acquiringBranchName;
    private String acquiringAccountNumber;
    private String acquiringAccountName;

    private String frequency;
    private String maxLimit;
    private String Purpose;
    private String startDate;
    private String endDate;
    private String status;
    private String statusDesc;
    private String statusModify;
    private String statusModifyDesc;
    private String createdBy;
    private String createdDate;
    private String reference;
    
    private String isCSVFileRequest;
    private String CSVFileName;
    private String CSVFilePath; 
    
    
    private String issuingBankAcceptedRemarks;
    private String issuingBankAcceptedBy;
    private String issuingBankAcceptedOn;
    private String acquiringBankAcceptedRemarks;
    private String acquiringBankAcceptedBy;
    private String acquiringBankAcceptedOn;

    private String terminationRequestRemarks;
    private String terminationRequestedBy;
    private String terminationRequestedOn;
    private String terminationApprovalRemarks;
    private String terminationApprovedBy;
    private String terminationApprovedOn;
    
    int ongoingReqCount;
    int completedReqCount;
    int rejectedReqCount;
    int SLABreachedReqCount;
    int terminatedReqCount;

    int SLABreachedIsuBkReqCount;
    int SLABreachedAcqBkReqCount;

    int SLABreachedIsuBkReqExceedDays;
    int SLABreachedAcqBkReqExceedDays;

    double SLABreachedIsuBkReqAvgExceedDays;
    double SLABreachedAcqBkReqAvgExceedDays;

    public DDMRequest()
    {
    }

    public DDMRequest(String DDA_ID, String status)
    {
        this.DDA_ID = DDA_ID;
        this.status = status;
    }

    public DDMRequest(String DDA_ID, String status, String createdBy)
    {
        this.DDA_ID = DDA_ID;
        this.status = status;
        this.createdBy = createdBy;
    }

    public String getDDA_ID()
    {
        return DDA_ID;
    }

    public void setDDA_ID(String DDA_ID)
    {
        this.DDA_ID = DDA_ID;
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

    public String getAcquiringAccountName()
    {
        return acquiringAccountName;
    }

    public void setAcquiringAccountName(String acquiringAccountName)
    {
        this.acquiringAccountName = acquiringAccountName;
    }

    public String getAcquiringAccountNumber()
    {
        return acquiringAccountNumber;
    }

    public void setAcquiringAccountNumber(String acquiringAccountNumber)
    {
        this.acquiringAccountNumber = acquiringAccountNumber;
    }

    public String getAcquiringBankCode()
    {
        return acquiringBankCode;
    }

    public void setAcquiringBankCode(String acquiringBankCode)
    {
        this.acquiringBankCode = acquiringBankCode;
    }

    public String getAcquiringBankName()
    {
        return acquiringBankName;
    }

    public void setAcquiringBankName(String acquiringBankName)
    {
        this.acquiringBankName = acquiringBankName;
    }

    public String getAcquiringBankShortName()
    {
        return acquiringBankShortName;
    }

    public void setAcquiringBankShortName(String acquiringBankShortName)
    {
        this.acquiringBankShortName = acquiringBankShortName;
    }

    public String getAcquiringBranch()
    {
        return acquiringBranch;
    }

    public void setAcquiringBranch(String acquiringBranch)
    {
        this.acquiringBranch = acquiringBranch;
    }

    public String getAcquiringBranchName()
    {
        return acquiringBranchName;
    }

    public void setAcquiringBranchName(String acquiringBranchName)
    {
        this.acquiringBranchName = acquiringBranchName;
    }

    public String getIssuningAccountName()
    {
        return issuningAccountName;
    }

    public void setIssuningAccountName(String issuningAccountName)
    {
        this.issuningAccountName = issuningAccountName;
    }

    public String getIssuningAccountNumber()
    {
        return issuningAccountNumber;
    }

    public void setIssuningAccountNumber(String issuningAccountNumber)
    {
        this.issuningAccountNumber = issuningAccountNumber;
    }

    public String getIssuningBankCode()
    {
        return issuningBankCode;
    }

    public void setIssuningBankCode(String issuningBankCode)
    {
        this.issuningBankCode = issuningBankCode;
    }

    public String getIssuningBankName()
    {
        return issuningBankName;
    }

    public void setIssuningBankName(String issuningBankName)
    {
        this.issuningBankName = issuningBankName;
    }

    public String getIssuningBankShortName()
    {
        return issuningBankShortName;
    }

    public void setIssuningBankShortName(String issuningBankShortName)
    {
        this.issuningBankShortName = issuningBankShortName;
    }

    public String getIssuningBranch()
    {
        return issuningBranch;
    }

    public void setIssuningBranch(String issuningBranch)
    {
        this.issuningBranch = issuningBranch;
    }

    public String getIssuningBranchName()
    {
        return issuningBranchName;
    }

    public void setIssuningBranchName(String issuningBranchName)
    {
        this.issuningBranchName = issuningBranchName;
    }

    public String getFrequency()
    {
        return frequency;
    }

    public void setFrequency(String frequency)
    {
        this.frequency = frequency;
    }

    public String getMaxLimit()
    {
        return maxLimit;
    }

    public void setMaxLimit(String maxLimit)
    {
        this.maxLimit = maxLimit;
    }

    public String getPurpose()
    {
        return Purpose;
    }

    public void setPurpose(String Purpose)
    {
        this.Purpose = Purpose;
    }

    public String getStartDate()
    {
        return startDate;
    }

    public void setStartDate(String startDate)
    {
        this.startDate = startDate;
    }

    public String getEndDate()
    {
        return endDate;
    }

    public void setEndDate(String endDate)
    {
        this.endDate = endDate;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getStatusDesc()
    {
        return statusDesc;
    }

    public void setStatusDesc(String statusDesc)
    {
        this.statusDesc = statusDesc;
    }

    public String getStatusModify()
    {
        return statusModify;
    }

    public void setStatusModify(String statusModify)
    {
        this.statusModify = statusModify;
    }

    public String getStatusModifyDesc()
    {
        return statusModifyDesc;
    }

    public void setStatusModifyDesc(String statusModifyDesc)
    {
        this.statusModifyDesc = statusModifyDesc;
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

    public String getReference()
    {
        return reference;
    }

    public void setReference(String reference)
    {
        this.reference = reference;
    }

    public String getIsCSVFileRequest() {
        return isCSVFileRequest;
    }

    public void setIsCSVFileRequest(String isCSVFileRequest) {
        this.isCSVFileRequest = isCSVFileRequest;
    }

    public String getCSVFileName() {
        return CSVFileName;
    }

    public void setCSVFileName(String CSVFileName) {
        this.CSVFileName = CSVFileName;
    }

    public String getCSVFilePath() {
        return CSVFilePath;
    }

    public void setCSVFilePath(String CSVFilePath) {
        this.CSVFilePath = CSVFilePath;
    }
    
    

    public String getIssuingBankAcceptedRemarks()
    {
        return issuingBankAcceptedRemarks;
    }

    public void setIssuingBankAcceptedRemarks(String issuingBankAcceptedRemarks)
    {
        this.issuingBankAcceptedRemarks = issuingBankAcceptedRemarks;
    }

    public String getIssuingBankAcceptedBy()
    {
        return issuingBankAcceptedBy;
    }

    public void setIssuingBankAcceptedBy(String issuingBankAcceptedBy)
    {
        this.issuingBankAcceptedBy = issuingBankAcceptedBy;
    }

    public String getIssuingBankAcceptedOn()
    {
        return issuingBankAcceptedOn;
    }

    public void setIssuingBankAcceptedOn(String issuingBankAcceptedOn)
    {
        this.issuingBankAcceptedOn = issuingBankAcceptedOn;
    }

    public String getAcquiringBankAcceptedRemarks()
    {
        return acquiringBankAcceptedRemarks;
    }

    public void setAcquiringBankAcceptedRemarks(String acquiringBankAcceptedRemarks)
    {
        this.acquiringBankAcceptedRemarks = acquiringBankAcceptedRemarks;
    }

    public String getAcquiringBankAcceptedBy()
    {
        return acquiringBankAcceptedBy;
    }

    public void setAcquiringBankAcceptedBy(String acquiringBankAcceptedBy)
    {
        this.acquiringBankAcceptedBy = acquiringBankAcceptedBy;
    }

    public String getAcquiringBankAcceptedOn()
    {
        return acquiringBankAcceptedOn;
    }

    public void setAcquiringBankAcceptedOn(String acquiringBankAcceptedOn)
    {
        this.acquiringBankAcceptedOn = acquiringBankAcceptedOn;
    }

    public String getTerminationRequestRemarks()
    {
        return terminationRequestRemarks;
    }

    public void setTerminationRequestRemarks(String terminationRequestRemarks)
    {
        this.terminationRequestRemarks = terminationRequestRemarks;
    }

    public String getTerminationRequestedBy()
    {
        return terminationRequestedBy;
    }

    public void setTerminationRequestedBy(String terminationRequestedBy)
    {
        this.terminationRequestedBy = terminationRequestedBy;
    }

    public String getTerminationRequestedOn()
    {
        return terminationRequestedOn;
    }

    public void setTerminationRequestedOn(String terminationRequestedOn)
    {
        this.terminationRequestedOn = terminationRequestedOn;
    }

    public String getTerminationApprovalRemarks()
    {
        return terminationApprovalRemarks;
    }

    public void setTerminationApprovalRemarks(String terminationApprovalRemarks)
    {
        this.terminationApprovalRemarks = terminationApprovalRemarks;
    }

    public String getTerminationApprovedBy()
    {
        return terminationApprovedBy;
    }

    public void setTerminationApprovedBy(String terminationApprovedBy)
    {
        this.terminationApprovedBy = terminationApprovedBy;
    }

    public String getTerminationApprovedOn()
    {
        return terminationApprovedOn;
    }

    public void setTerminationApprovedOn(String terminationApprovedOn)
    {
        this.terminationApprovedOn = terminationApprovedOn;
    }

    public int getOngoingReqCount()
    {
        return ongoingReqCount;
    }

    public void setOngoingReqCount(int ongoingReqCount)
    {
        this.ongoingReqCount = ongoingReqCount;
    }

    public int getCompletedReqCount()
    {
        return completedReqCount;
    }

    public void setCompletedReqCount(int completedReqCount)
    {
        this.completedReqCount = completedReqCount;
    }

    public int getRejectedReqCount()
    {
        return rejectedReqCount;
    }

    public void setRejectedReqCount(int rejectedReqCount)
    {
        this.rejectedReqCount = rejectedReqCount;
    }

    public int getSLABreachedReqCount()
    {
        return SLABreachedReqCount;
    }

    public void setSLABreachedReqCount(int SLABreachedReqCount)
    {
        this.SLABreachedReqCount = SLABreachedReqCount;
    }

    public int getTerminatedReqCount()
    {
        return terminatedReqCount;
    }

    public void setTerminatedReqCount(int terminatedReqCount)
    {
        this.terminatedReqCount = terminatedReqCount;
    }
    
    

    public int getSLABreachedIsuBkReqCount()
    {
        return SLABreachedIsuBkReqCount;
    }

    public void setSLABreachedIsuBkReqCount(int SLABreachedIsuBkReqCount)
    {
        this.SLABreachedIsuBkReqCount = SLABreachedIsuBkReqCount;
    }

    public int getSLABreachedAcqBkReqCount()
    {
        return SLABreachedAcqBkReqCount;
    }

    public void setSLABreachedAcqBkReqCount(int SLABreachedAcqBkReqCount)
    {
        this.SLABreachedAcqBkReqCount = SLABreachedAcqBkReqCount;
    }

    public int getSLABreachedIsuBkReqExceedDays()
    {
        return SLABreachedIsuBkReqExceedDays;
    }

    public void setSLABreachedIsuBkReqExceedDays(int SLABreachedIsuBkReqExceedDays)
    {
        this.SLABreachedIsuBkReqExceedDays = SLABreachedIsuBkReqExceedDays;
    }

    public int getSLABreachedAcqBkReqExceedDays()
    {
        return SLABreachedAcqBkReqExceedDays;
    }

    public void setSLABreachedAcqBkReqExceedDays(int SLABreachedAcqBkReqExceedDays)
    {
        this.SLABreachedAcqBkReqExceedDays = SLABreachedAcqBkReqExceedDays;
    }

    public double getSLABreachedIsuBkReqAvgExceedDays()
    {
        return SLABreachedIsuBkReqAvgExceedDays;
    }

    public void setSLABreachedIsuBkReqAvgExceedDays(double SLABreachedIsuBkReqAvgExceedDays)
    {
        this.SLABreachedIsuBkReqAvgExceedDays = SLABreachedIsuBkReqAvgExceedDays;
    }

    public double getSLABreachedAcqBkReqAvgExceedDays()
    {
        return SLABreachedAcqBkReqAvgExceedDays;
    }

    public void setSLABreachedAcqBkReqAvgExceedDays(double SLABreachedAcqBkReqAvgExceedDays)
    {
        this.SLABreachedAcqBkReqAvgExceedDays = SLABreachedAcqBkReqAvgExceedDays;
    }

}
