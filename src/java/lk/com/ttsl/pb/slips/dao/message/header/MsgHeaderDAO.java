/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.message.header;

/**
 *
 * @author Dinesh
 */
public interface MsgHeaderDAO
{

    public boolean addRecord(MsgHeader msgHeader);

    public boolean addRecordWithParentId(MsgHeader msgHeader);

    public boolean updateRecipientCount(long msgId, int count);
    
    public int msgAge_InNoOfDays(long msgId);
}
