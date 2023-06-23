/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.calendar;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

public class BCMCalendarUtil
{

    public BCMCalendarUtil()
    {
    }

    public static BCMCalendar makeCalendarObject(ResultSet rs)
            throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        BCMCalendar cal = null;

        if (rs.isBeforeFirst())
        {
            rs.next();
            cal = new BCMCalendar();

            cal.setCalenderDate(DateFormatter.doFormat(rs.getTimestamp("CalenderDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            cal.setDayType(rs.getString("DayType"));
            cal.setDay(rs.getString("Day"));
            cal.setDayCategory(rs.getString("DayCategory"));
            cal.setRemarks(rs.getString("Remarks"));

            if (rs.getString("ModifiedUser") != null)
            {
                cal.setModifiedby(rs.getString("ModifiedUser"));
            }
            if (rs.getString("ModifiedDate") != null)
            {
                cal.setModifieddate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
        }

        return cal;
    }

    public static Collection<BCMCalendar> makeCalendarObjectCollection(ResultSet rs)
            throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {

            BCMCalendar cal = new BCMCalendar();

            cal.setCalenderDate(DateFormatter.doFormat(rs.getTimestamp("CalenderDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            cal.setDayType(rs.getString("DayType"));
            cal.setDay(rs.getString("Day"));
            cal.setDayCategory(rs.getString("DayCategory"));
            cal.setRemarks(rs.getString("Remarks"));

            if (rs.getString("ModifiedUser") != null)
            {
                cal.setModifiedby(rs.getString("ModifiedUser"));
            }
            if (rs.getString("ModifiedDate") != null)
            {
                cal.setModifieddate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(cal);
        }
        return result;
    }

    public static Collection<String> makeBCMYearsObjectCollection(ResultSet rs)
            throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {
            String year = String.valueOf(rs.getInt("BCMYears"));

            result.add(year);
        }
        return result;
    }

    public static String makeNextBusinessDateObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        String nextBDate = null;

        if (rs.isBeforeFirst())
        {
            nextBDate = DateFormatter.doFormat(rs.getTimestamp("nextBDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd);
        }

        return nextBDate;
    }

    public static Collection<String> makeNextValueDatesObjectCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {
            result.add(DateFormatter.doFormat(rs.getTimestamp("nextValueDates").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
        }

        return result;
    }
    
        public static Collection<String> makePreviousBusinessDatesObjectCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection result = new ArrayList();

        while (rs.next())
        {
            result.add(DateFormatter.doFormat(rs.getTimestamp("prevBusinessDates").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
        }

        return result;
    }
    

    public static String makePreviousDateObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        String preBD = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            preBD = DateFormatter.doFormat(rs.getTimestamp("prevDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd);
        }

        return preBD;
    }

}
