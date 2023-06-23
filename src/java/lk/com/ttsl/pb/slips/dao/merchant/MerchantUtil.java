/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.merchant;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.merchant.accnomap.MerchantAccNoMap;

/**
 *
 * @author Dinesh - ProntoIT
 */
class MerchantUtil
{

    private MerchantUtil()
    {
    }

    static Merchant makeMerchantObject(ResultSet rs) throws SQLException
    {

        String prev_MerchantID = "";
        Merchant merchant = null;
        MerchantAccNoMap mranm = null;

        if (rs != null && rs.isBeforeFirst())
        {
            Collection<MerchantAccNoMap> result2 = new java.util.ArrayList();

            while (rs.next())
            {
                if (prev_MerchantID.equals(rs.getString("MerchantID")))
                {
                    mranm = new MerchantAccNoMap();

                    mranm.setBank(rs.getString("ACNOM_Bank"));
                    mranm.setBankName(rs.getString("ACNOM_BankName"));
                    mranm.setBankShortName(rs.getString("ACNOM_ShortName"));
                    mranm.setBranch(rs.getString("ACNOM_Branch"));
                    mranm.setBranchName(rs.getString("ACNOM_BranchName"));
                    mranm.setAcNo(rs.getString("ACNOM_AccountNo"));
                    mranm.setAcName(rs.getString("ACNOM_AccountName"));
                    mranm.setIsPrimary(rs.getString("ACNOM_IsPrimary"));
                    mranm.setStatus(rs.getString("ACNOM_Status"));

                    result2.add(mranm);
                }
                else
                {
                    merchant = new Merchant();

                    prev_MerchantID = rs.getString("MerchantID");

                    merchant.setMerchantID(rs.getString("MerchantID"));
                    merchant.setMerchantName(rs.getString("MerchantName"));
                    merchant.setMerchantNameModify(rs.getString("MerchantName_Modify"));
                    merchant.setEmail(rs.getString("Email"));
                    merchant.setEmailModify(rs.getString("Email_Modify"));
                    merchant.setPrimaryTP(rs.getString("PrimaryTP"));
                    merchant.setPrimaryTPModify(rs.getString("PrimaryTP_Modify"));
                    merchant.setSecondaryTP(rs.getString("SecondaryTP"));
                    merchant.setSecondaryTPModify(rs.getString("SecondaryTP_Modify"));
                    merchant.setPassword(rs.getString("Password"));
                    merchant.setPasswordModify(rs.getString("Password_Modify"));

                    merchant.setBankCode(rs.getString("bankcode"));
                    merchant.setBankName(rs.getString("BankName"));
                    merchant.setBankShortName(rs.getString("ShortName"));

                    merchant.setBankCodeModify(rs.getString("bankcode_Modify"));
                    merchant.setBankNameModify(rs.getString("BankName_Modify"));
                    merchant.setBankShortNameModify(rs.getString("ShortName_Modify"));

                    merchant.setBranchCode(rs.getString("branchcode"));
                    merchant.setBranchName(rs.getString("BranchName"));

                    merchant.setBranchCodeModify(rs.getString("branchcode_Modify"));
                    merchant.setBranchNameModify(rs.getString("BranchName_Modify"));

                    merchant.setPrimaryAccountNo(rs.getString("PrimaryACNO"));
                    merchant.setPrimaryAccountNoModify(rs.getString("PrimaryACNO_Modify"));

                    merchant.setPrimaryAccountName(rs.getString("PrimaryACName"));
                    merchant.setPrimaryAccountNameModify(rs.getString("PrimaryACName_Modify"));

                    merchant.setId(rs.getString("id"));
                    merchant.setIdModify(rs.getString("id_Modify"));

                    merchant.setStatus(rs.getString("Status"));
                    merchant.setStatusModify(rs.getString("Status_Modify"));

                    merchant.setCreatedBy(rs.getString("CreatedBy"));

                    if (rs.getTimestamp("CreatedDate") != null)
                    {
                        merchant.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                    }

                    merchant.setAuthorizedBy(rs.getString("AuthorizedBy"));

                    if (rs.getTimestamp("AuthorizedDate") != null)
                    {
                        merchant.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                    }
                    
                    merchant.setModificationRemarks(rs.getString("ModificationRemarks"));
                    merchant.setModifiedBy(rs.getString("ModifiedBy"));

                    if (rs.getTimestamp("ModifiedDate") != null)
                    {
                        merchant.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                    }

                    merchant.setModificationAuthBy(rs.getString("ModificationAuthBy"));

                    if (rs.getTimestamp("ModificationAuthDate") != null)
                    {
                        merchant.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                    }

                    mranm = new MerchantAccNoMap();

                    mranm.setBank(rs.getString("ACNOM_Bank"));
                    mranm.setBankName(rs.getString("ACNOM_BankName"));
                    mranm.setBankShortName(rs.getString("ACNOM_ShortName"));
                    mranm.setBranch(rs.getString("ACNOM_Branch"));
                    mranm.setBranchName(rs.getString("ACNOM_BranchName"));
                    mranm.setAcNo(rs.getString("ACNOM_AccountNo"));
                    mranm.setAcName(rs.getString("ACNOM_AccountName"));
                    mranm.setIsPrimary(rs.getString("ACNOM_IsPrimary"));
                    mranm.setStatus(rs.getString("ACNOM_Status"));

                    result2.add(mranm);
                    merchant.setColAccNoMap(result2);

                }

            }

        }

        return merchant;
    }

    static Collection<Merchant> makeMerchantObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Merchant> result = new java.util.ArrayList();
        Collection<MerchantAccNoMap> result2 = null;

        String prev_MerchantID = "";
        Merchant merchant = null;
        MerchantAccNoMap mranm = null;

        while (rs.next())
        {
            if (prev_MerchantID.equals(rs.getString("MerchantID")))
            {
                mranm = new MerchantAccNoMap();

                mranm.setBank(rs.getString("ACNOM_Bank"));
                mranm.setBankName(rs.getString("ACNOM_BankName"));
                mranm.setBankShortName(rs.getString("ACNOM_ShortName"));
                mranm.setBranch(rs.getString("ACNOM_Branch"));
                mranm.setBranchName(rs.getString("ACNOM_BranchName"));
                mranm.setAcNo(rs.getString("ACNOM_AccountNo"));
                mranm.setAcName(rs.getString("ACNOM_AccountName"));
                mranm.setIsPrimary(rs.getString("ACNOM_IsPrimary"));
                mranm.setStatus(rs.getString("ACNOM_Status"));

                result2.add(mranm);
            }
            else
            {
                merchant = new Merchant();

                prev_MerchantID = rs.getString("MerchantID");

                merchant.setMerchantID(rs.getString("MerchantID"));
                merchant.setMerchantName(rs.getString("MerchantName"));
                merchant.setMerchantNameModify(rs.getString("MerchantName_Modify"));
                merchant.setEmail(rs.getString("Email"));
                merchant.setEmailModify(rs.getString("Email_Modify"));
                merchant.setPrimaryTP(rs.getString("PrimaryTP"));
                merchant.setPrimaryTPModify(rs.getString("PrimaryTP_Modify"));
                merchant.setSecondaryTP(rs.getString("SecondaryTP"));
                merchant.setSecondaryTPModify(rs.getString("SecondaryTP_Modify"));
                merchant.setPassword(rs.getString("Password"));
                merchant.setPasswordModify(rs.getString("Password_Modify"));

                merchant.setBankCode(rs.getString("bankcode"));
                merchant.setBankName(rs.getString("BankName"));
                merchant.setBankShortName(rs.getString("ShortName"));

                merchant.setBankCodeModify(rs.getString("bankcode_Modify"));
                merchant.setBankNameModify(rs.getString("BankName_Modify"));
                merchant.setBankShortNameModify(rs.getString("ShortName_Modify"));

                merchant.setBranchCode(rs.getString("branchcode"));
                merchant.setBranchName(rs.getString("BranchName"));

                merchant.setBranchCodeModify(rs.getString("branchcode_Modify"));
                merchant.setBranchNameModify(rs.getString("BranchName_Modify"));

                merchant.setPrimaryAccountNo(rs.getString("PrimaryACNO"));
                merchant.setPrimaryAccountNoModify(rs.getString("PrimaryACNO_Modify"));

                merchant.setPrimaryAccountName(rs.getString("PrimaryACName"));
                merchant.setPrimaryAccountNameModify(rs.getString("PrimaryACName_Modify"));

                merchant.setId(rs.getString("id"));
                merchant.setIdModify(rs.getString("id_Modify"));

                merchant.setStatus(rs.getString("Status"));
                merchant.setStatusModify(rs.getString("Status_Modify"));

                merchant.setCreatedBy(rs.getString("CreatedBy"));

                if (rs.getTimestamp("CreatedDate") != null)
                {
                    merchant.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                }

                merchant.setAuthorizedBy(rs.getString("AuthorizedBy"));

                if (rs.getTimestamp("AuthorizedDate") != null)
                {
                    merchant.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                }

                merchant.setModificationRemarks(rs.getString("ModificationRemarks"));
                merchant.setModifiedBy(rs.getString("ModifiedBy"));

                if (rs.getTimestamp("ModifiedDate") != null)
                {
                    merchant.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                }

                merchant.setModificationAuthBy(rs.getString("ModificationAuthBy"));

                if (rs.getTimestamp("ModificationAuthDate") != null)
                {
                    merchant.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
                }

                mranm = new MerchantAccNoMap();

                mranm.setBank(rs.getString("ACNOM_Bank"));
                mranm.setBankName(rs.getString("ACNOM_BankName"));
                mranm.setBankShortName(rs.getString("ACNOM_ShortName"));
                mranm.setBranch(rs.getString("ACNOM_Branch"));
                mranm.setBranchName(rs.getString("ACNOM_BranchName"));
                mranm.setAcNo(rs.getString("ACNOM_AccountNo"));
                mranm.setAcName(rs.getString("ACNOM_AccountName"));
                mranm.setIsPrimary(rs.getString("ACNOM_IsPrimary"));
                mranm.setStatus(rs.getString("ACNOM_Status"));

                result2 = new java.util.ArrayList();
                result2.add(mranm);

                merchant.setColAccNoMap(result2);

                result.add(merchant);

            }

        }

        return result;
    }

    static Collection<Merchant> makeMerchantObjectsCollectionMinimal(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Merchant> result = new java.util.ArrayList();

        while (rs.next())
        {
            Merchant merchant = new Merchant();

            merchant.setMerchantID(rs.getString("MerchantID"));
            merchant.setMerchantName(rs.getString("MerchantName"));
            merchant.setMerchantNameModify(rs.getString("MerchantName_Modify"));
            merchant.setEmail(rs.getString("Email"));
            merchant.setEmailModify(rs.getString("Email_Modify"));
            merchant.setPrimaryTP(rs.getString("PrimaryTP"));
            merchant.setPrimaryTPModify(rs.getString("PrimaryTP_Modify"));
            merchant.setSecondaryTP(rs.getString("SecondaryTP"));
            merchant.setSecondaryTPModify(rs.getString("SecondaryTP_Modify"));
            merchant.setPassword(rs.getString("Password"));
            merchant.setPasswordModify(rs.getString("Password_Modify"));

            merchant.setBankCode(rs.getString("bankcode"));
            merchant.setBankName(rs.getString("BankName"));
            merchant.setBankShortName(rs.getString("ShortName"));

            merchant.setBankCodeModify(rs.getString("bankcode_Modify"));
            merchant.setBankNameModify(rs.getString("BankName_Modify"));
            merchant.setBankShortNameModify(rs.getString("ShortName_Modify"));

            merchant.setBranchCode(rs.getString("branchcode"));
            merchant.setBranchName(rs.getString("BranchName"));

            merchant.setBranchCodeModify(rs.getString("branchcode_Modify"));
            merchant.setBranchNameModify(rs.getString("BranchName_Modify"));

            merchant.setPrimaryAccountNo(rs.getString("PrimaryACNO"));
            merchant.setPrimaryAccountNoModify(rs.getString("PrimaryACNO_Modify"));

            merchant.setPrimaryAccountName(rs.getString("PrimaryACName"));
            merchant.setPrimaryAccountNameModify(rs.getString("PrimaryACName_Modify"));

            merchant.setId(rs.getString("id"));
            merchant.setIdModify(rs.getString("id_Modify"));

            merchant.setStatus(rs.getString("Status"));
            merchant.setStatusModify(rs.getString("Status_Modify"));

            merchant.setCreatedBy(rs.getString("CreatedBy"));

            if (rs.getTimestamp("CreatedDate") != null)
            {
                merchant.setCreatedDate(DateFormatter.doFormat(rs.getTimestamp("CreatedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            merchant.setAuthorizedBy(rs.getString("AuthorizedBy"));

            if (rs.getTimestamp("AuthorizedDate") != null)
            {
                merchant.setAuthorizedDate(DateFormatter.doFormat(rs.getTimestamp("AuthorizedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            merchant.setModificationRemarks(rs.getString("ModificationRemarks"));
            merchant.setModifiedBy(rs.getString("ModifiedBy"));

            if (rs.getTimestamp("ModifiedDate") != null)
            {
                merchant.setModifiedDate(DateFormatter.doFormat(rs.getTimestamp("ModifiedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            merchant.setModificationAuthBy(rs.getString("ModificationAuthBy"));

            if (rs.getTimestamp("ModificationAuthDate") != null)
            {
                merchant.setModificationAuthDate(DateFormatter.doFormat(rs.getTimestamp("ModificationAuthDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            result.add(merchant);

        }

        return result;
    }

}
