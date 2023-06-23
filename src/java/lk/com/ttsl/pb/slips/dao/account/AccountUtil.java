/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.account;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;


/**
 *
 * @author Dinesh
 */
public class AccountUtil
{

    private AccountUtil()
    {
    }

    public static Account makeAccountObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Account account = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            account = new Account();

            account.setBankCode(rs.getString("BankCode"));
            account.setBranchCode(rs.getString("BranchCode"));

            account.setAccountNo(rs.getString("AccountNo"));
            account.setAccountType(rs.getString("AccountType"));
            account.setAccountTypeDesc(rs.getString("TypeDesc"));
            account.setAccountSubType(rs.getString("AccountSubType"));
            account.setAccountStatus(rs.getString("AccountStatus"));

            account.setAccountHolderName(rs.getString("AccountHolderName"));
            account.setAccountHoderAddress1(rs.getString("AccountHoderAddress1"));
            account.setAccountHoderAddress2(rs.getString("AccountHoderAddress2"));
            account.setAccountHoderAddress3(rs.getString("AccountHoderAddress3"));
            account.setAccountHoderAddress4(rs.getString("AccountHoderAddress4"));

            account.setContactNo(rs.getString("ContactNo"));

            account.setSecondaryAccountHolderName(rs.getString("SecondaryAccountHolderName"));
            account.setSecondaryAccountHoderAddress(rs.getString("SecondaryAccountHolderAddress"));
            account.setSecondaryContactNo(rs.getString("SecondaryContactNo"));

            account.setIsNamePrePrintedOnCheques(rs.getString("IsNamePrePrintedOnCheques"));

            account.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getTimestamp("ModifiedDate") != null)
            {
                account.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
        }

        return account;
    }

    public static Collection<Account> makeAccountObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Account> result = new java.util.ArrayList();

        while (rs.next())
        {
            Account account = new Account();

            account.setBankCode(rs.getString("BankCode"));
            account.setBankShortName(rs.getString("ShortName"));
            account.setBankFullName(rs.getString("FullName"));
            account.setBranchCode(rs.getString("BranchCode"));
            account.setBranchName(rs.getString("BranchName"));
            account.setAccountNo(rs.getString("AccountNo"));
            account.setAccountType(rs.getString("AccountType"));
            account.setAccountTypeDesc(rs.getString("TypeDesc"));
            account.setAccountSubType(rs.getString("AccountSubType"));
            account.setAccountStatus(rs.getString("AccountStatus"));
            account.setAccountStatusDesc(rs.getString("StatusDesc"));

            account.setAccountHolderName(rs.getString("AccountHolderName"));

            account.setAccountHoderAddress1(rs.getString("AccountHoderAddress1"));
            account.setAccountHoderAddress2(rs.getString("AccountHoderAddress2"));
            account.setAccountHoderAddress3(rs.getString("AccountHoderAddress3"));
            account.setAccountHoderAddress4(rs.getString("AccountHoderAddress4"));

            account.setContactNo(rs.getString("ContactNo"));

            account.setSecondaryAccountHolderName(rs.getString("SecondaryAccountHolderName"));
            account.setSecondaryAccountHoderAddress(rs.getString("SecondaryAccountHolderAddress"));
            account.setSecondaryContactNo(rs.getString("SecondaryContactNo"));

            account.setIsNamePrePrintedOnCheques(rs.getString("IsNamePrePrintedOnCheques"));

            account.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getTimestamp("ModifiedDate") != null)
            {
                account.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(account);

        }

        return result;
    }
}
