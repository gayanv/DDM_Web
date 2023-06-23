/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.requeststatus;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class RequestStatusUtil
{

    static RequestStatus makeFileStatusObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        RequestStatus status = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            status = new RequestStatus();

            status.setStatusId(rs.getString("StatusId"));
            status.setDescription(rs.getString("StatusDesc"));
        }

        return status;
    }

    static Collection<RequestStatus> makeFileStatusObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<RequestStatus> result = new java.util.ArrayList();

        while (rs.next())
        {
            RequestStatus status = new RequestStatus();

            status.setStatusId(rs.getString("StatusId"));
            status.setDescription(rs.getString("StatusDesc"));

            result.add(status);
        }

        return result;
    }
}
