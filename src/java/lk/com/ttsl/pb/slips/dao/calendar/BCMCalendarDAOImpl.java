/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.calendar;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.GregorianCalendar;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

public class BCMCalendarDAOImpl implements BCMCalendarDAO
{

    static String msg;

    @Override
    public String getMsg()
    {
        return msg;
    }

    /**
     *
     * @return
     */
    @Override
    public Collection<String> getAvailableYears()
    {
        Collection<String> col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select distinct(YEAR(CalenderDate)) as BCMYears from ");
            sbQuery.append(DDM_Constants.tbl_calender + " ");

            //System.out.println("sbQuery.toString() --> " + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            rs = psmt.executeQuery();

            col = BCMCalendarUtil.makeBCMYearsObjectCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;

    }
    
    @Override
    public String getNextVaildBusinessDate(String startDate)
    {
        String nextBusinessDate = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select CalenderDate as nextBDate from ");
            sbQuery.append(DDM_Constants.tbl_calender + " ");
            sbQuery.append("where CalenderDate >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
            sbQuery.append("and DayType != ? ");
            sbQuery.append("order by CalenderDate limit ? ");

            System.out.println("sbQuery.toString() --> " + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, startDate);
            psmt.setString(2, DDM_Constants.calendar_day_type_nbd);
            psmt.setInt(3, 1);

            rs = psmt.executeQuery();

            nextBusinessDate = BCMCalendarUtil.makeNextBusinessDateObject(rs);

            if (nextBusinessDate == null)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return nextBusinessDate;

    }

    @Override
    public Collection<String> getNextVaildBusinessDates(String startDate, int noOfDays)
    {
        Collection<String> col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select CalenderDate as nextValueDates from ");
            sbQuery.append(DDM_Constants.tbl_calender + " ");
            sbQuery.append("where CalenderDate >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
            sbQuery.append("and DayType != ? ");
            sbQuery.append("order by CalenderDate limit ? ");

            System.out.println("sbQuery.toString() --> " + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, startDate);
            psmt.setString(2, DDM_Constants.calendar_day_type_nbd);
            psmt.setInt(3, noOfDays);

            rs = psmt.executeQuery();

            col = BCMCalendarUtil.makeNextValueDatesObjectCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;

    }
    
    @Override
    public Collection<String> getPreviousBusinessDates(String startDate, int noOfDays)
    {
        Collection<String> col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select CalenderDate as prevBusinessDates from ");
            sbQuery.append(DDM_Constants.tbl_calender + " ");
            sbQuery.append("where CalenderDate <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
            sbQuery.append("and DayType != ? ");
            sbQuery.append("order by CalenderDate desc limit ? ");

            System.out.println("sbQuery.toString() --> " + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, startDate);
            psmt.setString(2, DDM_Constants.calendar_day_type_nbd);
            psmt.setInt(3, noOfDays);

            rs = psmt.executeQuery();

            col = BCMCalendarUtil.makePreviousBusinessDatesObjectCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    /**
     *
     * @param date
     * @return
     */
    @Override
    public BCMCalendar getCalendar(String date)
    {

        BCMCalendar window = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (date == null)
        {
            System.out.println("WARNING : Null date parameter.");
            return window;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select CalenderDate, DayType, Day, DayCategory, Remarks, ModifiedUser, ModifiedDate  from ");
            sbQuery.append(DDM_Constants.tbl_calender + " ");
            sbQuery.append("where CalenderDate = str_to_date(replace(?,'-',''),'%Y%m%d') ");

            //System.out.println("sbQuery.toString() --> " + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, date);

            rs = psmt.executeQuery();

            //System.out.println("rs  ---> " + rs);
            window = BCMCalendarUtil.makeCalendarObject(rs);

            //System.out.println("window  ---> " + window);
            if (window == null)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return window;
    }

    /**
     *
     * @param startDate
     * @param noOfDays
     * @return
     */
    @Override
    public String getPreviousBusinessDate(String startDate, int noOfDays)
    {

        String previousBD = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (startDate == null)
        {
            System.out.println("WARNING : Null date parameter.");
            return previousBD;
        }

        if (noOfDays < 1)
        {
            System.out.println("WARNING : Invalid noOfDays parameter.");
            return previousBD;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select MIN(cd.CalenderDate) as prevDate from (select CalenderDate from ");
            sbQuery.append(DDM_Constants.tbl_calender + " ");
            sbQuery.append("where CalenderDate < str_to_date(replace(?,'-',''),'%Y%m%d') ");
            sbQuery.append("and DayType != ? ");
            sbQuery.append("order by CalenderDate desc limit ?) as cd ");

            //System.out.println("sbQuery.toString() --> " + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, startDate);
            psmt.setString(2, DDM_Constants.calendar_day_type_nbd);
            psmt.setInt(3, noOfDays);

            rs = psmt.executeQuery();

            //System.out.println("rs  ---> " + rs);
            previousBD = BCMCalendarUtil.makePreviousDateObject(rs);

            //System.out.println("window  ---> " + window);
            if (previousBD == null)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return previousBD;
    }

    @Override
    public Collection<BCMCalendar> getCalendarDetails(String year, String month, String day, String dayType)
    {

        Collection<BCMCalendar> col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (year == null)
        {
            System.out.println("WARNING : Null year parameter.");
            return col;
        }
        if (month == null)
        {
            System.out.println("WARNING : Null month parameter.");
            return col;
        }
        if (day == null)
        {
            System.out.println("WARNING : Null day parameter.");
            return col;
        }
        if (dayType == null)
        {
            System.out.println("WARNING : Null dayType parameter.");
            return col;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_year = 1;
            int val_month = 2;
            int val_day = 3;
            int val_dayType = 4;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select CalenderDate, DayType, Day, DayCategory, Remarks, ModifiedUser, ModifiedDate  from ");
            sbQuery.append(DDM_Constants.tbl_calender + " ");

            sbQuery.append("where CalenderDate is not null ");

            if (!year.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and YEAR(CalenderDate) = ? ");
                vt.add(val_year);
            }

            if (!month.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and MONTH(CalenderDate) = ? ");
                vt.add(val_month);
            }

            if (!day.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DAY(CalenderDate) = ? ");
                vt.add(val_day);
            }

            if (!dayType.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DayType = ? ");
                vt.add(val_dayType);
            }

            //System.out.println("sbQuery.toString() --> " + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    psmt.setInt(i, Integer.parseInt(year));
                    i++;
                }

                if (val_item == 2)
                {
                    psmt.setInt(i, Integer.parseInt(month));
                    i++;
                }

                if (val_item == 3)
                {
                    psmt.setInt(i, Integer.parseInt(day));
                    i++;
                }

                if (val_item == 4)
                {
                    psmt.setString(i, dayType);
                    i++;
                }
            }

            rs = psmt.executeQuery();

            col = BCMCalendarUtil.makeCalendarObjectCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    @Override
    public boolean isValidFutureBusinessDate(String checkDate, String currentDate)
    {
        boolean isVFBD = false;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select count(*) as isValidFBD from ");
            sbQuery.append(DDM_Constants.tbl_calender + " c1 ");
            sbQuery.append("where str_to_date(replace(?,'-',''),'%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
            sbQuery.append("and (select DayType from calender c2 "
                    + "where c2.CalenderDate = str_to_date(replace(?,'-',''),'%Y%m%d')) = ? ");

            System.out.println("sbQuery.toString() --> " + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, currentDate);
            psmt.setString(2, checkDate);
            psmt.setString(3, checkDate);
            psmt.setString(4, DDM_Constants.calendar_day_type_fbd);

            rs = psmt.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();

                if (rs.getInt("isValidFBD") > 0)
                {
                    isVFBD = true;
                }
            }
            else
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
        {

            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return isVFBD;

    }

    @Override
    public boolean addBulkCalendarDetails(String year, String modifiedby)
    {
        boolean status = false;
        int noOfDays = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        String yearStart = null;

        if (year == null)
        {
            System.out.println("WARNING : Null year parameter.");
            return status;
        }

        if (modifiedby == null)
        {
            System.out.println("WARNING : Null modifiedby parameter.");
            return status;
        }

        yearStart = year + "0101";

        if (new GregorianCalendar().isLeapYear(Integer.parseInt(year)))
        {
            noOfDays = 366;
        }
        else
        {
            noOfDays = 365;
        }

        for (int i = 0; i < noOfDays; i++)
        {
            try
            {
                con = DBUtil.getInstance().getConnection();
                con.setAutoCommit(false);

                StringBuilder sbQuery = new StringBuilder();

                sbQuery.append("INSERT INTO ");
                sbQuery.append(DDM_Constants.tbl_calender);
                sbQuery.append("(CalenderDate, DayType, Day, DayCategory, Remarks, ModifiedUser, ModifiedDate)");
                sbQuery.append("VALUES(ADDDATE(STR_TO_DATE(?, '%Y%m%d'), ?), "
                        + "IF(DAYNAME(ADDDATE(STR_TO_DATE(?, '%Y%m%d'), ?))= 'Sunday' or DAYNAME(ADDDATE(STR_TO_DATE(?, '%Y%m%d'), ?))= 'Saturday', 'NBD', 'FBD'), "
                        + "DAYNAME(ADDDATE(STR_TO_DATE(?, '%Y%m%d'), ?)), "
                        + "?,?,?,NOW())");

                //System.out.println("sbQuery.toString() ---> " + sbQuery.toString());
                pstm = con.prepareStatement(sbQuery.toString());

                pstm.setString(1, yearStart);
                pstm.setInt(2, i);
                pstm.setString(3, yearStart);
                pstm.setInt(4, i);
                pstm.setString(5, yearStart);
                pstm.setInt(6, i);
                pstm.setString(7, yearStart);
                pstm.setInt(8, i);
                pstm.setString(9, "0");
                pstm.setString(10, "");
                pstm.setString(11, modifiedby);

                if (pstm.executeUpdate() > 0)
                {
                    con.commit();
                    status = true;
                    msg = " (" + (i + 1) + " of days added for the calendar year " + year + ".) ";
                }
                else
                {
                    msg = DDM_Constants.msg_error_while_processing + " (" + i + " of days added for the calendar year " + year + ".) ";;
                    con.rollback();
                    status = false;
                    break;
                }
            }
            catch (Exception e)
            {
                msg = e.getMessage() + " (" + i + " of days added for the calendar year " + year + ".) ";;
                System.out.println(e.toString());
                status = false;
                break;
            }
            finally
            {
                DBUtil.getInstance().closeStatement(pstm);
                DBUtil.getInstance().closeConnection(con);
            }

        }

        return status;

    }

    @Override
    public boolean addCalendarDetail(BCMCalendar cal)
    {
        boolean status = false;
        int ctr = 0;
        Connection con = null;
        PreparedStatement pstm = null;

        if (cal.getCalenderDate() == null)
        {
            System.out.println("WARNING : Null calenderDate parameter.");
            return status;
        }

        if (cal.getDayType() == null)
        {
            System.out.println("WARNING : Null dayType parameter.");
            return status;
        }

        if (cal.getDayCategory() == null)
        {
            System.out.println("WARNING : Null dayCategory parameter.");
            return status;
        }

        if (cal.getModifiedby() == null)
        {
            System.out.println("WARNING : Null modifiedby parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("INSERT INTO ");
            sbQuery.append(DDM_Constants.tbl_calender);
            sbQuery.append("(CalenderDate, DayType, Day, DayCategory, Remarks, ModifiedUser, ModifiedDate)");
            sbQuery.append("VALUES(str_to_date(replace(?,'-',''),'%Y%m%d'), ?, DAYNAME(str_to_date(replace(?,'-',''),'%Y%m%d')), ?,?,?,(select NOW()))");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, cal.getCalenderDate());
            pstm.setString(2, cal.getDayType());
            pstm.setString(3, cal.getCalenderDate());
            pstm.setString(4, cal.getDayCategory());
            pstm.setString(5, cal.getRemarks());
            pstm.setString(6, cal.getModifiedby());

            ctr = pstm.executeUpdate();

            if (ctr > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }

        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;

    }

    @Override
    public boolean updateCalendarDetail(BCMCalendar cal)
    {

        boolean status = false;
        Connection con = null;
        PreparedStatement pstm = null;
        int count = 0;

        if (cal.getCalenderDate() == null)
        {
            System.out.println("WARNING : Null calenderDate parameter.");
            return status;
        }

        if (cal.getDayType() == null)
        {
            System.out.println("WARNING : Null dayType parameter.");
            return status;
        }

        if (cal.getDayCategory() == null)
        {
            System.out.println("WARNING : Null dayCategory parameter.");
            return status;
        }

        if (cal.getModifiedby() == null)
        {
            System.out.println("WARNING : Null modifiedby parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_calender + " ");
            sbQuery.append("set DayType = ?, DayCategory = ?, Remarks = ?, ModifiedUser = ?, ModifiedDate=(select NOW()) ");
            sbQuery.append("where CalenderDate = str_to_date(replace(?,'-',''),'%Y%m%d') ");

            //System.out.println(sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, cal.getDayType());
            pstm.setString(2, cal.getDayCategory());
            pstm.setString(3, cal.getRemarks());
            pstm.setString(4, cal.getModifiedby());
            pstm.setString(5, cal.getCalenderDate());

            count = pstm.executeUpdate();

            if (count > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }

        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

}
