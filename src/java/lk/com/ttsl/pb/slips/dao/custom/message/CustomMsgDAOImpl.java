/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.custom.message;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;
import lk.com.ttsl.pb.slips.dao.message.body.MsgBody;
import lk.com.ttsl.pb.slips.dao.message.header.MsgHeader;


/**
 *
 * @author Dinesh
 */
public class CustomMsgDAOImpl implements CustomMsgDAO
{

    String msg = null;
    Collection<CustomMsg> successList = null;
    Collection<CustomMsg> unsuccessList = null;

    @Override
    public String getErrMsg()
    {
        return msg;
    }

    @Override
    public Collection<CustomMsg> getSetMessagesList_Success()
    {
        return successList;
    }

    @Override
    public Collection<CustomMsg> getSetMessagesList_NotSuccess()
    {
        return unsuccessList;
    }

    @Override
    public long getNewMsgId()
    {
        long newMsgId = -1;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select nextval(?) as NewMsgId from dual");

            pstm = con.prepareStatement(sbQuery.toString());
            
            pstm.setString(1, DDM_Constants.nextval_sequence_id_msgId);

            rs = pstm.executeQuery();

            if (rs.isBeforeFirst())
            {
                rs.next();
                newMsgId = rs.getLong("NewMsgId");
            }
            else
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        catch (ClassNotFoundException e)
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

        return newMsgId;
    }

    @Override
    public CustomMsg getMessageDetails(long msgId, String msgTo)
    {
        CustomMsg customMsg = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (msgId < 0)
        {
            System.out.println("WARNING : Invalid msgId parameter.");
            return customMsg;
        }

        if (msgTo == null)
        {
            System.out.println("WARNING : Null msgTo parameter.");
            return customMsg;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select h.MsgID, h.Subject, h.MsgFrom, h.ParentId, h.GrandParentId, bkf.FullName as FromBankName, b.MsgTo, bkt.FullName as ToBankName, h.Priority, p.Description, h.RecipientCount, h.AttachmentName, h.AttachmentOriginalName, h.AttachmentPath, h.CreatedBy, h.CreatedTime, b.Body, b.IsRed, b.RedBy, b.RedTime FROM ");
            sbQuery.append(DDM_Constants.tbl_messageheader + " h, ");
            sbQuery.append(DDM_Constants.tbl_messagebody + " b, ");
            sbQuery.append(DDM_Constants.tbl_messagepriority + " p, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkf, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkt ");
            sbQuery.append("where h.MsgID = b.MsgID ");
            sbQuery.append("and h.Priority = p.Level ");
            sbQuery.append("and h.MsgFrom = bkf.BankCode ");
            sbQuery.append("and b.MsgTo = bkt.BankCode ");
            sbQuery.append("and h.MsgID = ? ");
            sbQuery.append("and b.MsgTo= ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setLong(1, msgId);
            pstm.setString(2, msgTo);

            rs = pstm.executeQuery();

            customMsg = CustomMsgUtil.makeMsgDetailsObject(rs);

            if (customMsg == null)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        catch (ClassNotFoundException e)
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

        return customMsg;
    }

    @Override
    public int getMessageCount(String msgFrom, String msgTo, String msgPriority, String isRed, String fromMsgDate, String toMsgDate)
    {
        int msgCount = -1;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (msgFrom == null)
        {
            System.out.println("WARNING : Null msgFrom parameter.");
            return msgCount;
        }

        if (msgTo == null)
        {
            System.out.println("WARNING : Null msgTo parameter.");
            return msgCount;
        }

        if (msgPriority == null)
        {
            System.out.println("WARNING : Null msgPriority parameter.");
            return msgCount;
        }

        if (isRed == null)
        {
            System.out.println("WARNING : Null isRed parameter.");
            return msgCount;
        }
        if (fromMsgDate == null)
        {
            System.out.println("WARNING : Null fromMsgDate parameter.");
            return msgCount;
        }
        if (toMsgDate == null)
        {
            System.out.println("WARNING : Null toMsgDate parameter.");
            return msgCount;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_msgFrom = 1;
            int val_msgTo = 2;
            int val_msgPriority = 3;
            int val_msgIsRed = 4;
            int val_fromMsgDate = 5;
            int val_toMsgDate = 6;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select count(*) as noOfMsg FROM ");
            sbQuery.append(DDM_Constants.tbl_messageheader + " h, ");
            sbQuery.append(DDM_Constants.tbl_messagebody + " b, ");
            sbQuery.append(DDM_Constants.tbl_messagepriority + " p ");
            sbQuery.append("where h.MsgID = b.MsgID ");
            sbQuery.append("and h.Priority = p.Level ");

            if (!msgFrom.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and h.MsgFrom = ? ");
                vt.add(val_msgFrom);
            }

            if (!msgTo.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and b.MsgTo = ? ");
                vt.add(val_msgTo);
            }

            if (!msgPriority.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and h.Priority = ? ");
                vt.add(val_msgPriority);
            }

            if (!isRed.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and b.IsRed = ? ");
                vt.add(val_msgIsRed);
            }

            if (!fromMsgDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(h.CreatedTime, '%Y%m%d') >= DATE_FORMAT(date(replace(?, '-','')),'%Y%m%d') ");
                vt.add(val_fromMsgDate);
            }

            if (!toMsgDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(h.CreatedTime, '%Y%m%d') <= DATE_FORMAT(date(replace(?, '-','')),'%Y%m%d') ");
                vt.add(val_toMsgDate);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            //System.out.println("sbQuery.toString() --> " + sbQuery.toString());
            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_msgFrom)
                {
                    pstm.setString(i, msgFrom);
                    i++;
                }

                if (val_item == val_msgTo)
                {
                    pstm.setString(i, msgTo);
                    i++;
                }

                if (val_item == val_msgPriority)
                {
                    pstm.setString(i, msgPriority);
                    i++;
                }
                if (val_item == val_msgIsRed)
                {
                    pstm.setString(i, isRed);
                    i++;
                }
                if (val_item == val_fromMsgDate)
                {
                    pstm.setString(i, fromMsgDate);
                    i++;
                }
                if (val_item == val_toMsgDate)
                {
                    pstm.setString(i, toMsgDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            if (rs.isBeforeFirst())
            {
                rs.next();
                msgCount = rs.getInt("noOfMsg");
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
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return msgCount;
    }

    public Collection<CustomMsg> getSentMassageList(String msgFrom, String msgTo, String msgPriority, String fromMsgDate, String toMsgDate)
    {
        Collection<CustomMsg> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (msgFrom == null)
        {
            System.out.println("WARNING : Null msgFrom parameter.");
            return col;
        }

        if (msgTo == null)
        {
            System.out.println("WARNING : Null msgTo parameter.");
            return col;
        }

        if (msgPriority == null)
        {
            System.out.println("WARNING : Null msgPriority parameter.");
            return col;
        }
        if (fromMsgDate == null)
        {
            System.out.println("WARNING : Null fromMsgDate parameter.");
            return col;
        }
        if (toMsgDate == null)
        {
            System.out.println("WARNING : Null toMsgDate parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_msgFrom = 1;
            int val_msgTo = 2;
            int val_msgPriority = 3;
            int val_fromMsgDate = 4;
            int val_toMsgDate = 5;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select h.MsgID, h.Subject, h.MsgFrom, bkf.FullName as FromBankName, h.Priority, p.Description, h.RecipientCount, h.AttachmentName, h.AttachmentOriginalName, h.AttachmentPath, h.CreatedBy, h.CreatedTime, b.Body FROM ");
            sbQuery.append(DDM_Constants.tbl_messageheader + " h, ");
            sbQuery.append(DDM_Constants.tbl_messagebody + " b, ");
            sbQuery.append(DDM_Constants.tbl_messagepriority + " p, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkf ");
            sbQuery.append("where h.MsgID = b.MsgID ");
            sbQuery.append("and h.Priority = p.Level ");
            sbQuery.append("and h.MsgFrom = bkf.BankCode ");

            if (!msgFrom.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and h.MsgFrom = ? ");
                vt.add(val_msgFrom);
            }

            if (!msgTo.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and b.MsgTo = ? ");
                vt.add(val_msgTo);
            }

            if (!msgPriority.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and h.Priority = ? ");
                vt.add(val_msgPriority);
            }

            if (!fromMsgDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(h.CreatedTime, '%Y%m%d') >= DATE_FORMAT(date(replace(?, '-','')),'%Y%m%d') ");
                vt.add(val_fromMsgDate);
            }

            if (!toMsgDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(h.CreatedTime, '%Y%m%d') <= DATE_FORMAT(date(replace(?, '-','')),'%Y%m%d') ");
                vt.add(val_toMsgDate);
            }

            sbQuery.append("group by MsgID, Subject, MsgFrom, Priority, RecipientCount, CreatedBy, CreatedTime, Body ");

            sbQuery.append("order by CreatedTime desc ");

            System.out.println("sbQuery.toString() --> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_msgFrom)
                {
                    pstm.setString(i, msgFrom);
                    i++;
                }

                if (val_item == val_msgTo)
                {
                    pstm.setString(i, msgTo);
                    i++;
                }

                if (val_item == val_msgPriority)
                {
                    pstm.setString(i, msgPriority);
                    i++;
                }
                if (val_item == val_fromMsgDate)
                {
                    pstm.setString(i, fromMsgDate);
                    i++;
                }
                if (val_item == val_toMsgDate)
                {
                    pstm.setString(i, toMsgDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = CustomMsgUtil.makeSentMsgObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
            else
            {

                System.out.println("getSentMassageList result size =====> " + col.size());
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

    public Collection<CustomMsg> getToListAndReadDetails(long msgId)
    {
        Collection<CustomMsg> colCustomMsg = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (msgId < 0)
        {
            System.out.println("WARNING : Invalid msgId parameter.");
            return colCustomMsg;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select b.MsgID, b.MsgTo, bkt.FullName as ToBankName, b.IsRed, b.RedBy, b.RedTime FROM ");
            sbQuery.append(DDM_Constants.tbl_messagebody + " b, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkt ");
            sbQuery.append("where b.MsgTo = bkt.BankCode ");
            sbQuery.append("and b.MsgID = ? ");

            sbQuery.append("order by MsgTo");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setLong(1, msgId);

            rs = pstm.executeQuery();

            colCustomMsg = CustomMsgUtil.makeMsgToListAndReadDetailsObject(rs);

            if (colCustomMsg.isEmpty())
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

        return colCustomMsg;

    }

    public CustomMsg getSentMassageDetails(long MsgID)
    {
        CustomMsg cusMsg = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (MsgID <= 0)
        {
            System.out.println("WARNING : Invalid MsgID parameter.");
            return cusMsg;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select h.MsgID, h.Subject, h.MsgFrom, bkf.FullName as FromBankName, h.Priority, p.Description, h.RecipientCount, h.AttachmentName, h.AttachmentOriginalName, h.AttachmentPath, h.CreatedBy, h.CreatedTime, b.Body FROM ");
            sbQuery.append(DDM_Constants.tbl_messageheader + " h, ");
            sbQuery.append(DDM_Constants.tbl_messagebody + " b, ");
            sbQuery.append(DDM_Constants.tbl_messagepriority + " p, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkf ");
            sbQuery.append("where h.MsgID = b.MsgID ");
            sbQuery.append("and h.Priority = p.Level ");
            sbQuery.append("and h.MsgFrom = bkf.BankCode ");
            sbQuery.append("and h.MsgID = ? ");

            sbQuery.append("group by MsgID, Subject, MsgFrom, Priority, RecipientCount, CreatedBy, CreatedTime, Body ");
            sbQuery.append("order by CreatedTime desc ");

            System.out.println("sbQuery.toString() --> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setLong(1, MsgID);

            rs = pstm.executeQuery();

            cusMsg = CustomMsgUtil.makeSentMsgObjects(rs);

            if (cusMsg == null)
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

        return cusMsg;
    }

    public Collection<CustomMsg> getMessageList(String msgFrom, String msgTo, String msgPriority, String isRed, String fromMsgDate, String toMsgDate)
    {
        Collection<CustomMsg> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (msgFrom == null)
        {
            System.out.println("WARNING : Null msgFrom parameter.");
            return col;
        }

        if (msgTo == null)
        {
            System.out.println("WARNING : Null msgTo parameter.");
            return col;
        }

        if (msgPriority == null)
        {
            System.out.println("WARNING : Null msgPriority parameter.");
            return col;
        }
        if (isRed == null)
        {
            System.out.println("WARNING : Null isRed parameter.");
            return col;
        }
        if (fromMsgDate == null)
        {
            System.out.println("WARNING : Null fromMsgDate parameter.");
            return col;
        }
        if (toMsgDate == null)
        {
            System.out.println("WARNING : Null toMsgDate parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_msgFrom = 1;
            int val_msgTo = 2;
            int val_msgPriority = 3;
            int val_msgIsRed = 4;
            int val_fromMsgDate = 5;
            int val_toMsgDate = 6;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select h.MsgID, h.ParentId, h.GrandParentId, h.Subject, h.MsgFrom, bkf.FullName as FromBankName, b.MsgTo, bkt.FullName as ToBankName, h.Priority, p.Description, h.RecipientCount, h.AttachmentName, h.AttachmentOriginalName, h.AttachmentPath, h.CreatedBy, h.CreatedTime, b.Body, b.IsRed, b.RedBy, b.RedTime FROM ");
            sbQuery.append(DDM_Constants.tbl_messageheader + " h, ");
            sbQuery.append(DDM_Constants.tbl_messagebody + " b, ");
            sbQuery.append(DDM_Constants.tbl_messagepriority + " p, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkf, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkt ");
            sbQuery.append("where h.MsgID = b.MsgID ");
            sbQuery.append("and h.Priority = p.Level ");
            sbQuery.append("and h.MsgFrom = bkf.BankCode ");
            sbQuery.append("and b.MsgTo = bkt.BankCode ");

            if (!msgFrom.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and h.MsgFrom = ? ");
                vt.add(val_msgFrom);
            }

            if (!msgTo.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and b.MsgTo = ? ");
                vt.add(val_msgTo);
            }

            if (!msgPriority.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and h.Priority = ? ");
                vt.add(val_msgPriority);
            }

            if (!isRed.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and b.IsRed = ? ");
                vt.add(val_msgIsRed);
            }

            if (!fromMsgDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(h.CreatedTime, '%Y%m%d') >= DATE_FORMAT(date(replace(?, '-','')),'%Y%m%d') ");
                vt.add(val_fromMsgDate);
            }

            if (!toMsgDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(h.CreatedTime, '%Y%m%d') <= DATE_FORMAT(date(replace(?, '-','')),'%Y%m%d') ");
                vt.add(val_toMsgDate);
            }

            sbQuery.append("order by CreatedTime desc");

            pstm = con.prepareStatement(sbQuery.toString());

            //System.out.println("sbQuery.toString() --> " + sbQuery.toString());
            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_msgFrom)
                {
                    pstm.setString(i, msgFrom);
                    i++;
                }

                if (val_item == val_msgTo)
                {
                    pstm.setString(i, msgTo);
                    i++;
                }

                if (val_item == val_msgPriority)
                {
                    pstm.setString(i, msgPriority);
                    i++;
                }
                if (val_item == val_msgIsRed)
                {
                    pstm.setString(i, isRed);
                    i++;
                }
                if (val_item == val_fromMsgDate)
                {
                    pstm.setString(i, fromMsgDate);
                    i++;
                }
                if (val_item == val_toMsgDate)
                {
                    pstm.setString(i, toMsgDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = CustomMsgUtil.makeMsgDetailsObjectsCollection(rs);

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

    public boolean setMessageDetails(long newMsgId, String msgFrom, Collection<CustomMsgTo> colMsgTo, String subject, String body, String msgPriority, String attachmentName, String attachmentOriginalName, String attachmentPath, String createdBy)
    {
        boolean status = true;
        //long newMsgId = -1;
        MsgHeader msgHeader = null;
        MsgBody msgBody = null;

        if (msgFrom == null)
        {
            System.out.println("WARNING : Null msgFrom parameter.");
            status = false;
            return status;
        }

        if (colMsgTo == null || colMsgTo.isEmpty())
        {
            System.out.println("WARNING : Null or empty colMsgTo parameter.");
            status = false;
            return status;
        }
        if (subject == null)
        {
            System.out.println("WARNING : Null subject parameter.");
            status = false;
            return status;
        }
        if (body == null)
        {
            System.out.println("WARNING : Null body parameter.");
            status = false;
            return status;
        }
        if (msgPriority == null)
        {
            System.out.println("WARNING : Null msgPriority parameter.");
            status = false;
            return status;
        }
        if (createdBy == null)
        {
            System.out.println("WARNING : Null createdBy parameter.");
            status = false;
            return status;
        }

        if (newMsgId < 0)
        {
            System.out.println("WARNING : Invalid newMsgId return from the DAOFactory.getCustomMsgDAO().getNewMsgId() method.");
            status = false;
            return status;
        }

        msgHeader = new MsgHeader();

        msgHeader.setMsgId(newMsgId);
        msgHeader.setMsgFromBank(msgFrom);
        msgHeader.setSubject(subject);
        msgHeader.setPriorityLevel(msgPriority);
        msgHeader.setAttachmentName(attachmentName);
        msgHeader.setAttachmentOriginalName(attachmentOriginalName);
        msgHeader.setAttachmentPath(attachmentPath);
        msgHeader.setCreatedBy(createdBy);
        msgHeader.setMsgParentId(newMsgId);//add root id as a perent id when composing new msg
        msgHeader.setMsgGrandParentId(newMsgId);//add seq

        //addRecord method called priviosly
        if (DAOFactory.getMsgHeaderDAO().addRecordWithParentId(msgHeader))
        {
            successList = new java.util.ArrayList();
            unsuccessList = new java.util.ArrayList();

            for (CustomMsgTo msgTo : colMsgTo)
            {
                msgBody = new MsgBody();

                msgBody.setMsgId(newMsgId);
                msgBody.setMsgToBank(msgTo.getMsgTo());
                msgBody.setMsgToBankName(DAOFactory.getBankDAO().getBankDetails(msgTo.getMsgTo()).getBankFullName());
                msgBody.setBody(body);
                msgBody.setIsRed(DDM_Constants.msg_isred_no);

                if (DAOFactory.getMsgBodyDAO().addRecord(msgBody))
                {
                    CustomMsg customMsg = new CustomMsg();
                    customMsg.setMsgHeader(msgHeader);
                    customMsg.setMsgBody(msgBody);
                    successList.add(customMsg);
                }
                else
                {
                    CustomMsg customMsg = new CustomMsg();
                    customMsg.setMsgHeader(msgHeader);
                    customMsg.setMsgBody(msgBody);
                    unsuccessList.add(customMsg);
                    status = false;
                    msg = "Add records to message body failed!";
                }
            }

            DAOFactory.getMsgHeaderDAO().updateRecipientCount(newMsgId, successList.size());
        }
        else
        {
            status = false;
            msg = "Add records to message header failed!";
        }

        return status;
    }

    public boolean setIsRedStatus(long msgId, String msgTo, boolean isRed, String redBy)
    {
        boolean status = false;
        MsgBody msgBody = null;

        if (msgId < 0)
        {
            System.out.println("WARNING : Invalid msgId parameter.");
            return status;
        }

        if (msgTo == null)
        {
            System.out.println("WARNING : Null msgTo parameter.");
            return status;
        }

        if (isRed)
        {
            if (redBy == null)
            {
                System.out.println("WARNING : Null redBy parameter.");
                return status;
            }
        }

        msgBody = new MsgBody();

        msgBody.setMsgId(msgId);
        msgBody.setMsgToBank(msgTo);

        if (isRed)
        {
            msgBody.setIsRed(DDM_Constants.msg_isred_yes);
            msgBody.setRedBy(redBy);
        }
        else
        {
            msgBody.setIsRed(DDM_Constants.msg_isred_no);
        }

        if (DAOFactory.getMsgBodyDAO().updateRecord(msgBody))
        {
            status = true;
        }

        return status;
    }

    public Collection<Recipient> getAvailableFullRecipientList(String userType, String bank)
    {
        Collection<Recipient> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (userType == null)
        {
            System.out.println("WARNING : Null userType parameter.");
            return col;
        }
        if (bank == null)
        {
            System.out.println("WARNING : Null bank parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            if (bank.equals(DDM_Constants.default_bank_code))
            {
                sbQuery.append("select BankCode as bankCode, BankCode as RecipientCode, FullName as RecipientName, '" + DDM_Constants.msg_recipient_lcpl + "' as RecipientType FROM ");
                sbQuery.append(DDM_Constants.tbl_bank + " ");
                sbQuery.append("where BankCode != ? ");
                sbQuery.append("and BankStatus = ? ");
            }
            else
            {
                sbQuery.append("select BankCode as bankCode, BankCode as RecipientCode, FullName as RecipientName, '" + DDM_Constants.msg_recipient_bank + "' as RecipientType FROM ");
                sbQuery.append(DDM_Constants.tbl_bank + " ");
                sbQuery.append("where BankCode != ? ");
                sbQuery.append("and BankStatus = ? ");
            }

            sbQuery.append("order by RecipientCode");

            System.out.println("sbQuery.toString() --> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            if (bank.equals(DDM_Constants.default_bank_code))
            {
                pstm.setString(1, bank);
                pstm.setString(2, DDM_Constants.status_active);
            }
            else
            {
                pstm.setString(1, bank);
                pstm.setString(2, DDM_Constants.status_active);
            }

            rs = pstm.executeQuery();

            col = CustomMsgUtil.makeRecipientObjectsCollection(rs);

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

    public Collection<CustomMsg> getMessageHistoryDetails(long msgGrandParentId, String msgTo)
    {
        Collection<CustomMsg> colCustomMsg = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (msgGrandParentId < 0)
        {
            System.out.println("WARNING : Invalid msgGrandParentId parameter.");
            return colCustomMsg;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select h.MsgID, h.Subject, h.MsgFrom, h.ParentId, h.GrandParentId, bkf.FullName as FromBankName, b.MsgTo, bkt.FullName as ToBankName, h.Priority, p.Description, h.RecipientCount, h.AttachmentName, h.AttachmentOriginalName, h.AttachmentPath, h.CreatedBy, h.CreatedTime, b.Body, b.IsRed, b.RedBy, b.RedTime FROM ");
            sbQuery.append(DDM_Constants.tbl_messageheader + " h, ");
            sbQuery.append(DDM_Constants.tbl_messagebody + " b, ");
            sbQuery.append(DDM_Constants.tbl_messagepriority + " p, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkf, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkt ");
            sbQuery.append("where h.MsgID = b.MsgID ");
            sbQuery.append("and h.Priority = p.Level ");
            sbQuery.append("and h.MsgFrom = bkf.BankCode ");
            sbQuery.append("and b.MsgTo = bkt.BankCode ");
            sbQuery.append("and h.GrandParentId = ? ");
            sbQuery.append("and (b.MsgTo = ? or h.MsgFrom = ?) ");
            sbQuery.append("order by MsgID desc");

            System.out.println("sbQuery.toString() ---> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setLong(1, msgGrandParentId);
            pstm.setString(2, msgTo);
            pstm.setString(3, msgTo);

            rs = pstm.executeQuery();

            colCustomMsg = CustomMsgUtil.makeMsgDetailsObjectsCollection(rs);

            if (colCustomMsg.isEmpty())
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

        return colCustomMsg;

    }
    
    
    public boolean setMessagePerentDetails(long newMsgId, long parentId, long grandParentId, String msgFrom, Collection<CustomMsgTo> colMsgTo, String subject, String body, String msgPriority, String attachmentName, String attachmentOriginalName, String attachmentPath, String createdBy)
    {
        boolean status = true;
        //long newMsgId = -1;
        MsgHeader msgHeader = null;
        MsgBody msgBody = null;

        System.out.println("parentId  is  " + parentId);
        System.out.println("grandParentId  is  " + grandParentId);

        if (msgFrom == null)
        {
            System.out.println("WARNING : Null msgFrom parameter.");
            status = false;
            return status;
        }

        if (colMsgTo == null || colMsgTo.isEmpty())
        {
            System.out.println("WARNING : Null or empty colMsgTo parameter.");
            status = false;
            return status;
        }
        if (subject == null)
        {
            System.out.println("WARNING : Null subject parameter.");
            status = false;
            return status;
        }
        if (body == null)
        {
            System.out.println("WARNING : Null body parameter.");
            status = false;
            return status;
        }
        if (msgPriority == null)
        {
            System.out.println("WARNING : Null msgPriority parameter.");
            status = false;
            return status;
        }
        if (createdBy == null)
        {
            System.out.println("WARNING : Null createdBy parameter.");
            status = false;
            return status;
        }

        if (newMsgId < 0)
        {
            System.out.println("WARNING : Invalid newMsgId return from the DAOFactory.getCustomMsgDAO().getNewMsgId() method.");
            status = false;
            return status;
        }

        if (parentId < 0)
        {
            System.out.println("WARNING : Invalid parentId return .");
            status = false;
            return status;
        }

        if (grandParentId < 0)
        {
            System.out.println("WARNING : Invalid grandParentId return .");
            status = false;
            return status;
        }

        msgHeader = new MsgHeader();

        msgHeader.setMsgId(newMsgId);
        msgHeader.setMsgFromBank(msgFrom);
        msgHeader.setSubject(subject);
        msgHeader.setPriorityLevel(msgPriority);
        msgHeader.setAttachmentName(attachmentName);
        msgHeader.setAttachmentOriginalName(attachmentOriginalName);
        msgHeader.setAttachmentPath(attachmentPath);
        msgHeader.setCreatedBy(createdBy);
        msgHeader.setMsgParentId(parentId);
        msgHeader.setMsgGrandParentId(grandParentId);

        if (DAOFactory.getMsgHeaderDAO().addRecordWithParentId(msgHeader))
        {
            successList = new java.util.ArrayList();
            unsuccessList = new java.util.ArrayList();

            for (CustomMsgTo msgTo : colMsgTo)
            {
                msgBody = new MsgBody();

                msgBody.setMsgId(newMsgId);
                msgBody.setMsgToBank(msgTo.getMsgTo());
                msgBody.setMsgToBankName(DAOFactory.getBankDAO().getBankDetails(msgTo.getMsgTo()).getBankFullName());
                msgBody.setBody(body);
                msgBody.setIsRed(DDM_Constants.msg_isred_no);

                if (DAOFactory.getMsgBodyDAO().addRecord(msgBody))
                {
                    CustomMsg customMsg = new CustomMsg();
                    customMsg.setMsgHeader(msgHeader);
                    customMsg.setMsgBody(msgBody);
                    successList.add(customMsg);
                }
                else
                {
                    CustomMsg customMsg = new CustomMsg();
                    customMsg.setMsgHeader(msgHeader);
                    customMsg.setMsgBody(msgBody);
                    unsuccessList.add(customMsg);
                    status = false;
                    msg = "Add records to message body failed!";
                }
            }

            DAOFactory.getMsgHeaderDAO().updateRecipientCount(newMsgId, successList.size());
        }
        else
        {
            status = false;
            msg = "Add records to message header failed!";
        }

        return status;
    }
    
        public boolean isOkToReply(long msgId)
    {
        boolean isOkToReply = false;

        try
        {
            int msgAge = DAOFactory.getMsgHeaderDAO().msgAge_InNoOfDays(msgId);
            int msgReplyBefore = Integer.parseInt(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_msg_reply_before));

            if (msgAge < msgReplyBefore)
            {
                isOkToReply = true;
            }
        }
        catch (Exception e)
        {
            isOkToReply = false;
            System.out.println(e.getMessage());
        }

        return isOkToReply;
    }
}
