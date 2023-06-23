/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.executionBatch;

/**
 *
 * @author Isanka
 */
public class ExecutionBatch {
    private String BatchId;
    private String BatchName;
    private String Status;
    private String StartTime;
    private String EndTime;
    private String ExecutedBy;
    private String Module;
 private String modifiedby;
  private String modifiedDate;
  private String StatusId;

    private String currentStatus;

    
     public String getBatchId() {
        return BatchId;
    }

    public String getBatchName() {
        return BatchName;
    }

    public String getStatus() {
        return Status;
    }

    public String getStartTime() {
        return StartTime;
    }

    public String getEndTime() {
        return EndTime;
    }

    public String getExecutedBy() {
        return ExecutedBy;
    }

    public String getModifiedby() {
        return modifiedby;
    }

    public String getModule() {
        return Module;
    }

    public void setBatchId(String BatchId) {
        this.BatchId = BatchId;
    }

    public void setBatchName(String BatchName) {
        this.BatchName = BatchName;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }

    public void setStartTime(String StartTime) {
        this.StartTime = StartTime;
    }

    public void setEndTime(String EndTime) {
        this.EndTime = EndTime;
    }

    public void setExecutedBy(String ExecutedBy) {
        this.ExecutedBy = ExecutedBy;
    }

    public void setModule(String Module) {
        this.Module = Module;
    }

    /**
     * @return the StatusId
     */
    public String getStatusId() {
        return StatusId;
    }

    /**
     * @param StatusId the StatusId to set
     */
    public void setStatusId(String StatusId) {
        this.StatusId = StatusId;
    }

    /**
     * @param modifiedby the modifiedby to set
     */
    public void setModifiedby(String modifiedby) {
        this.modifiedby = modifiedby;
    }

    /**
     * @return the modifiedDate
     */
    public String getModifiedDate() {
        return modifiedDate;
    }

    /**
     * @param modifiedDate the modifiedDate to set
     */
    public void setModifiedDate(String modifiedDate) {
        this.modifiedDate = modifiedDate;
    }

    /**
     * @return the currentStatus
     */
    public String getCurrentStatus() {
        return currentStatus;
    }

    /**
     * @param currentStatus the currentStatus to set
     */
    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }
    
   
    
}
