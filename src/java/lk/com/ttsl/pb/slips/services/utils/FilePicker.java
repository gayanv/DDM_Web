/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.utils;

import java.io.File;

/**
 *
 * @author Dinesh
 */
public class FilePicker
{
    /**
     * 
     * @param dir directory which needs check for the relevant  files
     * @param type 1 - File name starts with (prefix), 2 - File name ends with
     * (suffix), 3 - Find whether any occurrence of strings defined in the
     * string array 'extensionArrayMatch' is a substring of the file name., 4 - Find whether all the occurrence of strings defined in the
     * string array 'extensionArrayMatch' is a substring of the file name., 5 -
     * Find whether all the occurrence of strings defined in the string array
     * 'extensionArrayOmmit' is not a substring of the file name., 6 - Find
     * whether all the occurrence of strings defined in the string array
     * 'extensionArrayMatch' is a substring of the file name and all the
     * occurrence of strings defined in the string array 'extensionArrayOmmit'
     * is not a substring of the file name.
     * @param extensionArrayMatch String array which needs to match with the
     * file name.
     * @param extensionArrayOmmit String array which needs to not match with the
     * file name.
     * @return 
     */

    public File[] pickFiles(File dir, int type, String[] extensionArrayMatch, String[] extensionArrayOmmit)
    {
        File[] arrFile = null;
        
        arrFile = dir.listFiles(new CustomFileNameFilter(type, extensionArrayMatch, extensionArrayOmmit));        
        
        return arrFile;
    }
    
    
}
