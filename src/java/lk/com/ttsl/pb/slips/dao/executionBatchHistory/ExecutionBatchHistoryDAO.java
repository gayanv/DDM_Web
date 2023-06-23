/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.executionBatchHistory;

import java.util.Collection;

import lk.com.ttsl.pb.slips.dao.executionBatch.ExecutionBatch;

/**
 *
 * @author Isanka
 */
public interface ExecutionBatchHistoryDAO
{

    //   public Collection<ExecutionBatchHistory> getExecutionBatchHistory(String exeBatchId,
    //          String fromBusinessDate, String toBusinessDate);
    public Collection<ExecutionBatchHistory> getExecutionBatchHistory(String exeBatchId,
            String status, String fromBusinessDate, String toBusinessDate);

    public boolean update(Collection<ExecutionBatch> para);

}
