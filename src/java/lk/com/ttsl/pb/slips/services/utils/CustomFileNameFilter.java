/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.utils;

import java.io.File;
import java.io.FilenameFilter;

/**
 *
 * @author Dinesh
 */
public class CustomFileNameFilter implements FilenameFilter
{

    int type;
    String[] extensionArrayMatch = null;
    String[] extensionArrayOmmit = null;

    /**
     *
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
     */
    public CustomFileNameFilter(int type, String[] extensionArrayMatch, String[] extensionArrayOmmit)
    {
        this.type = type;
        this.extensionArrayMatch = extensionArrayMatch;
        this.extensionArrayOmmit = extensionArrayOmmit;
    }

    public boolean accept(File dir, String name)
    {
        boolean isMatch = false;

        switch (type)
        {
            case 1:
                for (String ext : extensionArrayMatch)
                {
                    if (name.startsWith(ext))
                    {
                        isMatch = true;
                        break;
                    }
                }
                break;
            case 2:
                for (String ext : extensionArrayMatch)
                {
                    if (name.endsWith(ext))
                    {
                        isMatch = true;
                        break;
                    }
                }
                break;
            case 3:
                for (String ext : extensionArrayMatch)
                {
                    if (name.indexOf(ext) > -1)
                    {
                        isMatch = true;
                        break;
                    }
                }
                break;

            case 4:
                boolean subMatch = false;

                for (String ext : extensionArrayMatch)
                {
                    if (ext != null && name.indexOf(ext) > -1)
                    {
                        subMatch = true;
                    }
                    else
                    {
                        subMatch = false;
                        break;
                    }
                }

                if (subMatch)
                {
                    isMatch = true;
                }
                break;
            case 5:
                boolean subMatch2 = false;

                for (String ext : extensionArrayOmmit)
                {
                    if (ext != null && !(name.indexOf(ext) > -1))
                    {
                        subMatch2 = true;
                    }
                    else
                    {
                        subMatch2 = false;
                        break;
                    }
                }

                if (subMatch2)
                {
                    isMatch = true;
                }
                break;
            case 6:
                boolean subMatch3 = false;

                for (String ext : extensionArrayMatch)
                {
                    if (ext != null && name.indexOf(ext) > -1)
                    {
                        subMatch3 = true;
                    }
                    else
                    {
                        subMatch3 = false;
                        break;
                    }
                }

                if (subMatch3)
                {
                    for (String ext : extensionArrayOmmit)
                    {
                        if (ext != null && !(name.indexOf(ext) > -1))
                        {
                            subMatch3 = true;
                        }
                        else
                        {
                            subMatch3 = false;
                            break;
                        }
                    }
                }

                if (subMatch3)
                {
                    isMatch = true;
                }
                break;

            default:
                isMatch = false;
                break;
        }

        return isMatch;
    }
}
