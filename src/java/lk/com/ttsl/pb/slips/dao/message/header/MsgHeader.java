/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.message.header;

/**
 *
 * @author Dinesh
 */
public class MsgHeader
{


    public long getMsgId()
    {
        return msgId;
    }

    public void setMsgId(long msgId)
    {
        this.msgId = msgId;
    }

    public int getRecipientCount()
    {
        return recipientCount;
    }

    public void setRecipientCount(int recipientCount)
    {
        this.recipientCount = recipientCount;
    }

    public String getSubject()
    {
        return subject;
    }

    public void setSubject(String subject)
    {
        this.subject = subject;
    }

    public String getMsgFromBank()
    {
        return msgFromBank;
    }

    public void setMsgFromBank(String msgFromBank)
    {
        this.msgFromBank = msgFromBank;
    }

    public String getMsgFromBankName()
    {
        return msgFromBankName;
    }

    public void setMsgFromBankName(String msgFromBankName)
    {
        this.msgFromBankName = msgFromBankName;
    }

    public String getPriorityLevel()
    {
        return priorityLevel;
    }

    public void setPriorityLevel(String priorityLevel)
    {
        this.priorityLevel = priorityLevel;
    }

    public String getPriorityLevelDesc()
    {
        return priorityLevelDesc;
    }

    public void setPriorityLevelDesc(String priorityLevelDesc)
    {
        this.priorityLevelDesc = priorityLevelDesc;
    }

    public String getAttachmentName()
    {
        return attachmentName;
    }

    public void setAttachmentName(String attachmentName)
    {
        this.attachmentName = attachmentName;
    }

    public String getAttachmentOriginalName()
    {
        return attachmentOriginalName;
    }

    public void setAttachmentOriginalName(String attachmentOriginalName)
    {
        this.attachmentOriginalName = attachmentOriginalName;
    }

    public String getAttachmentPath()
    {
        return attachmentPath;
    }

    public void setAttachmentPath(String attachmentPath)
    {
        this.attachmentPath = attachmentPath;
    }

    public String getCreatedBy()
    {
        return createdBy;
    }

    public void setCreatedBy(String createdBy)
    {
        this.createdBy = createdBy;
    }

    public String getCreatedTime()
    {
        return createdTime;
    }

    public void setCreatedTime(String createdTime)
    {
        this.createdTime = createdTime;
    }
    
        public long getMsgParentId() {
        return msgParentId;
    }

    public void setMsgParentId(long msgParentId) {
        this.msgParentId = msgParentId;
    }

    public long getMsgGrandParentId()
    {
        return msgGrandParentId;
    }

    public void setMsgGrandParentId(long msgGrandParentId)
    {
        this.msgGrandParentId = msgGrandParentId;
    }
    

    private long msgId;
    private int recipientCount;
    private String subject;
    private String msgFromBank;
    private String msgFromBankName;
    private String priorityLevel;
    private String priorityLevelDesc;
    private String attachmentName;
    private String attachmentOriginalName;
    private String attachmentPath;
    private String createdBy;
    private String createdTime;
    private long msgParentId;
    private long msgGrandParentId;   
}
