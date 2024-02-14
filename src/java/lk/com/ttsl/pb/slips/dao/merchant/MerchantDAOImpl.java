/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.merchant;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;
import lk.com.ttsl.pb.slips.dao.merchant.accnomap.MerchantAccNoMap;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 *
 * @author Dinesh
 */
public class MerchantDAOImpl implements MerchantDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    /**
     *
     * @param merchantID
     * @param bank
     * @param branch
     * @param status
     * @return
     */
    @Override
    public Collection<Merchant> getMerchant(String merchantID, String bank, String branch, String status)
    {
        Collection<Merchant> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantID == null)
        {
            System.out.println("WARNING : Null merchantID parameter.");
            return col;
        }

        if (bank == null)
        {
            System.out.println("WARNING : Null bank parameter.");
            return col;
        }

        if (branch == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
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

            ArrayList<Integer> vt = new ArrayList();

            int val_merchantID = 1;
            int val_bank = 2;
            int val_branch = 3;
            int val_status = 4;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select mr.MerchantID, mr.MerchantName, mr.MerchantName_Modify, "
                    + "mr.Email, mr.Email_Modify, mr.PrimaryTP, mr.PrimaryTP_Modify, "
                    + "mr.SecondaryTP, mr.SecondaryTP_Modify, mr.Password, mr.Password_Modify, "
                    + "mr.bankcode, bk.FullName as BankName, bk.ShortName, "
                    + "mr.bankcode_Modify, bkm.FullName as BankName_Modify, bk.ShortName as ShortName_Modify, "
                    + "mr.branchcode, br.BranchName, mr.branchcode_Modify,  brm.BranchName as BranchName_Modify, "
                    + "mr.acno as PrimaryACNO, mr.acno_Modify as PrimaryACNO_Modify, "
                    + "mr.acname as PrimaryACName, mr.acname_Modify as PrimaryACName_Modify, "
                    + "mr.id, mr.id_Modify, mr.Status, mr.Status_Modify, mr.CreatedBy, mr.CreatedDate, "
                    + "mr.AuthorizedBy, mr.AuthorizedDate, mr.ModificationRemarks, mr.ModifiedBy, mr.ModifiedDate, "
                    + "mr.ModificationAuthBy, mr.ModificationAuthDate ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm ");
            sbQuery.append("WHERE mr.bankcode = bk.BankCode ");
            sbQuery.append("AND mr.bankcode_Modify = bkm.BankCode ");
            sbQuery.append("AND mr.BankCode = br.BankCode ");
            sbQuery.append("AND mr.branchcode = br.BranchCode ");
            sbQuery.append("AND mr.bankcode_Modify = brm.BankCode ");
            sbQuery.append("AND mr.branchcode_Modify = brm.BranchCode ");
            sbQuery.append("AND mr.MerchantID != ? ");

            if (!merchantID.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.MerchantID like ? ");
                vt.add(val_merchantID);
            }

            if (!bank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.bankcode = ? ");
                vt.add(val_bank);
            }

            if (!branch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.branchcode = ? ");
                vt.add(val_branch);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.Status = ? ");
                vt.add(val_status);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("sbQuery(getMerchant) ---> " + sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.default_merchant_id);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_merchantID)
                {
                    pstm.setString(i, merchantID + "%");
                    i++;
                }

                if (val_item == val_bank)
                {
                    pstm.setString(i, bank);
                    i++;
                }

                if (val_item == val_branch)
                {
                    pstm.setString(i, branch);
                    i++;
                }

                if (val_item == val_status)
                {
                    pstm.setString(i, status);
                    i++;
                }

            }

            rs = pstm.executeQuery();

            col = MerchantUtil.makeMerchantObjectsCollectionMinimal(rs);

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
    public Merchant getMerchantDetails(String merchantID)
    {
        Merchant cocu = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (merchantID == null)
        {
            System.out.println("WARNING : Null merchantID parameter.");
            return cocu;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select mr.MerchantID, mr.MerchantName, mr.MerchantName_Modify, "
                    + "mr.Email, mr.Email_Modify, mr.PrimaryTP, mr.PrimaryTP_Modify, "
                    + "mr.SecondaryTP, mr.SecondaryTP_Modify, mr.Password, mr.Password_Modify, "
                    + "mr.bankcode, bk.FullName as BankName, bk.ShortName, "
                    + "mr.bankcode_Modify, bkm.FullName as BankName_Modify, bk.ShortName as ShortName_Modify, "
                    + "mr.branchcode, br.BranchName, mr.branchcode_Modify,  brm.BranchName as BranchName_Modify, "
                    + "mr.acno as PrimaryACNO, mr.acno_Modify as PrimaryACNO_Modify, "
                    + "mr.acname as PrimaryACName, mr.acname_Modify as PrimaryACName_Modify, "
                    + "mr.id, mr.id_Modify, mr.Status, mr.Status_Modify, mr.CreatedBy, mr.CreatedDate, "
                    + "mr.AuthorizedBy, mr.AuthorizedDate, mr.ModificationRemarks, mr.ModifiedBy, mr.ModifiedDate, "
                    + "mr.ModificationAuthBy, mr.ModificationAuthDate, "
                    + "mranm.bankcode as ACNOM_Bank, bkanm.FullName as ACNOM_BankName, bkanm.ShortName as ACNOM_ShortName, "
                    + "mranm.branchcode as ACNOM_Branch, branm.BranchName as ACNOM_BranchName, "
                    + "mranm.acno as ACNOM_AccountNo, mranm.acname as ACNOM_AccountName, "
                    + "mranm.isprimary as ACNOM_IsPrimary, "
                    + "mranm.status as ACNOM_Status, mranm.status_modify as ACNOM_StatusModify ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " mranm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkanm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " branm ");
            sbQuery.append("WHERE mr.MerchantID = mranm.merchantid ");
            sbQuery.append("AND mr.bankcode = bk.BankCode ");
            sbQuery.append("AND mr.bankcode_Modify = bkm.BankCode ");
            sbQuery.append("AND mr.BankCode = br.BankCode ");
            sbQuery.append("AND mr.branchcode = br.BranchCode ");
            sbQuery.append("AND mr.bankcode_Modify = brm.BankCode ");
            sbQuery.append("AND mr.branchcode_Modify = brm.BranchCode ");
            sbQuery.append("AND mranm.bankcode = bkanm.BankCode ");
            sbQuery.append("AND mranm.bankcode = branm.BankCode ");
            sbQuery.append("AND mranm.branchcode = branm.BranchCode ");
            sbQuery.append("AND mr.MerchantID = ?  ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, merchantID);

            rs = pstm.executeQuery();

            cocu = MerchantUtil.makeMerchantObject(rs);

            if (cocu == null)
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

        return cocu;
    }

    @Override
    public Collection<Merchant> getMerchantAll()
    {
        Collection<Merchant> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select mr.MerchantID, mr.MerchantName, mr.MerchantName_Modify, "
                    + "mr.Email, mr.Email_Modify, mr.PrimaryTP, mr.PrimaryTP_Modify, "
                    + "mr.SecondaryTP, mr.SecondaryTP_Modify, mr.Password, mr.Password_Modify, "
                    + "mr.bankcode, bk.FullName as BankName, bk.ShortName, "
                    + "mr.bankcode_Modify, bkm.FullName as BankName_Modify, bk.ShortName as ShortName_Modify, "
                    + "mr.branchcode, br.BranchName, mr.branchcode_Modify,  brm.BranchName as BranchName_Modify, "
                    + "mr.acno as PrimaryACNO, mr.acno_Modify as PrimaryACNO_Modify, "
                    + "mr.acname as PrimaryACName, mr.acname_Modify as PrimaryACName_Modify, "
                    + "mr.id, mr.id_Modify, mr.Status, mr.Status_Modify, mr.CreatedBy, mr.CreatedDate, "
                    + "mr.AuthorizedBy, mr.AuthorizedDate, mr.ModificationRemarks, mr.ModifiedBy, mr.ModifiedDate, "
                    + "mr.ModificationAuthBy, mr.ModificationAuthDate, "
                    + "mranm.bankcode as ACNOM_Bank, bkanm.FullName as ACNOM_BankName, bkanm.ShortName as ACNOM_ShortName, "
                    + "mranm.branchcode as ACNOM_Branch, branm.BranchName as ACNOM_BranchName, "
                    + "mranm.acno as ACNOM_AccountNo, mranm.acname as ACNOM_AccountName, "
                    + "mranm.isprimary as ACNOM_IsPrimary, "
                    + "mranm.status as ACNOM_Status, mranm.status_modify as ACNOM_StatusModify ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " mranm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkanm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " branm ");
            sbQuery.append("WHERE mr.MerchantID = mranm.merchantid ");
            sbQuery.append("AND mr.bankcode = bk.BankCode ");
            sbQuery.append("AND mr.bankcode_Modify = bkm.BankCode ");
            sbQuery.append("AND mr.BankCode = br.BankCode ");
            sbQuery.append("AND mr.branchcode = br.BranchCode ");
            sbQuery.append("AND mr.bankcode_Modify = brm.BankCode ");
            sbQuery.append("AND mr.branchcode_Modify = brm.BranchCode ");
            sbQuery.append("AND mranm.bankcode = bkanm.BankCode ");
            sbQuery.append("AND mranm.bankcode = branm.BankCode ");
            sbQuery.append("AND mranm.branchcode = branm.BranchCode ");
            sbQuery.append("AND mr.MerchantID != ? ");
            sbQuery.append("ORDER BY MerchantID ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, DDM_Constants.default_merchant_id);

            rs = pstm.executeQuery();

            col = MerchantUtil.makeMerchantObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {

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
    public Collection<Merchant> getMerchantBasicDetails(String status, String bank, String branch)
    {
        Collection<Merchant> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        if (bank == null)
        {
            System.out.println("WARNING : Null bank parameter.");
            return col;
        }

        if (branch == null)
        {
            System.out.println("WARNING : Null branch parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_status = 1;
            int val_bank = 2;
            int val_branch = 3;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select mr.MerchantID, mr.MerchantName, mr.MerchantName_Modify, "
                    + "mr.Email, mr.Email_Modify, mr.PrimaryTP, mr.PrimaryTP_Modify, "
                    + "mr.SecondaryTP, mr.SecondaryTP_Modify, mr.Password, mr.Password_Modify, "
                    + "mr.bankcode, bk.FullName as BankName, bk.ShortName, "
                    + "mr.bankcode_Modify, bkm.FullName as BankName_Modify, bk.ShortName as ShortName_Modify, "
                    + "mr.branchcode, br.BranchName, mr.branchcode_Modify,  brm.BranchName as BranchName_Modify, "
                    + "mr.acno as PrimaryACNO, mr.acno_Modify as PrimaryACNO_Modify, "
                    + "mr.acname as PrimaryACName, mr.acname_Modify as PrimaryACName_Modify, "
                    + "mr.id, mr.id_Modify, mr.Status, mr.Status_Modify, mr.CreatedBy, mr.CreatedDate, "
                    + "mr.AuthorizedBy, mr.AuthorizedDate, mr.ModificationRemarks, mr.ModifiedBy, mr.ModifiedDate, "
                    + "mr.ModificationAuthBy, mr.ModificationAuthDate ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm ");
            sbQuery.append("WHERE mr.bankcode = bk.BankCode ");
            sbQuery.append("AND mr.bankcode_Modify = bkm.BankCode ");
            sbQuery.append("AND mr.BankCode = br.BankCode ");
            sbQuery.append("AND mr.branchcode = br.BranchCode ");
            sbQuery.append("AND mr.bankcode_Modify = brm.BankCode ");
            sbQuery.append("AND mr.branchcode_Modify = brm.BranchCode ");
            sbQuery.append("AND mr.MerchantID != ? ");

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.Status = ?  ");
                vt.add(val_status);
            }

            if (!bank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.bankcode = ? ");
                vt.add(val_bank);
            }

            if (!branch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.branchcode = ?  ");
                vt.add(val_branch);
            }

            sbQuery.append("ORDER BY MerchantID ");

            System.out.println("sbQuery(getMerchantBasicDetails)------> " + sbQuery);

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.default_merchant_id);
            i++;

            for (int val_item : vt)
            {

                if (val_item == val_bank)
                {
                    pstm.setString(i, bank);
                    i++;
                }

                if (val_item == val_branch)
                {
                    pstm.setString(i, branch);
                    i++;
                }

                if (val_item == val_status)
                {
                    pstm.setString(i, status);
                    i++;
                }

            }

            rs = pstm.executeQuery();

            col = MerchantUtil.makeMerchantObjectsCollectionMinimal(rs);

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
    public Collection<Merchant> getMerchantNotInStatus(String status, String bank, String branch)
    {
        Collection<Merchant> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        if (bank == null)
        {
            System.out.println("WARNING : Null bank parameter.");
            return col;
        }

        if (branch == null)
        {
            System.out.println("WARNING : Null branch parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_bank = 1;
            int val_branch = 2;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select mr.MerchantID, mr.MerchantName, mr.MerchantName_Modify, "
                    + "mr.Email, mr.Email_Modify, mr.PrimaryTP, mr.PrimaryTP_Modify, "
                    + "mr.SecondaryTP, mr.SecondaryTP_Modify, mr.Password, mr.Password_Modify, "
                    + "mr.bankcode, bk.FullName as BankName, bk.ShortName, "
                    + "mr.bankcode_Modify, bkm.FullName as BankName_Modify, bk.ShortName as ShortName_Modify, "
                    + "mr.branchcode, br.BranchName, mr.branchcode_Modify,  brm.BranchName as BranchName_Modify, "
                    + "mr.acno as PrimaryACNO, mr.acno_Modify as PrimaryACNO_Modify, "
                    + "mr.acname as PrimaryACName, mr.acname_Modify as PrimaryACName_Modify, "
                    + "mr.id, mr.id_Modify, mr.Status, mr.Status_Modify, mr.CreatedBy, mr.CreatedDate, "
                    + "mr.AuthorizedBy, mr.AuthorizedDate, mr.ModificationRemarks, mr.ModifiedBy, mr.ModifiedDate, "
                    + "mr.ModificationAuthBy, mr.ModificationAuthDate, "
                    + "mranm.bankcode as ACNOM_Bank, bkanm.FullName as ACNOM_BankName, bkanm.ShortName as ACNOM_ShortName, "
                    + "mranm.branchcode as ACNOM_Branch, branm.BranchName as ACNOM_BranchName, "
                    + "mranm.acno as ACNOM_AccountNo, mranm.acname as ACNOM_AccountName, "
                    + "mranm.isprimary as ACNOM_IsPrimary, "
                    + "mranm.status as ACNOM_Status, mranm.status_modify as ACNOM_StatusModify ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " mranm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkanm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " branm ");
            sbQuery.append("WHERE mr.MerchantID = mranm.merchantid ");
            sbQuery.append("AND mr.bankcode = bk.BankCode ");
            sbQuery.append("AND mr.bankcode_Modify = bkm.BankCode ");
            sbQuery.append("AND mr.BankCode = br.BankCode ");
            sbQuery.append("AND mr.branchcode = br.BranchCode ");
            sbQuery.append("AND mr.bankcode_Modify = brm.BankCode ");
            sbQuery.append("AND mr.branchcode_Modify = brm.BranchCode ");
            sbQuery.append("AND mranm.bankcode = bkanm.BankCode ");
            sbQuery.append("AND mranm.bankcode = branm.BankCode ");
            sbQuery.append("AND mranm.branchcode = branm.BranchCode ");
            sbQuery.append("AND mr.MerchantID != ? ");
            sbQuery.append("AND mr.Status NOT IN (?) ");

            if (!bank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.bankcode = ? ");
                vt.add(val_bank);
            }

            if (!branch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.branchcode = ? ");
                vt.add(val_branch);
            }

            sbQuery.append("ORDER BY MerchantID ");

            System.out.println("sbQuery(getMerchantNotInStatus)----> " + sbQuery);

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.default_merchant_id);
            i++;

            pstm.setString(i, status);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_bank)
                {
                    pstm.setString(i, bank);
                    i++;
                }

                if (val_item == val_branch)
                {
                    pstm.setString(i, branch);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = MerchantUtil.makeMerchantObjectsCollection(rs);

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
    public Collection<Merchant> getMerchantNotInStatusBasicDetails(String status, String bank, String branch)
    {
        Collection<Merchant> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        if (bank == null)
        {
            System.out.println("WARNING : Null bank parameter.");
            return col;
        }

        if (branch == null)
        {
            System.out.println("WARNING : Null branch parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_bank = 1;
            int val_branch = 2;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select mr.MerchantID, mr.MerchantName, mr.MerchantName_Modify, "
                    + "mr.Email, mr.Email_Modify, mr.PrimaryTP, mr.PrimaryTP_Modify, "
                    + "mr.SecondaryTP, mr.SecondaryTP_Modify, mr.Password, mr.Password_Modify, "
                    + "mr.bankcode, bk.FullName as BankName, bk.ShortName, "
                    + "mr.bankcode_Modify, bkm.FullName as BankName_Modify, bk.ShortName as ShortName_Modify, "
                    + "mr.branchcode, br.BranchName, mr.branchcode_Modify,  brm.BranchName as BranchName_Modify, "
                    + "mr.acno as PrimaryACNO, mr.acno_Modify as PrimaryACNO_Modify, "
                    + "mr.acname as PrimaryACName, mr.acname_Modify as PrimaryACName_Modify, "
                    + "mr.id, mr.id_Modify, mr.Status, mr.Status_Modify, mr.CreatedBy, mr.CreatedDate, "
                    + "mr.AuthorizedBy, mr.AuthorizedDate, mr.ModificationRemarks, mr.ModifiedBy, mr.ModifiedDate, "
                    + "mr.ModificationAuthBy, mr.ModificationAuthDate ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm ");
            sbQuery.append("WHERE mr.bankcode = bk.BankCode ");
            sbQuery.append("AND mr.bankcode_Modify = bkm.BankCode ");
            sbQuery.append("AND mr.BankCode = br.BankCode ");
            sbQuery.append("AND mr.branchcode = br.BranchCode ");
            sbQuery.append("AND mr.bankcode_Modify = brm.BankCode ");
            sbQuery.append("AND mr.branchcode_Modify = brm.BranchCode ");
            sbQuery.append("AND mr.MerchantID != ? ");
            sbQuery.append("AND mr.Status NOT IN (?) ");

            if (!bank.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.bankcode = ? ");
                vt.add(val_bank);
            }

            if (!branch.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND mr.branchcode = ? ");
                vt.add(val_branch);
            }

            sbQuery.append("ORDER BY MerchantID ");

            System.out.println("sbQuery(getCorporateCustomerNotInStatus)----> " + sbQuery);
            
            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            pstm.setString(i, DDM_Constants.default_merchant_id);
            i++;

            pstm.setString(i, status);
            i++;

            for (int val_item : vt)
            {
                if (val_item == val_bank)
                {
                    pstm.setString(i, bank);
                    i++;
                }

                if (val_item == val_branch)
                {
                    pstm.setString(i, branch);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = MerchantUtil.makeMerchantObjectsCollectionMinimal(rs);

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
    public Collection<Merchant> getAuthPendingMerchant(String createdUser)
    {
        Collection<Merchant> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select mr.MerchantID, mr.MerchantName, mr.MerchantName_Modify, "
                    + "mr.Email, mr.Email_Modify, mr.PrimaryTP, mr.PrimaryTP_Modify, "
                    + "mr.SecondaryTP, mr.SecondaryTP_Modify, mr.Password, mr.Password_Modify, "
                    + "mr.bankcode, bk.FullName as BankName, bk.ShortName, "
                    + "mr.bankcode_Modify, bkm.FullName as BankName_Modify, bk.ShortName as ShortName_Modify, "
                    + "mr.branchcode, br.BranchName, mr.branchcode_Modify,  brm.BranchName as BranchName_Modify, "
                    + "mr.acno as PrimaryACNO, mr.acno_Modify as PrimaryACNO_Modify, "
                    + "mr.acname as PrimaryACName, mr.acname_Modify as PrimaryACName_Modify, "
                    + "mr.id, mr.id_Modify, mr.Status, mr.Status_Modify, mr.CreatedBy, mr.CreatedDate, "
                    + "mr.AuthorizedBy, mr.AuthorizedDate, mr.ModificationRemarks, mr.ModifiedBy, mr.ModifiedDate, "
                    + "mr.ModificationAuthBy, mr.ModificationAuthDate, "
                    + "mranm.bankcode as ACNOM_Bank, bkanm.FullName as ACNOM_BankName, bkanm.ShortName as ACNOM_ShortName, "
                    + "mranm.branchcode as ACNOM_Branch, branm.BranchName as ACNOM_BranchName, "
                    + "mranm.acno as ACNOM_AccountNo, mranm.acname as ACNOM_AccountName, "
                    + "mranm.isprimary as ACNOM_IsPrimary, "
                    + "mranm.status as ACNOM_Status, mranm.status_modify as ACNOM_StatusModify ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " mranm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkanm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " branm ");
            sbQuery.append("WHERE mr.MerchantID = mranm.merchantid ");
            sbQuery.append("AND mr.bankcode = bk.BankCode ");
            sbQuery.append("AND mr.bankcode_Modify = bkm.BankCode ");
            sbQuery.append("AND mr.BankCode = br.BankCode ");
            sbQuery.append("AND mr.branchcode = br.BranchCode ");
            sbQuery.append("AND mr.bankcode_Modify = brm.BankCode ");
            sbQuery.append("AND mr.branchcode_Modify = brm.BranchCode ");
            sbQuery.append("AND mranm.bankcode = bkanm.BankCode ");
            sbQuery.append("AND mranm.bankcode = branm.BankCode ");
            sbQuery.append("AND mranm.branchcode = branm.BranchCode ");
            sbQuery.append("AND mr.Status = ?  ");
            sbQuery.append("AND mr.CreatedBy != ? ");
            sbQuery.append("ORDER BY MerchantID");

            System.out.println("sbQuery(getAuthPendingCorporateCustomer) -----> " + sbQuery);
            System.out.println("createdUser -----> " + createdUser);

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, DDM_Constants.status_pending);
            pstm.setString(2, createdUser);

            rs = pstm.executeQuery();

            col = MerchantUtil.makeMerchantObjectsCollection(rs);

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
    public Collection<Merchant> getAuthPendingModifiedMerchant(String modifiedUser)
    {
        Collection<Merchant> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select mr.MerchantID, mr.MerchantName, mr.MerchantName_Modify, "
                    + "mr.Email, mr.Email_Modify, mr.PrimaryTP, mr.PrimaryTP_Modify, "
                    + "mr.SecondaryTP, mr.SecondaryTP_Modify, mr.Password, mr.Password_Modify, "
                    + "mr.bankcode, bk.FullName as BankName, bk.ShortName, "
                    + "mr.bankcode_Modify, bkm.FullName as BankName_Modify, bk.ShortName as ShortName_Modify, "
                    + "mr.branchcode, br.BranchName, mr.branchcode_Modify,  brm.BranchName as BranchName_Modify, "
                    + "mr.acno as PrimaryACNO, mr.acno_Modify as PrimaryACNO_Modify, "
                    + "mr.acname as PrimaryACName, mr.acname_Modify as PrimaryACName_Modify, "
                    + "mr.id, mr.id_Modify, mr.Status, mr.Status_Modify, mr.CreatedBy, mr.CreatedDate, "
                    + "mr.AuthorizedBy, mr.AuthorizedDate, mr.ModificationRemarks, mr.ModifiedBy, mr.ModifiedDate, "
                    + "mr.ModificationAuthBy, mr.ModificationAuthDate, "
                    + "mranm.bankcode as ACNOM_Bank, bkanm.FullName as ACNOM_BankName, bkanm.ShortName as ACNOM_ShortName, "
                    + "mranm.branchcode as ACNOM_Branch, branm.BranchName as ACNOM_BranchName, "
                    + "mranm.acno as ACNOM_AccountNo, mranm.acname as ACNOM_AccountName, "
                    + "mranm.isprimary as ACNOM_IsPrimary, "
                    + "mranm.status as ACNOM_Status, mranm.status_modify as ACNOM_StatusModify ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_merchant + " mr, ");
            sbQuery.append(DDM_Constants.tbl_merchant_accno_map + " mranm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bk, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_branch + " brm, ");
            sbQuery.append(DDM_Constants.tbl_bank + " bkanm, ");
            sbQuery.append(DDM_Constants.tbl_branch + " branm ");
            sbQuery.append("WHERE mr.MerchantID = mranm.merchantid ");
            sbQuery.append("AND mr.bankcode = bk.BankCode ");
            sbQuery.append("AND mr.bankcode_Modify = bkm.BankCode ");
            sbQuery.append("AND mr.BankCode = br.BankCode ");
            sbQuery.append("AND mr.branchcode = br.BranchCode ");
            sbQuery.append("AND mr.bankcode_Modify = brm.BankCode ");
            sbQuery.append("AND mr.branchcode_Modify = brm.BranchCode ");
            sbQuery.append("AND mranm.bankcode = bkanm.BankCode ");
            sbQuery.append("AND mranm.bankcode = branm.BankCode ");
            sbQuery.append("AND mranm.branchcode = branm.BranchCode ");
            sbQuery.append("AND mr.ModificationAuthBy is null ");
            sbQuery.append("AND mr.ModifiedBy != ? ");
            sbQuery.append("AND mr.Status != ? ");
            sbQuery.append("ORDER BY MerchantID");

            System.out.println("getAuthPendingModifiedMerchant(sbQuery)=========>" + sbQuery);

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, modifiedUser);
            pstm.setString(2, DDM_Constants.status_pending);

            rs = pstm.executeQuery();

            col = MerchantUtil.makeMerchantObjectsCollection(rs);

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
    public boolean addMerchant(Merchant merchant)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count;

        if (merchant.getMerchantID() == null)
        {
            System.out.println("WARNING : Null getMerchantID parameter.");
            return false;
        }

        if (merchant.getMerchantName() == null)
        {
            System.out.println("WARNING : Null getMerchantName parameter.");
            return false;
        }

        if (merchant.getEmail() == null)
        {
            System.out.println("WARNING : Null getEmail parameter.");
            return false;
        }

        if (merchant.getPrimaryTP() == null)
        {
            System.out.println("WARNING : Null getPrimaryTP parameter.");
            return false;
        }

        if (merchant.getPassword() == null)
        {
            System.out.println("WARNING : Null getPassword parameter.");
            return false;
        }

        if (merchant.getBankCode() == null)
        {
            System.out.println("WARNING : Null getBankCode parameter.");
            return false;
        }

        if (merchant.getBranchCode() == null)
        {
            System.out.println("WARNING : Null getBranchCode parameter.");
            return false;
        }

        if (merchant.getPrimaryAccountNo() == null)
        {
            System.out.println("WARNING : Null getPrimaryAccountNo parameter.");
            return false;
        }

        if (merchant.getPrimaryAccountName() == null)
        {
            System.out.println("WARNING : Null getPrimaryAccountName parameter.");
            return false;
        }

        if (merchant.getId() == null)
        {
            System.out.println("WARNING : Null getId parameter.");
            return false;
        }

        if (merchant.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null getModifiedBy parameter.");
            return false;
        }

        try
        {
            String encPassword = null;

            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

            encPassword = encoder.encode(merchant.getPassword().trim());

            // encPassword = DDM_Constants.default_merchant_pwd_hash;
            System.out.println("Info : encPassword  ======>" + encPassword);

            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_merchant + " ");
            sbQuery.append("(MerchantID, MerchantName, MerchantName_Modify, Email, Email_Modify, "
                    + "PrimaryTP, PrimaryTP_Modify, SecondaryTP, SecondaryTP_Modify, Password, Password_Modify, "
                    + "bankcode, bankcode_Modify, branchcode, branchcode_Modify, acno, acno_Modify, "
                    + "acname, acname_Modify, id, id_Modify, Status, Status_Modify, "
                    + "CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,now(),?,now())");

            System.out.println("addMerchant(sbQuery)=========>" + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, merchant.getMerchantID().trim());

            psmt.setString(2, merchant.getMerchantName().trim());
            psmt.setString(3, merchant.getMerchantName().trim());

            psmt.setString(4, merchant.getEmail().trim());
            psmt.setString(5, merchant.getEmail().trim());

            psmt.setString(6, merchant.getPrimaryTP().trim());
            psmt.setString(7, merchant.getPrimaryTP().trim());

            psmt.setString(8, merchant.getSecondaryTP().trim());
            psmt.setString(9, merchant.getSecondaryTP().trim());

            psmt.setString(10, encPassword);
            psmt.setString(11, encPassword);

            psmt.setString(12, merchant.getBankCode().trim());
            psmt.setString(13, merchant.getBankCode().trim());

            psmt.setString(14, merchant.getBranchCode().trim());
            psmt.setString(15, merchant.getBranchCode().trim());

            psmt.setString(16, merchant.getPrimaryAccountNo().trim());
            psmt.setString(17, merchant.getPrimaryAccountNo().trim());

            psmt.setString(18, merchant.getPrimaryAccountName().trim());
            psmt.setString(19, merchant.getPrimaryAccountName().trim());

            psmt.setString(20, merchant.getId().trim());
            psmt.setString(21, merchant.getId().trim());

            psmt.setString(22, DDM_Constants.status_pending);
            psmt.setString(23, DDM_Constants.status_pending);

            psmt.setString(24, merchant.getModifiedBy().trim());
            psmt.setString(25, merchant.getModifiedBy().trim());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                System.out.println("----> Start addMerchantAccNoMap ");

                if (DAOFactory.getMerchantAccNoMapDAO().addMerchantAccNoMap(new MerchantAccNoMap(merchant.getMerchantID(), merchant.getBankCode(), merchant.getBranchCode(), merchant.getPrimaryAccountNo(), merchant.getPrimaryAccountName(), DDM_Constants.status_yes, DDM_Constants.status_pending, merchant.getModifiedBy().trim())))
                {
                    System.out.println("### addMerchantAccNoMap was Success ####");
                    con.commit();
                    status = true;
                }
                else
                {
                    System.out.println("### addMerchantAccNoMap was Failed ####");
                    status = true;
                    msg = "Adding records to Merchant Acoount Map Failed.";
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
    public boolean modifyMerchant(Merchant merchant)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        String encPassword = null;

        if (merchant.getMerchantID() == null)
        {
            System.out.println("WARNING : Null getMerchantID  parameter.");
            return false;
        }

        if (merchant.getMerchantName() == null)
        {
            System.out.println("WARNING : Null getMerchantName parameter.");
            return false;
        }

        if (merchant.getEmail() == null)
        {
            System.out.println("WARNING : Null getEmail parameter.");
            return false;
        }

        if (merchant.getPrimaryTP() == null)
        {
            System.out.println("WARNING : Null getPrimaryTP parameter.");
            return false;
        }

        if (merchant.getBankCode() == null)
        {
            System.out.println("WARNING : Null getBankCode parameter.");
            return false;
        }

        if (merchant.getBranchCode() == null)
        {
            System.out.println("WARNING : Null getBranchCode parameter.");
            return false;
        }

        if (merchant.getPrimaryAccountNo() == null)
        {
            System.out.println("WARNING : Null getPrimaryAccountNo parameter.");
            return false;
        }

        if (merchant.getPrimaryAccountName() == null)
        {
            System.out.println("WARNING : Null getPrimaryAccountName parameter.");
            return false;
        }

        if (merchant.getId() == null)
        {
            System.out.println("WARNING : Null getId parameter.");
            return false;
        }

        if (merchant.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null getModifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_merchant + " ");
            sbQuery.append("set ");
            sbQuery.append("MerchantName_Modify = ?, ");
            sbQuery.append("Email_Modify = ?, ");
            sbQuery.append("PrimaryTP_Modify = ?, ");
            sbQuery.append("SecondaryTP_Modify = ?, ");
            sbQuery.append("bankcode_Modify = ?, ");
            sbQuery.append("branchcode_Modify = ?, ");
            sbQuery.append("acno_Modify = ?, ");
            sbQuery.append("acname_Modify = ?, ");
            sbQuery.append("id_Modify = ?, ");
            sbQuery.append("Status_Modify = ?, ");
            sbQuery.append("ModificationRemarks = ?, ");

            if (merchant.getPassword() != null)
            {
                sbQuery.append("Password_Modify = ?, ");

                BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

                encPassword = encoder.encode(merchant.getPassword().trim());
            }

            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate = now(), ");
            sbQuery.append("ModificationAuthBy = null, ");
            sbQuery.append("ModificationAuthDate = null ");
            sbQuery.append("where MerchantID = ? ");

            //System.out.println("modifyBank(sbQuery)=====>" + sbQuery.toString());
            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, merchant.getMerchantName());
            psmt.setString(2, merchant.getEmail());
            psmt.setString(3, merchant.getPrimaryTP());
            psmt.setString(4, merchant.getSecondaryTP());
            psmt.setString(5, merchant.getBankCode());
            psmt.setString(6, merchant.getBranchCode());
            psmt.setString(7, merchant.getPrimaryAccountNo());
            psmt.setString(8, merchant.getPrimaryAccountName());
            psmt.setString(9, merchant.getId());
            psmt.setString(10, merchant.getStatus());
            psmt.setString(11, merchant.getModificationRemarks());

            if (merchant.getPassword() != null)
            {
                psmt.setString(12, encPassword);
                psmt.setString(13, merchant.getModifiedBy());
                psmt.setString(14, merchant.getMerchantID());
            }
            else
            {
                psmt.setString(12, merchant.getModifiedBy());
                psmt.setString(13, merchant.getMerchantID());
            }

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
        catch (SQLException | ClassNotFoundException ex)
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
    public boolean doAuthorizedMerchant(Merchant merchant)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (merchant.getMerchantID() == null)
        {
            System.out.println("WARNING : Null getMerchantID  parameter.");
            return false;
        }

        if (merchant.getAuthorizedBy() == null)
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
            sbQuery.append(DDM_Constants.tbl_merchant + " ");
            sbQuery.append("set ");
            sbQuery.append("Status = ?, ");
            sbQuery.append("Status_Modify = ?, ");
            sbQuery.append("AuthorizedBy = ?, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("AuthorizedDate = now(), ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where MerchantID = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(2, DDM_Constants.status_active);
            psmt.setString(3, merchant.getAuthorizedBy());
            psmt.setString(4, merchant.getAuthorizedBy());
            psmt.setString(5, merchant.getMerchantID());

            System.out.println("doAuthorizedMerchant(sbQuery)=====>" + sbQuery.toString());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                if (DAOFactory.getMerchantAccNoMapDAO().doAuthorizedMerchantAccNoMap(new MerchantAccNoMap(merchant.getMerchantID().trim(), merchant.getAuthorizedBy().trim())))
                {
                    System.out.println("### doAuthorizedCorporateCustomerAccNoMap was Success ####");
                    con.commit();
                    status = true;
                }
                else
                {
                    System.out.println("### doAuthorizedCorporateCustomerAccNoMap was Failed ####");
                    status = true;
                    msg = "Authorized records of Merchant Acoount Map Failed.";
                }
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
    public boolean doAuthorizeModifiedMerchant(Merchant merchant)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (merchant.getMerchantID() == null)
        {
            System.out.println("WARNING : Null getMerchantID  parameter.");
            return false;
        }

        if (merchant.getAuthorizedBy() == null)
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
            sbQuery.append(DDM_Constants.tbl_merchant + " ");
            sbQuery.append("set ");
            sbQuery.append("MerchantName = MerchantName_Modify, ");
            sbQuery.append("Email = Email_Modify, ");
            sbQuery.append("PrimaryTP = PrimaryTP_Modify, ");
            sbQuery.append("SecondaryTP = SecondaryTP_Modify, ");
            sbQuery.append("Password = Password_Modify, ");
            sbQuery.append("bankcode = bankcode_Modify, ");
            sbQuery.append("branchcode = branchcode_Modify, ");
            sbQuery.append("acno = acno_Modify, ");
            sbQuery.append("acname = acname_Modify, ");
            sbQuery.append("id = id_Modify, ");
            sbQuery.append("Status = Status_Modify, ");

            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where MerchantID = ? ");

            System.out.println("doAuthorizeModifiedMerchant(sbQuery)=====>" + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, merchant.getAuthorizedBy());
            psmt.setString(2, merchant.getMerchantID());

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
        catch (SQLException | ClassNotFoundException ex)
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

}
