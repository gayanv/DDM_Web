/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.bank;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class BankDAOImpl implements BankDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public Bank getBankDetails(String bankCode)
    {
        Bank bank = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return bank;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode, ShortName, ShortName_Modify, FullName, FullName_Modify, BankStatus, "
                    + "BankStatus_Modify, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, "
                    + "AuthorizedBy, AuthorizedDate, ModificationAuthBy, ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_bank + " ");
            sbQuery.append("WHERE BankCode = ?  ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, bankCode);

            rs = pstm.executeQuery();

            bank = BankUtil.makeBankObject(rs);

            if (bank == null)
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

        return bank;
    }

    @Override
    public Collection<Bank> getBank()
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode, ShortName, ShortName_Modify, FullName, FullName_Modify, BankStatus,"
                    + "BankStatus_Modify, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, "
                    + "AuthorizedBy, AuthorizedDate, ModificationAuthBy, ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_bank + " ");
            sbQuery.append("ORDER BY BankCode ");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = BankUtil.makeBankObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException e)
        {

            System.out.println(e.getMessage());
        }
        catch (ClassNotFoundException e)
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
    public Collection<Bank> getBank(String status)
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode, ShortName, ShortName_Modify, FullName, FullName_Modify, BankStatus,"
                    + "BankStatus_Modify, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, "
                    + "AuthorizedBy, AuthorizedDate, ModificationAuthBy, ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_bank + " ");

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("WHERE BankStatus = ?  ");
            }

            sbQuery.append("ORDER BY BankCode");

            // System.out.println(" sbQuery-"+ sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            if (!status.equals(DDM_Constants.status_all))
            {
                pstm.setString(1, status);
            }

            rs = pstm.executeQuery();

            col = BankUtil.makeBankObjectsCollection(rs);

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
    public Collection<Bank> getBankNotInStatus(String status)
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode, ShortName, ShortName_Modify, FullName, FullName_Modify, BankStatus,"
                    + "BankStatus_Modify, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, "
                    + "AuthorizedBy, AuthorizedDate, ModificationAuthBy, ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_bank + " ");
            sbQuery.append("WHERE BankStatus NOT IN (?) ");
            sbQuery.append("ORDER BY BankCode");

            // System.out.println(" sbQuery-"+ sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, status);

            rs = pstm.executeQuery();

            col = BankUtil.makeBankObjectsCollection(rs);

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
    public Collection<Bank> getAuthPendingBank(String createdUser)
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode, ShortName, ShortName_Modify, FullName, FullName_Modify, BankStatus,"
                    + "BankStatus_Modify, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, "
                    + "AuthorizedBy, AuthorizedDate, ModificationAuthBy, ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_bank + " ");
            sbQuery.append("WHERE BankStatus = ? ");
            sbQuery.append("AND ModifiedBy != ? ");
            sbQuery.append("ORDER BY BankCode");

            System.out.println("sbQuery -----> " + sbQuery);
            System.out.println("createdUser -----> " + createdUser);

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, DDM_Constants.status_pending);
            pstm.setString(2, createdUser);

            rs = pstm.executeQuery();

            col = BankUtil.makeBankObjectsCollection(rs);

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
    public Collection<Bank> getAuthPendingModifiedBank(String modifiedUser)
    {
        Collection<Bank> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT BankCode, ShortName, ShortName_Modify, FullName, FullName_Modify, BankStatus,"
                    + "BankStatus_Modify, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, "
                    + "AuthorizedBy, AuthorizedDate, ModificationAuthBy, ModificationAuthDate FROM ");
            sbQuery.append(DDM_Constants.tbl_bank + " ");
            sbQuery.append("WHERE ModificationAuthBy is null ");
            sbQuery.append("AND ModifiedBy != ? ");
            sbQuery.append("AND BankStatus != ? ");
            sbQuery.append("ORDER BY BankCode");

            //System.out.println("getAuthPendingModifiedBank(sbQuery)=========>" + sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, modifiedUser);
            pstm.setString(2, DDM_Constants.status_pending);

            rs = pstm.executeQuery();

            col = BankUtil.makeBankObjectsCollection(rs);

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
    public boolean addBank(Bank bank)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count;

        if (bank.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (bank.getShortName() == null)
        {
            System.out.println("WARNING : Null shortName parameter.");
            return false;
        }

        if (bank.getBankFullName() == null)
        {
            System.out.println("WARNING : Null bankFullName parameter.");
            return false;
        }

        if (bank.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_bank + " ");
            sbQuery.append("(BankCode,ShortName,FullName,BankStatus,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,now(),?,now())");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, bank.getBankCode().trim());
            psmt.setString(2, bank.getShortName().trim());
            psmt.setString(3, bank.getBankFullName().trim());
            psmt.setString(4, bank.getStatus());
            psmt.setString(5, bank.getModifiedBy());
            psmt.setString(6, bank.getModifiedBy());

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
    public boolean modifyBank(Bank bank)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (bank.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (bank.getShortName() == null)
        {
            System.out.println("WARNING : Null shortName parameter.");
            return false;
        }

        if (bank.getBankFullName() == null)
        {
            System.out.println("WARNING : Null bankFullName parameter.");
            return false;
        }

        if (bank.getStatus() == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return false;
        }

        if (bank.getModifiedBy() == null)
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
            sbQuery.append(DDM_Constants.tbl_bank + " ");
            sbQuery.append("set ");
            sbQuery.append("ShortName_Modify = ?, ");
            sbQuery.append("FullName_Modify = ?, ");
            sbQuery.append("BankStatus_Modify = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate = now(), ");
            sbQuery.append("ModificationAuthBy = null, ");
            sbQuery.append("ModificationAuthDate = null ");
            sbQuery.append("where BankCode = ? ");

            //System.out.println("modifyBank(sbQuery)=====>" + sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, bank.getShortName());
            psmt.setString(2, bank.getBankFullName());
            psmt.setString(3, bank.getStatus());
            psmt.setString(4, bank.getModifiedBy());
            psmt.setString(5, bank.getBankCode());

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
    public boolean doAuthorizedBank(Bank bank)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (bank.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (bank.getAuthorizedBy() == null)
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
            sbQuery.append(DDM_Constants.tbl_bank + " ");
            sbQuery.append("set ");
            sbQuery.append("BankStatus = ?, ");
            sbQuery.append("BankStatus_Modify = ?, ");
            sbQuery.append("AuthorizedBy = ?, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("AuthorizedDate = now(), ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where BankCode = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(2, DDM_Constants.status_active);
            psmt.setString(3, bank.getAuthorizedBy());
            psmt.setString(4, bank.getAuthorizedBy());
            psmt.setString(5, bank.getBankCode());

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
        catch (NumberFormatException ex)
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
    public boolean doAuthorizeModifiedBank(Bank bank)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (bank.getBankCode() == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return false;
        }

        if (bank.getAuthorizedBy() == null)
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
            sbQuery.append(DDM_Constants.tbl_bank + " ");
            sbQuery.append("set ");
            sbQuery.append("ShortName = ShortName_Modify, ");
            sbQuery.append("FullName = FullName_Modify, ");
            sbQuery.append("BankStatus = BankStatus_Modify, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where BankCode = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, bank.getAuthorizedBy());
            psmt.setString(2, bank.getBankCode());

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
