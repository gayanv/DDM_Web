/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.message.body;

/**
 *
 * @author Dinesh
 */
public class MsgBody
{

    public long getMsgId()
    {
        return msgId;
    }

    public void setMsgId(long msgId)
    {
        this.msgId = msgId;
    }

    public String getMsgToBank()
    {
        return msgToBank;
    }

    public void setMsgToBank(String msgToBank)
    {
        this.msgToBank = msgToBank;
    }

    public String getMsgToBankName()
    {
        return msgToBankName;
    }

    public void setMsgToBankName(String msgToBankName)
    {
        this.msgToBankName = msgToBankName;
    }

    public String getBody()
    {
        return body;
    }

    public void setBody(String body)
    {
        this.body = body;
    }

    public String getIsRed()
    {
        return isRed;
    }

    public void setIsRed(String isRed)
    {
        this.isRed = isRed;
    }

    public String getRedBy()
    {
        return redBy;
    }

    public void setRedBy(String redBy)
    {
        this.redBy = redBy;
    }

    public String getRedTime()
    {
        return redTime;
    }

    public void setRedTime(String redTime)
    {
        this.redTime = redTime;
    }

    private long msgId;
    private String msgToBank;
    private String msgToBankName;
    private String body;
    private String isRed;
    private String redBy;
    private String redTime;
}
