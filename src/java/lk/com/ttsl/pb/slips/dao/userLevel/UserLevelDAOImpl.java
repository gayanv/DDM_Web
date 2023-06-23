/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.userLevel;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh - ProntoIT
 */
public class UserLevelDAOImpl implements UserLevelDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public UserLevel getUserLevel(String id)
    {
        UserLevel usrLvl = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (id == null)
        {
            System.out.println("WARNING : Null id parameter.");
            return usrLvl;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT  UserLevelId, UserLevelDesc from ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " ");
            sbQuery.append("where UserLevelId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, id);

            rs = pstm.executeQuery();

            usrLvl = UserLevelUtil.makeUserLevelObject(rs);

            if (usrLvl == null)
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

        return usrLvl;
    }

    public Collection<UserLevel> getUserLevelDetails()
    {
        Collection<UserLevel> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT  UserLevelId, UserLevelDesc from ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " ");
            sbQuery.append("ORDER BY UserLevelDesc");

            pstm = con.prepareStatement(sbQuery.toString());


            rs = pstm.executeQuery();

            col = UserLevelUtil.makeUserLevelObjectsCollection(rs);

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
