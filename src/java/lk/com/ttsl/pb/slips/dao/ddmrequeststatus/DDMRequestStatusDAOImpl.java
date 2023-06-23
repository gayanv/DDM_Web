/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.ddmrequeststatus;

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
public class DDMRequestStatusDAOImpl implements DDMRequestStatusDAO
{
    
    String msg = null;
    
    @Override
    public String getMsg()
    {
        return msg;
    }
    
    @Override
    public DDMRequestStatus getDDMRequestStatus(String id)
    {
        DDMRequestStatus ddmrs = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        if (id == null)
        {
            System.out.println("WARNING : Null id parameter.");
            return ddmrs;
        }
        
        try
        {
            con = DBUtil.getInstance().getConnection();
            
            StringBuilder sbQuery = new StringBuilder();
            
            sbQuery.append("select id, Description from ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus + " ");
            sbQuery.append("where id = ?  ");            
            
            pstm = con.prepareStatement(sbQuery.toString());
            
            pstm.setString(1, id);
            
            rs = pstm.executeQuery();
            
            ddmrs = DDMRequestStatusUtil.makeDDMRequestStatusObject(rs);
            
            if (ddmrs == null)
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
        
        return ddmrs;
    }
    
    @Override
    public Collection<DDMRequestStatus> getDDMRequestStatusAll()
    {
        Collection<DDMRequestStatus> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try
        {
            con = DBUtil.getInstance().getConnection();
            
            StringBuilder sbQuery = new StringBuilder();
            
            sbQuery.append("select id, Description from ");
            sbQuery.append(DDM_Constants.tbl_ddmrequeststatus);
            sbQuery.append(" order by id ");
            
            pstm = con.prepareStatement(sbQuery.toString());
            
            rs = pstm.executeQuery();
            
            col = DDMRequestStatusUtil.makeDDMRequestStatusObjectsCollection(rs);
            
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
}
