/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.custom.message;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface CustomMsgDAO
{

    public String getErrMsg();

    public long getNewMsgId();

    public int getMessageCount(String msgFrom, String msgTo, String msgPriority, String isRed, String fromMsgDate, String toMsgDate);

    public CustomMsg getMessageDetails(long msgId, String msgTo);

    public CustomMsg getSentMassageDetails(long MsgID);

    public Collection<CustomMsg> getSentMassageList(String msgFrom, String msgTo, String msgPriority, String fromMsgDate, String toMsgDate);

    public Collection<CustomMsg> getToListAndReadDetails(long msgId);

    public Collection<CustomMsg> getMessageList(String msgFrom, String msgTo, String msgPriority, String isRed, String fromMsgDate, String toMsgDate);

    public Collection<CustomMsg> getMessageHistoryDetails(long msgGrandParentId, String msgTo);

    public boolean setMessageDetails(long newMsgId, String msgFrom, Collection<CustomMsgTo> colMsgTo, String subject, String body, String msgPriority, String attachmentName, String attachmentOriginalName, String attachmentPath, String createdBy);

    public Collection<CustomMsg> getSetMessagesList_Success();

    public Collection<CustomMsg> getSetMessagesList_NotSuccess();

    public boolean setIsRedStatus(long msgId, String msgTo, boolean isRed, String redBy);
    
    public boolean isOkToReply(long msgId);

    public Collection<Recipient> getAvailableFullRecipientList(String userType, String bank);

    public boolean setMessagePerentDetails(long newMsgId, long parentId, long grandParentId, String msgFrom, Collection<CustomMsgTo> colMsgTo, String subject, String body, String msgPriority, String attachmentName, String attachmentOriginalName, String attachmentPath, String createdBy);
}
