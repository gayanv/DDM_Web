/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.message.priority;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface MsgPriorityDAO
{    
        public String getMsg();
    
    public MsgPriority getPriority(String id);
    
    public Collection<MsgPriority> getPriorityDetails();
    
}
