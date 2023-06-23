/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.common.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Dinesh - ProntoIT
 */
public class DateFormatter
{

    private DateFormatter()
    {
    }

    /**
     *
     * @param time time in milliseconds which needs to be formatted
     * @param pattern the pattern describing the date and time format (see <a
     * href="http://java.sun.com/javase/6/docs/api/java/text/SimpleDateFormat.html">java.text.SimpleDateFormat</a>
     * or more pattern details)
     * @return String - formatted date and time in requested string pattern
     */
    static public String doFormat(long time, String pattern)
    {
        String out = null;

        SimpleDateFormat sdf = new SimpleDateFormat(pattern);

        Date utilDate = new Date(time);

        out = sdf.format(utilDate);

        return out;
    }

    static public long getTime(String date, String pattern) throws ParseException
    {
        long time = 0;

        time = new SimpleDateFormat(pattern).parse(date).getTime();

        return time;
    }
}
