/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.emaillist;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class EmailListUtil
{

    private EmailListUtil()
    {
    }

    static EmailList makeEmailListObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        EmailList el = null;

        if (rs.isBeforeFirst())
        {
            el = new EmailList();

            rs.next();

            el.setBankCode(rs.getString("bankcode"));
            el.setBankShortName(rs.getString("ShortName"));
            el.setBankFullName(rs.getString("FullName"));

            el.setNotificationType(rs.getString("notificationtype"));
            el.setNotificationTypeDesc(rs.getString("Description"));
            el.setNotificationTypeSetBankOnly(rs.getString("SetBankOnly"));

            el.setEmailAddress(rs.getString("emailaddress"));
            el.setEmailAddressModify(rs.getString("emailaddress_modify"));

            el.setStatus(rs.getString("status"));
            el.setStatusModify(rs.getString("status_modify"));

            el.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getString("CreatedDate") != null)
            {
                el.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            el.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                el.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            el.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                el.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            el.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                el.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }

        return el;
    }

    static Collection<EmailList> makeEmailListObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<EmailList> result = new java.util.ArrayList();

        while (rs.next())
        {
            EmailList el = new EmailList();

            el.setBankCode(rs.getString("bankcode"));
            el.setBankShortName(rs.getString("ShortName"));
            el.setBankFullName(rs.getString("FullName"));

            el.setNotificationType(rs.getString("notificationtype"));
            el.setNotificationTypeDesc(rs.getString("Description"));
            el.setNotificationTypeSetBankOnly(rs.getString("SetBankOnly"));

            el.setEmailAddress(rs.getString("emailaddress"));
            el.setEmailAddressModify(rs.getString("emailaddress_modify"));

            el.setStatus(rs.getString("status"));
            el.setStatusModify(rs.getString("status_modify"));

            el.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getString("CreatedDate") != null)
            {
                el.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            el.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                el.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            el.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                el.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            el.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                el.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(el);
        }

        return result;
    }

}
