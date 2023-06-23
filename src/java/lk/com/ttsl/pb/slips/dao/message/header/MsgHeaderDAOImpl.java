/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.message.header;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;


/**
 *
 * @author Dinesh
 */
public class MsgHeaderDAOImpl implements MsgHeaderDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public boolean addRecord(MsgHeader msgHeader)
    {
        boolean status = false;

        Connection con = null;
        PreparedStatement pstm = null;

        if (msgHeader.getMsgId() < 0)
        {
            System.out.println("WARNING : Invalid msgHeader.getMsgId() parameter.");
            return status;
        }

        if (msgHeader.getSubject() == null)
        {
            System.out.println("WARNING : Null msgHeader.getSubject() parameter.");
            return status;
        }

        if (msgHeader.getMsgFromBank() == null)
        {
            System.out.println("WARNING : Null msgHeader.getMsgFromBank() parameter.");
            return status;
        }

        if (msgHeader.getPriorityLevel() == null)
        {
            System.out.println("WARNING : Null msgHeader.getPriorityLevel() parameter.");
            return status;
        }

        if (msgHeader.getCreatedBy() == null)
        {
            System.out.println("WARNING : Null msgHeader.getCreatedBy() parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_messageheader + " ");
            sbQuery.append("(MsgID, Subject, MsgFrom, Priority, RecipientCount, AttachmentName, AttachmentOriginalName, AttachmentPath, CreatedBy, CreatedTime) ");
            sbQuery.append("values(?,?,?,?,0,?,?,?,?,now())");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setLong(1, msgHeader.getMsgId());
            pstm.setString(2, msgHeader.getSubject());
            pstm.setString(3, msgHeader.getMsgFromBank());
            pstm.setString(4, msgHeader.getPriorityLevel());
            pstm.setString(5, msgHeader.getAttachmentName());
            pstm.setString(6, msgHeader.getAttachmentOriginalName());
            pstm.setString(7, msgHeader.getAttachmentPath());
            pstm.setString(8, msgHeader.getCreatedBy());

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

    public boolean updateRecipientCount(long msgId, int count)
    {
        boolean status = false;

        Connection con = null;
        PreparedStatement pstm = null;

        if (msgId < 0)
        {
            System.out.println("WARNING : Invalid msgId parameter.");
            return status;
        }

        if (count < 0)
        {
            System.out.println("WARNING : Invalid count parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update  ");
            sbQuery.append(DDM_Constants.tbl_messageheader + " set ");
            sbQuery.append("RecipientCount = ? ");
            sbQuery.append("where MsgID = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setInt(1, count);
            pstm.setLong(2, msgId);

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
    
    public boolean addRecordWithParentId(MsgHeader msgHeader)
    {
        boolean status = false;

        Connection con = null;
        PreparedStatement pstm = null;

        if (msgHeader.getMsgId() < 0)
        {
            System.out.println("WARNING : Invalid msgHeader.getMsgId() parameter.");
            return status;
        }

        if (msgHeader.getSubject() == null)
        {
            System.out.println("WARNING : Null msgHeader.getSubject() parameter.");
            return status;
        }

        if (msgHeader.getMsgFromBank() == null)
        {
            System.out.println("WARNING : Null msgHeader.getMsgFromBank() parameter.");
            return status;
        }

        if (msgHeader.getPriorityLevel() == null)
        {
            System.out.println("WARNING : Null msgHeader.getPriorityLevel() parameter.");
            return status;
        }

        if (msgHeader.getCreatedBy() == null)
        {
            System.out.println("WARNING : Null msgHeader.getCreatedBy() parameter.");
            return status;
        }

        if (msgHeader.getMsgParentId() < 0)
        {
            System.out.println("WARNING : Invalid msgHeader.getMsgParentId() parameter.");
            return status;
        }

        if (msgHeader.getMsgGrandParentId() < 0)
        {
            System.out.println("WARNING : Invalid msgHeader.getMsgGrandParentId() parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_messageheader + " ");
            sbQuery.append("(MsgID, ParentId, GrandParentId, Subject, MsgFrom, Priority, RecipientCount, AttachmentName, AttachmentOriginalName, AttachmentPath, CreatedBy, CreatedTime) ");
            sbQuery.append("values(?,?,?,?,?,?,0,?,?,?,?,now())");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setLong(1, msgHeader.getMsgId());
            pstm.setLong(2, msgHeader.getMsgParentId());
            pstm.setLong(3, msgHeader.getMsgGrandParentId());
            pstm.setString(4, msgHeader.getSubject());
            pstm.setString(5, msgHeader.getMsgFromBank());
            pstm.setString(6, msgHeader.getPriorityLevel());
            pstm.setString(7, msgHeader.getAttachmentName());
            pstm.setString(8, msgHeader.getAttachmentOriginalName());
            pstm.setString(9, msgHeader.getAttachmentPath());
            pstm.setString(10, msgHeader.getCreatedBy());
            

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

    public int msgAge_InNoOfDays(long msgId)
    {
        int msgAge = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (msgId < 0)
        {
            System.out.println("WARNING : Invalid msgId parameter.");
            return msgAge;
        }


        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select DATEDIFF(now(), CreatedTime) as noOfDays from ");
            sbQuery.append(DDM_Constants.tbl_messageheader + " ");
            sbQuery.append("where MsgID = ? ");
            
            System.out.println("sbQuery.toString() ----> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setLong(1, msgId);

            rs = pstm.executeQuery();
            
            if(rs!=null && rs.isBeforeFirst())
            {
                rs.next();
                
                msgAge = rs.getInt("noOfDays");
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

        return msgAge;
    }
    
}
