/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.executionBatch;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Isanka
 */
public class ExecutionBatchDAOImpl implements ExecutionBatchDAO
{

    String msg = null;
    HashMap<String, String> fail_Query = null;
    HashMap<String, String> success_Query = null;
//    Hashtable noChange_Query = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public HashMap<String, String> getFailQuery()
    {
        return fail_Query;
    }

    @Override
    public HashMap<String, String> getSuccessQuery()
    {
        return success_Query;
    }

//    public Hashtable getNoChangeQuery() {
//        return noChange_Query;
//    }
    @Override
    public Collection<ExecutionBatch> getExecutionBatch()
    {

        Collection<ExecutionBatch> exeBatch_col = null;
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

            exeBatch_col = ExecutionBatchUtil.makeExeBatchObjectCollection(rs);

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
    public boolean update(Collection<ExecutionBatch> col_exebatch)
    {

        boolean status = false;

        try
        {
            fail_Query = new HashMap<String, String>();
            success_Query = new HashMap<String, String>();
            // System.out.println("col_size at java class - "+ col_exebatch.size());

            if (!col_exebatch.isEmpty())
            {
                //System.out.println("1111");
                for (ExecutionBatch ex : col_exebatch)
                {

                    // System.out.println("22222222");
                    boolean result_query = update(ex);

                    if (result_query == false)
                    {

                        fail_Query.put(ex.getBatchId(), "F");
//                    } else {
//                        success_Query = new Hashtable();
//                    }
//                    success_Query.put(ex.getBatchId(), "S");
                    }
                    else
                    {
                        success_Query.put(ex.getBatchId(), "S");

                    }
                }

            }
            //  System.out.println("success query size - " +success_Query.size());
        }
        catch (Exception ex)
        {

            System.out.println(ex.toString());
        }
        if (fail_Query.isEmpty())
        {
            status = true;
        }
        return status;
    }

    @Override
    public boolean update(ExecutionBatch exec)
    {

        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        // success_Query = new Hashtable();
        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();
            //  System.out.println("statusssss---- "+exec.getStatus());

            if (exec.getStatus() != null)
            {

                sbQuery.append("update ");
                sbQuery.append(DDM_Constants.tbl_executionbatch + " ");
                sbQuery.append("set Status=? ");
                sbQuery.append("where BatchId =?");

                psmt = con.prepareStatement(sbQuery.toString());

                if (exec.getStatus().equalsIgnoreCase("Complete") || exec.getStatus().equalsIgnoreCase("C"))
                {
                    psmt.setString(1, "C");
                }
                else if (exec.getStatus().equalsIgnoreCase("Error") || exec.getStatus().equalsIgnoreCase("E"))
                {
                    psmt.setString(1, "E");
                }
                else if (exec.getStatus().equalsIgnoreCase("Initial") || exec.getStatus().equalsIgnoreCase("I"))
                {
                    psmt.setString(1, "I");
                }
                else if (exec.getStatus().equalsIgnoreCase("Running") || exec.getStatus().equalsIgnoreCase("R"))
                {
                    psmt.setString(1, "R");
                }

                psmt.setString(2, exec.getBatchId());
                //  System.out.println("4444444444444444444");
                count = psmt.executeUpdate();

                if (count > 0)
                {
                    con.commit();
                    status = true;
                    // System.out.println("5555555555555555");
                    // success_Query.put(exec.getBatchId(), "S");
                    // System.out.println(" success_Query -" +exec.getBatchId());
                }
                else
                {
                    con.rollback();
                    //  System.out.println("roll back");
                    fail_Query.put(exec.getBatchId(), "F");
                }
            }
            else
            {

                status = true;

            }
            //  System.out.println("success query size 15 - " +success_Query.size());
            return status;

        }
        catch (SQLException sqlEx)
        {
            System.out.println(sqlEx.toString());

        }
        catch (ClassNotFoundException ex)
        {

            System.out.println(ex.toString());
        }
        finally
        {

            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }
        return status;
    }

    @Override
    public String getExecutionBatchStatus(String batchid)
    {

        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;
        String batch_status = null;
        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select Status from ");
            sbQuery.append(DDM_Constants.tbl_executionbatch + " ");
            sbQuery.append("where batchId =  ? ");

            psmt = con.prepareStatement(sbQuery.toString());
            psmt.setString(1, batchid);
            rs = psmt.executeQuery();

            while (rs.next())
            {
                batch_status = rs.getString("Status");
            }
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
        return batch_status;

    }

}
