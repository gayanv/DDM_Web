/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.report;

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
public class ReportUtil
{

    static String makeReportPathObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        String path = null;

        if (rs.isBeforeFirst())
        {
            rs.next();
            path = rs.getString("ReportPath");
        }

        return path;
    }

    static Report makeReportObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Report report = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            report = new Report();

            report.setReportName(rs.getString("ReportName"));
            report.setReportPath(rs.getString("ReportPath"));
            report.setReportType(rs.getString("ReportType"));

            report.setBank(rs.getString("BankCode"));
            report.setBankShortName(rs.getString("BankShortName"));
            report.setBankFullName(rs.getString("BankFullName"));

            report.setMerchantId(rs.getString("MerchantCode"));
            report.setMerchantName(rs.getString("MerchantName"));

            if (rs.getTimestamp("BusinessDate") != null)
            {
                report.setBusinessDate(DateFormatter.doFormat(rs.getTimestamp("BusinessDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            }

            report.setIsDownloadable(rs.getString("IsDownloadable"));

            report.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedTime") != null)
            {
                report.setCreatedTime(DateFormatter.doFormat(rs.getTimestamp("CreatedTime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            if (rs.getString("IsAlreadyDownloaded") == null)
            {
                report.setIsAlreadyDownloaded(DDM_Constants.status_no);
            }
            else
            {
                report.setIsAlreadyDownloaded(rs.getString("IsAlreadyDownloaded"));
            }

            report.setDownloadedBy(rs.getString("DownloadedBy"));

            if (rs.getTimestamp("DownloadedTime") != null)
            {
                report.setDownloadedTime(DateFormatter.doFormat(rs.getTimestamp("DownloadedTime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }

        return report;
    }

    static Collection makeReportObjectCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {
            Report report = new Report();

            report.setReportName(rs.getString("ReportName"));
            report.setReportPath(rs.getString("ReportPath"));
            report.setReportType(rs.getString("ReportType"));

            report.setBank(rs.getString("BankCode"));
            report.setBankShortName(rs.getString("BankShortName"));
            report.setBankFullName(rs.getString("BankFullName"));

            report.setMerchantId(rs.getString("MerchantCode"));
            report.setMerchantName(rs.getString("MerchantName"));

            if (rs.getTimestamp("BusinessDate") != null)
            {
                report.setBusinessDate(DateFormatter.doFormat(rs.getTimestamp("BusinessDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            }

            report.setIsDownloadable(rs.getString("IsDownloadable"));

            report.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedTime") != null)
            {
                report.setCreatedTime(DateFormatter.doFormat(rs.getTimestamp("CreatedTime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            if (rs.getString("IsAlreadyDownloaded") == null)
            {
                report.setIsAlreadyDownloaded(DDM_Constants.status_no);
            }
            else
            {
                report.setIsAlreadyDownloaded(rs.getString("IsAlreadyDownloaded"));
            }

            report.setDownloadedBy(rs.getString("DownloadedBy"));

            if (rs.getTimestamp("DownloadedTime") != null)
            {
                report.setDownloadedTime(DateFormatter.doFormat(rs.getTimestamp("DownloadedTime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(report);
        }
        return result;
    }

}
