/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.common.utils;

import java.io.File;

/**
 *
 * @author Dinesh
 */
public class CommonUtils
{

    public boolean isFileAvailable(String filePath)
    {
        File file = null;
        boolean stat = false;
        
        if(filePath == null)
        {
            System.out.println("WARNING : Null filePath parameter.");
            return stat;
        
        }

        file = new File(filePath);

        if (file.exists())
        {
            stat = true;
        }

        return stat;
    }
    
    public long getFileSize(String filePath)
    {
        File file = null;
        long reportSize = 0;

        if (filePath == null)
        {
            System.out.println("WARNING : Null filePath parameter.");
            return reportSize;

        }

        file = new File(filePath);

        if (file.exists())
        {
            reportSize = file.length();
        }
        else
        {
            reportSize = 0;
        }

        return reportSize;
    }

}
