/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.account;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.StringTokenizer;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;


/**
 *
 * @author Dinesh
 */
public class AccountDAOImpl implements AccountDAO
{
    String msg = null;

    @Override
    public String getMsg()
    {
        return msg;
    }

    @Override
    public Collection<Account> findAccounts(String bankCode, String branchCode, String accountNo, String type, String status)
    {
        Collection<Account> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (branchCode == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return col;
        }
        if (accountNo == null)
        {
            System.out.println("WARNING : Null accountNo parameter.");
            return col;
        }
        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_bankCode = 1;
            int val_branchCode = 2;
            int val_glsAccountNo = 3;
            int val_status = 4;
            int val_type = 5;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ai.BankCode, ba.ShortName, ba.FullName, ai.BranchCode, br.BranchName, ai.AccountNo, ai.AccountType, atype.TypeDesc, ai.AccountSubType, ai.AccountStatus, astat.StatusDesc, ai.AccountHolderName, ai.AccountHoderAddress1, ai.AccountHoderAddress2, ai.AccountHoderAddress3, ai.AccountHoderAddress4, ai.ContactNo, ai.SecondaryAccountHolderName, ai.SecondaryAccountHolderAddress, ai.SecondaryContactNo, ai.IsNamePrePrintedOnCheques, ai.ModifiedBy, ai.ModifiedDate ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ai, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_account_status + " astat, ");
            sbQuery.append(DDM_Constants.tbl_account_type + " atype ");
            sbQuery.append("WHERE ai.BankCode =  ba.BankCode ");
            sbQuery.append("AND ai.BankCode =  br.BankCode ");
            sbQuery.append("AND ai.BranchCode =  br.BranchCode ");
            sbQuery.append("AND ai.AccountStatus =  astat.Status ");
            sbQuery.append("AND ai.AccountType =  atype.Type ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ai.BankCode = ? ");
                vt.add(val_bankCode);
            }

            if (!branchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ai.BranchCode = ? ");
                vt.add(val_branchCode);
            }

            if (!accountNo.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ai.AccountNo like ? ");
                vt.add(val_glsAccountNo);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ai.AccountStatus = ? ");
                vt.add(val_status);
            }

            if (!type.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ai.AccountType = ? ");
                vt.add(val_type);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            //System.out.println("sbQuery ---> " + sbQuery.toString());
            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, branchCode);
                    i++;
                }
                if (val_item == 3)
                {
                    pstm.setString(i, accountNo + "%");
                    i++;
                }
                if (val_item == 4)
                {
                    pstm.setString(i, status);
                    i++;
                }
                if (val_item == 5)
                {
                    pstm.setString(i, type);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = AccountUtil.makeAccountObjectsCollection(rs);

            //System.out.println("col.size() --> " + col.size());
            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }



    @Override
    public Collection<Account> getAccounts(String bankCode, String branchCode, String accountNo, String type, String status)
    {
        Collection<Account> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
//
//        System.out.println("AccountDAOImpl :::::::: getAccounts | bankCode ---> " + bankCode);
//        System.out.println("AccountDAOImpl :::::::: getAccounts | branchCode ---> " + branchCode);
//        System.out.println("AccountDAOImpl :::::::: getAccounts | accountNo ---> " + accountNo);
//        System.out.println("AccountDAOImpl :::::::: getAccounts | type ---> " + type);
//        System.out.println("AccountDAOImpl :::::::: getAccounts | status ---> " + status);

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }
        if (branchCode == null)
        {
            System.out.println("WARNING : Null branchCode parameter.");
            return col;
        }
        if (accountNo == null)
        {
            System.out.println("WARNING : Null accountNo parameter.");
            return col;
        }
        if (type == null)
        {
            System.out.println("WARNING : Null type parameter.");
            return col;
        }
        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();

            ArrayList<Integer> vt = new ArrayList();

            int val_bankCode = 1;
            int val_branchCode = 2;
            int val_glsAccountNo = 3;
            int val_status = 4;
            int val_type = 5;

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("select ai.BankCode, ba.ShortName, ba.FullName, ai.BranchCode, br.BranchName, ai.AccountNo, ai.AccountType, at.TypeDesc, ai.AccountSubType, ai.AccountStatus, acts.StatusDesc, ai.AccountHolderName, ai.AccountHoderAddress1, ai.AccountHoderAddress2, ai.AccountHoderAddress3, ai.AccountHoderAddress4, ai.ContactNo, ai.SecondaryAccountHolderName, ai.SecondaryAccountHolderAddress, ai.SecondaryContactNo, ai.IsNamePrePrintedOnCheques, ai.ModifiedBy, ai.ModifiedDate ");
            sbQuery.append("FROM ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ai, ");
            sbQuery.append(DDM_Constants.tbl_bank + " ba, ");
            sbQuery.append(DDM_Constants.tbl_branch + " br, ");
            sbQuery.append(DDM_Constants.tbl_account_status + " acts, ");
            sbQuery.append(DDM_Constants.tbl_account_type + " at ");
            sbQuery.append("WHERE ai.BankCode =  ba.BankCode ");
            sbQuery.append("AND ai.BankCode =  br.BankCode ");
            sbQuery.append("AND ai.BranchCode =  br.BranchCode ");
            sbQuery.append("AND ai.AccountStatus =  acts.Status ");
            sbQuery.append("AND ai.AccountType =  at.Type ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ai.BankCode = ? ");
                vt.add(val_bankCode);
            }

            if (!branchCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ai.BranchCode = ? ");
                vt.add(val_branchCode);
            }

            if (!accountNo.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ai.AccountNo = ? ");
                vt.add(val_glsAccountNo);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ai.AccountStatus = ? ");
                vt.add(val_status);
            }

            if (!type.equals(DDM_Constants.status_all))
            {
                sbQuery.append("AND ai.AccountType = ? ");
                vt.add(val_type);
            }

            pstm = con.prepareStatement(sbQuery.toString());

            System.out.println("AccountDAOImpl :::::::: sbQuery ---> " + sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == 1)
                {
                    pstm.setString(i, bankCode);
                    i++;
                }
                if (val_item == 2)
                {
                    pstm.setString(i, branchCode);
                    i++;
                }
                if (val_item == 3)
                {
                    pstm.setString(i, accountNo);
                    i++;
                }
                if (val_item == 4)
                {
                    pstm.setString(i, status);
                    i++;
                }
                if (val_item == 5)
                {
                    pstm.setString(i, type);
                    i++;
                }
            }

            rs = pstm.executeQuery();

            col = AccountUtil.makeAccountObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing;
            System.out.println(e.getMessage());
        }
        finally
        {
            DBUtil.getInstance().closeResultSet(rs);
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return col;
    }

 

    public boolean addAccount(Account account)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count = 0;

        //System.out.println("============ Inside addAccount ==========");
        if (account.getBankCode() == null)
        {
            System.out.println("WARNING : Null account.getBankCode() parameter.");
            return status;
        }

        if (account.getBranchCode() == null)
        {
            System.out.println("WARNING : Null account.getBranchCode() parameter.");
            return status;
        }

        if (account.getAccountNo() == null)
        {
            System.out.println("WARNING : Null account.getAccountNo() parameter.");
            return status;
        }

        if (account.getAccountHolderName() == null)
        {
            System.out.println("WARNING : Null account.getAccountHolderName() parameter.");
            return status;
        }

        if (account.getAccountType() == null)
        {
            System.out.println("WARNING : Null account.getAccountType() parameter.");
            return status;
        }

        if (account.getAccountSubType() == null)
        {
            System.out.println("WARNING : Null account.getAccountSubType() parameter.");
            return status;
        }

        if (account.getAccountStatus() == null)
        {
            System.out.println("WARNING : Null account.getAccountStatus() parameter.");
            return status;
        }
        if (account.getModifiedBy() == null)
        {
            System.out.println("WARNING : Null account.getModifiedBy() parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ");

            if (account.getSecondaryAccountHolderName() != null)
            {
                sbQuery.append("(BankCode,BranchCode,AccountNo,AccountType,AccountSubType,AccountStatus,AccountHolderName,AccountHoderAddress1,AccountHoderAddress2,AccountHoderAddress3,AccountHoderAddress4,ContactNo,SecondaryAccountHolderName,SecondaryContactNo,IsNamePrePrintedOnCheques,ModifiedBy,ModifiedDate) ");
            }
            else
            {
                sbQuery.append("(BankCode,BranchCode,AccountNo,AccountType,AccountSubType,AccountStatus,AccountHolderName,AccountHoderAddress1,AccountHoderAddress2,AccountHoderAddress3,AccountHoderAddress4,ContactNo,IsNamePrePrintedOnCheques,ModifiedBy,ModifiedDate) ");
            }

            if (account.getSecondaryAccountHolderName() != null)
            {
                sbQuery.append("values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,now()) ");

                sbQuery.append("ON DUPLICATE KEY UPDATE AccountHolderName = ?, AccountHoderAddress1 = ?, AccountHoderAddress2 = ?, AccountHoderAddress3 = ?, AccountHoderAddress4 = ?, ContactNo = ?, SecondaryAccountHolderName = ?, SecondaryContactNo = ?, ModifiedBy = ?, AccountSubType = ?, ModifiedDate = now(), AccountStatus = ? ");
            }
            else
            {
                sbQuery.append("values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,now()) ");

                sbQuery.append("ON DUPLICATE KEY UPDATE AccountHolderName = ?, AccountHoderAddress1 = ?, AccountHoderAddress2 = ?, AccountHoderAddress3 = ?, AccountHoderAddress4 = ?, ContactNo = ?, SecondaryAccountHolderName = ?, SecondaryContactNo = ?, ModifiedBy = ?, AccountSubType = ?, ModifiedDate = now(), AccountStatus = ? ");
            }

            System.out.println(sbQuery.toString());

            pstm = con.prepareStatement(sbQuery.toString());

            if (account.getSecondaryAccountHolderName() != null)
            {
                pstm.setString(1, account.getBankCode());
                pstm.setString(2, account.getBranchCode());
                pstm.setString(3, account.getAccountNo());
                pstm.setString(4, account.getAccountType());
                pstm.setString(5, account.getAccountSubType());
                pstm.setString(6, account.getAccountStatus());
                pstm.setString(7, account.getAccountHolderName());
                pstm.setString(8, account.getAccountHoderAddress1());
                pstm.setString(9, account.getAccountHoderAddress2());
                pstm.setString(10, account.getAccountHoderAddress3());
                pstm.setString(11, account.getAccountHoderAddress4());

                pstm.setString(12, account.getContactNo());
                pstm.setString(13, account.getSecondaryAccountHolderName());
                pstm.setString(14, account.getSecondaryContactNo());
                pstm.setString(15, account.getIsNamePrePrintedOnCheques());
                pstm.setString(16, account.getModifiedBy());

                pstm.setString(17, account.getAccountHolderName());
                pstm.setString(18, account.getAccountHoderAddress1());
                pstm.setString(19, account.getAccountHoderAddress2());
                pstm.setString(20, account.getAccountHoderAddress3());
                pstm.setString(21, account.getAccountHoderAddress4());

                pstm.setString(22, account.getContactNo());
                pstm.setString(23, account.getSecondaryAccountHolderName());
                pstm.setString(24, account.getSecondaryContactNo());
                pstm.setString(25, account.getModifiedBy());
                pstm.setString(26, account.getAccountSubType());
                pstm.setString(27, account.getAccountStatus());

            }
            else
            {
                pstm.setString(1, account.getBankCode());
                pstm.setString(2, account.getBranchCode());
                pstm.setString(3, account.getAccountNo());
                pstm.setString(4, account.getAccountType());
                pstm.setString(5, account.getAccountSubType());
                pstm.setString(6, account.getAccountStatus());
                pstm.setString(7, account.getAccountHolderName());
                pstm.setString(8, account.getAccountHoderAddress1());
                pstm.setString(9, account.getAccountHoderAddress2());
                pstm.setString(10, account.getAccountHoderAddress3());
                pstm.setString(11, account.getAccountHoderAddress4());

                pstm.setString(12, account.getContactNo());
                pstm.setString(13, account.getIsNamePrePrintedOnCheques());
                pstm.setString(14, account.getModifiedBy());

                pstm.setString(15, account.getAccountHolderName());
                pstm.setString(16, account.getAccountHoderAddress1());
                pstm.setString(17, account.getAccountHoderAddress2());
                pstm.setString(18, account.getAccountHoderAddress3());
                pstm.setString(19, account.getAccountHoderAddress4());

                pstm.setString(20, account.getContactNo());
                pstm.setString(21, account.getSecondaryAccountHolderName());
                pstm.setString(22, account.getSecondaryContactNo());
                pstm.setString(23, account.getModifiedBy());
                pstm.setString(24, account.getAccountSubType());
                pstm.setString(25, account.getAccountStatus());
            }

            count = pstm.executeUpdate();

            if (count > 0)
            {
                status = true;
            }
            else
            {
                status = false;
                msg = DDM_Constants.msg_no_records_updated;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing + " - " + e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    public boolean addBulkAccounts(Collection<Account> colAccount)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int[] count;

        //System.out.println("============ Inside addAccount ==========");
        if (colAccount == null)
        {
            System.out.println("WARNING : Null colAccount parameter.");
            return status;
        }

        try
        {
            //new AccountDAOImpl().deleteBulkAccounts(colAccount);            

            con = DBUtil.getInstance().getConnection();
            con.setAutoCommit(false);

            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ");
            sbQuery.append("(BankCode,BranchCode,AccountNo,AccountType,AccountSubType,AccountStatus,AccountHolderName,AccountHoderAddress1,AccountHoderAddress2,AccountHoderAddress3,AccountHoderAddress4,ContactNo,SecondaryAccountHolderName,SecondaryContactNo,IsNamePrePrintedOnCheques,ModifiedBy,ModifiedDate) ");

            sbQuery.append("values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,now()) ");

            sbQuery.append("ON DUPLICATE KEY UPDATE AccountHolderName = ?, AccountHoderAddress1 = ?, AccountHoderAddress2 = ?, AccountHoderAddress3 = ?, AccountHoderAddress4 = ?, ContactNo = ?, SecondaryAccountHolderName = ?, SecondaryContactNo = ?, ModifiedBy = ?, AccountSubType = ?, ModifiedDate = now(), AccountStatus = ? ");

            //System.out.println(sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            for (Account account : colAccount)
            {
                pstm.setString(1, account.getBankCode());
                pstm.setString(2, account.getBranchCode());
                pstm.setString(3, account.getAccountNo());
                pstm.setString(4, account.getAccountType());
                pstm.setString(5, account.getAccountSubType());
                pstm.setString(6, account.getAccountStatus());
                pstm.setString(7, account.getAccountHolderName());
                pstm.setString(8, account.getAccountHoderAddress1());
                pstm.setString(9, account.getAccountHoderAddress2());
                pstm.setString(10, account.getAccountHoderAddress3());
                pstm.setString(11, account.getAccountHoderAddress4());

                pstm.setString(12, account.getContactNo());
                pstm.setString(13, account.getSecondaryAccountHolderName());
                pstm.setString(14, account.getSecondaryContactNo());
                pstm.setString(15, account.getIsNamePrePrintedOnCheques());
                pstm.setString(16, account.getModifiedBy());

                pstm.setString(17, account.getAccountHolderName());
                pstm.setString(18, account.getAccountHoderAddress1());
                pstm.setString(19, account.getAccountHoderAddress2());
                pstm.setString(20, account.getAccountHoderAddress3());
                pstm.setString(21, account.getAccountHoderAddress4());

                pstm.setString(22, account.getContactNo());
                pstm.setString(23, account.getSecondaryAccountHolderName());
                pstm.setString(24, account.getSecondaryContactNo());
                pstm.setString(25, account.getModifiedBy());
                pstm.setString(26, account.getAccountSubType());
                pstm.setString(27, account.getAccountStatus());

                pstm.addBatch();
            }

            count = pstm.executeBatch();

            if (count.length > 0)
            {
                con.commit();
                status = true;
                System.out.println("addBulkAccounts is success and no. of accounts newly added ------->  " + count.length);
            }
            else
            {
                status = false;
                msg = DDM_Constants.msg_no_records_updated;
            }
        }
        catch (SQLException | ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing + " - " + e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    public boolean addBulkAccounts2(Collection<Account> colAccount)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int[] count;

        //System.out.println("============ Inside addAccount ==========");
        if (colAccount == null)
        {
            System.out.println("WARNING : Null colAccount parameter.");
            return status;
        }

        try
        {
            new AccountDAOImpl().deleteBulkAccounts(colAccount);

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("insert into ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ");
            sbQuery.append("(BankCode,BranchCode,AccountNo,AccountType,AccountSubType,AccountStatus,AccountHolderName,AccountHoderAddress1,AccountHoderAddress2,AccountHoderAddress3,AccountHoderAddress4,ContactNo,SecondaryAccountHolderName,SecondaryContactNo,IsNamePrePrintedOnCheques,ModifiedBy,ModifiedDate) ");

            sbQuery.append("values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,now()) ");

            //System.out.println(sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            for (Account account : colAccount)
            {
                pstm.setString(1, account.getBankCode());
                pstm.setString(2, account.getBranchCode());
                pstm.setString(3, account.getAccountNo());
                pstm.setString(4, account.getAccountType());
                pstm.setString(5, account.getAccountSubType());
                pstm.setString(6, account.getAccountStatus());
                pstm.setString(7, account.getAccountHolderName());
                pstm.setString(8, account.getAccountHoderAddress1());
                pstm.setString(9, account.getAccountHoderAddress2());
                pstm.setString(10, account.getAccountHoderAddress3());
                pstm.setString(11, account.getAccountHoderAddress4());

                pstm.setString(12, account.getContactNo());
                pstm.setString(13, account.getSecondaryAccountHolderName());
                pstm.setString(14, account.getSecondaryContactNo());
                pstm.setString(15, account.getIsNamePrePrintedOnCheques());
                pstm.setString(16, account.getModifiedBy());

                pstm.addBatch();
            }

            count = pstm.executeBatch();

            if (count.length > 0)
            {
                status = true;
                System.out.println("addBulkAccounts is success ----------------> " + count.length);
            }
            else
            {
                status = false;
                msg = DDM_Constants.msg_no_records_updated;
            }
        }
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing + " - " + e.getMessage();
            System.out.println(e.toString());
        }
        catch (ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing + " - " + e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    public boolean deleteBulkAccounts(Collection<Account> colAccount)
    {
        Connection con = null;
        PreparedStatement pstm = null;
        boolean status = false;
        int count;

        //System.out.println("============ Inside addAccount ==========");
        if (colAccount == null)
        {
            System.out.println("WARNING : Null colAccount parameter.");
            return status;
        }

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            String accNos = "";

            for (Account account : colAccount)
            {
                accNos = accNos + ",'" + account.getAccountNo() + "'";
            }

            accNos = accNos.replaceFirst(",", "");

            sbQuery.append("delete from ");
            sbQuery.append(DDM_Constants.tbl_accountinfo + " ");
            sbQuery.append("where AccountNo in (").append(accNos).append(") ");

            //System.out.println(sbQuery.toString());
            pstm = con.prepareStatement(sbQuery.toString());

            count = pstm.executeUpdate();

            System.out.println("deleteBulkAccounts ---> count - " + count);

            if (count > 0)
            {
                status = true;
            }
            else
            {
                status = false;
                msg = DDM_Constants.msg_no_records_updated;
            }
        }
        catch (SQLException e)
        {
            msg = DDM_Constants.msg_error_while_processing + " - " + e.getMessage();
            System.out.println(e.toString());
        }
        catch (ClassNotFoundException e)
        {
            msg = DDM_Constants.msg_error_while_processing + " - " + e.getMessage();
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(pstm);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

}
