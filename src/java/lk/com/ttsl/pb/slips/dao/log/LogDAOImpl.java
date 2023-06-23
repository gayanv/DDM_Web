/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.log;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Vector;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class LogDAOImpl implements LogDAO
{

    String msg = null;

    public String getMsg()
    {
        return msg;
    }

    public Log getLog(long logId)
    {
        Log log = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;


        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select lg.activityid, lg.type, lt.Description, lg.value, lg.processtime from ");
            sbQuery.append(DDM_Constants.tbl_activitylog + " lg, ");
            sbQuery.append(DDM_Constants.tbl_logtype + " lt ");
            sbQuery.append("where lg.type = lt.ID ");
            sbQuery.append("and lg.activityid = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setLong(1, logId);

            rs = pstm.executeQuery();

            log = LogUtil.makeLogObject(rs);

            if (log == null)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (Exception e)
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

        return log;
    }

    public long getRecordCountLogDetails(String type, String logText, String fromLogDate, String toLogDate)
    {

        long recCount = 0;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return recCount;
        }

        if (fromLogDate == null)
        {
            System.out.println("WARNING : Null fromLogDate parameter.");
            return recCount;
        }

        if (toLogDate == null)
        {
            System.out.println("WARNING : Null toLogDate parameter.");
            return recCount;
        }

        try
        {

            Vector<Integer> vt = new Vector();

            int val_type = 1;
            int val_logText = 2;
            int val_fromLogDate = 3;
            int val_toLogDate = 4;


            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select count(*) as rowCount from ");
            sbQuery.append(DDM_Constants.tbl_activitylog + " lg, ");
            sbQuery.append(DDM_Constants.tbl_logtype + " lt ");
            sbQuery.append("where lg.type = lt.ID ");

            if (!type.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and lg.type = ? ");
                vt.add(val_type);
            }

            if (logText != null && logText.length() > 0)
            {
                sbQuery.append("and upper(lg.value) like upper(?) ");
                vt.add(val_logText);
            }

            if (!fromLogDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(lg.processtime, '%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromLogDate);
            }
            if (!toLogDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(lg.processtime, '%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toLogDate);
            }

            //System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    psmt.setString(i, type);
                    i++;
                }

                if (val_item == 2)
                {
                    psmt.setString(i, "%" + logText + "%");
                    i++;
                }

                if (val_item == 3)
                {
                    psmt.setString(i, fromLogDate);
                    i++;
                }
                if (val_item == 4)
                {
                    psmt.setString(i, toLogDate);
                    i++;
                }

            }

            rs = psmt.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                recCount = rs.getLong("rowCount");
            }



        }
        catch (Exception e)
        {
            msg = e.toString();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return recCount;
    }

    @Override
    public Collection<Log> getLogDetails(String type, String logText, String fromLogDate, String toLogDate)
    {

        Collection col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return col;
        }

        if (fromLogDate == null)
        {
            System.out.println("WARNING : Null fromLogDate parameter.");
            return col;
        }

        if (toLogDate == null)
        {
            System.out.println("WARNING : Null toLogDate parameter.");
            return col;
        }

        try
        {

            ArrayList<Integer> vt = new ArrayList();

            int val_type = 1;
            int val_logText = 2;
            int val_fromLogDate = 3;
            int val_toLogDate = 4;


            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select lg.activityid, lg.type, lt.Description, lg.value, lg.processtime from ");
            sbQuery.append(DDM_Constants.tbl_activitylog + " lg, ");
            sbQuery.append(DDM_Constants.tbl_logtype + " lt ");
            sbQuery.append("where lg.type = lt.ID ");

            if (!type.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and lg.type = ? ");
                vt.add(val_type);
            }

            if (logText != null && logText.length() > 0)
            {
                sbQuery.append("and upper(lg.value) like upper(?) ");
                vt.add(val_logText);
            }

            if (!fromLogDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(lg.processtime, '%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromLogDate);
            }
            if (!toLogDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(lg.processtime, '%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toLogDate);
            }

            sbQuery.append("order by processtime");

            //System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    psmt.setString(i, type);
                    i++;
                }

                if (val_item == 2)
                {
                    psmt.setString(i, "%" + logText + "%");
                    i++;
                }

                if (val_item == 3)
                {
                    psmt.setString(i, fromLogDate);
                    i++;
                }
                if (val_item == 4)
                {
                    psmt.setString(i, toLogDate);
                    i++;
                }

            }

            rs = psmt.executeQuery();

            col = LogUtil.makeLogObjectCollection(rs);

        }
        catch (Exception e)
        {
            msg = e.toString();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    public Collection<Log> getLogDetails(String type, String logText, String fromLogDate, String toLogDate, int page, int recordsPrepage)
    {

        Collection col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return col;
        }

        if (fromLogDate == null)
        {
            System.out.println("WARNING : Null fromLogDate parameter.");
            return col;
        }

        if (toLogDate == null)
        {
            System.out.println("WARNING : Null toLogDate parameter.");
            return col;
        }

        try
        {

            Vector<Integer> vt = new Vector();

            int val_type = 1;
            int val_logText = 2;
            int val_fromLogDate = 3;
            int val_toLogDate = 4;


            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select lg.activityid, lg.type, lt.Description, lg.value, lg.processtime from ");
            sbQuery.append(DDM_Constants.tbl_activitylog + " lg, ");
            sbQuery.append(DDM_Constants.tbl_logtype + " lt ");
            sbQuery.append("where lg.type = lt.ID ");

            if (!type.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and lg.type = ? ");
                vt.add(val_type);
            }

            if (logText != null && logText.length() > 0)
            {
                sbQuery.append("and upper(lg.value) like upper(?) ");
                vt.add(val_logText);
            }

            if (!fromLogDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(lg.processtime, '%Y%m%d') >= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_fromLogDate);
            }
            if (!toLogDate.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and DATE_FORMAT(lg.processtime, '%Y%m%d') <= str_to_date(replace(?,'-',''),'%Y%m%d') ");
                vt.add(val_toLogDate);
            }

            sbQuery.append("order by processtime desc ");

            sbQuery.append("limit ?,? ");

            //System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    psmt.setString(i, type);
                    i++;
                }

                if (val_item == 2)
                {
                    psmt.setString(i, "%" + logText + "%");
                    i++;
                }

                if (val_item == 3)
                {
                    psmt.setString(i, fromLogDate);
                    i++;
                }
                if (val_item == 4)
                {
                    psmt.setString(i, toLogDate);
                    i++;
                }

            }

            psmt.setInt(i, (page - 1) * recordsPrepage);
            i++;
            psmt.setInt(i, recordsPrepage);

            rs = psmt.executeQuery();

            col = LogUtil.makeLogObjectCollection(rs);

        }
        catch (Exception e)
        {
            msg = e.toString();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    public boolean addLog(Log log)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;


        if (log == null)
        {
            System.out.println("WARNING : Null log object.");
            return status;
        }

        if (log.getLogType() == null)
        {
            System.out.println("WARNING : Null logType parameter.");
            return status;
        }

        if (log.getLogValue() == null)
        {
            System.out.println("WARNING : Null logValue parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_activitylog + " ");
            sbQuery.append("(type, value, processtime) ");
            sbQuery.append("values (?,?,now())");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, log.getLogType());
            psmt.setString(2, log.getLogValue());

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
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
            System.err.println(e);


        }
        catch (Exception ex)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(ex.getMessage());
            System.err.println(ex);

        }
        finally
        {

            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }
}
