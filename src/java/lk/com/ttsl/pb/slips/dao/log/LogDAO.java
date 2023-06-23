/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.log;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface LogDAO
{

    public Log getLog(long logId);
    
    public long getRecordCountLogDetails(String type, String logText, String fromLogDate, String toLogDate);

    public Collection<Log> getLogDetails(String type, String logText, String fromLogDate, String toLogDate);
    
    public Collection<Log> getLogDetails(String type, String logText, String fromLogDate, String toLogDate, int page, int recordsPrepage);

    public boolean addLog(Log log);
}
