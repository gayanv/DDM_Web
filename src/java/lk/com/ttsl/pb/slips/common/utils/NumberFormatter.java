/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.common.utils;

import java.text.DecimalFormat;

/**
 *
 * @author Dinesh
 */
public class NumberFormatter
{

    private NumberFormatter()
    {
    }

    /**
     * 
     * @param value
     * @param pattern
     * @return 
     */
    static public String doFormat(double value, String pattern)
    {
        String out = null;

        DecimalFormat df = new DecimalFormat(pattern);

        out = df.format(value);

        return out;
    }
}
