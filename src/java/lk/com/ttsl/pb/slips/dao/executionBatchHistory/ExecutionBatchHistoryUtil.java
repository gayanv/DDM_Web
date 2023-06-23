/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.executionBatchHistory;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;

/**
 *
 * @author Isanka
 */
public class ExecutionBatchHistoryUtil
{

    public ExecutionBatchHistoryUtil()
    {
    }

    static final SimpleDateFormat sdf_with_time = new SimpleDateFormat(
            "dd/MM/yyyy hh:mm:ss aa");
    /*
     * @param ResultSet 
     * @return collection 
     */

    public static Collection<ExecutionBatchHistory> makeExeBatchObjectCollection(final ResultSet rs)
            throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<ExecutionBatchHistory> exeBatchResult = new java.util.ArrayList();

        while (rs.next())
        {
            ExecutionBatchHistory exeBatch = new ExecutionBatchHistory();

            exeBatch.setBatchId(rs.getString("BatchId"));
            exeBatch.setNewStatus(rs.getString("NewStatus"));
            exeBatch.setExecutedBy(rs.getString("ExecutedBy"));
            exeBatch.setModule(rs.getString("Module"));
            exeBatch.setModifiedby(rs.getString("Modifiedby"));
            exeBatch.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), "yyyy-MM-dd HH:mm:ss"));
            exeBatch.setPreviousStatus(rs.getString("PreviousStatus"));
            exeBatchResult.add(exeBatch);
        }

        return exeBatchResult;
    }

}
