/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.message.priority;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class MsgPriorityUtil
{

    private MsgPriorityUtil()
    {
    }
    
        static MsgPriority makeMsgPriorityObject(ResultSet rs) throws SQLException
    {

        MsgPriority msgPriority = null;

        if(rs!=null && rs.isBeforeFirst())
        {
            rs.next();
            
            msgPriority = new MsgPriority();

            msgPriority.setPriorityLevel(rs.getString("Level"));
            msgPriority.setPriorityDesc(rs.getString("Description"));

        }

        return msgPriority;
    }

    static Collection<MsgPriority> makeMsgPriorityObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<MsgPriority> result = new java.util.ArrayList();

        while (rs.next())
        {
            MsgPriority msgPriority = new MsgPriority();

            msgPriority.setPriorityLevel(rs.getString("Level"));
            msgPriority.setPriorityDesc(rs.getString("Description"));

            result.add(msgPriority);
        }

        return result;
    }
}
