/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.branch;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.bank.Bank;

/**
 *
 * @author Dinesh
 */
public class BranchDAOImpl implements BranchDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public Branch getBranchDetails(String bankCode, String branchCode)
    {

        Branch branch = null;
        Connection con = null;
        ResultSet rs = null;
        PreparedStatement psmt = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return branch;
        }

        if (branchCode == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return branch;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_bankCode = 1;
            int val_branchCode = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchName_Modify, br.BranchStatus, br.BranchStatus_Modify, br.CreatedBy, br.CreatedDate, br.AuthorizedBy, br.AuthorizedDate, br.ModifiedBy, br.ModifiedDate, br.ModificationAuthBy, br.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and br.BankCode = ? ");
                vt.add(val_bankCode);
            }

            if (!branchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and br.BranchCode = ? ");
                vt.add(val_branchCode);
            }

            sbQuery.append("ORDER BY BankCode, BranchCode");

            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    psmt.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    psmt.setString(i, branchCode);
                    i++;
                }
            }

            rs = psmt.executeQuery();
            // col_branch = BranchUtil.makeBranchObjectsCollection(rs);
            branch = BranchUtil.makeBranchObject(rs);
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());

        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }
        return branch;

    }

    @Override
    public Collection<Branch> getBranch(String bankCode)
    {

        Collection<Branch> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bank parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchName_Modify, br.BranchStatus, br.BranchStatus_Modify, br.CreatedBy, br.CreatedDate, br.AuthorizedBy, br.AuthorizedDate, br.ModifiedBy, br.ModifiedDate, br.ModificationAuthBy, br.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");
            sbQuery.append("and br.BankCode = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, bankCode);

            rs = pstm.executeQuery();

            col = BranchUtil.makeBranchObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());

        }
        catch (ClassNotFoundException e)
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
    public Collection<Branch> getBranch(String bankCode, String status)
    {

        Collection<Branch> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_bankCode = 1;
            int val_status = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchName_Modify, br.BranchStatus, br.BranchStatus_Modify, br.CreatedBy, br.CreatedDate, br.AuthorizedBy, br.AuthorizedDate, br.ModifiedBy, br.ModifiedDate, br.ModificationAuthBy, br.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and br.BankCode = ? ");
                vt.add(val_bankCode);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and br.BranchStatus = ? ");
                vt.add(val_status);
            }

            sbQuery.append("ORDER BY BankCode, BranchCode");

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, status);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = BranchUtil.makeBranchObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());

        }
        catch (ClassNotFoundException e)
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
    public Collection<Branch> getBranchNotInStatus(String bankCode, String status)
    {

        Collection<Branch> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_bankCode = 1;
            int val_status = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchName_Modify, br.BranchStatus, br.BranchStatus_Modify, br.CreatedBy, br.CreatedDate, br.AuthorizedBy, br.AuthorizedDate, br.ModifiedBy, br.ModifiedDate, br.ModificationAuthBy, br.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and br.BankCode = ? ");
                vt.add(val_bankCode);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and br.BranchStatus NOT IN (?) ");
                vt.add(val_status);
            }

            sbQuery.append("ORDER BY BankCode, BranchCode");

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, status);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = BranchUtil.makeBranchObjectsCollection(rs);

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
    public Collection<Bank> getBanksListOfAuthPendingBranches(String createdUser)
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (createdUser == null)
        {
            System.out.println("WARNING : Null createdUser parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");
            sbQuery.append("AND br.AuthorizedBy is null ");
            sbQuery.append("AND br.CreatedBy != ? ");
            sbQuery.append("AND br.BranchStatus = ? ");
            sbQuery.append("GROUP BY br.BankCode ");
            sbQuery.append("ORDER BY BankCode");

            //System.out.println("sbQuery --> " + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, createdUser);
            pstm.setString(2, DDM_Constants.status_pending);

            rs = pstm.executeQuery();

            col = BranchUtil.makeBankObjectsCollection(rs);

            if (col == null || col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());

        }
        catch (ClassNotFoundException e)
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
    public Collection<Branch> getAuthPendingBranches(String bankCode, String createdUser)
    {
        Collection<Branch> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (createdUser == null)
        {
            System.out.println("WARNING : Null createdUser parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchName_Modify, br.BranchStatus, br.BranchStatus_Modify, br.CreatedBy, br.CreatedDate, br.AuthorizedBy, br.AuthorizedDate, br.ModifiedBy, br.ModifiedDate, br.ModificationAuthBy, br.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND br.BankCode = ? ");
            }

            sbQuery.append("AND br.AuthorizedBy is null ");
            sbQuery.append("AND br.CreatedBy != ? ");
            sbQuery.append("AND br.BranchStatus = ? ");
            sbQuery.append("ORDER BY BankCode, BranchCode");

            //System.out.println("sbQuery --> " + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                pstm.setString(1, bankCode);
                pstm.setString(2, createdUser);
                pstm.setString(3, DDM_Constants.status_pending);
            }
            else
            {
                pstm.setString(1, createdUser);
                pstm.setString(2, DDM_Constants.status_pending);
            }

            rs = pstm.executeQuery();

            col = BranchUtil.makeBranchObjectsCollection(rs);

            if (col == null || col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());

        }
        catch (ClassNotFoundException e)
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

    public Collection<Bank> getBanksListOfAuthPendingModifiedBranches(String createdUser)
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (createdUser == null)
        {
            System.out.println("WARNING : Null createdUser parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");
            sbQuery.append("AND br.ModificationAuthBy is null ");
            sbQuery.append("AND br.ModifiedBy != ? ");
            sbQuery.append("AND br.BranchStatus != ? ");
            sbQuery.append("GROUP BY br.BankCode ");
            sbQuery.append("ORDER BY BankCode");

            //System.out.println("sbQuery --> " + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, createdUser);
            pstm.setString(2, DDM_Constants.status_pending);

            rs = pstm.executeQuery();

            col = BranchUtil.makeBankObjectsCollection(rs);

            if (col == null || col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());

        }
        catch (ClassNotFoundException e)
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
    public Collection<Branch> getAuthPendingModifiedBranches(String bankCode, String createdUser)
    {
        Collection<Branch> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (createdUser == null)
        {
            System.out.println("WARNING : Null createdUser parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchName_Modify, br.BranchStatus, br.BranchStatus_Modify, br.CreatedBy, br.CreatedDate, br.AuthorizedBy, br.AuthorizedDate, br.ModifiedBy, br.ModifiedDate, br.ModificationAuthBy, br.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br ");
            sbQuery.append("where ba.BankCode = br.BankCode ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND br.BankCode = ? ");
            }

            sbQuery.append("AND br.ModificationAuthBy is null ");
            sbQuery.append("AND br.ModifiedBy != ? ");
            sbQuery.append("AND br.BranchStatus != ? ");
            sbQuery.append("ORDER BY BankCode, BranchCode");

            //System.out.println("sbQuery(getAuthPendingModifiedBranches)=======> " + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                pstm.setString(1, bankCode);
                pstm.setString(2, createdUser);
                pstm.setString(3, DDM_Constants.status_pending);
            }
            else
            {
                pstm.setString(1, createdUser);
                pstm.setString(2, DDM_Constants.status_pending);
            }

            rs = pstm.executeQuery();

            col = BranchUtil.makeBranchObjectsCollection(rs);

            if (col == null || col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());

        }
        catch (ClassNotFoundException e)
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
    public boolean addBranch(Branch branch)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count = 0;

        if (branch.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (branch.getBranchCode() == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return false;
        }

        if (branch.getBranchName() == null)
        {
            System.out.println("WARNING : Null branchName parameter.");
            return false;
        }

        if (branch.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (branch.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_branch + " ");
            sbQuery.append("(BankCode,BranchCode,BranchName,BranchStatus,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,now(),?,now())");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, branch.getBankCode());
            psmt.setString(2, branch.getBranchCode());
            psmt.setString(3, branch.getBranchName());
            psmt.setString(4, branch.getStatus());
            psmt.setString(5, branch.getModifiedBy());
            psmt.setString(6, branch.getModifiedBy());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                status = true;
            }
            else
            {
                status = false;
                msg = DDM_Constants.msg_duplicate_records;
            }
        }
        catch (SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        catch (ClassNotFoundException e)
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
    public boolean addBranchWithBankBranchFile(Branch branch)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count = 0;

        if (branch.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (branch.getBranchCode() == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return false;
        }

        if (branch.getBranchName() == null)
        {
            System.out.println("WARNING : Null branchName parameter.");
            return false;
        }

        if (branch.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (branch.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        if (branch.getAuthorizedBy() == null)
        {
            System.out.println("WARNING : Null authorizedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_branch + " ");
            sbQuery.append("(BankCode,BranchCode,BranchName,BranchStatus,ModifiedBy,ModifiedDate,AuthorizedBy,AuthorizedDate) ");
            sbQuery.append("values (?,?,?,?,?,now(),?,now()) ");
            sbQuery.append("ON DUPLICATE KEY UPDATE ");
            sbQuery.append("BranchName = ?, BranchStatus = ?, ModifiedBy = ?, ModifiedDate = now() ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, branch.getBankCode());
            psmt.setString(2, branch.getBranchCode());
            psmt.setString(3, branch.getBranchName());
            psmt.setString(4, branch.getStatus());
            psmt.setString(5, branch.getModifiedBy());
            psmt.setString(6, branch.getAuthorizedBy());
            psmt.setString(7, branch.getBranchName());
            psmt.setString(8, branch.getStatus());
            psmt.setString(9, branch.getModifiedBy());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                status = true;
            }
            else
            {
                status = false;
                msg = DDM_Constants.msg_duplicate_records;
            }
        }
        catch (SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        catch (ClassNotFoundException e)
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
    public boolean updateAllBranchStatus(String bankCode, String status, String modifiedBy)
    {
        boolean stat = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (modifiedBy == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_branch + " ");
            sbQuery.append("set ");
            sbQuery.append("BranchStatus = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()) ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("where BankCode = ? ");
            }

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, status);
            psmt.setString(2, modifiedBy);

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                psmt.setString(3, bankCode);
            }

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit();
                stat = true;
            }
            else
            {
                con.rollback();
            }

        }
        catch (SQLException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        catch (ClassNotFoundException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return stat;
    }

    @Override
    public boolean modifyBranch(Branch branch)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (branch.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (branch.getBranchCode() == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return false;
        }

        if (branch.getBranchName() == null)
        {
            System.out.println("WARNING : Null branchName parameter.");
            return false;
        }

        if (branch.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (branch.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_branch + " ");
            sbQuery.append("set ");
            sbQuery.append("BranchName_Modify = ?, ");
            sbQuery.append("BranchStatus_Modify = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()), ");
            sbQuery.append("ModificationAuthBy = null ");
            sbQuery.append("where BankCode = ? ");
            sbQuery.append("and BranchCode = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, branch.getBranchName());
            psmt.setString(2, branch.getStatus());
            psmt.setString(3, branch.getCreatedBy() != null ? branch.getCreatedBy() : branch.getModifiedBy());
            psmt.setString(4, branch.getBankCode());
            psmt.setString(5, branch.getBranchCode());

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
        catch (SQLException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        catch (ClassNotFoundException ex)
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
    public boolean doAuthorizedBranch(Branch branch)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (branch.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (branch.getBranchCode() == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return false;
        }

        if (branch.getAuthorizedBy() == null)
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
            sbQuery.append(DDM_Constants.tbl_branch + " ");
            sbQuery.append("set ");
            sbQuery.append("BranchStatus = ?, ");
            sbQuery.append("AuthorizedBy = ?, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("AuthorizedDate = now() ");
            sbQuery.append("where BankCode = ? ");
            sbQuery.append("and BranchCode = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(2, branch.getAuthorizedBy());
            psmt.setString(3, branch.getAuthorizedBy());
            psmt.setString(4, branch.getBankCode());
            psmt.setString(5, branch.getBranchCode());

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
        catch (SQLException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        catch (ClassNotFoundException ex)
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
    public boolean doAuthorizedModifiedBranch(Branch branch)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (branch.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (branch.getBranchCode() == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return false;
        }

        if (branch.getAuthorizedBy() == null)
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
            sbQuery.append(DDM_Constants.tbl_branch + " ");
            sbQuery.append("set ");
            sbQuery.append("BranchName = BranchName_Modify, ");
            sbQuery.append("BranchStatus = BranchStatus_Modify, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where BankCode = ? ");
            sbQuery.append("and BranchCode = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, branch.getAuthorizedBy());
            psmt.setString(2, branch.getBankCode());
            psmt.setString(3, branch.getBranchCode());

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
        catch (SQLException ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
        }
        catch (ClassNotFoundException ex)
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
