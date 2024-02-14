/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.emailnotificationtype;

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
public class EmailNotificationTypeDAOImpl implements EmailNotificationTypeDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public EmailNotificationType getEmailNotificationType(String id)
    {
        EmailNotificationType ent = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (id == null)
        {
            System.out.println("WARNING : Null id parameter.");
            return ent;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ID, Description, SetBankOnly from ");
            sbQuery.append(DDM_Constants.tbl_emailnotificationtype + " ");
            sbQuery.append("where ID = ?  ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, id);

            rs = pstm.executeQuery();

            ent = EmailNotificationTypeUtil.makeEmailNotificationTypeObject(rs);

            if (ent == null)
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

        return ent;
    }

    @Override
    public Collection<EmailNotificationType> getEmailNotificationTypeDetails()
    {
        Collection<EmailNotificationType> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ID, Description, SetBankOnly from ");
            sbQuery.append(DDM_Constants.tbl_emailnotificationtype);
            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = EmailNotificationTypeUtil.makeEmailNotificationTypeObjectsCollection(rs);

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
    public Collection<EmailNotificationType> getEmailNotificationTypeDetails(String setBankOnly)
    {
        Collection<EmailNotificationType> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (setBankOnly == null)
        {
            System.out.println("WARNING : Null setBankOnly parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ID, Description, SetBankOnly from ");
            sbQuery.append(DDM_Constants.tbl_emailnotificationtype + " ");

            if (!setBankOnly.equals(DDM_Constants.status_all))
            {
                sbQuery.append("where SetBankOnly = ? ");
            }

            pstm = con.prepareStatement(sbQuery.toString());

            if (!setBankOnly.equals(DDM_Constants.status_all))
            {
                pstm.setString(1, setBankOnly);
            }

            rs = pstm.executeQuery();

            col = EmailNotificationTypeUtil.makeEmailNotificationTypeObjectsCollection(rs);

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

}
