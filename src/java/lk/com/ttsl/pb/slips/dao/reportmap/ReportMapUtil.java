/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.reportmap;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

public class ReportMapUtil
{


    public static Collection<ReportMap> makeReportMapObjectCollection(ResultSet rs)
            throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {

            ReportMap reportMap = new ReportMap();

            reportMap.setSrcBankCode(rs.getString("SrcBank"));
            reportMap.setSrcBankShortName(rs.getString("S_ShortName"));
            reportMap.setSrcBankFullName(rs.getString("S_FullName"));
            reportMap.setSrcFileName(rs.getString("SrcFileName"));

            reportMap.setDesBankCode(rs.getString("DesBank"));
            reportMap.setDesBankShortName(rs.getString("D_ShortName"));
            reportMap.setDesBankFullName(rs.getString("D_FullName"));
            reportMap.setDesFileName(rs.getString("DesFileName"));

            reportMap.setSession(rs.getString("RelevantSession"));
            reportMap.setStatus(rs.getString("Status"));

            reportMap.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedTime") != null)
            {
                reportMap.setModifiedTime(DateFormatter.doFormat(rs.getTimestamp("ModifiedTime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(reportMap);
        }
        return result;
    }
}
