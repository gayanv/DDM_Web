/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.requeststatus;

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
public class RequestStatusDAOImpl implements RequestStatusDAO
{
    
    String msg = null;
    
    public String getMsg()
    {
        return msg;
    }
    
    @Override
    public RequestStatus getFileStatus(String id)
    {
        RequestStatus fs = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        if (id == null)
        {
            System.out.println("WARNING : Null id parameter.");
            return fs;
        }
        
        try
        {
            con = DBUtil.getInstance().getConnection();
            
            StringBuilder sbQuery = new StringBuilder();
            
            sbQuery.append("select StatusId, StatusDesc from ");
            sbQuery.append(DDM_Constants.tbl_status + " ");
            sbQuery.append("where StatusId = ?  ");            
            
            pstm = con.prepareStatement(sbQuery.toString());
            
            pstm.setString(1, id);
            
            rs = pstm.executeQuery();
            
            fs = RequestStatusUtil.makeFileStatusObject(rs);
            
            if (fs == null)
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
        
        return fs;
    }
    
    @Override
    public Collection<RequestStatus> getFileStatusDetails()
    {
        Collection<RequestStatus> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try
        {
            con = DBUtil.getInstance().getConnection();
            
            StringBuilder sbQuery = new StringBuilder();
            
            sbQuery.append("select StatusId, StatusDesc from ");
            sbQuery.append(DDM_Constants.tbl_status);
            pstm = con.prepareStatement(sbQuery.toString());
            
            rs = pstm.executeQuery();
            
            col = RequestStatusUtil.makeFileStatusObjectsCollection(rs);
            
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
