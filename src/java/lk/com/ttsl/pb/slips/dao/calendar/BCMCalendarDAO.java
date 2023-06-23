/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.calendar;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface BCMCalendarDAO
{

    /**
     * 
     * @return 
     */
    public String getMsg();

    /**
     * 
     * @return 
     */
    public Collection<String> getAvailableYears();
    
    /**
     * 
     * @param startDate
     * @return 
     */
    public String getNextVaildBusinessDate(String startDate);
    
    /**
     * 
     * @param startDate
     * @param noOfDays
     * @return 
     */
    public Collection<String> getNextVaildBusinessDates(String startDate, int noOfDays);
    
    /**
     * 
     * @param startDate
     * @param noOfDays
     * @return 
     */
    public Collection<String> getPreviousBusinessDates(String startDate, int noOfDays);

    /**
     * 
     * @param date
     * @return 
     */
    public BCMCalendar getCalendar(String date);
    
    /**
     * 
     * @param startDate
     * @param noOfDays
     * @return 
     */
    public String getPreviousBusinessDate(String startDate, int noOfDays); 

    /**
     * 
     * @param year
     * @param month
     * @param day
     * @param dayType
     * @return 
     */
    public Collection<BCMCalendar> getCalendarDetails(String year, String month, String day, String dayType);

    public boolean isValidFutureBusinessDate(String checkDate, String currentDate);
    
    public boolean addBulkCalendarDetails(String year, String modifiedby);
    
    public boolean addCalendarDetail(BCMCalendar cal);

    public boolean updateCalendarDetail(BCMCalendar cal);
}
