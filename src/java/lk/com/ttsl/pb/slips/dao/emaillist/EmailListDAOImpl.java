/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.emaillist;

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
public class EmailListDAOImpl implements EmailListDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public EmailList getEmailMappingDetails(String bankCode, String notificationType)
    {

        EmailList el = null;
        Connection con = null;
        ResultSet rs = null;
        PreparedStatement psmt = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return el;
        }

        if (notificationType == null)
        {
            System.out.println("WARNING : Null notificationType parameter.");
            return el;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select el.bankcode, ba.ShortName, ba.FullName, el.notificationtype, ent.Description, ent.SetBankOnly, el.emailaddress, el.emailaddress_modify, el.status, el.status_modify, el.CreatedBy, el.CreatedDate, el.AuthorizedBy, el.AuthorizedDate, el.ModifiedBy, el.ModifiedDate, el.ModificationAuthBy, el.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_emailnotificationtype + " ent, ");
            sbQuery.append(DDM_Constants.tbl_emaillist + " el ");
            sbQuery.append("where ba.BankCode = el.bankcode ");
            sbQuery.append("and ent.ID = el.notificationtype ");
            sbQuery.append("and el.bankcode = ? ");
            sbQuery.append("and el.notificationtype = ? ");
            sbQuery.append("ORDER BY bankcode, notificationtype");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, bankCode);
            psmt.setString(2, notificationType);

            rs = psmt.executeQuery();
            // col_branch = BranchUtil.makeBranchObjectsCollection(rs);
            el = EmailListUtil.makeEmailListObject(rs);
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
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }
        return el;

    }

    @Override
    public Collection<EmailList> getEmailMappings(String bankCode, String notificationType)
    {

        Collection<EmailList> col = null;
        Connection con = null;
        ResultSet rs = null;
        PreparedStatement psmt = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }

        if (notificationType == null)
        {
            System.out.println("WARNING : Null notificationType parameter.");
            return col;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_bankCode = 1;
            int val_nt = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select el.bankcode, ba.ShortName, ba.FullName, el.notificationtype, ent.Description, ent.SetBankOnly, el.emailaddress, el.emailaddress_modify, el.status, el.status_modify, el.CreatedBy, el.CreatedDate, el.AuthorizedBy, el.AuthorizedDate, el.ModifiedBy, el.ModifiedDate, el.ModificationAuthBy, el.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_emailnotificationtype + " ent, ");
            sbQuery.append(DDM_Constants.tbl_emaillist + " el ");
            sbQuery.append("where ba.BankCode = el.bankcode ");
            sbQuery.append("and ent.ID = el.notificationtype ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and el.bankcode = ? ");
                vt.add(val_bankCode);
            }

            if (!notificationType.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and el.notificationtype = ? ");
                vt.add(val_nt);
            }

            sbQuery.append("ORDER BY bankcode, notificationtype");

            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_bankCode)
                {
                    psmt.setString(i, bankCode);
                    i++;
                }
                if (val_item == val_nt)
                {
                    psmt.setString(i, notificationType);
                    i++;
                }
            }

            rs = psmt.executeQuery();
            // col_branch = BranchUtil.makeBranchObjectsCollection(rs);
            col = EmailListUtil.makeEmailListObjectsCollection(rs);
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
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }
        return col;

    }

    @Override
    public Collection<EmailList> getEmailMappingsByBankAndStatus(String bankCode, String status)
    {

        Collection<EmailList> col = null;
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
            int val_stat = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select el.bankcode, ba.ShortName, ba.FullName, el.notificationtype, ent.Description, ent.SetBankOnly, el.emailaddress, el.emailaddress_modify, el.status, el.status_modify, el.CreatedBy, el.CreatedDate, el.AuthorizedBy, el.AuthorizedDate, el.ModifiedBy, el.ModifiedDate, el.ModificationAuthBy, el.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_emailnotificationtype + " ent, ");
            sbQuery.append(DDM_Constants.tbl_emaillist + " el ");
            sbQuery.append("where ba.BankCode = el.bankcode ");
            sbQuery.append("and ent.ID = el.notificationtype ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and el.bankcode = ? ");
                vt.add(val_bankCode);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and el.status = ? ");
                vt.add(val_stat);
            }

            sbQuery.append("ORDER BY bankcode, notificationtype");

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_bankCode)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == val_stat)
                {
                    pstm.setString(i, status);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = EmailListUtil.makeEmailListObjectsCollection(rs);

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
    public Collection<EmailList> getEmailMappingsNotInStatus(String bankCode, String status)
    {

        Collection<EmailList> col = null;
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
            int val_stat = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select el.bankcode, ba.ShortName, ba.FullName, el.notificationtype, ent.Description, ent.SetBankOnly, el.emailaddress, el.emailaddress_modify, el.status, el.status_modify, el.CreatedBy, el.CreatedDate, el.AuthorizedBy, el.AuthorizedDate, el.ModifiedBy, el.ModifiedDate, el.ModificationAuthBy, el.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_emailnotificationtype + " ent, ");
            sbQuery.append(DDM_Constants.tbl_emaillist + " el ");
            sbQuery.append("where ba.BankCode = el.bankcode ");
            sbQuery.append("and ent.ID = el.notificationtype ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and el.bankcode = ? ");
                vt.add(val_bankCode);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append(" and el.status NOT IN (?) ");
                vt.add(val_stat);
            }

            sbQuery.append("ORDER BY bankcode, notificationtype");

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_bankCode)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == val_stat)
                {
                    pstm.setString(i, status);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = EmailListUtil.makeEmailListObjectsCollection(rs);

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
    public Collection<EmailList> getAuthPendingEmailMappings(String bankCode, String createdUser)
    {
        Collection<EmailList> col = null;
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

            sbQuery.append("select el.bankcode, ba.ShortName, ba.FullName, el.notificationtype, ent.Description, ent.SetBankOnly, el.emailaddress, el.emailaddress_modify, el.status, el.status_modify, el.CreatedBy, el.CreatedDate, el.AuthorizedBy, el.AuthorizedDate, el.ModifiedBy, el.ModifiedDate, el.ModificationAuthBy, el.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_emailnotificationtype + " ent, ");
            sbQuery.append(DDM_Constants.tbl_emaillist + " el ");
            sbQuery.append("where ba.BankCode = el.bankcode ");
            sbQuery.append("and ent.ID = el.notificationtype ");
            sbQuery.append("AND el.bankcode = ? ");
            sbQuery.append("AND el.AuthorizedBy is null ");
            sbQuery.append("AND el.CreatedBy != ? ");
            sbQuery.append("AND el.status = ? ");
            sbQuery.append("ORDER BY bankcode, notificationtype");

            //System.out.println("sbQuery --> " + sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, bankCode);
            pstm.setString(2, createdUser);
            pstm.setString(3, DDM_Constants.status_pending);

            rs = pstm.executeQuery();

            col = EmailListUtil.makeEmailListObjectsCollection(rs);

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
    public Collection<EmailList> getAuthPendingModifiedEmailMappings(String bankCode, String createdUser)
    {
        Collection<EmailList> col = null;
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

            sbQuery.append("select el.bankcode, ba.ShortName, ba.FullName, el.notificationtype, ent.Description, ent.SetBankOnly, el.emailaddress, el.emailaddress_modify, el.status, el.status_modify, el.CreatedBy, el.CreatedDate, el.AuthorizedBy, el.AuthorizedDate, el.ModifiedBy, el.ModifiedDate, el.ModificationAuthBy, el.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_emailnotificationtype + " ent, ");
            sbQuery.append(DDM_Constants.tbl_emaillist + " el ");
            sbQuery.append("where ba.BankCode = el.bankcode ");
            sbQuery.append("and ent.ID = el.notificationtype ");
            sbQuery.append("AND el.bankcode = ? ");
            sbQuery.append("AND el.ModificationAuthBy is null ");
            sbQuery.append("AND el.ModifiedBy != ? ");
            sbQuery.append("AND el.status != ? ");
            sbQuery.append("ORDER BY bankcode, notificationtype");

            //System.out.println("sbQuery(getAuthPendingModifiedEmailMappings)=======> " + sbQuery.toString());
            
            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, bankCode);
            pstm.setString(2, createdUser);
            pstm.setString(3, DDM_Constants.status_pending);

            rs = pstm.executeQuery();

            col = EmailListUtil.makeEmailListObjectsCollection(rs);

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
    public boolean addEmailMapping(EmailList emailList)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count;

        if (emailList.getBankCode() == null)
        {
            System.out.println("WARNING : Null getBankCode parameter.");
            return false;
        }

        if (emailList.getNotificationType() == null)
        {
            System.out.println("WARNING : Null getNotificationType parameter.");
            return false;
        }

        if (emailList.getEmailAddress() == null)
        {
            System.out.println("WARNING : Null getEmailAddress parameter.");
            return false;
        }

        if (emailList.getStatus() == null)
        {
            System.out.println("WARNING : Null getStatus parameter.");
            return false;
        }

        if (emailList.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null getModifiedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_emaillist + " ");
            sbQuery.append("(bankcode,notificationtype,emailaddress,status,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) ");
            sbQuery.append("values (?,?,?,?,?,now(),?,now())");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, emailList.getBankCode());
            psmt.setString(2, emailList.getNotificationType());
            psmt.setString(3, emailList.getEmailAddress());
            psmt.setString(4, emailList.getStatus());
            psmt.setString(5, emailList.getModifiedBy());
            psmt.setString(6, emailList.getModifiedBy());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                status = true;
            }
            else
            {
                status = false;
                msg = "The specified e-mail mapping is already added.(" + DDM_Constants.msg_duplicate_records + ") <br/>Please use 'Modify E-mail Mappings' to add new e-mails.";
                
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
    public boolean updateAllEmailMappingStatus(String bankCode, String status, String modifiedBy)
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
            sbQuery.append(DDM_Constants.tbl_emaillist + " ");
            sbQuery.append("set ");
            sbQuery.append("status = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()) ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("where bankcode = ? ");
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
    public boolean modifyEmailMappings(EmailList emailList)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (emailList.getBankCode() == null)
        {
            System.out.println("WARNING : Null getBankCode parameter.");
            return false;
        }

        if (emailList.getNotificationType() == null)
        {
            System.out.println("WARNING : Null getNotificationType parameter.");
            return false;
        }

        if (emailList.getEmailAddress() == null)
        {
            System.out.println("WARNING : Null getEmailAddress parameter.");
            return false;
        }

        if (emailList.getStatus() == null)
        {
            System.out.println("WARNING : Null getStatus parameter.");
            return false;
        }

        if (emailList.getModifiedBy() == null)
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
            sbQuery.append(DDM_Constants.tbl_emaillist + " ");
            sbQuery.append("set ");
            sbQuery.append("emailaddress_modify = ?, ");
            sbQuery.append("status_modify = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()), ");
            sbQuery.append("ModificationAuthBy = null ");
            sbQuery.append("where bankcode = ? ");
            sbQuery.append("and notificationtype = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, emailList.getEmailAddress());
            psmt.setString(2, emailList.getStatus());
            psmt.setString(3, emailList.getModifiedBy());
            psmt.setString(4, emailList.getBankCode());
            psmt.setString(5, emailList.getNotificationType());

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
    public boolean doAuthorizeEmailMappings(EmailList emailList)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (emailList.getBankCode() == null)
        {
            System.out.println("WARNING : Null getBankCode parameter.");
            return false;
        }

        if (emailList.getNotificationType() == null)
        {
            System.out.println("WARNING : Null getNotificationType parameter.");
            return false;
        }

        if (emailList.getAuthorizedBy() == null)
        {
            System.out.println("WARNING : Null getAuthorizedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_emaillist + " ");
            sbQuery.append("set ");
            sbQuery.append("status = ?, ");
            sbQuery.append("AuthorizedBy = ?, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("AuthorizedDate =(select NOW()) ");
            sbQuery.append("where bankcode = ? ");
            sbQuery.append("and notificationtype = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(2, emailList.getAuthorizedBy());
            psmt.setString(3, emailList.getAuthorizedBy());
            psmt.setString(4, emailList.getBankCode());
            psmt.setString(5, emailList.getNotificationType());

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
    public boolean doAuthorizeModifiedEmailMappings(EmailList emailList)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (emailList.getBankCode() == null)
        {
            System.out.println("WARNING : Null getBankCode parameter.");
            return false;
        }

        if (emailList.getNotificationType() == null)
        {
            System.out.println("WARNING : Null getNotificationType parameter.");
            return false;
        }

        if (emailList.getAuthorizedBy() == null)
        {
            System.out.println("WARNING : Null getAuthorizedBy parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_emaillist + " ");
            sbQuery.append("set ");
            sbQuery.append("emailaddress = emailaddress_modify, ");
            sbQuery.append("status = status_modify, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where bankcode = ? ");
            sbQuery.append("and notificationtype = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, emailList.getAuthorizedBy());
            psmt.setString(2, emailList.getBankCode());
            psmt.setString(3, emailList.getNotificationType());

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
