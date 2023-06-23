/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.logType;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class LogTypeUtil
{

    static LogType makeLogTypeObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        LogType logType = null;

        if (rs.isBeforeFirst())
        {
            rs.next();
            
            logType = new LogType();

            logType.setTypeId(rs.getString("ID"));
            logType.setDescription(rs.getString("Description"));

        }

        return logType;
    }

    static Collection<LogType> makeLogTypeObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<LogType> result = new java.util.ArrayList();

        while (rs.next())
        {
            LogType logType = new LogType();

            logType.setTypeId(rs.getString("ID"));
            logType.setDescription(rs.getString("Description"));

            result.add(logType);
        }

        return result;
    }
}
