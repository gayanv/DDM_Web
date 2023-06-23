/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.executionBatch;

import java.util.Collection;
import java.util.HashMap;

/**
 *
 * @author Dinesh
 */
public interface ExecutionBatchDAO
{

    public Collection<ExecutionBatch> getExecutionBatch();

    //public Collection<ExecutionBatch> getExecutionBatch(String status);
    public boolean update(Collection<ExecutionBatch> exec);

    public boolean update(ExecutionBatch exec);

    public String getMsg();

    public HashMap<String, String> getFailQuery();

    public HashMap<String, String> getSuccessQuery();

    public String getExecutionBatchStatus(String batchid);

}
