/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.reportsubtype;

/**
 *
 * @author Dinesh
 */
public class ReportSubType
{

    private String reportTypeID;
    private String reportTypeDesc;
    private String category;
    private String refParty;

    public String getReportTypeID()
    {
        return reportTypeID;
    }

    public void setReportTypeID(String reportTypeID)
    {
        this.reportTypeID = reportTypeID;
    }

    public String getReportTypeDesc()
    {
        return reportTypeDesc;
    }

    public void setReportTypeDesc(String reportTypeDesc)
    {
        this.reportTypeDesc = reportTypeDesc;
    }

    public String getCategory()
    {
        return category;
    }

    public void setCategory(String category)
    {
        this.category = category;
    }

    public String getRefParty()
    {
        return refParty;
    }

    public void setRefParty(String refParty)
    {
        this.refParty = refParty;
    }

}
