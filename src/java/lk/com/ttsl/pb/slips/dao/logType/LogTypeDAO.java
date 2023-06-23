/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.logType;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface LogTypeDAO
{
    public LogType getLogType(String logId);

    public Collection<LogType> getLogTypes();
}
