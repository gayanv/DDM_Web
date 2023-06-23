/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.userlevelfunctionmap;

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
public class UserLevelFunctionMapDAOImpl implements UserLevelFunctionMapDAO
{

    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public UserLevelFunctionMap getUserLevelFunctionMap(String usrLevel, int functionID)
    {
        UserLevelFunctionMap ulfm = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usrLevel == null)
        {
            System.out.println("WARNING : Null usrLevel parameter.");
            return ulfm;
        }

        if (functionID < 0)
        {
            System.out.println("WARNING : Invalid functionID parameter.");
            return ulfm;
        }

        System.out.println("usrLevel ---> " + usrLevel + " , functionID ---> " + functionID);

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ulfm.UserLevel, ul.UserLevelDesc, ulfm.FunctionID, ulfm.FunctionPath, ulfm.MenuLevel1, ulfm.WidthMenuLevel1, "
                    + "ulfm.MenuLevel2, ulfm.WidthMenuLevel2, ulfm.MenuLevel3, ulfm.WidthMenuLevel3, ulfm.MenuLevel4, ulfm.WidthMenuLevel4, "
                    + "ulfm.Status, ulfm.Status_Modify, ulfm.ModifiedBy, ulfm.ModifiedDate, ulfm.ModificationAuthBy, ulfm.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_userlevelfunctionmap + " ulfm, ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " ul ");
            sbQuery.append("where ulfm.UserLevel = ul.UserLevelId ");
            sbQuery.append("and UserLevel = ? ");
            sbQuery.append("and FunctionID = ? ");

            System.out.println("getUserLevelFunctionMap(sbQuery.toString()) =======> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, usrLevel);
            pstm.setInt(2, functionID);

            rs = pstm.executeQuery();

            ulfm = UserLevelFunctionMapUtil.makeUserLevelFunctionMapObject(rs);

            if (ulfm == null)
            {
                msg = DDM_Constants.msg_no_records;
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
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return ulfm;
    }

    @Override
    public Collection<UserLevelFunctionMap> getUserLevelFunctionMapDetails(String usrLevel)
    {

        Collection<UserLevelFunctionMap> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usrLevel == null)
        {
            System.out.println("WARNING : Null usrLevel parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ulfm.UserLevel, ul.UserLevelDesc, ulfm.FunctionID, ulfm.FunctionPath, ulfm.MenuLevel1, ulfm.WidthMenuLevel1, "
                    + "ulfm.MenuLevel2, ulfm.WidthMenuLevel2, ulfm.MenuLevel3, ulfm.WidthMenuLevel3, ulfm.MenuLevel4, ulfm.WidthMenuLevel4, "
                    + "ulfm.Status, ulfm.Status_Modify, ulfm.ModifiedBy, ulfm.ModifiedDate, ulfm.ModificationAuthBy, ulfm.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_userlevelfunctionmap + " ulfm, ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " ul ");
            sbQuery.append("where ulfm.UserLevel = ul.UserLevelId ");

            if (!usrLevel.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and ulfm.UserLevel = ? ");
            }

            sbQuery.append("order by ulfm.MenuLevel1, ulfm.MenuLevel2, ulfm.MenuLevel3, ulfm.MenuLevel4");

            System.out.println("getUserLevelFunctionMapDetails(sbQuery.toString()) =======> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            if (!usrLevel.equals(DDM_Constants.status_all))
            {
                pstm.setString(1, usrLevel);
            }

            rs = pstm.executeQuery();

            col = UserLevelFunctionMapUtil.makeUserLevelFunctionMapObjectCollection2(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    @Override
    public Collection<UserLevelFunctionMap> getUserLevelFunctionMapDetails(String usrLevel, String status)
    {

        Collection<UserLevelFunctionMap> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usrLevel == null)
        {
            System.out.println("WARNING : Null usrLevel parameter.");
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

            int val_usrLvl = 1;
            int val_stat = 2;

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ulfm.UserLevel, ul.UserLevelDesc, ulfm.FunctionID, ulfm.FunctionPath, ulfm.MenuLevel1, ulfm.WidthMenuLevel1, "
                    + "ulfm.MenuLevel2, ulfm.WidthMenuLevel2, ulfm.MenuLevel3, ulfm.WidthMenuLevel3, ulfm.MenuLevel4, ulfm.WidthMenuLevel4, "
                    + "ulfm.Status, ulfm.Status_Modify, ulfm.ModifiedBy, ulfm.ModifiedDate, ulfm.ModificationAuthBy, ulfm.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_userlevelfunctionmap + " ulfm, ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " ul ");
            sbQuery.append("where ulfm.UserLevel = ul.UserLevelId ");

            if (!usrLevel.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and ulfm.UserLevel = ? ");
                vt.add(val_usrLvl);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and ulfm.Status = ? ");
                vt.add(val_stat);
            }

            sbQuery.append("order by ulfm.MenuLevel1, ulfm.MenuLevel2, ulfm.MenuLevel3, ulfm.MenuLevel4");

            System.out.println("getUserLevelFunctionMapDetails(sbQuery.toString()) =======> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_usrLvl)
                {
                    pstm.setString(i, usrLevel);
                    i++;
                }
                if (val_item == val_stat)
                {
                    pstm.setString(i, status);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = UserLevelFunctionMapUtil.makeUserLevelFunctionMapObjectCollection2(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    @Override
    public Collection<UserLevelFunctionMap> getFunctionMapForMenuCreation(String usrLevel, String status)
    {

        Collection<UserLevelFunctionMap> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usrLevel == null)
        {
            System.out.println("WARNING : Null usrLevel parameter.");
            return col;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select "
                    + "MenuLevel1, max(WidthMenuLevel1) as wml1, "
                    + "MenuLevel2, max(WidthMenuLevel2) as wml2, "
                    + "MenuLevel3, max(WidthMenuLevel3) as wml3, "
                    + "MenuLevel4, max(WidthMenuLevel4) as wml4, "
                    + "FunctionID, "
                    + "FunctionPath from ");
            sbQuery.append(DDM_Constants.tbl_userlevelfunctionmap + " ");
            sbQuery.append("where  UserLevel = ? ");
            sbQuery.append("and Status = ? ");
            sbQuery.append("group by MenuLevel1, MenuLevel2, MenuLevel3, MenuLevel4, FunctionID, FunctionPath ");
            // sbQuery.append("order by MenuLevel1, MenuLevel2, MenuLevel3, MenuLevel4");
            sbQuery.append("order by MenuLevel1, FunctionID");

            System.out.println("getFunctionMapForMenuCreation(sbQuery.toString()) =======> " + sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, usrLevel);
            pstm.setString(2, status);

            rs = pstm.executeQuery();

            col = UserLevelFunctionMapUtil.makeUserLevelFunctionMapObjectCollection1(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
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
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

    @Override
    public boolean isAccessOK(String usrLevel, String path)
    {
        boolean isAccessOK = false;
        int count = -1;

        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usrLevel == null)
        {
            System.out.println("WARNING : Null usrLevel parameter.");
            return isAccessOK;
        }

        if (path == null)
        {
            System.out.println("WARNING : Null path parameter.");
            return isAccessOK;
        }
        try
        {

            con = DBUtil.getInstance().getConnection();

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT count(*) as IsAccessOK FROM ");
            sbQuery.append(DDM_Constants.tbl_userlevelfunctionmap + " ");
            sbQuery.append("WHERE UserLevel = ? ");
            sbQuery.append("AND FunctionPath = ? ");
            sbQuery.append("AND Status = ? ");

            pstm = con.prepareStatement(sbQuery.toString());

            pstm.setString(1, usrLevel);
            pstm.setString(2, path);
            pstm.setString(3, DDM_Constants.status_active);

            rs = pstm.executeQuery();

            if (rs != null && rs.isBeforeFirst())
            {
                rs.next();
                count = rs.getInt("IsAccessOK");

                if (count > 0)
                {
                    isAccessOK = true;
                }
            }

            if (count == -1)
            {
                msg = DDM_Constants.msg_no_records;
            }

        }
        catch (SQLException e)
        {
            msg = e.getMessage();
            System.out.println(e.getMessage());
        }
        catch (ClassNotFoundException e)
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

        return isAccessOK;
    }

    @Override
    public boolean modifyUserLevelFunctionMap(UserLevelFunctionMap ulfm)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count = 0;

        if (ulfm == null)
        {
            System.out.println("WARNING : Null UserLevelFunctionMap object.");
            return false;
        }

        if (ulfm.getUserLevel() == null)
        {
            System.out.println("WARNING : Null getUserLevel() parameter.");
            return false;
        }

        if (ulfm.getFunctionID() < 0)
        {
            System.out.println("WARNING : Invalid ulfm.getFunctionID() parameter.");
            return false;
        }

        if (ulfm.getStatus() == null)
        {
            System.out.println("WARNING : Null getStatus parameter.");
            return false;
        }

        if (ulfm.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null ulfm.getModifiedBy() parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_userlevelfunctionmap + " ");
            sbQuery.append("set ");
            sbQuery.append("Status_Modify = ?, ");
            sbQuery.append("ModifiedBy = ?, ");
            sbQuery.append("ModifiedDate =(select NOW()), ");
            sbQuery.append("ModificationAuthBy = null ");
            sbQuery.append("where UserLevel = ? ");
            sbQuery.append("and FunctionID = ? ");

            //System.out.println("modifyUserLevelFunctionMap(sbQuery)=========>" + sbQuery);

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, ulfm.getStatus());
            psmt.setString(2, ulfm.getModifiedBy());
            psmt.setString(3, ulfm.getUserLevel());
            psmt.setInt(4, ulfm.getFunctionID());

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
    public Collection<UserLevelFunctionMap> getAuthPendingModifiedFunctionMap(String usrLevel, String modifiedBy)
    {
        Collection<UserLevelFunctionMap> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (usrLevel == null)
        {
            System.out.println("WARNING : Null usrLevel parameter.");
            return col;
        }
        if (modifiedBy == null)
        {
            System.out.println("WARNING : Null modifiedBy parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ulfm.UserLevel, ul.UserLevelDesc, ulfm.FunctionID, ulfm.FunctionPath, ulfm.MenuLevel1, ulfm.WidthMenuLevel1, "
                    + "ulfm.MenuLevel2, ulfm.WidthMenuLevel2, ulfm.MenuLevel3, ulfm.WidthMenuLevel3, ulfm.MenuLevel4, ulfm.WidthMenuLevel4, "
                    + "ulfm.Status, ulfm.Status_Modify, ulfm.ModifiedBy, ulfm.ModifiedDate, ulfm.ModificationAuthBy, ulfm.ModificationAuthDate from ");
            sbQuery.append(DDM_Constants.tbl_userlevelfunctionmap + " ulfm, ");
            sbQuery.append(DDM_Constants.tbl_userlevel + " ul ");
            sbQuery.append("where ulfm.UserLevel = ul.UserLevelId ");

            if (!usrLevel.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and ulfm.UserLevel = ? ");
            }

            sbQuery.append("and ulfm.ModificationAuthBy is null ");
            sbQuery.append("and ulfm.ModifiedBy != ? ");
            sbQuery.append("ORDER BY ulfm.MenuLevel1, ulfm.MenuLevel2, ulfm.MenuLevel3, ulfm.MenuLevel4");

            //System.out.println("getAuthPendingModifiedFunctionMaps(sbQuery)=========>" + sbQuery);

            pstm = con.prepareStatement(sbQuery.toString());

            if (!usrLevel.equals(DDM_Constants.status_all))
            {
                pstm.setString(1, usrLevel);
                pstm.setString(2, modifiedBy);
            }
            else
            {
                pstm.setString(1, modifiedBy);
            }

            rs = pstm.executeQuery();

            col = UserLevelFunctionMapUtil.makeUserLevelFunctionMapObjectCollection2(rs);

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
    public boolean doAuthorizeModifiedParams(UserLevelFunctionMap ulfm)
    {
        boolean status = false;
        Connection con = null;
        PreparedStatement psmt = null;
        int count;

        if (ulfm == null)
        {
            System.out.println("WARNING : Null ulfm object.");
            return false;
        }

        if (ulfm.getUserLevel() == null)
        {
            System.out.println("WARNING : Null getUserLevel() parameter.");
            return false;
        }

        if (ulfm.getFunctionID() < 0)
        {
            System.out.println("WARNING : Invalid getFunctionID() parameter.");
            return false;
        }

        if (ulfm.getModificationAuthBy() == null)
        {
            System.out.println("WARNING : Null getModificationAuthBy() parameter.");
            return false;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_userlevelfunctionmap + " ");
            sbQuery.append("set ");
            sbQuery.append("Status = Status_Modify, ");
            sbQuery.append("ModificationAuthBy = ?, ");
            sbQuery.append("ModificationAuthDate = now() ");
            sbQuery.append("where UserLevel = ? ");
            sbQuery.append("and FunctionID = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            //psmt.setString(1, DDM_Constants.status_active);
            psmt.setString(1, ulfm.getModificationAuthBy());
            psmt.setString(2, ulfm.getUserLevel());
            psmt.setInt(3, ulfm.getFunctionID());

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
