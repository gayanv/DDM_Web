/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.parameter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;

/**
 *
 * @author Dinesh
 */
public class ParameterDAOImpl implements ParameterDAO
{

    String msg = null;
    HashMap<String, String> fail_Query = null;
    HashMap<String, String> success_Query = null;
    HashMap<String, Parameter> fail_Query2 = null;
    HashMap<String, Parameter> success_Query2 = null;

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

    @Override
    public HashMap<String, Parameter> getFailQuery2()
    {
        return fail_Query2;
    }

    @Override
    public HashMap<String, Parameter> getSuccessQuery2()
    {
        return success_Query2;
    }

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public String getParamValueById(String paramId)
    {
        String paramValue = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (paramId == null)
        {
            System.out.println("WARNING : Null paramId parameter.");
            return paramValue;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT ParamValue FROM ");
            sbQuery.append(DDM_Constants.tbl_parameter + " ");
            sbQuery.append("WHERE ParamId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, paramId);

            //System.out.println(sbQuery.toString());
            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                paramValue = rs.getString("ParamValue");
            }
            else
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
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

        return paramValue;
    }

    @Override
    public String getParamValue(String paramId, String paramType)
    {
        String paramValue = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (paramId == null)
        {
            System.out.println("WARNING : Null paramId parameter.");
            return paramValue;
        }

        if (paramType == null)
        {
            System.out.println("WARNING : Null paramType parameter.");
            return paramValue;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            if (paramType.equals(DDM_Constants.param_type_pwd))
            {
                sbQuery.append("SELECT AES_DECRYPT(ParamValue,?) as val FROM ");
                sbQuery.append(DDM_Constants.tbl_parameter + " ");
                sbQuery.append("WHERE ParamId = ? ");

                pstm = con.prepareStatement(sbQuery.toString());

                String kk = DDM_Constants.aesk_s + DDM_Constants.aesk_l + DDM_Constants.aesk_i
                        + DDM_Constants.aesk_p + DDM_Constants.aesk_s + DDM_Constants.aesk_b
                        + DDM_Constants.aesk_c + DDM_Constants.aesk_m + DDM_Constants.aesk_2
                        + DDM_Constants.aesk_0 + DDM_Constants.aesk_1 + DDM_Constants.aesk_2;

                pstm.setString(1, kk);
                pstm.setString(2, paramId);

                //System.out.println("decryptKey (kk) --> " + kk);
                //System.out.println("paramId (pwd) --> " + paramId);
            }
            else
            {
                sbQuery.append("SELECT ParamValue as val FROM ");
                sbQuery.append(DDM_Constants.tbl_parameter + " ");
                sbQuery.append("WHERE ParamId = ? ");

                pstm = con.prepareStatement(sbQuery.toString());

                pstm.setString(1, paramId);

                //System.out.println("paramId  --> " + paramId);
            }

            System.out.println(sbQuery.toString());

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                paramValue = rs.getString("val");

                //System.out.println("paramValue --> " + paramValue);
            }
            else
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
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

        return paramValue;
    }

    @Override
    public String getParamValueById_notFormatted(String paramId)
    {

        String paramValue = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (paramId == null)
        {
            System.out.println("WARNING : Null paramId parameter.");
            return paramValue;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT ParamValue FROM ");
            sbQuery.append(DDM_Constants.tbl_parameter + " ");
            sbQuery.append("WHERE ParamId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, paramId);

            // System.out.println(sbQuery.toString());
            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                paramValue = rs.getString("ParamValue");
            }
            else
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

        return paramValue;
    }

    @Override
    public Parameter getParamDetails(String paramId)
    {

        Parameter param = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ParamId, ParamDesc, ParamValue, ParamValue_Modify, ParamType, AES_DECRYPT(ParamValue,?) as decrypVal, AES_DECRYPT(ParamValue_Modify,?) as decrypVal_Modify, ModifiedBy, ModifiedDate, ModificationAuthBy, ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_parameter + " ");
            sbQuery.append("where ParamId = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            String kk = DDM_Constants.aesk_d + DDM_Constants.aesk_d + DDM_Constants.aesk_m
                    + DDM_Constants.aesk_hash + DDM_Constants.aesk_p + DDM_Constants.aesk_a
                    + DDM_Constants.aesk_r + DDM_Constants.aesk_a + DDM_Constants.aesk_m 
                    + DDM_Constants.aesk_2 + DDM_Constants.aesk_0 + DDM_Constants.aesk_2 + DDM_Constants.aesk_3;

            pstm.setString(1, kk);
            pstm.setString(2, kk);
            pstm.setString(3, paramId);

            rs = pstm.executeQuery();

            param = ParameterUtil.makeParameterObject(rs);

            if (param == null)
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (ClassNotFoundException | SQLException e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return param;
    }

    @Override
    public Collection<Parameter> getAllParamterValues()
    {

        Collection<Parameter> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ParamId, ParamDesc, ParamValue, ParamType, AES_DECRYPT(ParamValue,?) as decrypVal from ");
            sbQuery.append(DDM_Constants.tbl_parameter + " ");
            sbQuery.append("order by DisplayPriority");

            pstm = con.prepareStatement(sbQuery.toString());

            String kk = DDM_Constants.aesk_s + DDM_Constants.aesk_l + DDM_Constants.aesk_i
                    + DDM_Constants.aesk_p + DDM_Constants.aesk_s + DDM_Constants.aesk_b
                    + DDM_Constants.aesk_c + DDM_Constants.aesk_m + DDM_Constants.aesk_2
                    + DDM_Constants.aesk_0 + DDM_Constants.aesk_1 + DDM_Constants.aesk_2;

            pstm.setString(1, kk);

            rs = pstm.executeQuery();

            col = ParameterUtil.makeParameterCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            System.out.println(e.toString());
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
    public boolean update(Collection<Parameter> col_para)
    {
        boolean status = false;

        try
        {
            if (fail_Query == null)
            {
                fail_Query = new HashMap<>();
            }
            if (success_Query == null)
            {
                success_Query = new HashMap<>();
            }

            if (!col_para.isEmpty())
            {
                for (Parameter param : col_para)
                {
                    boolean status_Query = DAOFactory.getParameterDAO().update(param);

                    if (status_Query == false)
                    {
                        fail_Query.put(param.getName(), "F");
                    }
                    else
                    {
                        success_Query.put(param.getName(), "S");
                    }
                }
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }

        if (fail_Query.isEmpty())
        {
            status = true;
        }

        return status;
    }

    @Override
    public boolean update(Parameter parameter)
    {

        Connection con = null;
        PreparedStatement psmt = null;
        int count;
        boolean query_status = false;

        try
        {
            if (fail_Query2 == null)
            {
                fail_Query2 = new HashMap<>();
            }
            if (success_Query2 == null)
            {
                success_Query2 = new HashMap<>();
            }

            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            if (parameter.getValue().length() > 0)
            {
                if (parameter.getType().equals(DDM_Constants.param_type_pwd))
                {
                    sbQuery.append("update ");
                    sbQuery.append(DDM_Constants.tbl_parameter + " ");
                    sbQuery.append("set ParamValue_Modify = DES_ENCRYPT(?,?), ");
                    sbQuery.append("ModifiedBy = ?, ");
                    sbQuery.append("ModifiedDate =(select NOW()), ");
                    sbQuery.append("ModificationAuthBy = null ");
                    sbQuery.append("where ParamId = ?");

                    psmt = con.prepareStatement(sbQuery.toString());

                    String kk = DDM_Constants.aesk_s + DDM_Constants.aesk_l + DDM_Constants.aesk_i
                            + DDM_Constants.aesk_p + DDM_Constants.aesk_s + DDM_Constants.aesk_b
                            + DDM_Constants.aesk_c + DDM_Constants.aesk_m + DDM_Constants.aesk_2
                            + DDM_Constants.aesk_0 + DDM_Constants.aesk_1 + DDM_Constants.aesk_2;

                    psmt.setString(1, parameter.getValue());
                    psmt.setString(2, kk);
                    psmt.setString(3, parameter.getModifiedBy());
                    psmt.setString(4, parameter.getName());

                }
                else
                {
                    sbQuery.append("update ");
                    sbQuery.append(DDM_Constants.tbl_parameter + " ");
                    sbQuery.append("set ParamValue_Modify = ?,  ");
                    sbQuery.append("ModifiedBy = ?, ");
                    sbQuery.append("ModifiedDate =(select NOW()), ");
                    sbQuery.append("ModificationAuthBy = null ");
                    sbQuery.append("where ParamId = ? ");

                    psmt = con.prepareStatement(sbQuery.toString());

                    psmt.setString(1, parameter.getValue());
                    psmt.setString(2, parameter.getModifiedBy());
                    psmt.setString(3, parameter.getName());
                }

                count = psmt.executeUpdate();

                if (count > 0)
                {
                    con.commit();
                    parameter.setUpdateStatus(DDM_Constants.status_success);
                    success_Query2.put(parameter.getName(), parameter);
                    query_status = true;
                }
                else
                {
                    con.rollback();
                    parameter.setUpdateStatus(DDM_Constants.status_fail);
                    parameter.setUpdateStatusMsg(msg);
                    fail_Query2.put(parameter.getName(), parameter);
                    msg = DDM_Constants.msg_error_while_processing;
                }
            }
            else
            {
                query_status = true;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            parameter.setUpdateStatus(DDM_Constants.status_fail);
            parameter.setUpdateStatusMsg(msg);
            fail_Query2.put(parameter.getName(), parameter);
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    @Override
    public boolean updateLastEmailSentDate(Parameter parameter)
    {

        Connection con = null;
        PreparedStatement psmt = null;
        int count;
        boolean query_status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_parameter + " ");
            sbQuery.append("set ParamValue = ?,  ");
            sbQuery.append("ParamValue_Modify = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()), ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("ModificationAuthDate =(select NOW()) ");
            sbQuery.append("where ParamId = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, parameter.getValue());
            psmt.setString(2, parameter.getValue());
            psmt.setString(3, parameter.getModifiedBy());
            psmt.setString(4, parameter.getModifiedBy());
            psmt.setString(5, parameter.getName());

            count = psmt.executeUpdate();

            if (count > 0)
            {
                con.commit(); 
                query_status = true;
            }
            else
            {
                con.rollback();                
                msg = DDM_Constants.msg_error_while_processing;
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();            
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return query_status;
    }

    /**
     * @return no of records which contains date values
     */
    @Override
    public int getDateTypeParameterCount()
    {
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        int count = 0;
        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select count(ParamId) as NoOfRecords from ");
            sbQuery.append(DDM_Constants.tbl_parameter + " ");
            sbQuery.append("where ParamType=?");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, "Y");

            rs = pstm.executeQuery();
            while (rs.next())
            {
                count = rs.getInt("NoOfRecords");
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return count;
    }

    @Override
    public Map<String, Parameter> getAllSessionParams()
    {
        Map<String, Parameter> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ParamId, ParamDesc, ParamValue, ParamType, AES_DECRYPT(ParamValue,?) as decrypVal from ");
            sbQuery.append(DDM_Constants.tbl_parameter + " ");
            sbQuery.append("where ParamId LIKE 'OW_Session%' or ParamId LIKE 'IW_Session%' order by ParamId");

            pstm = con.prepareStatement(sbQuery.toString());

            String kk = DDM_Constants.aesk_s + DDM_Constants.aesk_l + DDM_Constants.aesk_i
                    + DDM_Constants.aesk_p + DDM_Constants.aesk_s + DDM_Constants.aesk_b
                    + DDM_Constants.aesk_c + DDM_Constants.aesk_m + DDM_Constants.aesk_2
                    + DDM_Constants.aesk_0 + DDM_Constants.aesk_1 + DDM_Constants.aesk_2;

            pstm.setString(1, kk);

            rs = pstm.executeQuery();

            col = ParameterUtil.makeParameterMap(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    //to add a parameter 
    @Override
    public boolean addParameter(Parameter parameter)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        int count;
        boolean status = false;

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("INSERT INTO ");
            sbQuery.append(DDM_Constants.tbl_parameter + " ");
            sbQuery.append("(ParamId,ParamDesc,ParamValue,ParamValue_Modify,ParamType,ModifiedBy,ModifiedDate) ");
            sbQuery.append("VALUES(?, ?, ?, ?, ?, ?, (select NOW()))");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, parameter.getName());
            pstm.setString(2, parameter.getDescription());
            pstm.setString(3, parameter.getValue());
            pstm.setString(4, parameter.getValue());
            pstm.setString(5, parameter.getType());
            pstm.setString(6, parameter.getModifiedBy());
            //pstm.setString(6, parameter.getModifiedDate());

            count = pstm.executeUpdate();

            if (count > 0)
            {
                con.commit();
                status = true;
            }
            else
            {
                msg = DDM_Constants.msg_error_while_processing;
                con.rollback();
            }

        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    @Override
    public Collection<Parameter> getAuthPendingModifiedParams(String modifiedBy)
    {
        Collection<Parameter> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ParamId, ParamDesc, ParamValue, ParamValue_Modify, ParamType, AES_DECRYPT(ParamValue,?) as decrypVal, AES_DECRYPT(ParamValue_Modify,?) as decrypVal_Modify, ModifiedBy, ModifiedDate, ModificationAuthBy, ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_parameter + " ");
            sbQuery.append("WHERE ModificationAuthBy is null ");
            sbQuery.append("AND ModifiedBy != ? ");
            sbQuery.append("ORDER BY DisplayPriority");

            //System.out.println("getAuthPendingModifiedParams(sbQuery)=========>" + sbQuery);
            String kk = DDM_Constants.aesk_s + DDM_Constants.aesk_l + DDM_Constants.aesk_i
                    + DDM_Constants.aesk_p + DDM_Constants.aesk_s + DDM_Constants.aesk_b
                    + DDM_Constants.aesk_c + DDM_Constants.aesk_m + DDM_Constants.aesk_2
                    + DDM_Constants.aesk_0 + DDM_Constants.aesk_1 + DDM_Constants.aesk_2;

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, kk);
            pstm.setString(2, kk);
            pstm.setString(3, modifiedBy);

            rs = pstm.executeQuery();

            col = ParameterUtil.makeParameterCollection(rs);

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
    public boolean doAuthorizeModifiedParams(Parameter parameter)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (parameter.getName() == null)
        {
            System.out.println("WARNING : Null Id parameter.");
            return false;
        }

        if (parameter.getModificationAuthBy() == null)
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
            sbQuery.append(DDM_Constants.tbl_parameter + " ");
            sbQuery.append("set ");
            sbQuery.append("ParamValue = ParamValue_Modify, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where ParamId = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            //psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(1, parameter.getModificationAuthBy());
            psmt.setString(2, parameter.getName());

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
        catch (SQLException | ClassNotFoundException ex)
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
