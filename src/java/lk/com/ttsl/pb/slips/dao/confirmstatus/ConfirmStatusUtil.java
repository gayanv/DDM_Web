/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.confirmstatus;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class ConfirmStatusUtil
{

    static ConfirmStatus makeConfirmStatusObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        ConfirmStatus status = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            status = new ConfirmStatus();

            status.setID(rs.getString("ID"));
            status.setDescription(rs.getString("Description"));
        }

        return status;
    }

    static Collection<ConfirmStatus> makeConfirmStatusObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<ConfirmStatus> result = new java.util.ArrayList();

        while (rs.next())
        {
            ConfirmStatus status = new ConfirmStatus();

            status.setID(rs.getString("ID"));
            status.setDescription(rs.getString("Description"));

            result.add(status);
        }

        return result;
    }
}
