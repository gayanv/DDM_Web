/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.bank;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh - ProntoIT
 */
class BankUtil
{

    private BankUtil()
    {
    }

    static Bank makeBankObject(ResultSet rs) throws SQLException
    {

        Bank bank = null;

        if (rs != null && rs.isBeforeFirst())
        {
            rs.next();

            bank = new Bank();

            bank.setBankCode(rs.getString("BankCode"));
            bank.setShortName(rs.getString("ShortName"));
            bank.setShortNameModify(rs.getString("ShortName_Modify"));
            bank.setBankFullName(rs.getString("FullName"));
            bank.setBankFullNameModify(rs.getString("FullName_Modify"));
            bank.setStatus(rs.getString("BankStatus"));
            bank.setStatusModify(rs.getString("BankStatus_Modify"));

            bank.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedDate") != null)
            {
                bank.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            bank.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                bank.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            bank.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getTimestamp("ModifiedDate") != null)
            {
                bank.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            bank.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                bank.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }

        return bank;
    }

    static Collection<Bank> makeBankObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Bank> result = new java.util.ArrayList();

        while (rs.next())
        {
            Bank bank = new Bank();

            bank.setBankCode(rs.getString("BankCode"));
            bank.setShortName(rs.getString("ShortName"));
            bank.setShortNameModify(rs.getString("ShortName_Modify"));
            bank.setBankFullName(rs.getString("FullName"));
            bank.setBankFullNameModify(rs.getString("FullName_Modify"));
            bank.setStatus(rs.getString("BankStatus"));
            bank.setStatusModify(rs.getString("BankStatus_Modify"));

            bank.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedDate") != null)
            {
                bank.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            bank.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                bank.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            bank.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getTimestamp("ModifiedDate") != null)
            {
                bank.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            bank.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                bank.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(bank);

        }

        return result;
    }

}
