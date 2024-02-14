/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.merchant.accnomap;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;
import lk.com.ttsl.pb.slips.dao.merchant.Merchant;

/**
 *
 * @author Dinesh
 */
public class MerchantAccNoMapDAOImpl implements MerchantAccNoMapDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public MerchantAccNoMap getMerchantAccount(String concatPK)
    {
        MerchantAccNoMap mAccNoMap = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (concatPK == null)
        {
            System.out.println("WARNING : Null concatPK parameter.");
            return mAccNoMap;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT manm.merchantid, manm.bankcode, bk.FullName as BankName, "
                    + "bk.ShortName as BankShortName, manm.branchcode, br.BranchName, "
                    + "manm.acno, manm.acname, manm.isprimary, "
                    + "manm.Status as AccNoMapStatus, manm.Status_Modify as AccNoMapStatusModify,"
                    + " manm.CreatedBy as AccNoMapCreatedBy, "
                    + "manm.CreatedDate as AccNoMapCreatedDate, manm.AuthorizedBy as AccNoMapAuthorizedBy, "
                    + "manm.AuthorizedDate as AccNoMapAuthorizedDate, "
                    + "manm.ModifiedBy as AccNoMapModifiedBy, manm.ModifiedDate as AccNoMapModifiedDate, "
                    + "manm.ModificationAuthBy as AccNoMapModificationAuthBy, "
                    + "manm.ModificationAuthDate as AccNoMapModificationAuthDate FROM ");

            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " manm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");

            sbQuery.append("WHERE manm.bankcode  = bk.BankCode ");
            sbQuery.append("AND manm.bankcode  = br.BankCode ");
            sbQuery.append("AND manm.branchcode  = br.BranchCode ");

            sbQuery.append("AND concat(manm.merchantid,manm.bankcode,manm.branchcode,manm.acno) = ? ");

            System.out.println("sbQuery(getMerchantAccount 1)----> " + sbQuery);

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, concatPK);

            rs = pstm.executeQuery();

            mAccNoMap = MerchantAccNoMapUtil.makeMerchantAccountMapObject(rs);

            if (mAccNoMap == null)
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

        return mAccNoMap;
    }

    @Override
    public MerchantAccNoMap getMerchantAccount(String merchantID, String bankCode, String branchCode, String accNo)
    {
        MerchantAccNoMap mAccNoMap = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantID == null)
        {
            System.out.println("WARNING : Null merchantID parameter.");
            return mAccNoMap;
        }

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return mAccNoMap;
        }

        if (branchCode == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return mAccNoMap;
        }

        if (accNo == null)
        {
            System.out.println("WARNING : Null accNo parameter.");
            return mAccNoMap;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT manm.merchantid, manm.bankcode, bk.FullName as BankName, "
                    + "bk.ShortName as BankShortName, manm.branchcode, br.BranchName, "
                    + "manm.acno, manm.acname, manm.isprimary, "
                    + "manm.Status as AccNoMapStatus, manm.Status_Modify as AccNoMapStatusModify,"
                    + " manm.CreatedBy as AccNoMapCreatedBy, "
                    + "manm.CreatedDate as AccNoMapCreatedDate, manm.AuthorizedBy as AccNoMapAuthorizedBy, "
                    + "manm.AuthorizedDate as AccNoMapAuthorizedDate, "
                    + "manm.ModifiedBy as AccNoMapModifiedBy, manm.ModifiedDate as AccNoMapModifiedDate, "
                    + "manm.ModificationAuthBy as AccNoMapModificationAuthBy, "
                    + "manm.ModificationAuthDate as AccNoMapModificationAuthDate FROM ");

            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " manm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");

            sbQuery.append("WHERE manm.bankcode  = bk.BankCode ");
            sbQuery.append("AND manm.bankcode  = br.BankCode ");
            sbQuery.append("AND manm.branchcode  = br.BranchCode ");

            sbQuery.append("AND manm.merchantid = ? ");

            sbQuery.append("AND manm.bankcode = ? ");
            sbQuery.append("AND manm.branchcode = ? ");
            sbQuery.append("AND manm.acno = ? ");

            System.out.println("sbQuery(getMerchantAccount 2)----> " + sbQuery);

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, merchantID);

            pstm.setString(2, bankCode);
            pstm.setString(3, branchCode);
            pstm.setString(4, accNo);

            rs = pstm.executeQuery();

            mAccNoMap = MerchantAccNoMapUtil.makeMerchantAccountMapObject(rs);

            if (mAccNoMap == null)
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

        return mAccNoMap;
    }

    @Override
    public Collection<MerchantAccNoMap> getMerchantAccounts(String merchantID, String status)
    {
        Collection<MerchantAccNoMap> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantID == null)
        {
            System.out.println("WARNING : Null merchantID parameter.");
            return col;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT manm.merchantid, manm.bankcode, bk.FullName as BankName, "
                    + "bk.ShortName as BankShortName, manm.branchcode, br.BranchName, "
                    + "manm.acno, manm.acname, manm.isprimary, "
                    + "manm.Status as AccNoMapStatus, manm.Status_Modify as AccNoMapStatusModify,"
                    + " manm.CreatedBy as AccNoMapCreatedBy, "
                    + "manm.CreatedDate as AccNoMapCreatedDate, manm.AuthorizedBy as AccNoMapAuthorizedBy, "
                    + "manm.AuthorizedDate as AccNoMapAuthorizedDate, "
                    + "manm.ModifiedBy as AccNoMapModifiedBy, manm.ModifiedDate as AccNoMapModifiedDate, "
                    + "manm.ModificationAuthBy as AccNoMapModificationAuthBy, "
                    + "manm.ModificationAuthDate as AccNoMapModificationAuthDate FROM ");

            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " manm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");

            sbQuery.append("WHERE manm.bankcode  = bk.BankCode ");
            sbQuery.append("AND manm.bankcode  = br.BankCode ");
            sbQuery.append("AND manm.branchcode  = br.BranchCode ");

            sbQuery.append("AND manm.merchantid = ? ");

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND manm.Status = ? ");
            }

            sbQuery.append("ORDER BY AccNo ");

            System.out.println("sbQuery(getCorporateCustomerNotInStatus)----> " + sbQuery);

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, merchantID);

            if (!status.equals(DDM_Constants.status_all))
            {
                pstm.setString(2, status);
            }

            rs = pstm.executeQuery();

            col = MerchantAccNoMapUtil.makeMerchantAccountMapObjectCollection(rs);

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
    public boolean addMerchantAccNoMap(MerchantAccNoMap manm)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count;

        if (manm.getMerchantID() == null)
        {
            System.out.println("WARNING : Null manm.getMerchantID()  parameter.");
            return false;
        }

        if (manm.getBank() == null)
        {
            System.out.println("WARNING : Null manm.getBank() parameter.");
            return false;
        }

        if (manm.getBranch() == null)
        {
            System.out.println("WARNING : Null manm.getBranch() parameter.");
            return false;
        }

        if (manm.getAcNo() == null)
        {
            System.out.println("WARNING : Null manm.getAcNo() parameter.");
            return false;
        }

        if (manm.getAcName() == null)
        {
            System.out.println("WARNING : Null manm.getAcName() parameter.");
            return false;
        }

        if (manm.getIsPrimary() == null)
        {
            System.out.println("WARNING : Null manm.getIsPrimary() parameter.");
            return false;
        }

        if (manm.getStatus() == null)
        {
            System.out.println("WARNING : Null manm.getStatus() parameter.");
            return false;
        }

        if (manm.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null manm.getModifiedBy() parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ");
            sbQuery.append("(merchantid,bankcode,branchcode,acno,acname,isprimary,status,status_modify,"
                    + "CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,?,?,?,?,now(),?,now())");

            System.out.println("addMerchantAccNoMap(sbQuery)=========>" + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, manm.getMerchantID().trim());
            psmt.setString(2, manm.getBank().trim());
            psmt.setString(3, manm.getBranch().trim());
            psmt.setString(4, manm.getAcNo().trim());
            psmt.setString(5, manm.getAcName().trim());
            psmt.setString(6, manm.getIsPrimary().trim());
            psmt.setString(7, manm.getStatus().trim());
            psmt.setString(8, manm.getStatus().trim());
            psmt.setString(9, manm.getModifiedBy().trim());
            psmt.setString(10, manm.getModifiedBy().trim());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                if (manm.getIsPrimary().trim().equals(DDM_Constants.status_yes))
                {
                    Merchant objMerchant = DAOFactory.getMerchantDAO().getMerchantDetails(manm.getMerchantID().trim());

                    if (objMerchant != null && objMerchant.getColAccNoMap() != null && objMerchant.getColAccNoMap().size() > 1)
                    {
                        if (DAOFactory.getMerchantDAO().modifyMerchant(new Merchant(objMerchant.getMerchantID(), objMerchant.getMerchantName(), objMerchant.getEmail(), objMerchant.getPrimaryTP(), objMerchant.getSecondaryTP(), null, manm.getBank().trim(), manm.getBranch().trim(), manm.getAcNo().trim(), manm.getAcName().trim(), objMerchant.getId(), objMerchant.getStatus(), manm.getModifiedBy().trim())))
                        {
                            System.out.println("### modifyMerchant was Success ####");
                            con.commit();
                            status = true;
                        }
                        else
                        {
                            System.out.println("### modifyMerchant was Failed ####");
                            status = true;
                            msg = "Modify Merchant Primary Acoount Details Failed.";
                        }
                    }
                    else
                    {
                        System.out.println("### modifyMerchant was Success ####");
                        con.commit();
                        status = true;
                    }
                }
                else
                {
                    System.out.println("### add Merchant Other Acc Nos is Success ####");
                    con.commit();
                    status = true;
                }

            }
            else
            {
                status = false;
                msg = DDM_Constants.msg_duplicate_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
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
    public boolean modifyMerchantAccNoMap(MerchantAccNoMap manm)
    {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public boolean doAuthorizedMerchantAccNoMap(MerchantAccNoMap manm)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (manm.getMerchantID() == null)
        {
            System.out.println("WARNING : Null getMerchantID()  parameter.");
            return false;
        }

        if (manm.getAuthorizedBy() == null)
        {
            System.out.println("WARNING : Null authorizedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " ");
            sbQuery.append("set ");
            sbQuery.append("status = ?, ");
            sbQuery.append("status_modify = ?, ");
            sbQuery.append("AuthorizedBy = ?, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("AuthorizedDate = now(), ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where merchantid = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(2, DDM_Constants.status_active);
            psmt.setString(3, manm.getAuthorizedBy());
            psmt.setString(4, manm.getAuthorizedBy());
            psmt.setString(5, manm.getMerchantID());

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
        catch (SQLException | ClassNotFoundException | NumberFormatException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    @Override
    public boolean doAuthorizeModifiedMerchantAccNoMap(MerchantAccNoMap manm)
    {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
