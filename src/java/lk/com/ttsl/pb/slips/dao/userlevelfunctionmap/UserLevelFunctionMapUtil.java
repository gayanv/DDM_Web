/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.userlevelfunctionmap;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class UserLevelFunctionMapUtil
{

    public static UserLevelFunctionMap makeUserLevelFunctionMapObject(final ResultSet rs) throws SQLException
    {

        UserLevelFunctionMap ulfm = null;

        if (rs != null && rs.isBeforeFirst())
        {
            rs.next();
            
            ulfm = new UserLevelFunctionMap();

            ulfm.setUserLevel(rs.getString("UserLevel"));
            ulfm.setUserLevelDesc(rs.getString("UserLevelDesc"));
            ulfm.setFunctionID(rs.getInt("FunctionID"));
            ulfm.setFunctionPath(rs.getString("FunctionPath"));
            ulfm.setMenuLevel1(rs.getString("MenuLevel1"));
            ulfm.setWidthMenuLevel1(rs.getInt("WidthMenuLevel1"));
            ulfm.setMenuLevel2(rs.getString("MenuLevel2"));
            ulfm.setWidthMenuLevel2(rs.getInt("WidthMenuLevel2"));
            ulfm.setMenuLevel3(rs.getString("MenuLevel3"));
            ulfm.setWidthMenuLevel3(rs.getInt("WidthMenuLevel3"));
            ulfm.setMenuLevel4(rs.getString("MenuLevel4"));
            ulfm.setWidthMenuLevel4(rs.getInt("WidthMenuLevel4"));
            ulfm.setStatus(rs.getString("Status"));
            ulfm.setStatusModify(rs.getString("Status_Modify"));
            ulfm.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                ulfm.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ulfm.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                ulfm.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }

        return ulfm;
    }

    public static Collection<UserLevelFunctionMap> makeUserLevelFunctionMapObjectCollection1(final ResultSet rs)
            throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<UserLevelFunctionMap> ulfmResult = new ArrayList();

        while (rs.next())
        {
            UserLevelFunctionMap ulfm = new UserLevelFunctionMap();

            ulfm.setMenuLevel1(rs.getString("MenuLevel1"));
            ulfm.setWidthMenuLevel1(rs.getInt("wml1"));
            ulfm.setMenuLevel2(rs.getString("MenuLevel2"));
            ulfm.setWidthMenuLevel2(rs.getInt("wml2"));
            ulfm.setMenuLevel3(rs.getString("MenuLevel3"));
            ulfm.setWidthMenuLevel3(rs.getInt("wml3"));
            ulfm.setMenuLevel4(rs.getString("MenuLevel4"));
            ulfm.setWidthMenuLevel4(rs.getInt("wml4"));
            ulfm.setFunctionPath(rs.getString("FunctionPath"));

            ulfmResult.add(ulfm);
        }

        return ulfmResult;
    }

    public static Collection<UserLevelFunctionMap> makeUserLevelFunctionMapObjectCollection2(final ResultSet rs)
            throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<UserLevelFunctionMap> ulfmResult = new ArrayList();

        while (rs.next())
        {
            UserLevelFunctionMap ulfm = new UserLevelFunctionMap();

            ulfm.setUserLevel(rs.getString("UserLevel"));
            ulfm.setUserLevelDesc(rs.getString("UserLevelDesc"));
            ulfm.setFunctionID(rs.getInt("FunctionID"));
            ulfm.setFunctionPath(rs.getString("FunctionPath"));
            ulfm.setMenuLevel1(rs.getString("MenuLevel1"));
            ulfm.setWidthMenuLevel1(rs.getInt("WidthMenuLevel1"));
            ulfm.setMenuLevel2(rs.getString("MenuLevel2"));
            ulfm.setWidthMenuLevel2(rs.getInt("WidthMenuLevel2"));
            ulfm.setMenuLevel3(rs.getString("MenuLevel3"));
            ulfm.setWidthMenuLevel3(rs.getInt("WidthMenuLevel3"));
            ulfm.setMenuLevel4(rs.getString("MenuLevel4"));
            ulfm.setWidthMenuLevel4(rs.getInt("WidthMenuLevel4"));
            ulfm.setStatus(rs.getString("Status"));
            ulfm.setStatusModify(rs.getString("Status_Modify"));
            ulfm.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                ulfm.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ulfm.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                ulfm.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            ulfmResult.add(ulfm);

        }

        return ulfmResult;
    }

}
