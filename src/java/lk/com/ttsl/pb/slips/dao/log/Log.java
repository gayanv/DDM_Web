/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.log;

/**
 *
 * @author Dinesh
 */
public class Log
{

    private long logId;
    private String logType;
    private String logTypeDesc;
    private String logValue;
    private String logtime;

    public Log()
    {
    }

    public Log(String logType, String logValue)
    {
        this.logType = logType;
        this.logValue = logValue;
    }

    public long getLogId()
    {
        return logId;
    }

    public void setLogId(long logId)
    {
        this.logId = logId;
    }

    public String getLogType()
    {
        return logType;
    }

    public void setLogType(String logType)
    {
        this.logType = logType;
    }

    public String getLogTypeDesc()
    {
        return logTypeDesc;
    }

    public void setLogTypeDesc(String logTypeDesc)
    {
        this.logTypeDesc = logTypeDesc;
    }

    public String getLogValue()
    {
        return logValue;
    }

    public void setLogValue(String logValue)
    {
        this.logValue = logValue;
    }

    public String getLogtime()
    {
        return logtime;
    }

    public void setLogtime(String logtime)
    {
        this.logtime = logtime;
    }
}
