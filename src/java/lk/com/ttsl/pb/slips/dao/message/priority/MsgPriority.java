/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.message.priority;

/**
 *
 * @author Dinesh
 */
public class MsgPriority
{

    public String getPriorityDesc()
    {
        return priorityDesc;
    }

    public void setPriorityDesc(String priorityDesc)
    {
        this.priorityDesc = priorityDesc;
    }

    public String getPriorityLevel()
    {
        return priorityLevel;
    }

    public void setPriorityLevel(String priorityLevel)
    {
        this.priorityLevel = priorityLevel;
    }
    
    private String priorityLevel;
    private String priorityDesc;
}
