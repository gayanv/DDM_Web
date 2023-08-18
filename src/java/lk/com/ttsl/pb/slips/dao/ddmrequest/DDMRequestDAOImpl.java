/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.ddmrequest;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class DDMRequestDAOImpl implements DDMRequestDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public DDMRequest getDDARequestDetails(String ddaRequestId)
    {
        DDMRequest cbr = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (ddaRequestId == null)
        {
            System.out.println("WARNING : Null ddaRequestId parameter.");
            return cbr;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.StatusModify, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "ddmr.TerminationRequestRemarks, ddmr.TerminationRequestedBy, ddmr.TerminationRequestedOn, "
                    + "ddmr.TerminationApprovalRemarks, ddmr.TerminationApprovedBy, ddmr.TerminationApprovedOn ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");
            sbQuery.append("AND ddmr.DDAID = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getDDARequestDetails) ---> " + sbQuery.toString());

            pstm.setString(1, ddaRequestId);

            rs = pstm.executeQuery();

            cbr = DDMRequestUtil.makeDDMRequestObject(rs);

            //System.out.println("col.size() --> " + col.size());
            if (cbr == null)
            {
                msg = DDM_Constants.msg_no_records;
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

        return cbr;
    }

    @Override
    public Collection<DDMRequest> getDDARequestDetails(String merchantId, String issuingBankCode, String issuingBranchCode, String acquiringBankCode, String acquiringBranchCode, String status, String fromRequestDate, String toRequestDate)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantId == null)
        {
            System.out.println("WARNING : Null merchantId parameter.");
            return col;
        }
        if (issuingBankCode == null)
        {
            System.out.println("WARNING : Null issuingBankCode parameter.");
            return col;
        }
        if (issuingBranchCode == null)
        {
            System.out.println("WARNING : Null issuingBranchCode parameter.");
            return col;
        }
        if (acquiringBankCode == null)
        {
            System.out.println("WARNING : Null aquiringBankCode parameter.");
            return col;
        }
        if (acquiringBranchCode == null)
        {
            System.out.println("WARNING : Null aquiringBranchCode parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }
        if (fromRequestDate == null)
        {
            System.out.println("WARNING : Null fromRequestDate parameter.");
            return col;
        }
        if (toRequestDate == null)
        {
            System.out.println("WARNING : Null toRequestDate parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_merchantID = 1;
            int val_issuingBK = 2;
            int val_issuingBR = 3;
            int val_acquiringBK = 4;
            int val_acquiringBR = 5;
            int val_status = 6;
            int val_fromRequestDate = 7;
            int val_toRequestDate = 8;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.StatusModify, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "ddmr.TerminationRequestRemarks, ddmr.TerminationRequestedBy, ddmr.TerminationRequestedOn, "
                    + "ddmr.TerminationApprovalRemarks, ddmr.TerminationApprovedBy, ddmr.TerminationApprovedOn ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");

            if (!merchantId.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.MerchantID = ? ");
                vt.add(val_merchantID);
            }

            if (!issuingBankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBank = ? ");
                vt.add(val_issuingBK);
            }

            if (!issuingBranchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBranch = ? ");
                vt.add(val_issuingBR);
            }

            if (!acquiringBankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBank = ? ");
                vt.add(val_acquiringBK);
            }

            if (!acquiringBranchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBranch = ? ");
                vt.add(val_acquiringBR);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.Status = ? ");
                vt.add(val_status);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append(" order by DDAID ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getDDARequestDetails) 1 ---> " + sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantId);
                    i++;
                }
                if (val_item == val_issuingBK)
                {
                    pstm.setString(i, issuingBankCode);
                    i++;
                }
                if (val_item == val_issuingBR)
                {
                    pstm.setString(i, issuingBranchCode);
                    i++;
                }
                if (val_item == val_acquiringBK)
                {
                    pstm.setString(i, acquiringBankCode);
                    i++;
                }
                if (val_item == val_acquiringBR)
                {
                    pstm.setString(i, acquiringBranchCode);
                    i++;
                }
                if (val_item == val_status)
                {
                    pstm.setString(i, status);
                    i++;
                }
                if (val_item == val_fromRequestDate)
                {
                    pstm.setString(i, fromRequestDate);
                    i++;
                }

                if (val_item == val_toRequestDate)
                {
                    pstm.setString(i, toRequestDate);
                    i++;
                }

            }

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeDDMRequestObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getDDARequestDetails(String merchantId, String issuingBankCode, String issuingBranchCode, String issuningAcountNo, String issuningAcountName, String acquiringBankCode, String acquiringBranchCode, String aquiringAccountNo, String aquiringAccountName, String status, String fromRequestDate, String toRequestDate)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantId == null)
        {
            System.out.println("WARNING : Null merchantId parameter.");
            return col;
        }
        if (issuingBankCode == null)
        {
            System.out.println("WARNING : Null issuingBankCode parameter.");
            return col;
        }
        if (issuingBranchCode == null)
        {
            System.out.println("WARNING : Null issuingBranchCode parameter.");
            return col;
        }
        if (acquiringBankCode == null)
        {
            System.out.println("WARNING : Null aquiringBankCode parameter.");
            return col;
        }
        if (acquiringBranchCode == null)
        {
            System.out.println("WARNING : Null aquiringBranchCode parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }
        if (fromRequestDate == null)
        {
            System.out.println("WARNING : Null fromRequestDate parameter.");
            return col;
        }
        if (toRequestDate == null)
        {
            System.out.println("WARNING : Null toRequestDate parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_merchantID = 1;
            int val_issuingBK = 2;
            int val_issuingBR = 3;
            int val_acquiringBK = 4;
            int val_acquiringBR = 5;
            int val_status = 6;
            int val_fromRequestDate = 7;
            int val_toRequestDate = 8;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.StatusModify, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "ddmr.TerminationRequestRemarks, ddmr.TerminationRequestedBy, ddmr.TerminationRequestedOn, "
                    + "ddmr.TerminationApprovalRemarks, ddmr.TerminationApprovedBy, ddmr.TerminationApprovedOn ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");

            if (!merchantId.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.MerchantID = ? ");
                vt.add(val_merchantID);
            }

            if (!issuingBankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBank = ? ");
                vt.add(val_issuingBK);
            }

            if (!issuingBranchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBranch = ? ");
                vt.add(val_issuingBR);
            }

            if (!acquiringBankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBank = ? ");
                vt.add(val_acquiringBK);
            }

            if (!acquiringBranchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBranch = ? ");
                vt.add(val_acquiringBR);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.Status = ? ");
                vt.add(val_status);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append(" order by DDAID ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getDDARequestDetails) 2 ---> " + sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantId);
                    i++;
                }
                if (val_item == val_issuingBK)
                {
                    pstm.setString(i, issuingBankCode);
                    i++;
                }
                if (val_item == val_issuingBR)
                {
                    pstm.setString(i, issuingBranchCode);
                    i++;
                }
                if (val_item == val_acquiringBK)
                {
                    pstm.setString(i, acquiringBankCode);
                    i++;
                }
                if (val_item == val_acquiringBR)
                {
                    pstm.setString(i, acquiringBranchCode);
                    i++;
                }
                if (val_item == val_status)
                {
                    pstm.setString(i, status);
                    i++;
                }
                if (val_item == val_fromRequestDate)
                {
                    pstm.setString(i, fromRequestDate);
                    i++;
                }

                if (val_item == val_toRequestDate)
                {
                    pstm.setString(i, toRequestDate);
                    i++;
                }

            }

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeDDMRequestObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getDDARequestDetailsForIssuingBankApproval(String issuingBank)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (issuingBank == null)
        {
            System.out.println("WARNING : Null issuingBank parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.StatusModify, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "ddmr.TerminationRequestRemarks, ddmr.TerminationRequestedBy, ddmr.TerminationRequestedOn, "
                    + "ddmr.TerminationApprovalRemarks, ddmr.TerminationApprovedBy, ddmr.TerminationApprovedOn ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");
            sbQuery.append("AND ddmr.IssuningBank = ? ");
            sbQuery.append("AND ddmr.Status = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getDDARequestDetailsForIssuingBankApproval) ---> " + sbQuery.toString());

            pstm.setString(1, issuingBank);
            pstm.setString(2, DDM_Constants.ddm_request_status_02);

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeDDMRequestObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getDDARequestDetailsForIssuingBankApproval(String issuingBank, String issuingBranch, String acquiringBank, String acquiringBranch, String merchantID)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (issuingBank == null)
        {
            System.out.println("WARNING : Null issuingBankCode parameter.");
            return col;
        }

        if (issuingBranch == null)
        {
            System.out.println("WARNING : Null issuingBranch parameter.");
            return col;
        }

        if (acquiringBank == null)
        {
            System.out.println("WARNING : Null acquiringBank parameter.");
            return col;
        }

        if (acquiringBranch == null)
        {
            System.out.println("WARNING : Null acquiringBranch parameter.");
            return col;
        }

        if (merchantID == null)
        {
            System.out.println("WARNING : Null merchantID parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_issuingBK = 1;
            int val_issuingBR = 2;
            int val_acquiringBK = 3;
            int val_acquiringBR = 4;
            int val_merchantID = 5;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.StatusModify, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "ddmr.TerminationRequestRemarks, ddmr.TerminationRequestedBy, ddmr.TerminationRequestedOn, "
                    + "ddmr.TerminationApprovalRemarks, ddmr.TerminationApprovedBy, ddmr.TerminationApprovedOn ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");
            sbQuery.append("AND ddmr.Status = ? ");

            if (!issuingBank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBank = ? ");
                vt.add(val_issuingBK);
            }
            if (!issuingBranch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBranch = ? ");
                vt.add(val_issuingBR);
            }

            if (!acquiringBank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBank = ? ");
                vt.add(val_acquiringBK);
            }

            if (!acquiringBranch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBranch = ? ");
                vt.add(val_acquiringBR);
            }

            if (!merchantID.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.MerchantID = ? ");
                vt.add(val_merchantID);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getDDARequestDetailsForIssuingBankApproval) ---> " + sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.ddm_request_status_02);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_issuingBK)
                {
                    pstm.setString(i, issuingBank);
                    i++;
                }
                if (val_item == val_issuingBR)
                {
                    pstm.setString(i, issuingBranch);
                    i++;
                }
                if (val_item == val_acquiringBK)
                {
                    pstm.setString(i, acquiringBank);
                    i++;
                }
                if (val_item == val_acquiringBR)
                {
                    pstm.setString(i, acquiringBranch);
                    i++;
                }
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantID);
                    i++;
                }

            }

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeDDMRequestObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getDDARequestDetailsForAcquiringBankApproval(String acquiringBankCode)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (acquiringBankCode == null)
        {
            System.out.println("WARNING : Null acquiringBankCode parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.StatusModify, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "ddmr.TerminationRequestRemarks, ddmr.TerminationRequestedBy, ddmr.TerminationRequestedOn, "
                    + "ddmr.TerminationApprovalRemarks, ddmr.TerminationApprovedBy, ddmr.TerminationApprovedOn ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");
            sbQuery.append("AND ddmr.AquiringBank = ? ");
            sbQuery.append("AND ddmr.Status = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getDDARequestDetailsForAquiringBankApproval) ---> " + sbQuery.toString());

            pstm.setString(1, acquiringBankCode);
            pstm.setString(2, DDM_Constants.ddm_request_status_04);

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeDDMRequestObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getDDARequestDetailsForAcquiringBankApproval(String acquiringBank, String acquiringBranch, String issuingBank, String issuingBranch, String merchantID)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (acquiringBank == null)
        {
            System.out.println("WARNING : Null acquiringBank parameter.");
            return col;
        }

        if (acquiringBranch == null)
        {
            System.out.println("WARNING : Null acquiringBranch parameter.");
            return col;
        }

        if (issuingBank == null)
        {
            System.out.println("WARNING : Null issuingBankCode parameter.");
            return col;
        }

        if (issuingBranch == null)
        {
            System.out.println("WARNING : Null issuingBranch parameter.");
            return col;
        }

        if (merchantID == null)
        {
            System.out.println("WARNING : Null merchantID parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_acquiringBK = 1;
            int val_acquiringBR = 2;
            int val_issuingBK = 3;
            int val_issuingBR = 4;
            int val_merchantID = 5;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.StatusModify, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "ddmr.TerminationRequestRemarks, ddmr.TerminationRequestedBy, ddmr.TerminationRequestedOn, "
                    + "ddmr.TerminationApprovalRemarks, ddmr.TerminationApprovedBy, ddmr.TerminationApprovedOn ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");

            sbQuery.append("AND ddmr.Status = ? ");

            if (!acquiringBank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBank = ? ");
                vt.add(val_acquiringBK);
            }

            if (!acquiringBranch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBranch = ? ");
                vt.add(val_acquiringBR);
            }

            if (!issuingBank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBank = ? ");
                vt.add(val_issuingBK);
            }
            if (!issuingBranch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBranch = ? ");
                vt.add(val_issuingBR);
            }

            if (!merchantID.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.MerchantID = ? ");
                vt.add(val_merchantID);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getDDARequestDetailsForAquiringBankApproval) ---> " + sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.ddm_request_status_04);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_acquiringBK)
                {
                    pstm.setString(i, acquiringBank);
                    i++;
                }
                if (val_item == val_acquiringBR)
                {
                    pstm.setString(i, acquiringBranch);
                    i++;
                }
                if (val_item == val_issuingBK)
                {
                    pstm.setString(i, issuingBank);
                    i++;
                }
                if (val_item == val_issuingBR)
                {
                    pstm.setString(i, issuingBranch);
                    i++;
                }
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantID);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeDDMRequestObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getDDARequestDetailsForDDAReqTerminationApproval()
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.StatusModify, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "ddmr.TerminationRequestRemarks, ddmr.TerminationRequestedBy, ddmr.TerminationRequestedOn, "
                    + "ddmr.TerminationApprovalRemarks, ddmr.TerminationApprovedBy, ddmr.TerminationApprovedOn ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");
            sbQuery.append("AND ddmr.StatusModify = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getDDARequestDetailsForDDAReqTerminationApproval) ---> " + sbQuery.toString());

            pstm.setString(1, DDM_Constants.ddm_request_status_08);

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeDDMRequestObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getDDARequestDetailsForDDAReqTerminationApproval(String acquiringBank, String acquiringBranch, String issuingBank, String issuingBranch, String merchantID)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (acquiringBank == null)
        {
            System.out.println("WARNING : Null acquiringBank parameter.");
            return col;
        }

        if (acquiringBranch == null)
        {
            System.out.println("WARNING : Null acquiringBranch parameter.");
            return col;
        }

        if (issuingBank == null)
        {
            System.out.println("WARNING : Null issuingBankCode parameter.");
            return col;
        }

        if (issuingBranch == null)
        {
            System.out.println("WARNING : Null issuingBranch parameter.");
            return col;
        }

        if (merchantID == null)
        {
            System.out.println("WARNING : Null merchantID parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_acquiringBK = 1;
            int val_acquiringBR = 2;
            int val_issuingBK = 3;
            int val_issuingBR = 4;
            int val_merchantID = 5;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.StatusModify, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "ddmr.TerminationRequestRemarks, ddmr.TerminationRequestedBy, ddmr.TerminationRequestedOn, "
                    + "ddmr.TerminationApprovalRemarks, ddmr.TerminationApprovedBy, ddmr.TerminationApprovedOn ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");

            sbQuery.append("AND ddmr.Status = ? ");

            if (!acquiringBank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBank = ? ");
                vt.add(val_acquiringBK);
            }

            if (!acquiringBranch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBranch = ? ");
                vt.add(val_acquiringBR);
            }

            if (!issuingBank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBank = ? ");
                vt.add(val_issuingBK);
            }
            if (!issuingBranch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBranch = ? ");
                vt.add(val_issuingBR);
            }

            if (!merchantID.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.MerchantID = ? ");
                vt.add(val_merchantID);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getDDARequestDetailsForAquiringBankApproval) ---> " + sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.ddm_request_status_04);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_acquiringBK)
                {
                    pstm.setString(i, acquiringBank);
                    i++;
                }
                if (val_item == val_acquiringBR)
                {
                    pstm.setString(i, acquiringBranch);
                    i++;
                }
                if (val_item == val_issuingBK)
                {
                    pstm.setString(i, issuingBank);
                    i++;
                }
                if (val_item == val_issuingBR)
                {
                    pstm.setString(i, issuingBranch);
                    i++;
                }
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantID);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeDDMRequestObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getDDAReqSummaryByMerchant(String merchantId, String bank, String fromRequestDate, String toRequestDate)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantId == null)
        {
            System.out.println("WARNING : Null merchantId parameter.");
            return col;
        }

        if (bank == null)
        {
            System.out.println("WARNING : Null bank parameter.");
            return col;
        }

        if (fromRequestDate == null)
        {
            System.out.println("WARNING : Null fromRequestDate parameter.");
            return col;
        }

        if (toRequestDate == null)
        {
            System.out.println("WARNING : Null toRequestDate parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_status_1 = 1;
            int val_status_2 = 2;
            int val_status_3 = 3;
            int val_status_4 = 4;
            int val_status_5 = 5;
            int val_status_6 = 6;
            int val_status_7 = 7;
            int val_status_9 = 8;
            int val_status_11 = 9;
            int val_status_12 = 10;
            int val_status_14 = 11;
            int val_status_15 = 12;
            int val_bank = 13;
            int val_fromRequestDate = 14;
            int val_toRequestDate = 15;
            int val_merchantID = 16;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select tb1.MerchantID, tb1.MerchantName, sum(tb1.OngoingReqCount) as OnReqCount, "
                    + "sum(tb1.CompletedReqCount) as CmpReqCount, sum(tb1.RejectedReqCount) as RejReqCount, "
                    + "sum(tb1.SLABreachedReqCount) as SLABReqCount, sum(tb1.TerminatedReqCount) as TerReqCount ");
            sbQuery.append("FROM (");

            // Ongoing ddm request count
            sbQuery.append("SELECT ddmr.MerchantID, mer.MerchantName, count(ddmr.DDAID) as OngoingReqCount, 0 as CompletedReqCount, 0 as RejectedReqCount, 0 as SLABreachedReqCount, 0 as TerminatedReqCount ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mer ");
            sbQuery.append("WHERE ddmr.MerchantID = mer.MerchantID ");
            sbQuery.append("and ddmr.Status in(?,?,?,?) ");
            vt.add(val_status_1);
            vt.add(val_status_2);
            vt.add(val_status_3);
            vt.add(val_status_4);

            if (!bank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND (ddmr.IssuningBank = ? OR ddmr.AquiringBank = ?) ");
                vt.add(val_bank);
                vt.add(val_bank);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append("group by ddmr.MerchantID ");

            // Completed ddm request count
            sbQuery.append("union all ");
            sbQuery.append("SELECT ddmr.MerchantID, mer.MerchantName, 0 as OngoingReqCount, count(ddmr.DDAID) as CompletedReqCount, 0 as RejectedReqCount, 0 as SLABreachedReqCount, 0 as TerminatedReqCount ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mer ");
            sbQuery.append("WHERE ddmr.MerchantID = mer.MerchantID ");
            sbQuery.append("and ddmr.Status in(?) ");
            vt.add(val_status_5);

            if (!bank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND (ddmr.IssuningBank = ? OR ddmr.AquiringBank = ?) ");
                vt.add(val_bank);
                vt.add(val_bank);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append("group by ddmr.MerchantID ");

            // Rejected ddm request count
            sbQuery.append("union all ");
            sbQuery.append("SELECT ddmr.MerchantID, mer.MerchantName, 0 as OngoingReqCount, 0 as CompletedReqCount, count(ddmr.DDAID) as RejectedReqCount, 0 as SLABreachedReqCount, 0 as TerminatedReqCount ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mer ");
            sbQuery.append("WHERE ddmr.MerchantID = mer.MerchantID ");
            sbQuery.append("and ddmr.Status in(?,?,?,?) ");
            vt.add(val_status_6);
            vt.add(val_status_7);
            vt.add(val_status_11);
            vt.add(val_status_12);

            if (!bank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND (ddmr.IssuningBank = ? OR ddmr.AquiringBank = ?) ");
                vt.add(val_bank);
                vt.add(val_bank);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append("group by ddmr.MerchantID ");

            // SLA Breached ddm request count            
            sbQuery.append("union all ");
            sbQuery.append("SELECT ddmr.MerchantID, mer.MerchantName, 0 as OngoingReqCount, 0 as CompletedReqCount, 0 as RejectedReqCount, count(ddmr.DDAID) as SLABreachedReqCount, 0 as TerminatedReqCount ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mer ");
            sbQuery.append("WHERE ddmr.MerchantID = mer.MerchantID ");
            sbQuery.append("and ddmr.Status in(?,?) ");
            vt.add(val_status_14);
            vt.add(val_status_15);

            if (!bank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND (ddmr.IssuningBank = ? OR ddmr.AquiringBank = ?) ");
                vt.add(val_bank);
                vt.add(val_bank);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append("group by ddmr.MerchantID ");

            // Terminated ddm request count            
            sbQuery.append("union all ");
            sbQuery.append("SELECT ddmr.MerchantID, mer.MerchantName, 0 as OngoingReqCount, 0 as CompletedReqCount, 0 as RejectedReqCount, 0 as SLABreachedReqCount, count(ddmr.DDAID) as TerminatedReqCount ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mer ");
            sbQuery.append("WHERE ddmr.MerchantID = mer.MerchantID ");
            sbQuery.append("and ddmr.Status in(?) ");
            vt.add(val_status_9);

            if (!bank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND (ddmr.IssuningBank = ? OR ddmr.AquiringBank = ?) ");
                vt.add(val_bank);
                vt.add(val_bank);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append("group by ddmr.MerchantID ");

            sbQuery.append(") as tb1  ");

            if (!merchantId.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND tb1.MerchantID = ? ");
                vt.add(val_merchantID);
            }

            sbQuery.append("group by tb1.MerchantID,  tb1.MerchantName ");
            sbQuery.append("order by tb1.MerchantID ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getDDAReqSummaryByMerchant) ---> " + sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_status_1)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_01);
                    i++;
                }
                if (val_item == val_status_2)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_02);
                    i++;
                }
                if (val_item == val_status_3)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_03);
                    i++;
                }
                if (val_item == val_status_4)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_04);
                    i++;
                }
                if (val_item == val_status_5)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_05);
                    i++;
                }
                if (val_item == val_status_6)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_06);
                    i++;
                }
                if (val_item == val_status_7)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_07);
                    i++;
                }
                if (val_item == val_status_9)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_09);
                    i++;
                }
                if (val_item == val_status_11)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_11);
                    i++;
                }
                if (val_item == val_status_12)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_12);
                    i++;
                }
                if (val_item == val_status_14)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_14);
                    i++;
                }
                if (val_item == val_status_15)
                {
                    pstm.setString(i, DDM_Constants.ddm_request_status_15);
                    i++;
                }

                if (val_item == val_bank)
                {
                    pstm.setString(i, bank);
                    i++;
                }

                if (val_item == val_fromRequestDate)
                {
                    pstm.setString(i, fromRequestDate);
                    i++;
                }

                if (val_item == val_toRequestDate)
                {
                    pstm.setString(i, toRequestDate);
                    i++;
                }

                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantId);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeDDMRequestSummaryObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getSLABreachByIssuingBankDDAReqSummary(String merchantId, String issuingBank, String fromRequestDate, String toRequestDate)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantId == null)
        {
            System.out.println("WARNING : Null merchantId parameter.");
            return col;
        }
        if (issuingBank == null)
        {
            System.out.println("WARNING : Null issuingBank parameter.");
            return col;
        }

        if (fromRequestDate == null)
        {
            System.out.println("WARNING : Null fromRequestDate parameter.");
            return col;
        }

        if (toRequestDate == null)
        {
            System.out.println("WARNING : Null toRequestDate parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_merchantID = 1;
            int val_issuingBK = 2;
            int val_fromRequestDate = 3;
            int val_toRequestDate = 4;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT ddmr.IssuningBank, bk.FullName as IssuningBankName, count(ddmr.DDAID) as ReqCount, "
                    + "avg(datediff(curdate(), ddmr.createddate) - (select CAST(ParamValue AS UNSIGNED) from parameter where ParamId = ?)) as AvgNoOfDaysExeed ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk ");
            sbQuery.append("WHERE ddmr.IssuningBank = bk.BankCode ");
            sbQuery.append("and ddmr.Status = ? ");
            sbQuery.append("and ddmr.IssuingBankAcceptedOn is null ");
            sbQuery.append("and datediff(curdate(), ddmr.createddate)>(select CAST(ParamValue AS UNSIGNED) from parameter where ParamId = ?) ");

            if (!merchantId.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.MerchantID = ? ");
                vt.add(val_merchantID);
            }

            if (!issuingBank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBank = ? ");
                vt.add(val_issuingBK);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append("group by ddmr.IssuningBank ");
            sbQuery.append("order by ddmr.IssuningBank ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getSLABreachByIssuingBankDDAReqSummary) ---> " + sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.param_id_ddm_sla_breach_for_issuing_bank);
            i++;
            pstm.setString(i, DDM_Constants.ddm_request_status_02);
            i++;
            pstm.setString(i, DDM_Constants.param_id_ddm_sla_breach_for_issuing_bank);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantId);
                    i++;
                }
                if (val_item == val_issuingBK)
                {
                    pstm.setString(i, issuingBank);
                    i++;
                }
                if (val_item == val_fromRequestDate)
                {
                    pstm.setString(i, fromRequestDate);
                    i++;
                }
                if (val_item == val_toRequestDate)
                {
                    pstm.setString(i, toRequestDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeSLABreachIssuingBankSummaryObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getSLABreachByIssuingBankDDAReqDetails(String merchantId, String issuingBankCode, String issuingBranchCode, String acquiringBankCode, String acquiringBranchCode, String status, String fromRequestDate, String toRequestDate)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantId == null)
        {
            System.out.println("WARNING : Null merchantId parameter.");
            return col;
        }
        if (issuingBankCode == null)
        {
            System.out.println("WARNING : Null issuingBankCode parameter.");
            return col;
        }
        if (issuingBranchCode == null)
        {
            System.out.println("WARNING : Null issuingBranchCode parameter.");
            return col;
        }
        if (acquiringBankCode == null)
        {
            System.out.println("WARNING : Null aquiringBankCode parameter.");
            return col;
        }
        if (acquiringBranchCode == null)
        {
            System.out.println("WARNING : Null aquiringBranchCode parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }
        if (fromRequestDate == null)
        {
            System.out.println("WARNING : Null fromRequestDate parameter.");
            return col;
        }
        if (toRequestDate == null)
        {
            System.out.println("WARNING : Null toRequestDate parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_merchantID = 1;
            int val_issuingBK = 2;
            int val_issuingBR = 3;
            int val_acquiringBK = 4;
            int val_acquiringBR = 5;
            int val_fromRequestDate = 6;
            int val_toRequestDate = 7;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "(datediff(curdate(), ddmr.createddate) - (select CAST(ParamValue AS UNSIGNED) from parameter where ParamId = ?)) as NoOfDaysExceed ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");

            sbQuery.append("and ddmr.Status = ? ");
            sbQuery.append("and ddmr.IssuingBankAcceptedOn is null ");
            sbQuery.append("and datediff(curdate(), ddmr.createddate)>(select CAST(ParamValue AS UNSIGNED) from parameter where ParamId = ?) ");

            if (!merchantId.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.MerchantID = ? ");
                vt.add(val_merchantID);
            }

            if (!issuingBankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBank = ? ");
                vt.add(val_issuingBK);
            }

            if (!issuingBranchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBranch = ? ");
                vt.add(val_issuingBR);
            }

            if (!acquiringBankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBank = ? ");
                vt.add(val_acquiringBK);
            }

            if (!acquiringBranchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBranch = ? ");
                vt.add(val_acquiringBR);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append(" order by IssuningBank, IssuningBranch, DDAID ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getSLABreachByIssuingBankDDAReqDetails) ---> " + sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.param_id_ddm_sla_breach_for_issuing_bank);
            i++;
            pstm.setString(i, DDM_Constants.ddm_request_status_02);
            i++;
            pstm.setString(i, DDM_Constants.param_id_ddm_sla_breach_for_issuing_bank);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantId);
                    i++;
                }
                if (val_item == val_issuingBK)
                {
                    pstm.setString(i, issuingBankCode);
                    i++;
                }
                if (val_item == val_issuingBR)
                {
                    pstm.setString(i, issuingBranchCode);
                    i++;
                }
                if (val_item == val_acquiringBK)
                {
                    pstm.setString(i, acquiringBankCode);
                    i++;
                }
                if (val_item == val_acquiringBR)
                {
                    pstm.setString(i, acquiringBranchCode);
                    i++;
                }
                if (val_item == val_fromRequestDate)
                {
                    pstm.setString(i, fromRequestDate);
                    i++;
                }
                if (val_item == val_toRequestDate)
                {
                    pstm.setString(i, toRequestDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeSLABreachIssuingBankReqDetailObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public Collection<DDMRequest> getSLABreachByAcquiringBankDDAReqSummary(String merchantId, String acquiringBank, String fromRequestDate, String toRequestDate)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantId == null)
        {
            System.out.println("WARNING : Null merchantId parameter.");
            return col;
        }
        if (acquiringBank == null)
        {
            System.out.println("WARNING : Null acquiringBank parameter.");
            return col;
        }

        if (fromRequestDate == null)
        {
            System.out.println("WARNING : Null fromRequestDate parameter.");
            return col;
        }

        if (toRequestDate == null)
        {
            System.out.println("WARNING : Null toRequestDate parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_merchantID = 1;
            int val_acquiringBK = 2;
            int val_fromRequestDate = 3;
            int val_toRequestDate = 4;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT ddmr.AquiringBank, bk.FullName as AquiringBankName, count(ddmr.DDAID) as ReqCount, "
                    + "avg(datediff(curdate(), ddmr.IssuingBankAcceptedOn) - (select CAST(ParamValue AS UNSIGNED) from parameter where ParamId = ?)) as AvgNoOfDaysExeed ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk ");
            sbQuery.append("WHERE ddmr.AquiringBank = bk.BankCode ");
            sbQuery.append("and ddmr.Status = ? ");
            sbQuery.append("and ddmr.AquiringBankAcceptedOn is null ");
            sbQuery.append("and datediff(curdate(), ddmr.IssuingBankAcceptedOn)>(select CAST(ParamValue AS UNSIGNED) from parameter where ParamId = ?) ");

            if (!merchantId.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.MerchantID = ? ");
                vt.add(val_merchantID);
            }

            if (!acquiringBank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBank = ? ");
                vt.add(val_acquiringBK);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append("group by ddmr.AquiringBank ");
            sbQuery.append("order by ddmr.AquiringBank ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getSLABreachByAcquiringBankDDAReqSummary) ---> " + sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.param_id_ddm_sla_breach_for_acquiring_bank);
            i++;
            pstm.setString(i, DDM_Constants.ddm_request_status_04);
            i++;
            pstm.setString(i, DDM_Constants.param_id_ddm_sla_breach_for_acquiring_bank);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantId);
                    i++;
                }
                if (val_item == val_acquiringBK)
                {
                    pstm.setString(i, acquiringBank);
                    i++;
                }
                if (val_item == val_fromRequestDate)
                {
                    pstm.setString(i, fromRequestDate);
                    i++;
                }
                if (val_item == val_toRequestDate)
                {
                    pstm.setString(i, toRequestDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeSLABreachAcquiringBankSummaryObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

//    @Override
//    public Collection<DDMRequest> getSLABreachByAcquiringBankDDAReqDetails(String merchantId, String acquiringBank, String fromRequestDate, String toRequestDate)
//    {
//        Collection<DDMRequest> col = null;
//        Connection con = null;
//        PreparedStatement pstm = null;
//        ResultSet rs = null;
//
//        if (merchantId == null)
//        {
//            System.out.println("WARNING : Null merchantId parameter.");
//            return col;
//        }
//        if (acquiringBank == null)
//        {
//            System.out.println("WARNING : Null acquiringBank parameter.");
//            return col;
//        }
//        if (fromRequestDate == null)
//        {
//            System.out.println("WARNING : Null fromRequestDate parameter.");
//            return col;
//        }
//        if (toRequestDate == null)
//        {
//            System.out.println("WARNING : Null toRequestDate parameter.");
//            return col;
//        }
//
//        try
//        {
//            con = DBUtil.getInstance().getConnection();
//
//            ArrayList<Integer> vt = new ArrayList();
//
//            int val_merchantID = 1;
//            int val_acquiringBK = 2;
//            int val_fromRequestDate = 3;
//            int val_toRequestDate = 4;
//
//            StringBuilder sbQuery = new StringBuilder();
//
//            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
//                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
//                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
//                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
//                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
//                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
//                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.CreatedBy, ddmr.CreatedDate, "
//                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
//                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
//                    + "(datediff(curdate(), ddmr.IssuingBankAcceptedOn) - (select CAST(ParamValue AS UNSIGNED) from parameter where ParamId = ?)) as NoOfDaysExceed ");
//            sbQuery.append("FROM ");
//            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
//            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
//            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
//            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
//            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
//            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
//            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
//            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
//            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
//            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
//            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
//            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
//            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
//            sbQuery.append("and ddmr.Status = ddmrs.id ");
//            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");
//
//            sbQuery.append("and ddmr.Status = ? ");
//            sbQuery.append("and ddmr.AquiringBankAcceptedOn is null ");
//            sbQuery.append("and datediff(curdate(), ddmr.IssuingBankAcceptedOn)>(select CAST(ParamValue AS UNSIGNED) from parameter where ParamId = ?) ");
//
//            if (!merchantId.equals(DDM_Constants.status_all))
//            {
//                sbQuery.append("AND ddmr.MerchantID = ? ");
//                vt.add(val_merchantID);
//            }
//
//            if (!acquiringBank.equals(DDM_Constants.status_all))
//            {
//                sbQuery.append("AND ddmr.AquiringBank = ? ");
//                vt.add(val_acquiringBK);
//            }
//
//            if (!fromRequestDate.equals(DDM_Constants.status_all))
//            {
//                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
//                vt.add(val_fromRequestDate);
//            }
//
//            if (!toRequestDate.equals(DDM_Constants.status_all))
//            {
//                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
//                vt.add(val_toRequestDate);
//            }
//
//            sbQuery.append(" order by AquiringBank, AquiringBranch, DDAID ");
//
//            pstm = con.prepareStatement(sbQuery.toString());
//
//            System.out.println("sbQuery(getSLABreachByAcquiringBankDDAReqDetails) ---> " + sbQuery.toString());
//
//            int i = 1;
//
//            pstm.setString(i, DDM_Constants.param_id_ddm_sla_breach_for_acquiring_bank);
//            i++;
//            pstm.setString(i, DDM_Constants.ddm_request_status_04);
//            i++;
//            pstm.setString(i, DDM_Constants.param_id_ddm_sla_breach_for_acquiring_bank);
//            i++;
//
//            for (int val_item : vt)
//            {
//                if (val_item == val_merchantID)
//                {
//                    pstm.setString(i, merchantId);
//                    i++;
//                }
//                if (val_item == val_acquiringBK)
//                {
//                    pstm.setString(i, acquiringBank);
//                    i++;
//                }
//                if (val_item == val_fromRequestDate)
//                {
//                    pstm.setString(i, fromRequestDate);
//                    i++;
//                }
//
//                if (val_item == val_toRequestDate)
//                {
//                    pstm.setString(i, toRequestDate);
//                    i++;
//                }
//            }
//
//            rs = pstm.executeQuery();
//
//            col = DDMRequestUtil.makeSLABreachAcquiringBankReqDetailObjectsCollection(rs);
//
//            if (col.isEmpty())
//            {
//                msg = DDM_Constants.msg_no_records;
//            }
//        }
//        catch (SQLException | ClassNotFoundException e)
//        {
//            msg = DDM_Constants.msg_error_while_processing;
//            System.out.println(e.getMessage());
//        }
//        finally
//        {
//            DBUtil.getInstance().closeResultSet(rs);
//            DBUtil.getInstance().closeStatement(pstm);
//            DBUtil.getInstance().closeConnection(con);
//        }
//
//        return col;
//    }
    @Override
    public Collection<DDMRequest> getSLABreachByAcquiringBankDDAReqDetails(String merchantId, String issuingBankCode, String issuingBranchCode, String acquiringBankCode, String acquiringBranchCode, String status, String fromRequestDate, String toRequestDate)
    {
        Collection<DDMRequest> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantId == null)
        {
            System.out.println("WARNING : Null merchantId parameter.");
            return col;
        }
        if (issuingBankCode == null)
        {
            System.out.println("WARNING : Null issuingBankCode parameter.");
            return col;
        }
        if (issuingBranchCode == null)
        {
            System.out.println("WARNING : Null issuingBranchCode parameter.");
            return col;
        }
        if (acquiringBankCode == null)
        {
            System.out.println("WARNING : Null aquiringBankCode parameter.");
            return col;
        }
        if (acquiringBranchCode == null)
        {
            System.out.println("WARNING : Null aquiringBranchCode parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }
        if (fromRequestDate == null)
        {
            System.out.println("WARNING : Null fromRequestDate parameter.");
            return col;
        }
        if (toRequestDate == null)
        {
            System.out.println("WARNING : Null toRequestDate parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_merchantID = 1;
            int val_issuingBK = 2;
            int val_issuingBR = 3;
            int val_acquiringBK = 4;
            int val_acquiringBR = 5;
            int val_fromRequestDate = 6;
            int val_toRequestDate = 7;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ddmr.DDAID, ddmr.MerchantID, mr.MerchantName, ddmr.IssuningBank, "
                    + "ibk.FullName as IssuningBankName, ibk.ShortName as IssuningBankShortName, "
                    + "ddmr.IssuningBranch, ibr.BranchName as IssuningBranchName, ddmr.IssuningAcNo, ddmr.IssuningAcName, "
                    + "ddmr.AquiringBank, abk.FullName as AquiringBankName, abk.ShortName as AquiringBankShortName, "
                    + "ddmr.AquiringBranch, abr.BranchName as AquiringBranchName, ddmr.AquiringAcNo, ddmr.AquiringAcName, "
                    + "ddmr.StartDate, ddmr.EndDate, ddmr.MaxLimit, ddmr.Frequency, ddmr.Purpose, ddmr.Ref, "
                    + "ddmr.Status, ddmrs.Description as StatusDesc, ddmr.CreatedBy, ddmr.CreatedDate, "
                    + "ddmr.IssuingBankAcceptedRemarks, ddmr.IssuingBankAcceptedBy, ddmr.IssuingBankAcceptedOn, "
                    + "ddmr.AquiringBankAcceptedRemarks, ddmr.AquiringBankAcceptedBy, ddmr.AquiringBankAcceptedOn, "
                    + "(datediff(curdate(), ddmr.IssuingBankAcceptedOn) - (select CAST(ParamValue AS UNSIGNED) from parameter where ParamId = ?)) as NoOfDaysExceed ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ddmr, ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ddmrs, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ibk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " ibr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " abk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " abr, ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr ");
            sbQuery.append("WHERE ddmr.IssuningBank = ibk.BankCode ");
            sbQuery.append("and ddmr.IssuningBank = ibr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = ibr.BranchCode ");
            sbQuery.append("and ddmr.AquiringBank = abk.BankCode ");
            sbQuery.append("and ddmr.AquiringBank = abr.BankCode ");
            sbQuery.append("and ddmr.IssuningBranch = abr.BranchCode ");
            sbQuery.append("and ddmr.Status = ddmrs.id ");
            sbQuery.append("and ddmr.MerchantID = mr.MerchantID ");

            sbQuery.append("and ddmr.Status = ? ");
            sbQuery.append("and ddmr.AquiringBankAcceptedOn is null ");
            sbQuery.append("and datediff(curdate(), ddmr.IssuingBankAcceptedOn)>(select CAST(ParamValue AS UNSIGNED) from parameter where ParamId = ?) ");

            if (!merchantId.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.MerchantID = ? ");
                vt.add(val_merchantID);
            }

            if (!issuingBankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBank = ? ");
                vt.add(val_issuingBK);
            }

            if (!issuingBranchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.IssuningBranch = ? ");
                vt.add(val_issuingBR);
            }

            if (!acquiringBankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBank = ? ");
                vt.add(val_acquiringBK);
            }

            if (!acquiringBranchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.AquiringBranch = ? ");
                vt.add(val_acquiringBR);
            }

            if (!fromRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate >= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_fromRequestDate);
            }

            if (!toRequestDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ddmr.CreatedDate <= str_to_date(REPLACE(?, '-', ''),'%Y%m%d') ");
                vt.add(val_toRequestDate);
            }

            sbQuery.append(" order by IssuningBank, IssuningBranch, DDAID ");

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getSLABreachByIssuingBankDDAReqDetails) ---> " + sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.param_id_ddm_sla_breach_for_acquiring_bank);
            i++;
            pstm.setString(i, DDM_Constants.ddm_request_status_04);
            i++;
            pstm.setString(i, DDM_Constants.param_id_ddm_sla_breach_for_acquiring_bank);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantId);
                    i++;
                }
                if (val_item == val_issuingBK)
                {
                    pstm.setString(i, issuingBankCode);
                    i++;
                }
                if (val_item == val_issuingBR)
                {
                    pstm.setString(i, issuingBranchCode);
                    i++;
                }
                if (val_item == val_acquiringBK)
                {
                    pstm.setString(i, acquiringBankCode);
                    i++;
                }
                if (val_item == val_acquiringBR)
                {
                    pstm.setString(i, acquiringBranchCode);
                    i++;
                }
                if (val_item == val_fromRequestDate)
                {
                    pstm.setString(i, fromRequestDate);
                    i++;
                }
                if (val_item == val_toRequestDate)
                {
                    pstm.setString(i, toRequestDate);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = DDMRequestUtil.makeSLABreachIssuingBankReqDetailObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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

        return col;
    }

    @Override
    public boolean updateDDMRequestStatus(String ddaRequestId, String curStatus, String newStatus, String modifiedBy, String remarks)
    {
        boolean updateStatus = false;
        Connection con = null;
        PreparedStatement pstm = null;
        int count = 0;

        if (ddaRequestId == null)
        {
            System.out.println("WARNING : Null ddaRequestId parameter.");
            return updateStatus;
        }

        if (curStatus == null)
        {
            System.out.println("WARNING : Null curStatus parameter.");
            return updateStatus;
        }

        if (newStatus == null)
        {
            System.out.println("WARNING : Null newStatus parameter.");
            return updateStatus;
        }

        if (modifiedBy == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return updateStatus;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_ddmrequest + " ");
            sbQuery.append("set ");
            sbQuery.append("Status = ?, ");

            if (newStatus.equals(DDM_Constants.ddm_request_status_03) || newStatus.equals(DDM_Constants.ddm_request_status_11))
            {
                if (remarks != null)
                {
                    sbQuery.append("IssuingBankAcceptedRemarks = ?, IssuingBankAcceptedBy = ?,  IssuingBankAcceptedOn = now()");
                }
                else
                {
                    sbQuery.append("IssuingBankAcceptedBy = ?,  IssuingBankAcceptedOn = now()");
                }
            }

            else if (newStatus.equals(DDM_Constants.ddm_request_status_05) || newStatus.equals(DDM_Constants.ddm_request_status_12))
            {
                if (remarks != null)
                {
                    sbQuery.append("AquiringBankAcceptedRemarks = ?, AquiringBankAcceptedBy = ?,  AquiringBankAcceptedOn = now()");
                }
                else
                {
                    sbQuery.append("AquiringBankAcceptedBy = ?,  AquiringBankAcceptedOn = now()");
                }
            }
            else
            {
                sbQuery.append("CreatedBy = CreatedBy  ");
            }

            sbQuery.append("where DDAID = ? ");
            sbQuery.append("and Status = ? ");

            System.out.println("sbQuery(updateDDMRequestStatus)---> " + sbQuery.toString());

            System.out.println("ddaRequestId --> " + ddaRequestId);
            System.out.println("curStatus ---> " + curStatus);
            System.out.println("newStatus ---> " + newStatus);

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, newStatus);

            if (newStatus.equals(DDM_Constants.ddm_request_status_03)
                    || newStatus.equals(DDM_Constants.ddm_request_status_05)
                    || newStatus.equals(DDM_Constants.ddm_request_status_11)
                    || newStatus.equals(DDM_Constants.ddm_request_status_12))
            {
                if (remarks != null)
                {
                    pstm.setString(2, remarks);
                    pstm.setString(3, modifiedBy);
                    pstm.setString(4, ddaRequestId);
                    pstm.setString(5, curStatus);
                }
                else
                {
                    pstm.setString(2, modifiedBy);
                    pstm.setString(3, ddaRequestId);
                    pstm.setString(4, curStatus);
                }
            }
            else
            {
                pstm.setString(2, ddaRequestId);
                pstm.setString(3, curStatus);
            }

            count = pstm.executeUpdate();

            if (count > 0)
            {
                con.commit();
                updateStatus = true;
            }
            else
            {
                con.rollback();
            }

        }
        catch (SQLException | ClassNotFoundException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return updateStatus;

    }

}
