/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.executionBatchHistory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.executionBatch.ExecutionBatch;

/**
 *
 * @author dinesh
 */
public class ExecutionBatchHistoryDAOImpl implements ExecutionBatchHistoryDAO
{

    String msg = null;
    //Hashtable fail_Query = null;
    //Hashtable success_Query = null;

    public String getMsg()
    {
        return msg;
    }

    public Collection<ExecutionBatchHistory> getExecutionBatch()
    {

        Collection<ExecutionBatchHistory> exeBatch_col = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;
        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select A.batchid, A.batchname,B.StatusId,B.StatusDesc as Status,");
            sbQuery.append("A.starttime,A.endtime,A.executedby,A.module from ");
            sbQuery.append(DDM_Constants.tbl_executionbatch + " A, ");
            sbQuery.append(DDM_Constants.tbl_executionbatchstatus + " B ");
            sbQuery.append("where A.Status =  B.StatusId" + " ");
            sbQuery.append("order by  A.batchname");
//            sbQuery.append("union ");
//            sbQuery.append("select batchid, batchname, N/A  as StatusId ,Status, ");
//            sbQuery.append("starttime,endtime,executedby,module from ");
//            sbQuery.append(DDM_Constants.tbl_executionbatch);
//                     sbQuery.append("where Status is null ");
//           sbQuery.append("order by  batchname ,status ");

            psmt = con.prepareStatement(sbQuery.toString());

            rs = psmt.executeQuery();

            exeBatch_col = ExecutionBatchHistoryUtil.makeExeBatchObjectCollection(rs);

            if (exeBatch_col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }

            return exeBatch_col;

        }
        catch (SQLException ex)
        {
            System.out.println(ex.toString());
        }
        catch (ClassNotFoundException ex)
        {
            System.out.println(ex.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }
        return exeBatch_col;

    }

    @Override
    public Collection<ExecutionBatchHistory> getExecutionBatchHistory(String exeBatchId,
            String status, String fromBusinessDate, String toBusinessDate)
    {

        Collection col_history = null;
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (exeBatchId == null)
        {
            // paramId=DDM_Constants.status_all;
            System.out.println("WARNING : Null paraName parameter.");
            return col_history;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col_history;
        }

        if (fromBusinessDate == null)
        {
            //  fromBusinessDate=DDM_Constants.status_all;
            System.out.println("WARNING : Null fromBusinessDate parameter.");
            return col_history;
        }
        if (toBusinessDate == null)
        {
            // toBusinessDate=DDM_Constants.status_all;
            System.out.println("WARNING : Null toBusinessDate parameter.");
            return col_history;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select eh.batchid,e.batchname,eh.NewStatus,eh.PreviousStatus,eh.starttime,");
            sbQuery.append("eh.endtime,eh.executedby,eh.module,eh.ModifiedBy,eh.ModifiedDate from ");
            sbQuery.append(DDM_Constants.tbl_executionbatchhistory + " eh,");
            sbQuery.append(DDM_Constants.tbl_executionbatch + " e ");
            sbQuery.append("where eh.batchid=e.batchid ");


            /*select eh.batchid,e.batchname,eh.NewStatus,eh.starttime,eh.PreviousStatus
             eh.endtime, eh.executedby ,  eh.ModifiedBy ,   eh.ModifiedDate
             from tbl_executionbatchhistory eh ,tbl_executionbatch e
             where  eh.batchid=e.batchid
             */
            int i = 0;

            if (!exeBatchId.equals(DDM_Constants.status_all))
            {

                sbQuery.append("and eh.batchid = ? ");
                i = i + 1;

            }

            if (!fromBusinessDate.equals(DDM_Constants.status_all))
            {

                sbQuery.append("and eh.ModifiedDate>=DATE_FORMAT(date(?),'%Y%m%d') ");
                i = i + 2;

            }

            if (!toBusinessDate.equals(DDM_Constants.status_all))
            {

                sbQuery.append("and eh.ModifiedDate<=DATE_FORMAT(date(?),'%Y%m%d') ");
                i = i + 4;
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and eh.NewStatus=? ");
                i = i + 8;

            }
            sbQuery.append("order by eh.ModifiedDate desc");
            // sbQuery.append("order by e.batchname");

            System.out.println(sbQuery.toString());

            psmt = con.prepareStatement(sbQuery.toString());

            switch (i)
            {
                case 1:
                    psmt.setString(1, exeBatchId);
                    break;
                case 2:
                    psmt.setString(1, fromBusinessDate);
                    break;
                case 3:
                    psmt.setString(1, exeBatchId);
                    psmt.setString(2, fromBusinessDate);
                    break;
                case 4:
                    psmt.setString(1, toBusinessDate);
                    break;
                case 5:
                    psmt.setString(1, exeBatchId);
                    psmt.setString(2, toBusinessDate);
                    break;
                case 6:
                    psmt.setString(1, fromBusinessDate);
                    psmt.setString(2, toBusinessDate);
                    break;
                case 7:
                    psmt.setString(1, exeBatchId);
                    psmt.setString(2, fromBusinessDate);
                    psmt.setString(3, toBusinessDate);
                    break;

                case 8:
                    psmt.setString(1, status);
                    break;

                case 9:
                    psmt.setString(1, exeBatchId);
                    psmt.setString(2, status);
                    break;

                case 10:
                    psmt.setString(1, fromBusinessDate);
                    psmt.setString(2, status);
                    break;

                case 11:
                    psmt.setString(1, exeBatchId);
                    psmt.setString(2, fromBusinessDate);
                    psmt.setString(3, status);
                    break;

                case 12:
                    psmt.setString(1, toBusinessDate);
                    psmt.setString(2, status);
                    break;

                case 13:
                    psmt.setString(1, exeBatchId);
                    psmt.setString(2, toBusinessDate);
                    psmt.setString(3, status);
                    break;

                case 14:
                    psmt.setString(1, fromBusinessDate);
                    psmt.setString(2, toBusinessDate);
                    psmt.setString(3, status);
                    break;

                case 15:
                    psmt.setString(1, exeBatchId);
                    psmt.setString(2, fromBusinessDate);
                    psmt.setString(3, toBusinessDate);
                    psmt.setString(4, status);
                    break;
            }

            rs = psmt.executeQuery();

            col_history = ExecutionBatchHistoryUtil.makeExeBatchObjectCollection(rs);

            if (col_history.isEmpty())
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
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }
        return col_history;

    }

    @Override
    public boolean update(Collection<ExecutionBatch> col_exec)
    {
        boolean result_query = false;

        try
        {
            if (!col_exec.isEmpty())
            {
                for (ExecutionBatch exec : col_exec)
                {
                    result_query = update(exec);
                    //  System.out.println("result_query--->" + result_query);
                }
            }
        }
        catch (Exception e)
        {
            System.out.println(e.toString());
        }
        return result_query;
    }

    private boolean update(ExecutionBatch exec)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);
            StringBuilder sbQuery = new StringBuilder();

            // String PreviousStatus = get_NewStatus(exec.getBatchId());
            if (exec.getBatchId().length() > 0)
            {
                System.out.println(exec.getCurrentStatus());
                sbQuery.append("insert into ");
                sbQuery.append(DDM_Constants.tbl_executionbatchhistory + " ");
                sbQuery.append("(batchid,NewStatus,executedby,module,ModifiedBy,");
                sbQuery.append("ModifiedDate,PreviousStatus) ");
                sbQuery.append("values ");
                sbQuery.append("(?,?,?,?,?,(select NOW()),? )");

                psmt = con.prepareStatement(sbQuery.toString());

                psmt.setString(1, exec.getBatchId());
                psmt.setString(2, exec.getStatus());
                psmt.setString(3, exec.getExecutedBy());
                psmt.setString(4, exec.getModule());
                psmt.setString(5, exec.getModifiedby());
                psmt.setString(6, exec.getCurrentStatus());

                System.out.println(sbQuery.toString());

                //  System.out.println(exec.getExecutedBy());
                //  System.out.println(exec.getCurrentStatus());
                count = psmt.executeUpdate();

                if (count > 0)
                {
                    con.commit();
                    System.out.println("commit");
                    query_status = true;
                }
                else
                {
                    System.out.println("rollback");
                    con.rollback();
                }
            }
            else
            {
                query_status = true;
            }

        }
        catch (SQLException e)
        {
            System.out.println(e.toString());
        }
        catch (ClassNotFoundException e)
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

    public String get_NewStatus(String batchId)
    {

        //boolean status = false;
        PreparedStatement psmt = null;
        ResultSet rs = null;
        Connection con = null;
        String newValue = "";
        try
        {

            System.out.println("get_NewStatus");
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);
            StringBuilder sbQuery = new StringBuilder();
            //System.out.println("2");

            sbQuery.append("SELECT NewStatus from  ");
            sbQuery.append(DDM_Constants.tbl_executionbatchhistory + " ");
            sbQuery.append("where batchid =?");

            psmt = con.prepareStatement(sbQuery.toString());
            psmt.setString(1, batchId);

            rs = psmt.executeQuery();
            while (rs.next())
            {
                newValue = rs.getString("NewStatus");
            }

        }
        catch (SQLException e)
        {
            System.out.println(e.toString());
        }
        catch (ClassNotFoundException e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeConnection(con);
        }
        return newValue;
    }

}
