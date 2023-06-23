/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.executionBatchStatus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author dinesh
 */
public class ExecutionBatchStatusDAOImpl implements ExecutionBatchStatusDAO
{

    @Override
    public Collection<ExecutionBatchStatus> getExecutionBatchStatus()
    {
        /*
         select  StatusId,    StatusDesc from   tbl_executionbatchstatus
         where StatusId !='H'
         */
        Collection<ExecutionBatchStatus> exeBatchStatus_col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;
        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select StatusId,StatusDesc from ");
            sbQuery.append(DDM_Constants.tbl_executionbatchstatus + " ");
            sbQuery.append("where StatusId !=? ");
            sbQuery.append("order by  StatusDesc");

            psmt = con.prepareStatement(sbQuery.toString());
            psmt.setString(1, "H");
            rs = psmt.executeQuery();
            System.out.println(sbQuery.toString());
            exeBatchStatus_col = ExecutionBatchStatusUtil.makeExecutionBatchStatusObjectCollection(rs);

            if (exeBatchStatus_col.isEmpty())
            {
                String msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException ex)
        {
            System.out.println(ex.toString());
        }
        catch (ClassNotFoundException ex)
        {
            System.out.println(ex.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }
        return exeBatchStatus_col;

    }

}
