/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.custom;

/**
 *
 * @author Dinesh - ProntoIT
 */
public class CustomDate
{

    public int getDay()
    {
        return day;
    }

    public void setDay(int day)
    {
        this.day = day;
    }

    public int getHour()
    {
        return hour;
    }

    public void setHour(int hour)
    {
        this.hour = hour;
    }

    public int getMilisecond()
    {
        return milisecond;
    }

    public void setMilisecond(int milisecond)
    {
        this.milisecond = milisecond;
    }

    public int getMinitue()
    {
        return minitue;
    }

    public void setMinitue(int minitue)
    {
        this.minitue = minitue;
    }

    public int getMonth()
    {
        return month;
    }

    public void setMonth(int month)
    {
        this.month = month;
    }

    public int getSecond()
    {
        return second;
    }

    public void setSecond(int second)
    {
        this.second = second;
    }

    public int getYear()
    {
        return year;
    }

    public void setYear(int year)
    {
        this.year = year;
    }


    int year;
    int month;
    int day;
    int hour;
    int minitue;
    int second;
    int milisecond;
}
