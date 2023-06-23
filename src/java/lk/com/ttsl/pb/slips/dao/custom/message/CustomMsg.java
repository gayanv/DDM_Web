/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.custom.message;

import lk.com.ttsl.pb.slips.dao.message.body.MsgBody;
import lk.com.ttsl.pb.slips.dao.message.header.MsgHeader;
import lk.com.ttsl.pb.slips.dao.message.priority.MsgPriority;



/**
 *
 * @author Dinesh
 */
public class CustomMsg
{

    public MsgBody getMsgBody()
    {
        return msgBody;
    }

    public void setMsgBody(MsgBody msgBody)
    {
        this.msgBody = msgBody;
    }

    public MsgHeader getMsgHeader()
    {
        return msgHeader;
    }

    public void setMsgHeader(MsgHeader msgHeader)
    {
        this.msgHeader = msgHeader;
    }

    public MsgPriority getMsgPriority()
    {
        return msgPriority;
    }

    public void setMsgPriority(MsgPriority msgPriority)
    {
        this.msgPriority = msgPriority;
    }    

    private MsgBody msgBody;
    private MsgHeader msgHeader;
    private MsgPriority msgPriority;
}
