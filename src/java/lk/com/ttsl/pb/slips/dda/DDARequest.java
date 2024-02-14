/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dda;

/**
 *
 * @author TTSADMIN
 */
public class DDARequest {

    private String DDAID;
    private String MerchantID;
    private String IssuningBank;
    private String IssuningBranch;
    private String IssuningAcNo;
    private String IssuningAcName;
    private String StartDate;
    private String EndDate;
    private String MaxLimit;
    private String Frequency;
    private String Purpose;
    private String Ref;
    private String Status;
    private String aquiringBank;
    private String aquiringBranch;
    private String aquiringAcNo;
    private String aquiringAcName;
    private String createdBy;

    /*
    DDAID, MerchantID, IssuningBank, IssuningBranch, IssuningAcNo, IssuningAcName, 
    StartDate, EndDate, MaxLimit, Frequency, Purpose, Ref, Status,
    AquiringBank, AquiringBranch, AquiringAcNo, AquiringAcName,  
    CreatedBy, CreatedDate
     */
    public String getDDAID() {
        return DDAID;
    }

    public void setDDAID(String DDAID) {
        this.DDAID = DDAID;
    }

    public String getMerchantID() {
        return MerchantID;
    }

    public void setMerchantID(String MerchantID) {
        this.MerchantID = MerchantID;
    }

    public String getIssuningBank() {
        return IssuningBank;
    }

    public void setIssuningBank(String IssuningBank) {
        this.IssuningBank = IssuningBank;
    }

    public String getIssuningBranch() {
        return IssuningBranch;
    }

    public void setIssuningBranch(String IssuningBranch) {
        this.IssuningBranch = IssuningBranch;
    }

    public String getIssuningAcNo() {
        return IssuningAcNo;
    }

    public void setIssuningAcNo(String IssuningAcNo) {
        this.IssuningAcNo = IssuningAcNo;
    }

    public String getIssuningAcName() {
        return IssuningAcName;
    }

    public void setIssuningAcName(String IssuningAcName) {
        this.IssuningAcName = IssuningAcName;
    }

    public String getStartDate() {
        return StartDate;
    }

    public void setStartDate(String StartDate) {
        this.StartDate = StartDate;
    }

    public String getEndDate() {
        return EndDate;
    }

    public void setEndDate(String EndDate) {
        this.EndDate = EndDate;
    }

    public String getMaxLimit() {
        return MaxLimit;
    }

    public void setMaxLimit(String MaxLimit) {
        this.MaxLimit = MaxLimit;
    }

    public String getFrequency() {
        return Frequency;
    }

    public void setFrequency(String Frequency) {
        this.Frequency = Frequency;
    }

    public String getPurpose() {
        return Purpose;
    }

    public void setPurpose(String Purpose) {
        this.Purpose = Purpose;
    }

    public String getRef() {
        return Ref;
    }

    public void setRef(String Ref) {
        this.Ref = Ref;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }

    public String getAquiringBank() {
        return aquiringBank;
    }

    public void setAquiringBank(String aquiringBank) {
        this.aquiringBank = aquiringBank;
    }

    public String getAquiringBranch() {
        return aquiringBranch;
    }

    public void setAquiringBranch(String aquiringBranch) {
        this.aquiringBranch = aquiringBranch;
    }

    public String getAquiringAcNo() {
        return aquiringAcNo;
    }

    public void setAquiringAcNo(String aquiringAcNo) {
        this.aquiringAcNo = aquiringAcNo;
    }

    public String getAquiringAcName() {
        return aquiringAcName;
    }

    public void setAquiringAcName(String aquiringAcName) {
        this.aquiringAcName = aquiringAcName;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public String toString() {
        return "DDARequest{" + "DDAID=" + DDAID + ", MerchantID=" + MerchantID + ", IssuningBank=" + IssuningBank + ", IssuningBranch=" + IssuningBranch + ", IssuningAcNo=" + IssuningAcNo + ", IssuningAcName=" + IssuningAcName + ", StartDate=" + StartDate + ", EndDate=" + EndDate + ", MaxLimit=" + MaxLimit + ", Frequency=" + Frequency + ", Purpose=" + Purpose + ", Ref=" + Ref + ", Status=" + Status + ", aquiringBank=" + aquiringBank + ", aquiringBranch=" + aquiringBranch + ", aquiringAcNo=" + aquiringAcNo + ", aquiringAcName=" + aquiringAcName + ", createdBy=" + createdBy + '}';
    }

}
