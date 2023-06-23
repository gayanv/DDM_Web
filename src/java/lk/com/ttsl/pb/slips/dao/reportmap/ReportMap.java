/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.reportmap;

/**
 *
 * @author Dinesh
 */
public class ReportMap
{

    private String srcBankCode;
    private String srcBankShortName;
    private String srcBankFullName;
    private String srcFileName;
    //private String srcFileNameNew;
    private String desBankCode;
    private String desBankShortName;
    private String desBankFullName;
    private String desFileName;
    private String desFileNameNew;

    public String getDesFileNameNew() {
        return desFileNameNew;
    }

    public void setDesFileNameNew(String desFileNameNew) {
        this.desFileNameNew = desFileNameNew;
    }
    private String session;
    private String status;
    private String modifiedBy;
    private String modifiedTime;

    public ReportMap()
    {
    }

    public String getSrcBankCode()
    {
        return srcBankCode;
    }

    public void setSrcBankCode(String srcBankCode)
    {
        this.srcBankCode = srcBankCode;
    }

    public String getSrcBankShortName()
    {
        return srcBankShortName;
    }

    public void setSrcBankShortName(String srcBankShortName)
    {
        this.srcBankShortName = srcBankShortName;
    }

    public String getSrcBankFullName()
    {
        return srcBankFullName;
    }

    public void setSrcBankFullName(String srcBankFullName)
    {
        this.srcBankFullName = srcBankFullName;
    }

    public String getSrcFileName()
    {
        return srcFileName;
    }

    public void setSrcFileName(String srcFileName)
    {
        this.srcFileName = srcFileName;
    }

    public String getDesBankCode()
    {
        return desBankCode;
    }

    public void setDesBankCode(String desBankCode)
    {
        this.desBankCode = desBankCode;
    }

    public String getDesBankShortName()
    {
        return desBankShortName;
    }

    public void setDesBankShortName(String desBankShortName)
    {
        this.desBankShortName = desBankShortName;
    }

    public String getDesBankFullName()
    {
        return desBankFullName;
    }

    public void setDesBankFullName(String desBankFullName)
    {
        this.desBankFullName = desBankFullName;
    }

    public String getDesFileName()
    {
        return desFileName;
    }

    public void setDesFileName(String desFileName)
    {
        this.desFileName = desFileName;
    }

    public String getSession()
    {
        return session;
    }

    public void setSession(String session)
    {
        this.session = session;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getModifiedBy()
    {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy)
    {
        this.modifiedBy = modifiedBy;
    }

    public String getModifiedTime()
    {
        return modifiedTime;
    }

    public void setModifiedTime(String modifiedTime)
    {
        this.modifiedTime = modifiedTime;
    }
}
