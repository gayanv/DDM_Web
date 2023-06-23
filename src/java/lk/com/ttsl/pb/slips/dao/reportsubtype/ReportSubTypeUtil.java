/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.reportsubtype;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class ReportSubTypeUtil
{

    static ReportSubType makeReportTypeObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        ReportSubType reportType = null;

        if (rs.isBeforeFirst())
        {
            rs.next();
            
            reportType = new ReportSubType();

            reportType.setReportTypeID(rs.getString("ReportTypeID"));
            reportType.setReportTypeDesc(rs.getString("Description"));
            reportType.setCategory(rs.getString("Category"));
            reportType.setRefParty(rs.getString("ReferringParty"));

        }

        return reportType;
    }

    static Collection<ReportSubType> makeReportTypeObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<ReportSubType> result = new java.util.ArrayList();

        while (rs.next())
        {
            ReportSubType reportType = new ReportSubType();

            reportType.setReportTypeID(rs.getString("ReportTypeID"));
            reportType.setReportTypeDesc(rs.getString("Description"));
            reportType.setCategory(rs.getString("Category"));
            reportType.setRefParty(rs.getString("ReferringParty"));

            result.add(reportType);
        }

        return result;
    }
}
