/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.message.body;

import java.sql.Connection;
import java.sql.PreparedStatement;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;


/**
 *
 * @author Dinesh
 */
public class MsgBodyDAOImpl implements MsgBodyDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public boolean addRecord(MsgBody msgBody)
    {
        boolean status = false;

        Connection con = null;
        PreparedStatement pstm = null;

        if (msgBody.getMsgId() < 0)
        {
            System.out.println("WARNING : Invalid msgId parameter.");
            return status;
        }

        if (msgBody.getMsgToBank() == null)
        {
            System.out.println("WARNING : Null msgBody.getMsgToBank() parameter.");
            return status;
        }

        if (msgBody.getIsRed() == null)
        {
            System.out.println("WARNING : Null msgBody.getIsRed() parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_messagebody + " ");
            sbQuery.append("(MsgID, MsgTo, Body, IsRed) ");
            sbQuery.append("values(?,?,?,?) ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setLong(1, msgBody.getMsgId());
            pstm.setString(2, msgBody.getMsgToBank());

            pstm.setString(3, msgBody.getBody());
            pstm.setString(4, msgBody.getIsRed());

            int i = pstm.executeUpdate();

            if (i > 0)
            {
                status = true;
            }
            else
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
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    public boolean updateRecord(MsgBody msgBody)
    {
        boolean status = false;

        Connection con = null;
        PreparedStatement pstm = null;

        if (msgBody.getMsgId() < 0)
        {
            System.out.println("WARNING : Invalid msgId parameter.");
            return status;
        }

        if (msgBody.getMsgToBank() == null)
        {
            System.out.println("WARNING : Null msgBody.getMsgToBank() parameter.");
            return status;
        }

        if (msgBody.getIsRed() == null)
        {
            System.out.println("WARNING : Null isRed parameter.");
            return status;
        }
        else
        {
            if (msgBody.getIsRed().equals(DDM_Constants.msg_isred_yes))
            {
                if (msgBody.getRedBy() == null)
                {
                    System.out.println("WARNING : Null redBy parameter.");
                    return status;
                }
            }
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update  ");
            sbQuery.append(DDM_Constants.tbl_messagebody + " set ");
            sbQuery.append("IsRed = ?, ");

            if (msgBody.getIsRed().equals(DDM_Constants.msg_isred_yes))
            {
                sbQuery.append("RedBy = ?, ");
                sbQuery.append("RedTime = now() ");
            }
            else
            {
                sbQuery.append("RedBy = null, ");
                sbQuery.append("RedTime = null ");
            }

            sbQuery.append("where MsgID = ? ");
            sbQuery.append("and MsgTo = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            if (msgBody.getIsRed().equals(DDM_Constants.msg_isred_yes))
            {
                pstm.setString(1, msgBody.getIsRed());
                pstm.setString(2, msgBody.getRedBy());
                pstm.setLong(3, msgBody.getMsgId());
                pstm.setString(4, msgBody.getMsgToBank());

            }
            else
            {
                pstm.setString(1, msgBody.getIsRed());
                pstm.setLong(2, msgBody.getMsgId());
                pstm.setString(3, msgBody.getMsgToBank());

            }

            int i = pstm.executeUpdate();

            if (i > 0)
            {
                status = true;
            }
            else
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
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }
}
