/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.utils;

import com.pronto.lcpl.filereader.processor.OWDFileUploader;

/**
 *
 * @author Dinesh
 */
public class SLIPS_FileProcessor
{

    private static SLIPS_FileProcessor slipsFileProcessor;
    private OWDFileUploader objSLIPS_FileProcessor;

    private SLIPS_FileProcessor()
    {
    }

    public static SLIPS_FileProcessor getInstance()
    {
        if (slipsFileProcessor == null)
        {
            slipsFileProcessor = new SLIPS_FileProcessor();
        }
        return slipsFileProcessor;
    }

    public OWDFileUploader getObjSLIPS_FileProcessor()
    {
//        if (objSLIPS_FileProcessor == null)
//        {

            objSLIPS_FileProcessor = new OWDFileUploader();
//        }

        return objSLIPS_FileProcessor;
    }

}
