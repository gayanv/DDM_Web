/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.reporttype;

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
public class ReportTypeDAOImpl implements ReportTypeDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    @Override
    public ReportType getReportType(String reportTypeID)
    {
        ReportType lt = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (reportTypeID == null)
        {
            System.out.println("WARNING : Null reportTypeID parameter.");
            return lt;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ReportTypeID, Description, Category, ReferringParty from from ");
            sbQuery.append(DDM_Constants.tbl_reportype + " ");
            sbQuery.append("where ReportTypeID = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, reportTypeID);

            rs = pstm.executeQuery();

            lt = ReportTypeUtil.makeReportTypeObject(rs);

            if (lt == null)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return lt;
    }

    @Override
    public Collection<ReportType> getReportTypes()
    {
        Collection<ReportType> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ReportTypeID, Description, Category, ReferringParty from ");
            sbQuery.append(DDM_Constants.tbl_reportype + " ");
            sbQuery.append("order by Description");

            pstm = con.prepareStatement(sbQuery.toString());

            rs = pstm.executeQuery();

            col = ReportTypeUtil.makeReportTypeObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
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
    public Collection<ReportType> getReportTypes(String category, String refParty)
    {
        Collection<ReportType> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (category == null)
        {
            System.out.println("WARNING : Null category parameter.");
            return col;
        }

        if (refParty == null)
        {
            System.out.println("WARNING : Null refParty parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_category = 1;
            int val_refParty = 2;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ReportTypeID, Description, Category, ReferringParty from ");
            sbQuery.append(DDM_Constants.tbl_reportype + " ");
            sbQuery.append("where ReportTypeID = ReportTypeID");

            if (!category.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND Category = ? ");
                vt.add(val_category);
            }

            if (!refParty.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ReferringParty = ? ");
                vt.add(val_refParty);
            }

            sbQuery.append("order by Description");

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_category)
                {
                    pstm.setString(i, category);
                    i++;
                }
                if (val_item == val_refParty)
                {
                    pstm.setString(i, refParty);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = ReportTypeUtil.makeReportTypeObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (ClassNotFoundException | SQLException e)
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
