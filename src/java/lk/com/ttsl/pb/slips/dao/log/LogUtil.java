/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.log;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class LogUtil
{

    public static Log makeLogObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Log log = null;

        while (rs.isBeforeFirst())
        {
            rs.next();

            log = new Log();

            log.setLogId(rs.getLong("activityid"));
            log.setLogType(rs.getString("type"));
            log.setLogTypeDesc(rs.getString("Description"));
            log.setLogValue(rs.getString("value"));

            if (rs.getString("processtime") != null)
            {
                log.setLogtime(DateFormatter.doFormat(rs.getTimestamp("processtime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }
        
        return log;
    }

    public static Collection<Log> makeLogObjectCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {
            Log log = new Log();

            log.setLogId(rs.getLong("activityid"));
            log.setLogType(rs.getString("type"));
            log.setLogTypeDesc(rs.getString("Description"));
            log.setLogValue(rs.getString("value"));

            if (rs.getString("processtime") != null)
            {
                log.setLogtime(DateFormatter.doFormat(rs.getTimestamp("processtime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(log);
        }
        return result;
    }
}
