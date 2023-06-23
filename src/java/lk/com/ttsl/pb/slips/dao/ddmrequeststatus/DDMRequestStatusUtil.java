/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.ddmrequeststatus;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class DDMRequestStatusUtil
{

    static DDMRequestStatus makeDDMRequestStatusObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        DDMRequestStatus ddmrs = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            ddmrs = new DDMRequestStatus();

            ddmrs.setStatusId(rs.getString("id"));
            ddmrs.setDescription(rs.getString("Description"));
        }

        return ddmrs;
    }

    static Collection<DDMRequestStatus> makeDDMRequestStatusObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<DDMRequestStatus> result = new java.util.ArrayList();

        while (rs.next())
        {
            DDMRequestStatus ddmrs = new DDMRequestStatus();

            ddmrs.setStatusId(rs.getString("id"));
            ddmrs.setDescription(rs.getString("Description"));

            result.add(ddmrs);
        }

        return result;
    }
}
