/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package lk.com.ttsl.pb.slips.dao.executionBatchStatus;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

/**
 *
 * @author Isanka
 */
public class ExecutionBatchStatusUtil {
public static Collection<ExecutionBatchStatus> makeExecutionBatchStatusObjectCollection(ResultSet rs)
            throws SQLException {
        if (rs == null) {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();
        while (rs.next()) {


            ExecutionBatchStatus ex = new ExecutionBatchStatus();

            ex.setStatusId(rs.getString("StatusId"));
            ex.setStatusDesc(rs.getString("StatusDesc"));


            result.add(ex);

        }
        return result;
    }
}
