/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.executionBatchHistory;

/**
 *
 * @author Isanka
 */
public class ExecutionBatchHistory {
    private String BatchId;
    private String NewStatus;
    private String StartTime;
    private String EndTime;
    private String ExecutedBy;
    private String Module;
    private String modifiedby;
    private String modifiedDate;
 private String PreviousStatus;
    /**
     * @return the BatchId
     */
    public String getBatchId() {
        return BatchId;
    }

    /**
     * @param BatchId the BatchId to set
     */
    public void setBatchId(String BatchId) {
        this.BatchId = BatchId;
    }

    

    /**
     * @return the StartTime
     */
    public String getStartTime() {
        return StartTime;
    }

    /**
     * @param StartTime the StartTime to set
     */
    public void setStartTime(String StartTime) {
        this.StartTime = StartTime;
    }

    /**
     * @return the EndTime
     */
    public String getEndTime() {
        return EndTime;
    }

    /**
     * @param EndTime the EndTime to set
     */
    public void setEndTime(String EndTime) {
        this.EndTime = EndTime;
    }

    /**
     * @return the ExecutedBy
     */
    public String getExecutedBy() {
        return ExecutedBy;
    }

    /**
     * @param ExecutedBy the ExecutedBy to set
     */
    public void setExecutedBy(String ExecutedBy) {
        this.ExecutedBy = ExecutedBy;
    }

    /**
     * @return the Module
     */
    public String getModule() {
        return Module;
    }

    /**
     * @param Module the Module to set
     */
    public void setModule(String Module) {
        this.Module = Module;
    }

    /**
     * @return the modifiedby
     */
    public String getModifiedby() {
        return modifiedby;
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
     * @return the NewStatus
     */
    public String getNewStatus() {
        return NewStatus;
    }

    /**
     * @param NewStatus the NewStatus to set
     */
    public void setNewStatus(String NewStatus) {
        this.NewStatus = NewStatus;
    }

    /**
     * @return the PreviousStatus
     */
    public String getPreviousStatus() {
        return PreviousStatus;
    }

    /**
     * @param PreviousStatus the PreviousStatus to set
     */
    public void setPreviousStatus(String PreviousStatus) {
        this.PreviousStatus = PreviousStatus;
    }
    
    
    
  
   
    
}
