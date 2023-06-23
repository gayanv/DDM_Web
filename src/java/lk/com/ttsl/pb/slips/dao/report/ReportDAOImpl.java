/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.report;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;
import lk.com.ttsl.pb.slips.services.utils.FileManager;
import lk.com.ttsl.pb.slips.services.utils.PropertyLoader;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRPdfExporter;

/**
 *
 * @author Dinesh
 */
public class ReportDAOImpl implements ReportDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public File getFile(String reportName, String okToDownload)
    {
        File file = null;
        String path = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (reportName == null)
        {
            System.out.println("WARNING : Null reportName parameter.");
            return file;
        }

        if (okToDownload == null)
        {
            System.out.println("WARNING : Null okToDownload parameter.");
            return file;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ReportPath from ");
            sbQuery.append(DDM_Constants.tbl_report + " ");
            sbQuery.append("where ReportName = ? ");

            if (!okToDownload.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and IsDownloadable = ? ");
            }

            //System.out.println(sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, reportName);

            if (!okToDownload.equals(DDM_Constants.status_all))
            {
                pstm.setString(2, okToDownload);
            }

            rs = pstm.executeQuery();

            path = ReportUtil.makeReportPathObject(rs);

            if (path != null)
            {
                file = new File(path);

                if (!file.exists())
                {
                    file = null;
                }
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return file;
    }

    @Override
    public Report getReportDetails(String reportName, String type, String okToDownload)
    {
        Report report = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (reportName == null)
        {
            System.out.println("WARNING : Null reportName parameter.");
            return report;
        }
        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return report;
        }
        if (okToDownload == null)
        {
            System.out.println("WARNING : Null okToDownload parameter.");
            return report;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_reportName = 1;
            int val_type = 2;
            int val_okToDownload = 3;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select rp.BusinessDate, rp.ReportName, rp.ReportPath, rp.ReportType, "
                    + "rp.BankCode, ba.ShortName as BankShortName, ba.FullName as BankFullName, "
                    + "rp.MerchantCode, cc.MerchantName, rp.CreatedBy, rp.CreatedTime, "
                    + "rp.IsDownloadable, rp.IsAlreadyDownloaded, rp.DownloadedBy, rp.DownloadedTime from ");

            sbQuery.append(DDM_Constants.tbl_report + " rp, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_merchant + "  cc ");

            sbQuery.append("where rp.BankCode = ba.BankCode ");
            sbQuery.append("and ifnull(rp.MerchantCode, ?) = cc.MerchantID ");

            if (!reportName.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rp.ReportName = ? ");
                vt.add(val_reportName);
            }

            if (!okToDownload.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rp.IsDownloadable = ? ");
                vt.add(val_okToDownload);
            }
            if (!type.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rp.ReportType = ? ");
                vt.add(val_type);
            }

            sbQuery.append("order by  rp.BusinessDate, rp.BankCode, rp.MerchantCode ");

            System.out.println(sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;
            
            pstm.setString(i, DDM_Constants.default_coporate_customer_id);
            i++;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, reportName);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, type);
                    i++;
                }
                if (val_item == 3)
                {
                    pstm.setString(i, okToDownload);
                    i++;
                }

            }

            rs = pstm.executeQuery();

            System.out.println("rs ---> " + rs);

            report = ReportUtil.makeReportObject(rs);

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return report;
    }

    @Override
    public Collection<Report> getReportDetails(String bankCode, String branchCode, String merchantID, String type, String category, String status, String fromBusinessDate, String toBusinessDate)
    {
        Collection<Report> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (branchCode == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return col;
        }
        if (merchantID == null)
        {
            System.out.println("WARNING : Null merchantID parameter.");
            return col;
        }

        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return col;
        }
        
        if (category == null)
        {
            System.out.println("WARNING : Null category parameter.");
            return col;
        }
        
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        if (fromBusinessDate == null)
        {
            System.out.println("WARNING : Null fromBusinessDate parameter.");
            return col;
        }

        if (toBusinessDate == null)
        {
            System.out.println("WARNING : Null toBusinessDate parameter.");
            return col;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_bankCode = 1;
            int val_branchCode = 2;
            int val_merchantID = 3;
            int val_status = 4;
            int val_type = 5;
            int val_category = 6;
            int val_fromBusinessDate = 7;
            int val_toBusinessDate = 8;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select rp.BusinessDate, rp.ReportName, rp.ReportPath, rp.ReportType, "
                    + "rp.BankCode, ba.ShortName as BankShortName, ba.FullName as BankFullName, "
                    + "rp.MerchantCode, cc.MerchantName, rp.CreatedBy, rp.CreatedTime, "
                    + "rp.IsDownloadable, rp.IsAlreadyDownloaded, rp.DownloadedBy, rp.DownloadedTime from ");

            sbQuery.append(DDM_Constants.tbl_report + " rp, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_merchant + "  cc, ");
            sbQuery.append(DDM_Constants.tbl_reportype + "  rpt ");
            

            sbQuery.append("where rp.BankCode = ba.BankCode ");
            sbQuery.append("and ifnull(rp.MerchantCode, ?) = cc.MerchantID ");
            sbQuery.append("and rp.ReportType = rpt.ReportTypeID ");
            //sbQuery.append("and rp.BranchCode = br.BranchCode ");
            

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rp.BankCode = ? ");
                vt.add(val_bankCode);
            }
            if (!branchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rp.BranchCode = ?  ");
                vt.add(val_branchCode);
            }
            if (!merchantID.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rp.MerchantCode = ?  ");
                vt.add(val_merchantID);
            }
            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rp.IsDownloadable = ? ");
                vt.add(val_status);
            }
            if (!type.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rp.ReportType = ? ");
                vt.add(val_type);
            }            
             if (!category.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rpt.Category = ? ");
                vt.add(val_category);
            }
            
            if (!fromBusinessDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rp.BusinessDate >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromBusinessDate);
            }
            if (!toBusinessDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and rp.BusinessDate <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toBusinessDate);
            }

            sbQuery.append("order by rp.BusinessDate, rp.BankCode, rp.MerchantCode ");

            System.out.println(sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;
            
            pstm.setString(i, DDM_Constants.default_coporate_customer_id);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_bankCode)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == val_branchCode)
                {
                    pstm.setString(i, branchCode);
                    i++;
                }
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantID);
                    i++;
                }
                
                if (val_item == val_type)
                {
                    pstm.setString(i, type);
                    i++;
                }
                
                if (val_item == val_category)
                {
                    pstm.setString(i, category);
                    i++;
                }
                
                if (val_item == val_status)
                {
                    pstm.setString(i, status);
                    i++;
                }
                
                if (val_item == val_fromBusinessDate)
                {
                    pstm.setString(i, fromBusinessDate);
                    i++;
                }
                if (val_item == val_toBusinessDate)
                {
                    pstm.setString(i, toBusinessDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = ReportUtil.makeReportObjectCollection(rs);
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    @Override
    public boolean addReportDetails(String businessDate, String session, String bankCode, String branchCode, String cocu_id, String reportName, String reportPath, String reportType, String createdBy)
    {

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean status = false;

        if (businessDate == null)
        {
            System.out.println("WARNING : Null businessDate parameter.");
            return status;
        }
        if (session == null)
        {
            System.out.println("WARNING : Null session parameter.");
            return status;
        }
        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return status;
        }
        if (branchCode == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return status;
        }
        if (cocu_id == null)
        {
            System.out.println("WARNING : Null cocu_id parameter.");
            return status;
        }
        if (reportName == null)
        {
            System.out.println("WARNING : Null reportName parameter.");
            return status;
        }
        if (reportPath == null)
        {
            System.out.println("WARNING : Null reportPath parameter.");
            return status;
        }
        if (reportType == null)
        {
            System.out.println("WARNING : Null reportType parameter.");
            return status;
        }
        if (createdBy == null)
        {
            System.out.println("WARNING : Null createdBy parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_report + " ");
            sbQuery.append("(BusinessDate,Session,BankCode,BranchCode,cocu_id,ReportName,ReportPath,"
                    + "ReportType,IsDownloadable,CreatedBy,CreatedTime) ");
            sbQuery.append("values (str_to_date(replace(?,'-',''),'%Y%m%d'),?,?,?,?,?,?,?,?,?,now())");
            sbQuery.append("ON DUPLICATE KEY UPDATE BusinessDate = str_to_date(replace(?,'-',''),'%Y%m%d'), "
                    + "Session = ?, BankCode = ?, BranchCode = ?, cocu_id = ?, ReportPath = ?, "
                    + "ReportType = ?, IsDownloadable = ?, CreatedBy = ?, CreatedTime = now(), IsAlreadyDownloaded = ?, "
                    + "DownloadedBy = null, DownloadedTime = null ");

            System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, businessDate);
            psmt.setString(2, session);
            psmt.setString(3, bankCode);
            psmt.setString(4, branchCode);
            psmt.setString(5, cocu_id);
            psmt.setString(6, reportName);
            psmt.setString(7, reportPath);
            psmt.setString(8, reportType);
            psmt.setString(9, DDM_Constants.status_yes);
            psmt.setString(10, createdBy);

            psmt.setString(11, businessDate);
            psmt.setString(12, session);
            psmt.setString(13, bankCode);
            psmt.setString(14, branchCode);
            psmt.setString(15, cocu_id);
            psmt.setString(16, reportPath);
            psmt.setString(17, reportType);
            psmt.setString(18, DDM_Constants.status_yes);
            psmt.setString(19, createdBy);
            psmt.setString(20, DDM_Constants.status_no);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                con.rollback();
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    @Override
    public boolean updateDownloadDetails(String reportName, String downloadedBy)
    {

        if (reportName == null)
        {
            System.out.println("WARNING : Null reportName parameter.");
            return false;
        }
        if (downloadedBy == null)
        {
            System.out.println("WARNING : Null downloadedBy parameter.");
            return false;
        }

        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_report + " ");
            sbQuery.append("set IsAlreadyDownloaded = ?, DownloadedBy = ?, DownloadedTime = NOW() ");
            sbQuery.append("where ReportName = ? ");

            //System.out.println(sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_yes);
            psmt.setString(2, downloadedBy);
            psmt.setString(3, reportName);

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                query_status = true;
            }
            else
            {
                con.rollback();
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

//    @Override
//    public String generateHOGL_Report(String businessDate, String session, String generatedBy)
//    {
//        if (businessDate == null)
//        {
//            System.out.println("WARNING : Null businessDate parameter.");
//            return null;
//        }
//
//        if (generatedBy == null)
//        {
//            System.out.println("WARNING : Null generatedBy parameter.");
//            return null;
//        }
//
//        String hoglReportPath = null;
//
//        long total_ACCNO = 0;
//        long total_CreditTrCount = 0;
//        long total_CreditAmount = 0;
//        long total_DebitTrCount = 0;
//        long total_DebitAmount = 0;
//
//        ArrayList<String> hoglData = null;
//
//        Collection<HOGL_Report> col_IW_OW_OtherBank = DAOFactory.getHOGL_ReportDAO().getIW_OW_OtherBankRecords(businessDate);
//
//        if (col_IW_OW_OtherBank != null && col_IW_OW_OtherBank.size() > 0)
//        {
//
//            if (hoglData == null)
//            {
//                hoglData = new ArrayList();
//            }
//
//            for (HOGL_Report hogl : col_IW_OW_OtherBank)
//            {
//                long lAccountValue = 0;
//
//                try
//                {
//                    lAccountValue = Long.parseLong(hogl.getIACCTNO());
//                }
//                catch (Exception e)
//                {
//                    lAccountValue = 0;
//                }
//
//                total_ACCNO = total_ACCNO + lAccountValue;
//
//                if (hogl.getTRANID().equals(DDM_Constants.transaction_type_credit))
//                {
//                    total_CreditTrCount++;
//
//                    total_CreditAmount = total_CreditAmount + hogl.getIAMT();
//                }
//                else if (hogl.getTRANID().equals(DDM_Constants.transaction_type_debit))
//                {
//                    total_DebitTrCount++;
//                    total_DebitAmount = total_DebitAmount + hogl.getIAMT();
//                }
//
//                String hoglDataLine = hogl.getIBANKID() + hogl.getIBRANCH() + hogl.getIACCTNO() + hogl.getIAMT_Formatted() + hogl.getTRANID() + hogl.getTRID() + hogl.getBRCODE() + hogl.getVDATE() + hogl.getSessionNo() + "0" + hogl.getITRDATE();
//
//                hoglData.add(hoglDataLine);
//
//            }
//        }
//
//        Collection<HOGL_Report> col_IW_And_Inhouse = DAOFactory.getHOGL_ReportDAO().getIW_And_InhouseRecords(businessDate);
//
//        if (col_IW_And_Inhouse != null && col_IW_And_Inhouse.size() > 0)
//        {
//            if (hoglData == null)
//            {
//                hoglData = new ArrayList();
//            }
//
//            for (HOGL_Report hogl : col_IW_And_Inhouse)
//            {
//                long lAccountValue = 0;
//
//                try
//                {
//                    lAccountValue = Long.parseLong(hogl.getIACCTNO());
//                }
//                catch (Exception e)
//                {
//                    lAccountValue = 0;
//                }
//
//                total_ACCNO = total_ACCNO + lAccountValue;
//
//                if (hogl.getTRANID().equals(DDM_Constants.transaction_type_credit))
//                {
//                    total_CreditTrCount++;
//
//                    total_CreditAmount = total_CreditAmount + hogl.getIAMT();
//                }
//                else if (hogl.getTRANID().equals(DDM_Constants.transaction_type_debit))
//                {
//                    total_DebitTrCount++;
//                    total_DebitAmount = total_DebitAmount + hogl.getIAMT();
//                }
//
//                String hoglDataLine = hogl.getIBANKID() + hogl.getIBRANCH() + hogl.getIACCTNO() + hogl.getIAMT_Formatted() + hogl.getTRANID() + hogl.getTRID() + hogl.getBRCODE() + "0" + hogl.getITRDATE().substring(1) + hogl.getSessionNo() + hogl.getITRDATE();
//
//                hoglData.add(hoglDataLine);
//            }
//        }
//
//        Collection<HOGL_Report> col_CardCenter = DAOFactory.getHOGL_ReportDAO().getCardCenterRecords(businessDate);
//
//        if (col_CardCenter != null && col_CardCenter.size() > 0)
//        {
//            if (hoglData == null)
//            {
//                hoglData = new ArrayList();
//            }
//
//            for (HOGL_Report hogl : col_CardCenter)
//            {
//                long lAccountValue = 0;
//
//                try
//                {
//                    lAccountValue = Long.parseLong(hogl.getIACCTNO());
//                }
//                catch (Exception e)
//                {
//                    lAccountValue = 0;
//                }
//
//                total_ACCNO = total_ACCNO + lAccountValue;
//
//                if (hogl.getTRANID().equals(DDM_Constants.transaction_type_credit))
//                {
//                    total_CreditTrCount++;
//
//                    total_CreditAmount = total_CreditAmount + hogl.getIAMT();
//                }
//                else if (hogl.getTRANID().equals(DDM_Constants.transaction_type_debit))
//                {
//                    total_DebitTrCount++;
//                    total_DebitAmount = total_DebitAmount + hogl.getIAMT();
//                }
//
//                String hoglDataLine = hogl.getIBANKID() + hogl.getIBRANCH() + hogl.getIACCTNO() + hogl.getIAMT_Formatted() + hogl.getTRANID() + hogl.getTRID() + hogl.getBRCODE() + "0" + hogl.getITRDATE().substring(1) + hogl.getSessionNo() + "0" + hogl.getITRDATE();
//
//                hoglData.add(hoglDataLine);
//
//            }
//        }
//
//        /*
//           
//        Collection<HOGL_Report> col_HeadOffice = DAOFactory.getHOGL_ReportDAO().getHeadOfficeRecords(businessDate);
//
//        if (col_HeadOffice != null && col_HeadOffice.size() > 0)
//        {
//            if (hoglData == null)
//            {
//                hoglData = new ArrayList();
//            }
//
//            for (HOGL_Report hogl : col_HeadOffice)
//            {
//                long lAccountValue = 0;
//
//                try
//                {
//                    lAccountValue = Long.parseLong(hogl.getIACCTNO());
//                }
//                catch (Exception e)
//                {
//                    lAccountValue = 0;
//                }
//
//                total_ACCNO = total_ACCNO + lAccountValue;
//
//                if (hogl.getTRANID().equals(DDM_Constants.transaction_type_credit))
//                {
//                    total_CreditTrCount++;
//
//                    total_CreditAmount = total_CreditAmount + hogl.getIAMT();
//                }
//                else if (hogl.getTRANID().equals(DDM_Constants.transaction_type_debit))
//                {
//                    total_DebitTrCount++;
//                    total_DebitAmount = total_DebitAmount + hogl.getIAMT();
//                }
//
//                String hoglDataLine = hogl.getIBANKID() + hogl.getIBRANCH() + hogl.getIACCTNO() + hogl.getIAMT_Formatted() + hogl.getTRANID() + hogl.getTRID() + hogl.getBRCODE() + "0" + hogl.getREF() + "0" + hogl.getITRDATE();
//
//                hoglData.add(hoglDataLine);
//
//            }
//        }
//        
//         */
//        Collection<HOGL_Report> col_Cust1DSlipsFSlipsCustOut = DAOFactory.getHOGL_ReportDAO().getCust1DSlipsFSlipsCustOutRecords(businessDate);
//
//        if (col_Cust1DSlipsFSlipsCustOut != null && col_Cust1DSlipsFSlipsCustOut.size() > 0)
//        {
//            if (hoglData == null)
//            {
//                hoglData = new ArrayList();
//            }
//
//            for (HOGL_Report hogl : col_Cust1DSlipsFSlipsCustOut)
//            {
//                long lAccountValue = 0;
//
//                try
//                {
//                    lAccountValue = Long.parseLong(hogl.getIACCTNO());
//                }
//                catch (Exception e)
//                {
//                    lAccountValue = 0;
//                }
//
//                total_ACCNO = total_ACCNO + lAccountValue;
//
//                if (hogl.getTRANID().equals(DDM_Constants.transaction_type_credit))
//                {
//                    total_CreditTrCount++;
//
//                    total_CreditAmount = total_CreditAmount + hogl.getIAMT();
//                }
//                else if (hogl.getTRANID().equals(DDM_Constants.transaction_type_debit))
//                {
//                    total_DebitTrCount++;
//                    total_DebitAmount = total_DebitAmount + hogl.getIAMT();
//                }
//
//                String hoglDataLine = hogl.getIBANKID() + hogl.getIBRANCH() + hogl.getIACCTNO() + hogl.getIAMT_Formatted() + hogl.getTRANID() + hogl.getTRID() + hogl.getBRCODE() + "0" + hogl.getREF() + "0" + hogl.getITRDATE();
//
//                hoglData.add(hoglDataLine);
//
//            }
//        }
//
//        Collection<HOGL_Report> col_CoreReturn = DAOFactory.getHOGL_ReportDAO().getCoreReturnRecords(businessDate);
//
//        if (col_CoreReturn != null && col_CoreReturn.size() > 0)
//        {
//            if (hoglData == null)
//            {
//                hoglData = new ArrayList();
//            }
//
//            for (HOGL_Report hogl : col_CoreReturn)
//            {
//                long lAccountValue = 0;
//
//                try
//                {
//                    lAccountValue = Long.parseLong(hogl.getIACCTNO());
//                }
//                catch (Exception e)
//                {
//                    lAccountValue = 0;
//                }
//
//                total_ACCNO = total_ACCNO + lAccountValue;
//
//                if (hogl.getTRANID().equals(DDM_Constants.transaction_type_credit))
//                {
//                    total_CreditTrCount++;
//
//                    total_CreditAmount = total_CreditAmount + hogl.getIAMT();
//                }
//                else if (hogl.getTRANID().equals(DDM_Constants.transaction_type_debit))
//                {
//                    total_DebitTrCount++;
//                    total_DebitAmount = total_DebitAmount + hogl.getIAMT();
//                }
//
//                String hoglDataLine = hogl.getIBANKID() + hogl.getIBRANCH() + hogl.getIACCTNO() + hogl.getIAMT_Formatted() + hogl.getTRANID() + hogl.getTRID() + hogl.getBRCODE() + "0" + hogl.getREF() + "0" + hogl.getITRDATE();
//
//                hoglData.add(hoglDataLine);
//
//            }
//        }
//
//        Collection<HOGL_Report> col_SMS = DAOFactory.getHOGL_ReportDAO().getSMSRecords(businessDate);
//
//        if (col_SMS != null && col_SMS.size() > 0)
//        {
//            if (hoglData == null)
//            {
//                hoglData = new ArrayList();
//            }
//
//            for (HOGL_Report hogl : col_SMS)
//            {
//                long lAccountValue = 0;
//
//                try
//                {
//                    lAccountValue = Long.parseLong(hogl.getIACCTNO());
//                }
//                catch (Exception e)
//                {
//                    lAccountValue = 0;
//                }
//
//                total_ACCNO = total_ACCNO + lAccountValue;
//
//                if (hogl.getTRANID().equals(DDM_Constants.transaction_type_credit))
//                {
//                    total_CreditTrCount++;
//
//                    total_CreditAmount = total_CreditAmount + hogl.getIAMT();
//                }
//                else if (hogl.getTRANID().equals(DDM_Constants.transaction_type_debit))
//                {
//                    total_DebitTrCount++;
//                    total_DebitAmount = total_DebitAmount + hogl.getIAMT();
//                }
//
//                String hoglDataLine = hogl.getIBANKID() + hogl.getIBRANCH() + hogl.getIACCTNO() + hogl.getIAMT_Formatted() + hogl.getTRANID() + hogl.getTRID() + hogl.getBRCODE() + "0" + hogl.getREF() + "0" + hogl.getITRDATE();
//
//                hoglData.add(hoglDataLine);
//            }
//        }
//
//        Collection<HOGL_Report> col_DBank = DAOFactory.getHOGL_ReportDAO().getDBankINetRecords(businessDate);
//
//        if (col_DBank != null && col_DBank.size() > 0)
//        {
//            if (hoglData == null)
//            {
//                hoglData = new ArrayList();
//            }
//
//            for (HOGL_Report hogl : col_DBank)
//            {
//                long lAccountValue = 0;
//
//                try
//                {
//                    lAccountValue = Long.parseLong(hogl.getIACCTNO());
//                }
//                catch (Exception e)
//                {
//                    lAccountValue = 0;
//                }
//
//                total_ACCNO = total_ACCNO + lAccountValue;
//
//                if (hogl.getTRANID().equals(DDM_Constants.transaction_type_credit))
//                {
//                    total_CreditTrCount++;
//
//                    total_CreditAmount = total_CreditAmount + hogl.getIAMT();
//                }
//                else if (hogl.getTRANID().equals(DDM_Constants.transaction_type_debit))
//                {
//                    total_DebitTrCount++;
//                    total_DebitAmount = total_DebitAmount + hogl.getIAMT();
//                }
//
//                String hoglDataLine = hogl.getIBANKID() + hogl.getIBRANCH() + hogl.getIACCTNO() + hogl.getIAMT_Formatted() + hogl.getTRANID() + hogl.getTRID() + hogl.getBRCODE() + "0" + hogl.getREF() + "0" + hogl.getITRDATE();
//
//                hoglData.add(hoglDataLine);
//
//            }
//        }
//
//        Collection<HOGL_Report> col_AFT = DAOFactory.getHOGL_ReportDAO().getAFTRecords(businessDate);
//
//        if (col_AFT != null && col_AFT.size() > 0)
//        {
//            if (hoglData == null)
//            {
//                hoglData = new ArrayList();
//            }
//
//            for (HOGL_Report hogl : col_AFT)
//            {
//                long lAccountValue = 0;
//
//                try
//                {
//                    lAccountValue = Long.parseLong(hogl.getIACCTNO());
//                }
//                catch (Exception e)
//                {
//                    lAccountValue = 0;
//                }
//
//                total_ACCNO = total_ACCNO + lAccountValue;
//
//                if (hogl.getTRANID().equals(DDM_Constants.transaction_type_credit))
//                {
//                    total_CreditTrCount++;
//                    total_CreditAmount = total_CreditAmount + hogl.getIAMT();
//                }
//                else if (hogl.getTRANID().equals(DDM_Constants.transaction_type_debit))
//                {
//                    total_DebitTrCount++;
//                    total_DebitAmount = total_DebitAmount + hogl.getIAMT();
//                }
//
//                String hoglDataLine = hogl.getIBANKID() + hogl.getIBRANCH() + hogl.getIACCTNO() + hogl.getIAMT_Formatted() + hogl.getTRANID() + hogl.getTRID() + hogl.getBRCODE() + "0" + hogl.getREF() + "0" + hogl.getITRDATE();
//
//                hoglData.add(hoglDataLine);
//            }
//        }
//
//        DecimalFormat df1 = new DecimalFormat("000000000000000000000000");
//        String strTotalAccNo = df1.format(total_ACCNO);
//
//        DecimalFormat df2 = new DecimalFormat("00000000000000000000");
//        String strTotalDrAmount = df2.format(total_DebitAmount);
//        String strTotalCrAmount = df2.format(total_CreditAmount);
//
//        DecimalFormat df3 = new DecimalFormat("0000");
//        String strTotalDrTrCount = df3.format(total_DebitTrCount);
//        String strTotalCrTrCount = df3.format(total_CreditTrCount);
//
//        String headerData = strTotalAccNo + strTotalDrAmount + strTotalCrAmount + strTotalDrTrCount + strTotalCrTrCount;
//
//        boolean fileWriteStatus = true;
//
//        String hoglReportName = DDM_Constants.ddm_hogl_report_prefix + businessDate.substring(6) + businessDate.substring(4, 6) + businessDate.substring(0, 4) + DDM_Constants.ddm_hogl_report_suffix;
//
//        String reportFolderPath = PropertyLoader.getInstance().getReportCommonPath() + businessDate.replaceAll("-", "") + File.separator;
//
//        hoglReportPath = reportFolderPath + hoglReportName;
//
//        File fileReportFolderPath = new File(reportFolderPath);
//
//        if (!fileReportFolderPath.exists())
//        {
//            System.out.println("fileReportFolderPath not available and create the directory ------> " + reportFolderPath);
//
//            fileReportFolderPath.mkdirs();
//        }
//
//        File file_HOGL_Report = new File(hoglReportPath);
//
//        if (hoglData != null && hoglData.size() > 0)
//        {
//            FileWriter fw = null;
//            BufferedWriter bw = null;
//
//            try
//            {
//                if (!file_HOGL_Report.exists())
//                {
//                    if (file_HOGL_Report.createNewFile())
//                    {
//                        fw = new FileWriter(file_HOGL_Report, true);
//                        bw = new BufferedWriter(fw);
//
//                        bw.write(headerData);
//                        bw.newLine();
//
//                        for (String line : hoglData)
//                        {
//                            bw.write(line);
//                            bw.newLine();
//                        }
//
//                        bw.flush();
//                        fw.flush();
//                    }
//                    else
//                    {
//                        fileWriteStatus = false;
//                        msg = "Error While Creating New HOGL Report File! - (" + file_HOGL_Report.getAbsolutePath() + ")";
//                    }
//                }
//                else
//                {
//                    if (new FileManager().clean(file_HOGL_Report))
//                    {
//                        if (file_HOGL_Report.createNewFile())
//                        {
//                            fw = new FileWriter(file_HOGL_Report, true);
//                            bw = new BufferedWriter(fw);
//
//                            bw.write(headerData);
//                            bw.newLine();
//
//                            for (String line : hoglData)
//                            {
//                                bw.write(line);
//                                bw.newLine();
//                            }
//
//                            bw.flush();
//                            fw.flush();
//                        }
//                        else
//                        {
//                            fileWriteStatus = false;
//                            msg = "Error While Creating New HOGL Report File! - (" + file_HOGL_Report.getAbsolutePath() + ")";
//
//                        }
//                    }
//                    else
//                    {
//                        fileWriteStatus = false;
//                        msg = "Error While Deleting Existing the HOGL Report File! - (" + file_HOGL_Report.getAbsolutePath() + ")";
//                    }
//
//                }
//
//            }
//            catch (IOException e)
//            {
//                fileWriteStatus = false;
//                msg = "Error While Rewriting the HOGL Report File! - (" + e.getMessage() + ")";
//            }
//            finally
//            {
//                if (bw != null)
//                {
//                    try
//                    {
//                        bw.close();
//                    }
//                    catch (IOException e2)
//                    {
//                        System.out.println("Error (while close BufferedWriter) - " + e2.getMessage());
//                    }
//                }
//
//                if (fw != null)
//                {
//                    try
//                    {
//                        fw.close();
//                    }
//                    catch (IOException e2)
//                    {
//                        System.out.println("Error (while close FileWriter) - " + e2.getMessage());
//                    }
//                }
//            }
//        }
//        else
//        {
//            hoglReportPath = null;
//            msg = "No records available for PB Business Date - " + businessDate + " to genereate the HOGL Report!";
//        }
//
//        if (fileWriteStatus)
//        {
//            System.out.println("HOGL Report Successfully created ------> " + hoglReportPath);
//
//            if (DAOFactory.getReportDAO().addReportDetails(businessDate, session, DDM_Constants.default_bank_code, DDM_Constants.default_branch_code, DDM_Constants.default_coporate_customer_id, hoglReportName, hoglReportPath, DDM_Constants.report_type_hogl, generatedBy))
//            {
//
//            }
//            else
//            {
//                hoglReportPath = null;
//                msg = "Error Occured while adding to the genereated HOGL Report to the database table!";
//            }
//        }
//        else
//        {
//            msg = "Error Occured while genereating HOGL Report!";
//        }
//
//        return hoglReportPath;
//    }

    @Override
    public String generateFT_Reports(String businessDate, String session, String reportType, String reportName, String generatedBy)
    {

        String reportPath = null;
        String jasperFile = null;
        Connection con = null;
        HashMap hmParams = null;

        try
        {
            String reportFolderPath = PropertyLoader.getInstance().getReportCommonPath() + businessDate.replaceAll("-", "") + File.separator;

            System.out.println("generateFT_Reports: reportFolderPath ----> " + reportFolderPath);

            reportPath = reportFolderPath + reportName;

            System.out.println("generateFT_Reports: reportPath ----> " + reportPath);

            File fileReportFolderPath = new File(reportFolderPath);

            if (!fileReportFolderPath.exists())
            {
                System.out.println("fileReportFolderPath not available and create the directory ------> " + reportFolderPath);

                fileReportFolderPath.mkdirs();
            }

            File fReport = new File(reportPath);

            if (new FileManager().clean(fReport))
            {
                if (reportType != null)
                {
                    if (reportType.equals(DDM_Constants.report_type_iwd_ft_session))
                    {
                        jasperFile = PropertyLoader.getInstance().getJasperBasePath() + DDM_Constants.report_iwd_session_ft + DDM_Constants.file_ext_type_jasper;

                    }
                    else if (reportType.equals(DDM_Constants.report_type_iwd_ft_session_all))
                    {
                        jasperFile = PropertyLoader.getInstance().getJasperBasePath() + DDM_Constants.report_iwd_all_session_ft + DDM_Constants.file_ext_type_jasper;
                    }
                    else if (reportType.equals(DDM_Constants.report_type_owd_ft_session))
                    {
                        jasperFile = PropertyLoader.getInstance().getJasperBasePath() + DDM_Constants.report_owd_session_ft + DDM_Constants.file_ext_type_jasper;
                    }
                    else if (reportType.equals(DDM_Constants.report_type_owd_ft_session_all))
                    {
                        jasperFile = PropertyLoader.getInstance().getJasperBasePath() + DDM_Constants.report_owd_all_session_ft + DDM_Constants.file_ext_type_jasper;
                    }
                }

                System.out.println("generateFT_Reports: jasperFile ------> " + jasperFile);

                if (hmParams == null)
                {
                    hmParams = new HashMap();
                }

                hmParams.put("BUSINESS_DATE", businessDate.replaceAll("-", ""));
                hmParams.put("SESSION_ID", session);

                File logoImageFile = new File(PropertyLoader.getInstance().getReportLogoPath());

                if (logoImageFile.exists())
                {
                    hmParams.put("LOGO_PATH", logoImageFile.getAbsolutePath());
                }

                con = DBUtil.getInstance().getConnection();

                // Fill the report using an empty data source
                //System.out.println("jasperFile ----> " + jasperFile);
                System.out.println("generateFT_Reports:  hmParams ----> " + hmParams.size());

                JasperPrint print = JasperFillManager.fillReport(jasperFile, hmParams, con);

                System.out.println("generateFT_Reports:  JasperPrint print obj is ok ----> " + con);

                // Create a PDF exporter
                JRExporter exporter = new JRPdfExporter();

                System.out.println("generateFT_Reports:  JRExporter exporter obj creation is ok ----> ");

                // Configure the exporter (set output file name and print object)
                exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, reportPath);
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, print);

                System.out.println("generateFT_Reports:  exporter.setParameter is  ok ----> ");

                // Export the PDF file
                exporter.exportReport();

            }
            else
            {
                System.out.println("Error : Exsisting pdf report deletion failed ------> " + reportPath);
            }

        }
        catch (JRException e)
        {
            reportPath = null;
            System.out.println("JRException ---> " + e.getMessage());
        }
        catch (ClassNotFoundException | SQLException e)
        {
            reportPath = null;
            System.out.println("generateFT_Reports Error ---> " + e.getMessage());
        }
        finally
        {
            if (con != null)
            {
                DBUtil.getInstance().closeConnection(con);
            }
        }

        return reportPath;
    }

    @Override
    public String generateCustomerSummary_Reports(String businessDate, String session, String reportType, String reportName, String generatedBy)
    {

        String reportPath = null;
        String jasperFile = null;
        Connection con = null;
        HashMap hmParams = null;

        try
        {
            String reportFolderPath = PropertyLoader.getInstance().getReportCommonPath() + businessDate.replaceAll("-", "") + File.separator;

            System.out.println("generateCustomerSummary_Reports: reportFolderPath ----> " + reportFolderPath);

            reportPath = reportFolderPath + reportName;

            System.out.println("generateCustomerSummary_Reports: reportPath ----> " + reportPath);

            File fileReportFolderPath = new File(reportFolderPath);

            if (!fileReportFolderPath.exists())
            {
                System.out.println("fileReportFolderPath not available and create the directory ------> " + reportFolderPath);

                fileReportFolderPath.mkdirs();
            }

            File fReport = new File(reportPath);

            if (new FileManager().clean(fReport))
            {
                if (reportType != null)
                {
                    jasperFile = PropertyLoader.getInstance().getJasperBasePath() + DDM_Constants.report_customer_file_wise_session_summary + DDM_Constants.file_ext_type_jasper;
                }

                System.out.println("generateCustomerSummary_Reports: jasperFile ------> " + jasperFile);

                if (hmParams == null)
                {
                    hmParams = new HashMap();
                }

                hmParams.put("BUSINESS_DATE", businessDate.replaceAll("-", ""));
                hmParams.put("SESSION_ID", session);

                File logoImageFile = new File(PropertyLoader.getInstance().getReportLogoPath());

                if (logoImageFile.exists())
                {
                    hmParams.put("LOGO_PATH", logoImageFile.getAbsolutePath());
                }

                con = DBUtil.getInstance().getConnection();

                // Fill the report using an empty data source
                //System.out.println("jasperFile ----> " + jasperFile);
                System.out.println("generateCustomerSummary_Reports:  hmParams ----> " + hmParams.size());

                JasperPrint print = JasperFillManager.fillReport(jasperFile, hmParams, con);

                System.out.println("generateCustomerSummary_Reports:  JasperPrint print obj is ok ----> " + con);

                // Create a PDF exporter
                JRExporter exporter = new JRPdfExporter();

                System.out.println("generateCustomerSummary_Reports:  JRExporter exporter obj creation is ok ----> ");

                // Configure the exporter (set output file name and print object)
                exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, reportPath);
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, print);

                System.out.println("generateCustomerSummary_Reports:  exporter.setParameter is  ok ----> ");

                // Export the PDF file
                exporter.exportReport();

            }
            else
            {
                System.out.println("Error : Exsisting pdf report deletion failed ------> " + reportPath);
            }

        }
        catch (JRException e)
        {
            reportPath = null;
            System.out.println("JRException ---> " + e.getMessage());
        }
        catch (ClassNotFoundException | SQLException e)
        {
            reportPath = null;
            System.out.println("generateCustomerSummary_Reports Error ---> " + e.getMessage());
        }
        finally
        {
            if (con != null)
            {
                DBUtil.getInstance().closeConnection(con);
            }
        }

        return reportPath;
    }

    @Override
    public String generateCustomerSummary_Branch_Reports(String businessDate, String session, String branch, String reportType, String reportName, String generatedBy)
    {

        String reportPath = null;
        String jasperFile = null;
        Connection con = null;
        HashMap hmParams = null;

        try
        {
            String reportFolderPath = PropertyLoader.getInstance().getReportCommonPath() + businessDate.replaceAll("-", "") + File.separator;

            System.out.println("generateCustomerSummary_Branch_Reports: reportFolderPath ----> " + reportFolderPath);

            reportPath = reportFolderPath + reportName;

            System.out.println("generateCustomerSummary_Branch_Reports: reportPath ----> " + reportPath);

            File fileReportFolderPath = new File(reportFolderPath);

            if (!fileReportFolderPath.exists())
            {
                System.out.println("(generateCustomerSummary_Branch_Reports) fileReportFolderPath not available and create the directory ------> " + reportFolderPath);

                fileReportFolderPath.mkdirs();
            }

            File fReport = new File(reportPath);

            if (new FileManager().clean(fReport))
            {
                if (reportType != null)
                {
                    jasperFile = PropertyLoader.getInstance().getJasperBasePath() + DDM_Constants.report_customer_file_wise_session_wise_branch_summary + DDM_Constants.file_ext_type_jasper;
                }

                System.out.println("generateCustomerSummary_Branch_Reports: jasperFile ------> " + jasperFile);

                if (hmParams == null)
                {
                    hmParams = new HashMap();
                }

                hmParams.put("BUSINESS_DATE", businessDate.replaceAll("-", ""));
                hmParams.put("SESSION_ID", session);
                hmParams.put("BRANCH_CODE", branch);

                File logoImageFile = new File(PropertyLoader.getInstance().getReportLogoPath());

                if (logoImageFile.exists())
                {
                    hmParams.put("LOGO_PATH", logoImageFile.getAbsolutePath());
                }

                con = DBUtil.getInstance().getConnection();

                // Fill the report using an empty data source
                //System.out.println("jasperFile ----> " + jasperFile);
                System.out.println("generateCustomerSummary_Branch_Reports:  hmParams ----> " + hmParams.size());

                JasperPrint print = JasperFillManager.fillReport(jasperFile, hmParams, con);

                System.out.println("generateCustomerSummary_Branch_Reports:  JasperPrint print obj is ok ----> " + con);

                // Create a PDF exporter
                JRExporter exporter = new JRPdfExporter();

                System.out.println("generateCustomerSummary_Branch_Reports:  JRExporter exporter obj creation is ok ----> ");

                // Configure the exporter (set output file name and print object)
                exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, reportPath);
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, print);

                System.out.println("generateCustomerSummary_Branch_Reports:  exporter.setParameter is  ok ----> ");

                // Export the PDF file
                exporter.exportReport();

            }
            else
            {
                System.out.println("Error : Exsisting pdf report deletion failed ------> " + reportPath);
            }

        }
        catch (JRException e)
        {
            reportPath = null;
            System.out.println("(generateCustomerSummary_Branch_Reports) JRException ---> " + e.getMessage());
        }
        catch (ClassNotFoundException | SQLException e)
        {
            reportPath = null;
            System.out.println("generateCustomerSummary_Branch_Reports Error ---> " + e.getMessage());
        }
        finally
        {
            if (con != null)
            {
                DBUtil.getInstance().closeConnection(con);
            }
        }

        return reportPath;
    }

    @Override
    public String generateCustomerSummary_CoCu_Reports(String businessDate, String session, String branch, String cocuid, String reportType, String reportName, String generatedBy)
    {

        String reportPath = null;
        String jasperFile = null;
        Connection con = null;
        HashMap hmParams = null;

        try
        {
            String reportFolderPath = PropertyLoader.getInstance().getReportCommonPath() + businessDate.replaceAll("-", "") + File.separator;

            System.out.println("generateCustomerSummary_CoCu_Reports: reportFolderPath ----> " + reportFolderPath);

            reportPath = reportFolderPath + reportName;

            System.out.println("generateCustomerSummary_CoCu_Reports: reportPath ----> " + reportPath);

            File fileReportFolderPath = new File(reportFolderPath);

            if (!fileReportFolderPath.exists())
            {
                System.out.println("(generateCustomerSummary_CoCu_Reports)fileReportFolderPath not available and create the directory ------> " + reportFolderPath);

                fileReportFolderPath.mkdirs();
            }

            File fReport = new File(reportPath);

            if (new FileManager().clean(fReport))
            {
                if (reportType != null)
                {
                    //jasperFile = PropertyLoader.getInstance().getJasperBasePath() + DDM_Constants.report_customer_file_wise_session_wise_cocu_summary + DDM_Constants.file_ext_type_jasper;
                }

                System.out.println("generateCustomerSummary_CoCu_Reports: jasperFile ------> " + jasperFile);

                if (hmParams == null)
                {
                    hmParams = new HashMap();
                }

                hmParams.put("BUSINESS_DATE", businessDate.replaceAll("-", ""));
                hmParams.put("SESSION_ID", session);
                hmParams.put("BRANCH_CODE", branch);
                hmParams.put("COCU_ID", cocuid);

                File logoImageFile = new File(PropertyLoader.getInstance().getReportLogoPath());

                if (logoImageFile.exists())
                {
                    hmParams.put("LOGO_PATH", logoImageFile.getAbsolutePath());
                }

                con = DBUtil.getInstance().getConnection();

                // Fill the report using an empty data source
                //System.out.println("jasperFile ----> " + jasperFile);
                System.out.println("generateCustomerSummary_CoCu_Reports:  hmParams ----> " + hmParams.size());

                JasperPrint print = JasperFillManager.fillReport(jasperFile, hmParams, con);

                System.out.println("generateCustomerSummary_CoCu_Reports:  JasperPrint print obj is ok ----> " + con);

                // Create a PDF exporter
                JRExporter exporter = new JRPdfExporter();

                System.out.println("generateCustomerSummary_CoCu_Reports:  JRExporter exporter obj creation is ok ----> ");

                // Configure the exporter (set output file name and print object)
                exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, reportPath);
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, print);

                System.out.println("generateCustomerSummary_CoCu_Reports:  exporter.setParameter is  ok ----> ");

                // Export the PDF file
                exporter.exportReport();

            }
            else
            {
                System.out.println("Error : Exsisting pdf report deletion failed ------> " + reportPath);
            }

        }
        catch (JRException e)
        {
            reportPath = null;
            System.out.println("(generateCustomerSummary_CoCu_Reports)JRException ---> " + e.getMessage());
        }
        catch (ClassNotFoundException | SQLException e)
        {
            reportPath = null;
            System.out.println("generateCustomerSummary_CoCu_Reports Error ---> " + e.getMessage());
        }
        finally
        {
            if (con != null)
            {
                DBUtil.getInstance().closeConnection(con);
            }
        }

        return reportPath;
    }    

    @Override
    public String generateInhouseBranchSummary(String businessDate, String session, String reportType, String fileId, String generatedBy)
    {

        String reportPath = null;
        String reportName = null;
        String jasperFile = null;
        HashMap hmParams = null;

        Connection con = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            String reportFolderPath = PropertyLoader.getInstance().getReportCommonPath() + businessDate.replaceAll("-", "") + File.separator;

            System.out.println("generateInhouseBranchSummary: reportFolderPath ----> " + reportFolderPath);

            File fileReportFolderPath = new File(reportFolderPath);

            if (!fileReportFolderPath.exists())
            {
                System.out.println("generateInhouseBranchSummary:fileReportFolderPath not available and create the directory ------> " + reportFolderPath);

                fileReportFolderPath.mkdirs();
            }

            reportName = fileId.replaceAll(DDM_Constants.ddm_ibt_file_suffix, "") + "_" + DDM_Constants.report_ih_branch_summary + DDM_Constants.file_ext_type_pdf;

            System.out.println("generateInhouseBranchSummary:reportName ------> " + reportName);

            reportPath = reportFolderPath + reportName;

            System.out.println("generateInhouseBranchSummary: reportPath ----> " + reportPath);

            File fReport = new File(reportPath);

            if (new FileManager().clean(fReport))
            {
                if (reportType != null)
                {
                    jasperFile = PropertyLoader.getInstance().getJasperBasePath() + DDM_Constants.report_ih_branch_summary + DDM_Constants.file_ext_type_jasper;

                    System.out.println("generateInhouseBranchSummary: jasperFile ------> " + jasperFile);

                    if (hmParams == null)
                    {
                        hmParams = new HashMap();
                    }

                    hmParams.put("BUSINESS_DATE", businessDate.replaceAll("-", ""));
                    hmParams.put("SESSION_ID", session);
                    hmParams.put("IBT_FILE_ID", fileId);

                    String curDate = DAOFactory.getCustomDAO().getCurrentDate().replaceAll("-", "");

                    hmParams.put("CURRENT_DATE", curDate);

                    File logoImageFile = new File(PropertyLoader.getInstance().getReportLogoPath());

                    if (logoImageFile.exists())
                    {
                        hmParams.put("LOGO_PATH", logoImageFile.getAbsolutePath());
                    }

                    // Fill the report using an empty data source
                    //System.out.println("jasperFile ----> " + jasperFile);
                    System.out.println("generateInhouseBranchSummary:  hmParams ----> " + hmParams.size());

                    JasperPrint print = JasperFillManager.fillReport(jasperFile, hmParams, con);

                    System.out.println("generateInhouseBranchSummary:  JasperPrint print obj is ok ----> " + con);

                    // Create a PDF exporter
                    JRExporter exporter = new JRPdfExporter();

                    System.out.println("generateInhouseBranchSummary:  JRExporter exporter obj creation is ok ----> ");

                    // Configure the exporter (set output file name and print object)
                    exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, reportPath);
                    exporter.setParameter(JRExporterParameter.JASPER_PRINT, print);

                    System.out.println("generateInhouseBranchSummary:  exporter.setParameter is  ok ----> ");

                    // Export the PDF file
                    exporter.exportReport();

                    if (reportPath != null)
                    {
                        DAOFactory.getReportDAO().addReportDetails(businessDate.replaceAll("-", ""), session, DDM_Constants.default_bank_code, DDM_Constants.default_branch_code, DDM_Constants.default_coporate_customer_id, reportName, reportPath, reportType, generatedBy);
                    }
                    else
                    {
                        System.out.println("generateInhouseBranchSummary : Error while generating report ------> " + reportPath);
                    }
                }
            }
            else
            {
                reportPath = null;
                System.out.println("generateInhouseBranchSummary : Error ---> Exsisting pdf report deletion failed ------> " + reportPath);

            }
        }
        catch (JRException e)
        {
            reportPath = null;
            System.out.println("generateInhouseBranchSummary:JRException ---> " + e.getMessage());
        }
        catch (Exception e)
        {
            reportPath = null;
            System.out.println("generateInhouseBranchSummary:Error ---> " + e.getMessage());
        }
        finally
        {
            if (con != null)
            {
                DBUtil.getInstance().closeConnection(con);
            }
        }

        return reportPath;
    }

    @Override
    public String generateOutwardBranchSummary(String businessDate, String session, String reportType, String fileId, String generatedBy)
    {

        String reportPath = null;
        String reportName = null;
        String jasperFile = null;
        HashMap hmParams = null;

        Connection con = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            String reportFolderPath = PropertyLoader.getInstance().getReportCommonPath() + businessDate.replaceAll("-", "") + File.separator;

            System.out.println("generateOutwardBranchSummary: reportFolderPath ----> " + reportFolderPath);

            File fileReportFolderPath = new File(reportFolderPath);

            if (!fileReportFolderPath.exists())
            {
                System.out.println("generateOutwardBranchSummary: fileReportFolderPath not available and create the directory ------> " + reportFolderPath);

                fileReportFolderPath.mkdirs();
            }

            reportName = fileId + "_" + DDM_Constants.report_ow_branch_summary + DDM_Constants.file_ext_type_pdf;

            System.out.println("generateOutwardBranchSummary: reportName ------> " + reportName);

            reportPath = reportFolderPath + reportName;

            System.out.println("generateOutwardBranchSummary: reportPath ----> " + reportPath);

            File fReport = new File(reportPath);

            if (new FileManager().clean(fReport))
            {
                if (reportType != null)
                {
                    jasperFile = PropertyLoader.getInstance().getJasperBasePath() + DDM_Constants.report_ow_branch_summary + DDM_Constants.file_ext_type_jasper;

                    System.out.println("generateOutwardBranchSummary: jasperFile ------> " + jasperFile);

                    if (hmParams == null)
                    {
                        hmParams = new HashMap();
                    }

                    hmParams.put("BUSINESS_DATE", businessDate.replaceAll("-", ""));
                    hmParams.put("SESSION_ID", session);
                    hmParams.put("OW_FILE_ID", fileId);

                    String curDate = DAOFactory.getCustomDAO().getCurrentDate().replaceAll("-", "");

                    hmParams.put("CURRENT_DATE", curDate);

                    File logoImageFile = new File(PropertyLoader.getInstance().getReportLogoPath());

                    if (logoImageFile.exists())
                    {
                        hmParams.put("LOGO_PATH", logoImageFile.getAbsolutePath());
                    }

                    // Fill the report using an empty data source
                    //System.out.println("jasperFile ----> " + jasperFile);
                    System.out.println("generateOutwardBranchSummary:  hmParams ----> " + hmParams.size());

                    JasperPrint print = JasperFillManager.fillReport(jasperFile, hmParams, con);

                    System.out.println("generateOutwardBranchSummary:  JasperPrint print obj is ok ----> " + con);

                    // Create a PDF exporter
                    JRExporter exporter = new JRPdfExporter();

                    System.out.println("generateOutwardBranchSummary:  JRExporter exporter obj creation is ok ----> ");

                    // Configure the exporter (set output file name and print object)
                    exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, reportPath);
                    exporter.setParameter(JRExporterParameter.JASPER_PRINT, print);

                    System.out.println("generateOutwardBranchSummary:  exporter.setParameter is  ok ----> ");

                    // Export the PDF file
                    exporter.exportReport();

                    if (reportPath != null)
                    {
                        DAOFactory.getReportDAO().addReportDetails(businessDate.replaceAll("-", ""), session, DDM_Constants.default_bank_code, DDM_Constants.default_branch_code, DDM_Constants.default_coporate_customer_id, reportName, reportPath, reportType, generatedBy);
                    }
                    else
                    {
                        System.out.println("generateOutwardBranchSummary : Error while generating report ------> " + reportPath);
                    }
                }
            }
            else
            {
                reportPath = null;
                System.out.println("generateOutwardBranchSummary : Error ---> Exsisting pdf report deletion failed ------> " + reportPath);

            }
        }
        catch (JRException e)
        {
            reportPath = null;
            System.out.println("generateOutwardBranchSummary: JRException ---> " + e.getMessage());
        }
        catch (Exception e)
        {
            reportPath = null;
            System.out.println("generateOutwardBranchSummary: Error ---> " + e.getMessage());
        }
        finally
        {
            if (con != null)
            {
                DBUtil.getInstance().closeConnection(con);
            }
        }

        return reportPath;
    }

}
