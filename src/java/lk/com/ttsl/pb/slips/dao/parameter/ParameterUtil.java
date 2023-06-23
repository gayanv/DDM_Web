/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.parameter;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class ParameterUtil
{
    
    public static Parameter makeParameterObject(final ResultSet rs)
            throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Parameter param = null;

        while (rs.next())
        {
            param = new Parameter();

            param.setName(rs.getString("ParamId"));
            param.setDescription(rs.getString("ParamDesc"));
            param.setValue(rs.getString("ParamValue"));
            param.setValueModify(rs.getString("ParamValue_Modify"));
            param.setType(rs.getString("ParamType"));

            if (rs.getString("ParamType") != null && rs.getString("ParamType").equals(DDM_Constants.param_type_pwd))
            {
                param.setDecrytedValue(rs.getString("decrypVal"));
                param.setDecrytedValueModify(rs.getString("decrypVal_Modify"));
            }

            param.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                param.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            param.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                param.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }

        return param;
    }

    public static Collection makeParameterCollection(final ResultSet rs)
            throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Parameter> paramResult = new ArrayList();

        while (rs.next())
        {
            Parameter param = new Parameter();

            param.setName(rs.getString("ParamId"));
            param.setDescription(rs.getString("ParamDesc"));
            param.setValue(rs.getString("ParamValue"));
            param.setType(rs.getString("ParamType"));

            if (rs.getString("ParamType") != null && rs.getString("ParamType").equals(DDM_Constants.param_type_pwd))
            {
                param.setDecrytedValue(rs.getString("decrypVal"));
            }

            paramResult.add(param);
        }

        return paramResult;
    }
    
    public static Map makeParameterMap(final ResultSet rs)
            throws SQLException
    {

        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Map<String,Parameter> paramResult = new HashMap();

        while (rs.next())
        {
            Parameter param = new Parameter();

            param.setName(rs.getString("ParamId"));
            param.setDescription(rs.getString("ParamDesc"));
            param.setValue(rs.getString("ParamValue"));
            param.setType(rs.getString("ParamType"));

            if (rs.getString("ParamType") != null && rs.getString("ParamType").equals(DDM_Constants.param_type_pwd))
            {
                param.setDecrytedValue(rs.getString("decrypVal"));
            }
            //System.out.println(param.getName().charAt(7));
            String key = param.getName();
            paramResult.put(key, param);
        }

        return paramResult;
    }
}
