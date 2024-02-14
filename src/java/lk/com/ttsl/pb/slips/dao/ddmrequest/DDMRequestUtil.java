/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.ddmrequest;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;

/**
 *
 * @author Dinesh
 */
public class DDMRequestUtil
{
   public static boolean isNumeric(String str) {
        try {
            Integer.parseInt(str); 
            return true;
        } catch (NumberFormatException e) {
            return false; 
        }
    }
   
   public static boolean isValidFrequency(String str) {
        try {
            //D,W,M,Q,Y
            
            if ((str.toUpperCase().equals("D"))||(str.toUpperCase().equals("W"))||(str.toUpperCase().equals("M"))||(str.toUpperCase().equals("Q"))||(str.toUpperCase().equals("Y")))
            {
                System.out.println("Valid Frequency "+ str );
                return true;
            }else{
                System.out.println("In-Valid Frequency "+ str );
                return false;
            } 
                
        } catch (Exception e) {
            return false; 
        }
    }
   
   public static boolean isValidDate(String strDate){
        SimpleDateFormat sdfrmt = new SimpleDateFormat("yyyymmdd");      
        sdfrmt.setLenient(false);
        
        try
	    {
	        Date javaDate = sdfrmt.parse(strDate); 
	        System.out.println(strDate+" is valid date format");
                
                
	    }
	    /* Date format is invalid */
	    catch (ParseException e)
	    {
	        System.out.println(strDate+" is Invalid Date format");
	        return false;
	    }
	    /* Return true if date format is valid */
	    return true;
    }
   
   public static boolean isValidSDateEDate(String strSDate,String strEDate){
        SimpleDateFormat sdfrmt = new SimpleDateFormat("yyyymmdd");      
        sdfrmt.setLenient(false);
        
        try
	    {
	        int isdate=Integer.parseInt(strSDate);
                int iedate=Integer.parseInt(strEDate);
                
                if (isdate<iedate){
                    return true;
                }else{
                    return false;
                }
	    }
	    
	    catch (NumberFormatException e)
	    {
	        System.out.println(" is Invalid Date format");
	        return false;
	    }
	    
	   
    }
   
   public static boolean isNotB4BusinessDate(String strDate,String strBdate){
       SimpleDateFormat sdfrmt = new SimpleDateFormat("yyyymmdd");
       sdfrmt.setLenient(false);

       try {
           int isdate = Integer.parseInt(strDate);
           int iedate = Integer.parseInt(strBdate);

           if (isdate < iedate) {
               return true;
           } else {
               return false;
           }
       } catch (NumberFormatException e) {
           System.out.println(" is Invalid Date format");
           return false;
       }
    }
   
    public static DDMRequest makeDDMRequestObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        DDMRequest ddmr = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            ddmr = new DDMRequest();

            ddmr.setDDA_ID(rs.getString("DDAID"));
            ddmr.setMerchantID(rs.getString("MerchantID"));
            ddmr.setMerchantName(rs.getString("MerchantName"));

            ddmr.setIssuningBankCode(rs.getString("IssuningBank"));
            ddmr.setIssuningBankName(rs.getString("IssuningBankName"));
            ddmr.setIssuningBankShortName(rs.getString("IssuningBankShortName"));
            ddmr.setIssuningBranch(rs.getString("IssuningBranch"));
            ddmr.setIssuningBranchName(rs.getString("IssuningBranchName"));
            ddmr.setIssuningAccountNumber(rs.getString("IssuningAcNo"));
            ddmr.setIssuningAccountName(rs.getString("IssuningAcName"));

            ddmr.setAcquiringBankCode(rs.getString("AquiringBank"));
            ddmr.setAcquiringBankName(rs.getString("AquiringBankName"));
            ddmr.setAcquiringBankShortName(rs.getString("AquiringBankShortName"));
            ddmr.setAcquiringBranch(rs.getString("AquiringBranch"));
            ddmr.setAcquiringBranchName(rs.getString("AquiringBranchName"));
            ddmr.setAcquiringAccountNumber(rs.getString("AquiringAcNo"));
            ddmr.setAcquiringAccountName(rs.getString("AquiringAcName"));

            if (rs.getTimestamp("StartDate") != null)
            {
                ddmr.setStartDate(DateFormatter.doFormat(rs.getTimestamp("StartDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            }

            if (rs.getTimestamp("EndDate") != null)
            {
                ddmr.setEndDate(DateFormatter.doFormat(rs.getTimestamp("EndDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            }

            ddmr.setMaxLimit(rs.getString("MaxLimit"));
            ddmr.setFrequency(rs.getString("Frequency"));
            ddmr.setPurpose(rs.getString("Purpose"));
            ddmr.setReference(rs.getString("Ref"));

            ddmr.setStatus(rs.getString("Status"));
            ddmr.setStatusDesc(rs.getString("StatusDesc"));            
            ddmr.setStatusModify(rs.getString("StatusModify"));

            ddmr.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedDate") != null)
            {
                ddmr.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ddmr.setIssuingBankAcceptedRemarks(rs.getString("IssuingBankAcceptedRemarks"));
            ddmr.setIssuingBankAcceptedBy(rs.getString("IssuingBankAcceptedBy"));

            if (rs.getTimestamp("IssuingBankAcceptedOn") != null)
            {
                ddmr.setIssuingBankAcceptedOn(DateFormatter.doFormat(rs.getTimestamp("IssuingBankAcceptedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ddmr.setAcquiringBankAcceptedRemarks(rs.getString("AquiringBankAcceptedRemarks"));
            ddmr.setAcquiringBankAcceptedBy(rs.getString("AquiringBankAcceptedBy"));

            if (rs.getTimestamp("AquiringBankAcceptedOn") != null)
            {
                ddmr.setAcquiringBankAcceptedOn(DateFormatter.doFormat(rs.getTimestamp("AquiringBankAcceptedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            
            ddmr.setTerminationRequestRemarks(rs.getString("TerminationRequestRemarks"));
            ddmr.setTerminationRequestedBy(rs.getString("TerminationRequestedBy"));

            if (rs.getTimestamp("TerminationRequestedOn") != null)
            {
                ddmr.setTerminationRequestedOn(DateFormatter.doFormat(rs.getTimestamp("TerminationRequestedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            
            ddmr.setTerminationApprovalRemarks(rs.getString("TerminationApprovalRemarks"));
            ddmr.setTerminationApprovedBy(rs.getString("TerminationApprovedBy"));

            if (rs.getTimestamp("TerminationApprovedOn") != null)
            {
                ddmr.setTerminationApprovedOn(DateFormatter.doFormat(rs.getTimestamp("TerminationApprovedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }

        return ddmr;
    }

    static Collection<DDMRequest> makeDDMRequestObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<DDMRequest> result = new java.util.ArrayList();

        while (rs.next())
        {

            DDMRequest ddmr = new DDMRequest();

            ddmr.setDDA_ID(rs.getString("DDAID"));
            ddmr.setMerchantID(rs.getString("MerchantID"));
            ddmr.setMerchantName(rs.getString("MerchantName"));

            ddmr.setIssuningBankCode(rs.getString("IssuningBank"));
            ddmr.setIssuningBankName(rs.getString("IssuningBankName"));
            ddmr.setIssuningBankShortName(rs.getString("IssuningBankShortName"));
            ddmr.setIssuningBranch(rs.getString("IssuningBranch"));
            ddmr.setIssuningBranchName(rs.getString("IssuningBranchName"));
            ddmr.setIssuningAccountNumber(rs.getString("IssuningAcNo"));
            ddmr.setIssuningAccountName(rs.getString("IssuningAcName"));

            ddmr.setAcquiringBankCode(rs.getString("AquiringBank"));
            ddmr.setAcquiringBankName(rs.getString("AquiringBankName"));
            ddmr.setAcquiringBankShortName(rs.getString("AquiringBankShortName"));
            ddmr.setAcquiringBranch(rs.getString("AquiringBranch"));
            ddmr.setAcquiringBranchName(rs.getString("AquiringBranchName"));
            ddmr.setAcquiringAccountNumber(rs.getString("AquiringAcNo"));
            ddmr.setAcquiringAccountName(rs.getString("AquiringAcName"));

            if (rs.getTimestamp("StartDate") != null)
            {
                ddmr.setStartDate(DateFormatter.doFormat(rs.getTimestamp("StartDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            }

            if (rs.getTimestamp("EndDate") != null)
            {
                ddmr.setEndDate(DateFormatter.doFormat(rs.getTimestamp("EndDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            }

            ddmr.setMaxLimit(rs.getString("MaxLimit"));
            ddmr.setFrequency(rs.getString("Frequency"));
            ddmr.setPurpose(rs.getString("Purpose"));
            ddmr.setReference(rs.getString("Ref"));

            ddmr.setStatus(rs.getString("Status"));
            ddmr.setStatusDesc(rs.getString("StatusDesc"));
            ddmr.setStatusModify(rs.getString("StatusModify"));

            ddmr.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedDate") != null)
            {
                ddmr.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ddmr.setIssuingBankAcceptedRemarks(rs.getString("IssuingBankAcceptedRemarks"));
            ddmr.setIssuingBankAcceptedBy(rs.getString("IssuingBankAcceptedBy"));

            if (rs.getTimestamp("IssuingBankAcceptedOn") != null)
            {
                ddmr.setIssuingBankAcceptedOn(DateFormatter.doFormat(rs.getTimestamp("IssuingBankAcceptedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ddmr.setAcquiringBankAcceptedRemarks(rs.getString("AquiringBankAcceptedRemarks"));
            ddmr.setAcquiringBankAcceptedBy(rs.getString("AquiringBankAcceptedBy"));

            if (rs.getTimestamp("AquiringBankAcceptedOn") != null)
            {
                ddmr.setAcquiringBankAcceptedOn(DateFormatter.doFormat(rs.getTimestamp("AquiringBankAcceptedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            
            ddmr.setTerminationRequestRemarks(rs.getString("TerminationRequestRemarks"));
            ddmr.setTerminationRequestedBy(rs.getString("TerminationRequestedBy"));

            if (rs.getTimestamp("TerminationRequestedOn") != null)
            {
                ddmr.setTerminationRequestedOn(DateFormatter.doFormat(rs.getTimestamp("TerminationRequestedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            
            ddmr.setTerminationApprovalRemarks(rs.getString("TerminationApprovalRemarks"));
            ddmr.setTerminationApprovedBy(rs.getString("TerminationApprovedBy"));

            if (rs.getTimestamp("TerminationApprovedOn") != null)
            {
                ddmr.setTerminationApprovedOn(DateFormatter.doFormat(rs.getTimestamp("TerminationApprovedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(ddmr);
        }

        return result;
    }
    
    static Collection<DDMRequest> makeDDMRequestSummaryObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<DDMRequest> result = new java.util.ArrayList();

        while (rs.next())
        {
            DDMRequest ddmr = new DDMRequest();

            ddmr.setMerchantID(rs.getString("MerchantID"));
            ddmr.setMerchantName(rs.getString("MerchantName"));

            ddmr.setOngoingReqCount(rs.getInt("OnReqCount"));
            ddmr.setCompletedReqCount(rs.getInt("CmpReqCount"));
            ddmr.setRejectedReqCount(rs.getInt("RejReqCount"));
            ddmr.setSLABreachedReqCount(rs.getInt("SLABReqCount"));
            ddmr.setTerminatedReqCount(rs.getInt("TerReqCount"));

            result.add(ddmr);
        }

        return result;
    }

    static Collection<DDMRequest> makeSLABreachIssuingBankSummaryObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<DDMRequest> result = new java.util.ArrayList();

        while (rs.next())
        {
            DDMRequest ddmr = new DDMRequest();

            ddmr.setIssuningBankCode(rs.getString("IssuningBank"));
            ddmr.setIssuningBankName(rs.getString("IssuningBankName"));

            ddmr.setSLABreachedIsuBkReqCount(rs.getInt("ReqCount"));
            ddmr.setSLABreachedIsuBkReqAvgExceedDays(rs.getDouble("AvgNoOfDaysExeed"));

            result.add(ddmr);
        }

        return result;
    }
    
    static Collection<DDMRequest> makeSLABreachIssuingBankReqDetailObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<DDMRequest> result = new java.util.ArrayList();

        while (rs.next())
        {

            DDMRequest ddmr = new DDMRequest();

            ddmr.setDDA_ID(rs.getString("DDAID"));
            ddmr.setMerchantID(rs.getString("MerchantID"));
            ddmr.setMerchantName(rs.getString("MerchantName"));

            ddmr.setIssuningBankCode(rs.getString("IssuningBank"));
            ddmr.setIssuningBankName(rs.getString("IssuningBankName"));
            ddmr.setIssuningBankShortName(rs.getString("IssuningBankShortName"));
            ddmr.setIssuningBranch(rs.getString("IssuningBranch"));
            ddmr.setIssuningBranchName(rs.getString("IssuningBranchName"));
            ddmr.setIssuningAccountNumber(rs.getString("IssuningAcNo"));
            ddmr.setIssuningAccountName(rs.getString("IssuningAcName"));

            ddmr.setAcquiringBankCode(rs.getString("AquiringBank"));
            ddmr.setAcquiringBankName(rs.getString("AquiringBankName"));
            ddmr.setAcquiringBankShortName(rs.getString("AquiringBankShortName"));
            ddmr.setAcquiringBranch(rs.getString("AquiringBranch"));
            ddmr.setAcquiringBranchName(rs.getString("AquiringBranchName"));
            ddmr.setAcquiringAccountNumber(rs.getString("AquiringAcNo"));
            ddmr.setAcquiringAccountName(rs.getString("AquiringAcName"));

            if (rs.getTimestamp("StartDate") != null)
            {
                ddmr.setStartDate(DateFormatter.doFormat(rs.getTimestamp("StartDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            }

            if (rs.getTimestamp("EndDate") != null)
            {
                ddmr.setEndDate(DateFormatter.doFormat(rs.getTimestamp("EndDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            }

            ddmr.setMaxLimit(rs.getString("MaxLimit"));
            ddmr.setFrequency(rs.getString("Frequency"));
            ddmr.setPurpose(rs.getString("Purpose"));
            ddmr.setReference(rs.getString("Ref"));

            ddmr.setStatus(rs.getString("Status"));
            ddmr.setStatusDesc(rs.getString("StatusDesc"));

            ddmr.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedDate") != null)
            {
                ddmr.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ddmr.setIssuingBankAcceptedRemarks(rs.getString("IssuingBankAcceptedRemarks"));
            ddmr.setIssuingBankAcceptedBy(rs.getString("IssuingBankAcceptedBy"));

            if (rs.getTimestamp("IssuingBankAcceptedOn") != null)
            {
                ddmr.setIssuingBankAcceptedOn(DateFormatter.doFormat(rs.getTimestamp("IssuingBankAcceptedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ddmr.setAcquiringBankAcceptedRemarks(rs.getString("AquiringBankAcceptedRemarks"));
            ddmr.setAcquiringBankAcceptedBy(rs.getString("AquiringBankAcceptedBy"));

            if (rs.getTimestamp("AquiringBankAcceptedOn") != null)
            {
                ddmr.setAcquiringBankAcceptedOn(DateFormatter.doFormat(rs.getTimestamp("AquiringBankAcceptedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            
            ddmr.setSLABreachedIsuBkReqExceedDays(rs.getInt("NoOfDaysExceed"));

            result.add(ddmr);
        }

        return result;
    }
    
    static Collection<DDMRequest> makeSLABreachAcquiringBankSummaryObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<DDMRequest> result = new java.util.ArrayList();

        while (rs.next())
        {
            DDMRequest ddmr = new DDMRequest();

            ddmr.setAcquiringBankCode(rs.getString("AquiringBank"));
            ddmr.setAcquiringBankName(rs.getString("AquiringBankName"));

            ddmr.setSLABreachedAcqBkReqCount(rs.getInt("ReqCount"));
            ddmr.setSLABreachedAcqBkReqAvgExceedDays(rs.getDouble("AvgNoOfDaysExeed"));

            result.add(ddmr);
        }

        return result;
    }
    
    static Collection<DDMRequest> makeSLABreachAcquiringBankReqDetailObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<DDMRequest> result = new java.util.ArrayList();

        while (rs.next())
        {

            DDMRequest ddmr = new DDMRequest();

            ddmr.setDDA_ID(rs.getString("DDAID"));
            ddmr.setMerchantID(rs.getString("MerchantID"));
            ddmr.setMerchantName(rs.getString("MerchantName"));

            ddmr.setIssuningBankCode(rs.getString("IssuningBank"));
            ddmr.setIssuningBankName(rs.getString("IssuningBankName"));
            ddmr.setIssuningBankShortName(rs.getString("IssuningBankShortName"));
            ddmr.setIssuningBranch(rs.getString("IssuningBranch"));
            ddmr.setIssuningBranchName(rs.getString("IssuningBranchName"));
            ddmr.setIssuningAccountNumber(rs.getString("IssuningAcNo"));
            ddmr.setIssuningAccountName(rs.getString("IssuningAcName"));

            ddmr.setAcquiringBankCode(rs.getString("AquiringBank"));
            ddmr.setAcquiringBankName(rs.getString("AquiringBankName"));
            ddmr.setAcquiringBankShortName(rs.getString("AquiringBankShortName"));
            ddmr.setAcquiringBranch(rs.getString("AquiringBranch"));
            ddmr.setAcquiringBranchName(rs.getString("AquiringBranchName"));
            ddmr.setAcquiringAccountNumber(rs.getString("AquiringAcNo"));
            ddmr.setAcquiringAccountName(rs.getString("AquiringAcName"));

            if (rs.getTimestamp("StartDate") != null)
            {
                ddmr.setStartDate(DateFormatter.doFormat(rs.getTimestamp("StartDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            }

            if (rs.getTimestamp("EndDate") != null)
            {
                ddmr.setEndDate(DateFormatter.doFormat(rs.getTimestamp("EndDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
            }

            ddmr.setMaxLimit(rs.getString("MaxLimit"));
            ddmr.setFrequency(rs.getString("Frequency"));
            ddmr.setPurpose(rs.getString("Purpose"));
            ddmr.setReference(rs.getString("Ref"));

            ddmr.setStatus(rs.getString("Status"));
            ddmr.setStatusDesc(rs.getString("StatusDesc"));

            ddmr.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedDate") != null)
            {
                ddmr.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ddmr.setIssuingBankAcceptedRemarks(rs.getString("IssuingBankAcceptedRemarks"));
            ddmr.setIssuingBankAcceptedBy(rs.getString("IssuingBankAcceptedBy"));

            if (rs.getTimestamp("IssuingBankAcceptedOn") != null)
            {
                ddmr.setIssuingBankAcceptedOn(DateFormatter.doFormat(rs.getTimestamp("IssuingBankAcceptedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ddmr.setAcquiringBankAcceptedRemarks(rs.getString("AquiringBankAcceptedRemarks"));
            ddmr.setAcquiringBankAcceptedBy(rs.getString("AquiringBankAcceptedBy"));

            if (rs.getTimestamp("AquiringBankAcceptedOn") != null)
            {
                ddmr.setAcquiringBankAcceptedOn(DateFormatter.doFormat(rs.getTimestamp("AquiringBankAcceptedOn").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            
            ddmr.setSLABreachedAcqBkReqExceedDays(rs.getInt("NoOfDaysExceed"));

            result.add(ddmr);
        }

        return result;
    }

}
