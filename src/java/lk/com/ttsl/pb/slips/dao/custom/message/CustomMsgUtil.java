/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.custom.message;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.dao.message.body.MsgBody;
import lk.com.ttsl.pb.slips.dao.message.header.MsgHeader;
import lk.com.ttsl.pb.slips.dao.message.priority.MsgPriority;



/**
 *
 * @author Dinesh
 */
public class CustomMsgUtil
{

    private CustomMsgUtil()
    {
    }

    static Collection<CustomMsg> makeMsgDetailsObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<CustomMsg> result = new java.util.ArrayList();

        while (rs.next())
        {
            CustomMsg customMsg = new CustomMsg();
            MsgHeader msgHeader = new MsgHeader();
            MsgBody msgBody = new MsgBody();
            MsgPriority msgPriority = new MsgPriority();

            msgHeader.setMsgId(rs.getLong("MsgID"));
            msgHeader.setMsgFromBank(rs.getString("MsgFrom"));
            msgHeader.setMsgFromBankName(rs.getString("FromBankName"));
            msgHeader.setSubject(rs.getString("Subject"));
            msgHeader.setPriorityLevel(rs.getString("Priority"));
            msgHeader.setRecipientCount(rs.getInt("RecipientCount"));
            msgHeader.setAttachmentName(rs.getString("AttachmentName"));
            msgHeader.setAttachmentOriginalName(rs.getString("AttachmentOriginalName"));
            msgHeader.setAttachmentPath(rs.getString("AttachmentPath"));
            msgHeader.setCreatedBy(rs.getString("CreatedBy"));
            msgHeader.setMsgParentId(rs.getLong("ParentId"));
            msgHeader.setMsgGrandParentId(rs.getLong("GrandParentId"));

            if (rs.getTimestamp("CreatedTime") != null)
            {
                msgHeader.setCreatedTime(DateFormatter.doFormat(rs.getTimestamp("CreatedTime").getTime(), "yyyy-MM-dd HH:mm:ss"));
            }

            msgBody.setMsgId(rs.getLong("MsgID"));
            msgBody.setMsgToBank(rs.getString("MsgTo"));
            msgBody.setMsgToBankName(rs.getString("ToBankName"));
            msgBody.setBody(rs.getString("Body"));
            msgBody.setIsRed(rs.getString("IsRed"));
            msgBody.setRedBy(rs.getString("RedBy"));

            if (rs.getTimestamp("RedTime") != null)
            {
                msgBody.setRedTime(DateFormatter.doFormat(rs.getTimestamp("RedTime").getTime(), "yyyy-MM-dd HH:mm:ss"));
            }

            msgPriority.setPriorityLevel(rs.getString("Priority"));
            msgPriority.setPriorityDesc(rs.getString("Description"));

            customMsg.setMsgHeader(msgHeader);
            customMsg.setMsgBody(msgBody);
            customMsg.setMsgPriority(msgPriority);

            result.add(customMsg);
        }

        return result;
    }

    static CustomMsg makeMsgDetailsObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        CustomMsg customMsg = null;

        if (rs.next())
        {
            customMsg = new CustomMsg();
            MsgHeader msgHeader = new MsgHeader();
            MsgBody msgBody = new MsgBody();
            MsgPriority msgPriority = new MsgPriority();

            msgHeader.setMsgId(rs.getLong("MsgID"));
            msgHeader.setMsgFromBank(rs.getString("MsgFrom"));
            msgHeader.setMsgFromBankName(rs.getString("FromBankName"));
            msgHeader.setSubject(rs.getString("Subject"));
            msgHeader.setPriorityLevel(rs.getString("Priority"));
            msgHeader.setAttachmentName(rs.getString("AttachmentName"));
            msgHeader.setAttachmentOriginalName(rs.getString("AttachmentOriginalName"));
            msgHeader.setAttachmentPath(rs.getString("AttachmentPath"));
            msgHeader.setRecipientCount(rs.getInt("RecipientCount"));
            msgHeader.setCreatedBy(rs.getString("CreatedBy"));

            msgHeader.setMsgParentId(rs.getLong("ParentId"));
            msgHeader.setMsgGrandParentId(rs.getLong("GrandParentId"));

            if (rs.getTimestamp("CreatedTime") != null)
            {
                msgHeader.setCreatedTime(DateFormatter.doFormat(rs.getTimestamp("CreatedTime").getTime(), "yyyy-MM-dd HH:mm:ss"));
            }

            msgBody.setMsgId(rs.getLong("MsgID"));
            msgBody.setMsgToBank(rs.getString("MsgTo"));
            msgBody.setMsgToBankName(rs.getString("ToBankName"));
            msgBody.setBody(rs.getString("Body"));
            msgBody.setIsRed(rs.getString("IsRed"));
            msgBody.setRedBy(rs.getString("RedBy"));

            if (rs.getTimestamp("RedTime") != null)
            {
                msgBody.setRedTime(DateFormatter.doFormat(rs.getTimestamp("RedTime").getTime(), "yyyy-MM-dd HH:mm:ss"));
            }

            msgPriority.setPriorityLevel(rs.getString("Priority"));
            msgPriority.setPriorityDesc(rs.getString("Description"));

            customMsg.setMsgHeader(msgHeader);
            customMsg.setMsgBody(msgBody);
            customMsg.setMsgPriority(msgPriority);
        }

        return customMsg;
    }

    static Collection<CustomMsg> makeSentMsgObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<CustomMsg> result = new java.util.ArrayList();

        while (rs.next())
        {
            CustomMsg customMsg = new CustomMsg();
            MsgHeader msgHeader = new MsgHeader();
            MsgBody msgBody = new MsgBody();
            MsgPriority msgPriority = new MsgPriority();

            msgHeader.setMsgId(rs.getLong("MsgID"));
            msgHeader.setMsgFromBank(rs.getString("MsgFrom"));
            msgHeader.setMsgFromBankName(rs.getString("FromBankName"));
            msgHeader.setSubject(rs.getString("Subject"));
            msgHeader.setPriorityLevel(rs.getString("Priority"));
            msgHeader.setAttachmentName(rs.getString("AttachmentName"));
            msgHeader.setAttachmentOriginalName(rs.getString("AttachmentOriginalName"));
            msgHeader.setAttachmentPath(rs.getString("AttachmentPath"));
            msgHeader.setRecipientCount(rs.getInt("RecipientCount"));
            
            msgHeader.setCreatedBy(rs.getString("CreatedBy"));
            msgHeader.setCreatedTime(DateFormatter.doFormat(rs.getTimestamp("CreatedTime").getTime(), "yyyy-MM-dd HH:mm:ss"));

            msgBody.setMsgId(rs.getLong("MsgID"));
            msgBody.setBody(rs.getString("Body"));

            msgPriority.setPriorityLevel(rs.getString("Priority"));
            msgPriority.setPriorityDesc(rs.getString("Description"));

            customMsg.setMsgHeader(msgHeader);
            customMsg.setMsgBody(msgBody);
            customMsg.setMsgPriority(msgPriority);

            result.add(customMsg);
        }

        return result;
    }

    static Collection<CustomMsg> makeMsgToListAndReadDetailsObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<CustomMsg> result = new java.util.ArrayList();

        while (rs.next())
        {
            CustomMsg customMsg = new CustomMsg();
            //MsgHeader msgHeader = new MsgHeader();
            MsgBody msgBody = new MsgBody();
            //MsgPriority msgPriority = new MsgPriority();

//            msgHeader.setMsgId(rs.getLong("MsgID"));
//            msgHeader.setMsgFrom(rs.getString("MsgFrom"));
//            msgHeader.setMsgFromBankName(rs.getString("fromBranch"));
//            msgHeader.setSubject(rs.getString("Subject"));
//            msgHeader.setPriorityLevel(rs.getString("Priority"));
//            msgHeader.setRecipientCount(rs.getInt("RecipientCount"));
//            msgHeader.setCreatedBy(rs.getString("CreatedBy"));
//            msgHeader.setCreatedTime(DateFormatter.doFormat(rs.getTimestamp("CreatedTime").getTime(), "yyyy-MM-dd HH:mm:ss"));
            msgBody.setMsgId(rs.getLong("MsgID"));
            msgBody.setMsgToBank(rs.getString("MsgTo"));
            msgBody.setMsgToBankName(rs.getString("ToBankName"));
            msgBody.setIsRed(rs.getString("IsRed"));
            msgBody.setRedBy(rs.getString("RedBy"));

            if (rs.getTimestamp("RedTime") != null)
            {
                msgBody.setRedTime(DateFormatter.doFormat(rs.getTimestamp("RedTime").getTime(), "yyyy-MM-dd HH:mm:ss"));
            }

//            msgPriority.setPriorityLevel(rs.getString("Priority"));
//            msgPriority.setPriorityDesc(rs.getString("Description"));
            //customMsg.setMsgHeader(msgHeader);
            customMsg.setMsgBody(msgBody);
            //customMsg.setMsgPriority(msgPriority);

            result.add(customMsg);
        }

        return result;
    }

    static Collection<Recipient> makeRecipientObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Recipient> result = new java.util.ArrayList();

        while (rs.next())
        {
            Recipient recipient = new Recipient();

            recipient.setRecipientBankCode(rs.getString("bankCode"));
            recipient.setRecipientCode(rs.getString("RecipientCode"));
            recipient.setRecipientName(rs.getString("RecipientName"));
            recipient.setRecipientType(rs.getString("RecipientType"));

            result.add(recipient);
        }

        return result;
    }

    static CustomMsg makeSentMsgObjects(ResultSet rs) throws SQLException
    {

        CustomMsg customMsg = null;

        if (rs != null && rs.isBeforeFirst())
        {
            rs.next();

            customMsg = new CustomMsg();
            MsgHeader msgHeader = new MsgHeader();
            MsgBody msgBody = new MsgBody();
            MsgPriority msgPriority = new MsgPriority();

            msgHeader.setMsgId(rs.getLong("MsgID"));
            msgHeader.setMsgFromBank(rs.getString("MsgFrom"));
            msgHeader.setMsgFromBankName(rs.getString("FromBankName"));
            msgHeader.setSubject(rs.getString("Subject"));
            msgHeader.setPriorityLevel(rs.getString("Priority"));
            msgHeader.setRecipientCount(rs.getInt("RecipientCount"));

            msgHeader.setAttachmentName(rs.getString("AttachmentName"));
            msgHeader.setAttachmentOriginalName(rs.getString("AttachmentOriginalName"));
            msgHeader.setAttachmentPath(rs.getString("AttachmentPath"));

            msgHeader.setCreatedBy(rs.getString("CreatedBy"));
            msgHeader.setCreatedTime(DateFormatter.doFormat(rs.getTimestamp("CreatedTime").getTime(), "yyyy-MM-dd HH:mm:ss"));

            msgBody.setMsgId(rs.getLong("MsgID"));
            msgBody.setBody(rs.getString("Body"));

            msgPriority.setPriorityLevel(rs.getString("Priority"));
            msgPriority.setPriorityDesc(rs.getString("Description"));

            customMsg.setMsgHeader(msgHeader);
            customMsg.setMsgBody(msgBody);
            customMsg.setMsgPriority(msgPriority);
        }

        return customMsg;
    }

}
