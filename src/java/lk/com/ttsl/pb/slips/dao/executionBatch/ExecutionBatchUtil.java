/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.executionBatch;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Collection;


/**
 *
 * @author Isanka
 */
public class ExecutionBatchUtil {

    public ExecutionBatchUtil() {
    }
    static final SimpleDateFormat sdf_with_time = new SimpleDateFormat(
            "dd/MM/yyyy hh:mm:ss aa");
    /*
     * @param ResultSet 
     * @return collection 
     */

    public static Collection<ExecutionBatch> makeExeBatchObjectCollection(final ResultSet rs)
            throws SQLException {

        if (rs == null) {
            throw new NullPointerException("resultset parameter");
        }

        Collection<ExecutionBatch> exeBatchResult = new java.util.ArrayList();

        while (rs.next()) {
            
            ExecutionBatch exeBatch = new ExecutionBatch();
            
            exeBatch.setBatchId(rs.getString("BatchId"));
            exeBatch.setBatchName(rs.getString("BatchName"));
            exeBatch.setStatus(rs.getString("Status"));
         exeBatch.setStartTime(rs.getString("starttime"));
           exeBatch.setEndTime(rs.getString("endtime"));
        exeBatch.setStatusId(rs.getString("StatusId"));
  //    exeBatch.setStartTime(DateFormatter.doFormat(rs.getTimestamp("starttime").getTime(), "yyyy-MM-dd HH:mm:ss"));
  // exeBatch.setEndTime(DateFormatter.doFormat(rs.getTimestamp("endtime").getTime(), "yyyy-MM-dd HH:mm:ss"));


         // batch.setTransactionDate(DateFormatter.doFormat(rs.getTimestamp("TransactionDate").getTime(), "yyyy-MM-dd HH:mm:ss"));

            //exeBatch.setStatus(rs.getString("endtime"));
            exeBatch.setExecutedBy(rs.getString("ExecutedBy"));
            exeBatch.setModule(rs.getString("Module"));
//sdf_with_time.format(rs.getTimestamp("modifiedDate")), rs.getString("modifiedBy"));
           
            exeBatchResult.add(exeBatch);
        }

        return exeBatchResult;
    }
}
