/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.utils;

import com.itextpdf.text.Document;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 *
 * @author Dinesh
 */
public class PDFMerger
{

    public static boolean mergePdfFiles(List<InputStream> inputPdfList, String outFile)
    {
        boolean status = false;
        OutputStream outputStream = null;
        File objOutFile = null;
        //Create document and pdfReader objects.
        Document document = new Document();
        List<PdfReader> readers = new ArrayList<>();
        int totalPages = 0;

        try
        {
            //Create pdf Iterator object using inputPdfList.
            Iterator<InputStream> pdfIterator = inputPdfList.iterator();

            // Create reader list for the input pdf files.
            while (pdfIterator.hasNext())
            {
                InputStream pdf = pdfIterator.next();
                PdfReader pdfReader = new PdfReader(pdf);
                readers.add(pdfReader);
                totalPages = totalPages + pdfReader.getNumberOfPages();
            }
            
            objOutFile = new File(outFile);
            
            if(objOutFile.exists())
            {
                new FileManager().clean(objOutFile);
            }

            outputStream = new FileOutputStream(outFile);

            // Create writer for the outputStream
            PdfWriter writer = PdfWriter.getInstance(document, outputStream);

            //Open document.
            document.open();

            //Contain the pdf data.
            PdfContentByte pageContentByte = writer.getDirectContent();

            PdfImportedPage pdfImportedPage;
            int currentPdfReaderPage = 1;
            Iterator<PdfReader> iteratorPDFReader = readers.iterator();

            // Iterate and process the reader list.
            while (iteratorPDFReader.hasNext())
            {
                PdfReader pdfReader = iteratorPDFReader.next();
                //Create page and add content.
                while (currentPdfReaderPage <= pdfReader.getNumberOfPages())
                {
                    document.newPage();
                    pdfImportedPage = writer.getImportedPage(pdfReader, currentPdfReaderPage);
                    pageContentByte.addTemplate(pdfImportedPage, 0, 0);
                    currentPdfReaderPage++;
                }

                currentPdfReaderPage = 1;
            }

            //Close document and outputStream.
            if (outputStream != null)
            {
                outputStream.flush();
            }
            
            if (document != null)
            {
                document.close();
            }
            
            if (outputStream != null)
            {
                outputStream.close();
            }

            status = true;

            System.out.println("Pdf files merged successfully.");

        }
        catch (Exception e)
        {
            System.out.println("Error occured while merging pdf files - " + e.getMessage());
        }

        return status;

    }

//    public static void main(String args[])
//    {
//        try
//        {
//            //Prepare input pdf file list as list of input stream.
//            List<InputStream> inputPdfList = new ArrayList<>();
//            
//            inputPdfList.add(new FileInputStream("E:\\TTS\\PB\\SLIPS\\RTN_ADVICE\\2209017010001000007388780713500210017902543923000000075000_1_RTN_Advice.pdf"));
//            inputPdfList.add(new FileInputStream("E:\\TTS\\PB\\SLIPS\\RTN_ADVICE\\2209017010068000089084978713500210017902543923000000075000_2_RTN_Advice.pdf"));
//            inputPdfList.add(new FileInputStream("E:\\TTS\\PB\\SLIPS\\RTN_ADVICE\\2209017010068000089089988713500210017902543923000000075000_3_RTN_Advice.pdf"));
//            inputPdfList.add(new FileInputStream("E:\\TTS\\PB\\SLIPS\\RTN_ADVICE\\2209017010144000070203209713500210017902543923000000075000_4_RTN_Advice.pdf"));
//
//            //Prepare output stream for merged pdf file.
//            OutputStream outputStream = new FileOutputStream("E:\\TTS\\PB\\SLIPS\\RTN_ADVICE\\test_RTN_Advice.pdf");
//
//            //call method to merge pdf files.
//            mergePdfFiles(inputPdfList, outputStream);
//        }
//        catch (Exception e)
//        {
//            System.out.println(e.getMessage());
//        }
//    }
}
