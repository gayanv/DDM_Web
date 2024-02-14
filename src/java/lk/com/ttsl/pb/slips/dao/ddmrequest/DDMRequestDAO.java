/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.ddmrequest;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface DDMRequestDAO
{

    /**
     *
     * @return
     */
    public String getMsg();

    /**
     *
     * @param ddaRequestId
     * @return
     */
    public DDMRequest getDDARequestDetails(String ddaRequestId);

    /**
     *
     * @param merchantId
     * @param issuingBankCode
     * @param issuingBranchCode
     * @param acquiringBankCode
     * @param acquiringBranchCode
     * @param status
     * @param fromRequestDate
     * @param toRequestDate
     * @return
     */
    public Collection<DDMRequest> getDDARequestDetails(String merchantId, String issuingBankCode, String issuingBranchCode, String acquiringBankCode, String acquiringBranchCode, String status, String fromRequestDate, String toRequestDate);

    /**
     *
     * @param merchantId
     * @param issuingBankCode
     * @param issuingBranchCode
     * @param issuningAcountNo
     * @param issuningAcountName
     * @param acquiringBankCode
     * @param acquiringBranchCode
     * @param acquiringAccountNo
     * @param acquiringAccountName
     * @param status
     * @param fromRequestDate
     * @param toRequestDate
     * @return
     */
    public Collection<DDMRequest> getDDARequestDetails(String merchantId, String issuingBankCode, String issuingBranchCode, String issuningAcountNo, String issuningAcountName, String acquiringBankCode, String acquiringBranchCode, String acquiringAccountNo, String acquiringAccountName, String status, String fromRequestDate, String toRequestDate);

    /**
     *
     * @param issuingBankCode
     * @return
     */
    public Collection<DDMRequest> getDDARequestDetailsForIssuingBankApproval(String issuingBankCode);

    /**
     *
     * @param issuingBank
     * @param issuingBranch
     * @param acquiringBank
     * @param acquiringBranch
     * @param merchantID
     * @return
     */
    public Collection<DDMRequest> getDDARequestDetailsForIssuingBankApproval(String issuingBank, String issuingBranch, String acquiringBank, String acquiringBranch, String merchantID);

    /**
     *
     * @param acquiringBank
     * @return
     */
    public Collection<DDMRequest> getDDARequestDetailsForAcquiringBankApproval(String acquiringBank);

    /**
     *
     * @param acquiringBank
     * @param acquiringBranch
     * @param issuingBank
     * @param issuingBranch
     * @param merchantID
     * @return
     */
    public Collection<DDMRequest> getDDARequestDetailsForAcquiringBankApproval(String acquiringBank, String acquiringBranch, String issuingBank, String issuingBranch, String merchantID);

    /**
     *
     * @return
     */
    public Collection<DDMRequest> getDDARequestDetailsForDDAReqTerminationApproval();

    /**
     *
     * @param acquiringBank
     * @param acquiringBranch
     * @param issuingBank
     * @param issuingBranch
     * @param merchantID
     * @return
     */
    public Collection<DDMRequest> getDDARequestDetailsForDDAReqTerminationApproval(String acquiringBank, String acquiringBranch, String issuingBank, String issuingBranch, String merchantID);

    
    
        /**
     * 
     * @param merchantId
     * @param fromRequestDate
     * @param toRequestDate
     * @return 
     */
    public Collection<DDMRequest> getDDAReqSummaryByMerchant(String merchantId, String bank, String fromRequestDate, String toRequestDate);
    
    
    
    /**
     * 
     * @param merchantId
     * @param issuingBankCode
     * @param fromRequestDate
     * @param toRequestDate
     * @return 
     */
    public Collection<DDMRequest> getSLABreachByIssuingBankDDAReqSummary(String merchantId, String issuingBankCode, String fromRequestDate, String toRequestDate);

    /**
     *
     * @param merchantId
     * @param issuingBankCode
     * @param issuingBranchCode
     * @param acquiringBankCode
     * @param acquiringBranchCode
     * @param fromRequestDate
     * @param toRequestDate
     * @param status
     * @return
     */
    public Collection<DDMRequest> getSLABreachByIssuingBankDDAReqDetails(String merchantId, String issuingBankCode, String issuingBranchCode, String acquiringBankCode, String acquiringBranchCode, String status, String fromRequestDate, String toRequestDate);

    /**
     *
     * @param merchantId
     * @param acquiringBank
     * @param fromRequestDate
     * @param toRequestDate
     * @return
     */
    public Collection<DDMRequest> getSLABreachByAcquiringBankDDAReqSummary(String merchantId, String acquiringBank, String fromRequestDate, String toRequestDate);

    /**
     *
     * @param merchantId
     * @param issuingBankCode
     * @param issuingBranchCode
     * @param acquiringBankCode
     * @param acquiringBranchCode
     * @param fromRequestDate
     * @param toRequestDate
     * @param status
     * @return
     */
    public Collection<DDMRequest> getSLABreachByAcquiringBankDDAReqDetails(String merchantId, String issuingBankCode, String issuingBranchCode, String acquiringBankCode, String acquiringBranchCode, String status, String fromRequestDate, String toRequestDate);

    
    /**
     * 
     * @param ddmRequest
     * @return 
     */
    public boolean addDDARequest(DDMRequest ddmRequest);
    public boolean rmDDARequest(String csvpath);
    
    
    /**
     *
     * @param ddaRequestId
     * @param curStatus
     * @param newStatus
     * @param modifiedBy
     * @param remarks
     * @return
     */
    public boolean updateDDMRequestStatus(String ddaRequestId, String curStatus, String newStatus, String modifiedBy, String remarks);
    
    /**
     * 
     * @param csvFileName
     * @param curStatus
     * @param newStatus
     * @param modifiedBy
     * @param remarks
     * @return 
     */
    public boolean updateDDMRequestStatusByCSVFileName(String csvFileName, String curStatus, String newStatus, String modifiedBy);
    
    
    /**
     * 
     * @param csvFileName
     * @return 
     */
    public boolean isCSVFileAlreadyUploaded(String csvFileName);
    

}
