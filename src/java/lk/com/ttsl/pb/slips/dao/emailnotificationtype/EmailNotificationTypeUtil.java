/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.emailnotificationtype;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class EmailNotificationTypeUtil
{

    private EmailNotificationTypeUtil()
    {
    }

    static EmailNotificationType makeEmailNotificationTypeObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        EmailNotificationType ent = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            ent = new EmailNotificationType();

            ent.setID(rs.getString("ID"));
            ent.setDescription(rs.getString("Description"));
            ent.setSetBankOnly(rs.getString("SetBankOnly"));
        }

        return ent;
    }

    static Collection<EmailNotificationType> makeEmailNotificationTypeObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<EmailNotificationType> result = new java.util.ArrayList();

        while (rs.next())
        {
            EmailNotificationType ent = new EmailNotificationType();

            ent.setID(rs.getString("ID"));
            ent.setDescription(rs.getString("Description"));
            ent.setSetBankOnly(rs.getString("SetBankOnly"));

            result.add(ent);
        }

        return result;
    }

}
