/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.user.pwd.history;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;

/**
 *
 * @author Dinesh
 */
public class PWD_HistoryDAOImpl implements PWD_HistoryDAO
{

    static String msg;

    public String getMsg()
    {
        return msg;
    }

    public boolean isPWDNotAvailableInHistory(String userId, String pwd, int lastPwdCount)
{
        boolean isPWDNotAvailabel = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userId == null)
        {
            System.out.println("WARNING : Null userId parameter.");
            return isPWDNotAvailabel;
        }
        if (pwd == null)
        {
            System.out.println("WARNING : Null pwd parameter.");
            return isPWDNotAvailabel;
        }
        if (lastPwdCount <0)
        {
            System.out.println("WARNING : Invalid lastPwdCount parameter.");
            return isPWDNotAvailabel;
        }
        
        //System.out.println("userId --> " + userId);
        //System.out.println("pwd --> " + pwd);
        //System.out.println("lastPwdCount --> " + lastPwdCount);

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsPWDAvailabel FROM ");
            sbQuery.append("(SELECT * FROM ");
            sbQuery.append(DDM_Constants.tbl_user_pw_history + " ");
            sbQuery.append("WHERE UserId = BINARY(?) order by CreatedDate desc limit ?) as tempPWDHis ");
            sbQuery.append("WHERE tempPWDHis.UserId = BINARY(?)");
            sbQuery.append("AND tempPWDHis.PWD = MD5(?) ");
            
            System.out.println("isPWDNotAvailableInHistory_sbQuery (userId - "+ userId +" , pwd - "+ pwd +" , lastPwdCount -  " + lastPwdCount +") -->  " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());
            

            pstm.setString(1, userId);
            pstm.setInt(2, lastPwdCount);
            pstm.setString(3, userId);
            pstm.setString(4, userId + pwd);

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsPWDAvailabel");

                if (count == 0)
                {
                    isPWDNotAvailabel = true;
                }
            }

            if (count == -1)
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

        return isPWDNotAvailabel;
    }

    public boolean addPWD_History(PWD_History pwdHis)
    {
        boolean status = false;
        int ctr = 0;
        Connection con = null;
        PreparedStatement pstm = null;

        if (pwdHis.getUserId()  == null)
        {
            System.out.println("WARNING : Null pwdHis.getUserId() parameter.");
            return status;
        }

        if (pwdHis.getPwd() == null)
        {
            System.out.println("WARNING : Null pwdHis.getPwd() parameter.");
            return status;
        }



        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("INSERT INTO ");
            sbQuery.append(DDM_Constants.tbl_user_pw_history);
            sbQuery.append("(UserId,PWD,CreatedDate)");
            sbQuery.append("VALUES(?, MD5(?), NOW())");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, pwdHis.getUserId());
            pstm.setString(2, pwdHis.getUserId()+pwdHis.getPwd());

            ctr = pstm.executeUpdate();

            if (ctr > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }


        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;

    }
}
