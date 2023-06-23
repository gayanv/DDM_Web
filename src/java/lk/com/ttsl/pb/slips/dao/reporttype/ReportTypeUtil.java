/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.reporttype;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class ReportTypeUtil
{

    static ReportType makeReportTypeObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        ReportType reportType = null;

        if (rs.isBeforeFirst())
        {
            rs.next();
            
            reportType = new ReportType();

            reportType.setReportTypeID(rs.getString("ReportTypeID"));
            reportType.setReportTypeDesc(rs.getString("Description"));
            reportType.setCategory(rs.getString("Category"));
            reportType.setRefParty(rs.getString("ReferringParty"));

        }

        return reportType;
    }

    static Collection<ReportType> makeReportTypeObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<ReportType> result = new java.util.ArrayList();

        while (rs.next())
        {
            ReportType reportType = new ReportType();

            reportType.setReportTypeID(rs.getString("ReportTypeID"));
            reportType.setReportTypeDesc(rs.getString("Description"));
            reportType.setCategory(rs.getString("Category"));
            reportType.setRefParty(rs.getString("ReferringParty"));

            result.add(reportType);
        }

        return result;
    }
}
