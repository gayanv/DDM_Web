/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.logType;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class LogTypeDAOImpl implements LogTypeDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public LogType getLogType(String logId)
    {
        LogType lt = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (logId == null)
        {
            System.out.println("WARNING : Null logId parameter.");
            return lt;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ID, Description from ");
            sbQuery.append(DDM_Constants.tbl_logtype + " ");
            sbQuery.append("where ID = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, logId);

            rs = pstm.executeQuery();

            lt = LogTypeUtil.makeLogTypeObject(rs);

            if (lt == null)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return lt;
    }

    public Collection<LogType> getLogTypes()
    {
        Collection<LogType> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ID, Description from ");
            sbQuery.append(DDM_Constants.tbl_logtype + " ");
            sbQuery.append("order by Description");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = LogTypeUtil.makeLogTypeObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }
}
