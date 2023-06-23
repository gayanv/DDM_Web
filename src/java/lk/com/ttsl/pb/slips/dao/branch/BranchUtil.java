/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.branch;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.bank.Bank;

/**
 *
 * @author Dinesh
 */
public class BranchUtil
{

    private BranchUtil()
    {
    }

    static Branch makeBranchObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Branch branch = null;

        if (rs.isBeforeFirst())
        {
            branch = new Branch();

            rs.next();

            branch.setBankCode(rs.getString("BankCode"));
            branch.setBankShortName(rs.getString("ShortName"));
            branch.setBankFullName(rs.getString("FullName"));
            branch.setBranchCode(rs.getString("BranchCode"));
            branch.setBranchName(rs.getString("BranchName"));
            branch.setBranchNameModify(rs.getString("BranchName_Modify"));
            branch.setStatus(rs.getString("BranchStatus"));
            branch.setStatusModify(rs.getString("BranchStatus_Modify"));

//            if (rs.getString("SystemEffectiveDate") != null)
//            {
//                branch.setSystemEffectiveDate(DateFormatter.doFormat(rs.getTimestamp("SystemEffectiveDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
//            }
//            
//            if (rs.getString("SystemEffectiveDate_Modify") != null)
//            {
//                branch.setSystemEffectiveDateModify(DateFormatter.doFormat(rs.getTimestamp("SystemEffectiveDate_Modify").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
//            }
            branch.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getString("CreatedDate") != null)
            {
                branch.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            branch.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                branch.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            branch.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                branch.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            branch.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                branch.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

        }

        return branch;
    }

    static Collection<Branch> makeBranchObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Branch> result = new java.util.ArrayList();

        while (rs.next())
        {
            Branch branch = new Branch();

            // br.BankCode, ba.ShortName, ba.FullName, br.BranchCode, br.BranchName, br.BranchStatus, 
            // br.CreatedBy, br.CreatedDate, br.AuthorizedBy, br.AuthorizedDate
            branch.setBankCode(rs.getString("BankCode"));
            branch.setBankShortName(rs.getString("ShortName"));
            branch.setBankFullName(rs.getString("FullName"));
            branch.setBranchCode(rs.getString("BranchCode"));
            branch.setBranchName(rs.getString("BranchName"));
            branch.setBranchNameModify(rs.getString("BranchName_Modify"));
            branch.setStatus(rs.getString("BranchStatus"));
            branch.setStatusModify(rs.getString("BranchStatus_Modify"));

//            if (rs.getString("SystemEffectiveDate") != null)
//            {
//                branch.setSystemEffectiveDate(DateFormatter.doFormat(rs.getTimestamp("SystemEffectiveDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
//            }
//            
//            if (rs.getString("SystemEffectiveDate_Modify") != null)
//            {
//                branch.setSystemEffectiveDateModify(DateFormatter.doFormat(rs.getTimestamp("SystemEffectiveDate_Modify").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd));
//            }
            branch.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getString("CreatedDate") != null)
            {
                branch.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            branch.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                branch.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            branch.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getString("ModifiedDate") != null)
            {
                branch.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            branch.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                branch.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(branch);
        }

        return result;
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
            Bank bk = new Bank();

            bk.setBankCode(rs.getString("BankCode"));
            bk.setShortName(rs.getString("ShortName"));
            bk.setBankFullName(rs.getString("FullName"));

            result.add(bk);
        }

        return result;
    }

}
