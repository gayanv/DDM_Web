/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.confirmstatus;

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
public class ConfirmStatusDAOImpl implements ConfirmStatusDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public ConfirmStatus getConfirmStatus(String id)
    {
        ConfirmStatus fs = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (id == null)
        {
            System.out.println("WARNING : Null id parameter.");
            return fs;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ID, Description from ");
            sbQuery.append(DDM_Constants.tbl_confirmstatus + " ");
            sbQuery.append("where ID = ?  ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, id);

            rs = pstm.executeQuery();

            fs = ConfirmStatusUtil.makeConfirmStatusObject(rs);

            if (fs == null)
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

        return fs;
    }

    public Collection<ConfirmStatus> getConfirmStatusDetails()
    {
        Collection<ConfirmStatus> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ID, Description from ");
            sbQuery.append(DDM_Constants.tbl_confirmstatus);            
            
            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = ConfirmStatusUtil.makeConfirmStatusObjectsCollection(rs);

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
