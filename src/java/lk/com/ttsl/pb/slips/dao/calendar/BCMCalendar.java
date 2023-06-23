/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.calendar;

/**
 *
 * @author Dinesh
 */
public class BCMCalendar
{

    private String CalenderDate;
    private String DayType;
    private String Day;
    private String DayCategory;
    private String Remarks;
    private String modifiedby;
    private String modifieddate;

    public BCMCalendar()
    {
    }

    public BCMCalendar(String CalenderDate, String DayType, String DayCategory, String Remarks, String modifiedby)
    {
        this.CalenderDate = CalenderDate;
        this.DayType = DayType;
        this.DayCategory = DayCategory;
        this.Remarks = Remarks;
        this.modifiedby = modifiedby;
    }

    public String getCalenderDate()
    {
        return CalenderDate;
    }

    public void setCalenderDate(String CalenderDate)
    {
        this.CalenderDate = CalenderDate;
    }

    public String getDay()
    {
        return Day;
    }

    public void setDay(String Day)
    {
        this.Day = Day;
    }

    public String getDayCategory()
    {
        return DayCategory;
    }

    public void setDayCategory(String DayCategory)
    {
        this.DayCategory = DayCategory;
    }

    public String getDayType()
    {
        return DayType;
    }

    public void setDayType(String DayType)
    {
        this.DayType = DayType;
    }

    public String getRemarks()
    {
        return Remarks;
    }

    public void setRemarks(String Remarks)
    {
        this.Remarks = Remarks;
    }

    public String getModifiedby()
    {
        return modifiedby;
    }

    public void setModifiedby(String modifiedby)
    {
        this.modifiedby = modifiedby;
    }

    public String getModifieddate()
    {
        return modifieddate;
    }

    public void setModifieddate(String modifieddate)
    {
        this.modifieddate = modifieddate;
    }
}
