/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.merchant.accnomap;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class MerchantAccNoMapUtil
{

    private MerchantAccNoMapUtil()
    {
    }

    static MerchantAccNoMap makeMerchantAccountMapObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        MerchantAccNoMap mranm = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            mranm = new MerchantAccNoMap();

            mranm.setMerchantID(rs.getString("merchantid"));
            mranm.setBank(rs.getString("bankcode"));
            mranm.setBankName(rs.getString("BankName"));
            mranm.setBankShortName(rs.getString("BankShortName"));
            mranm.setBranch(rs.getString("branchcode"));
            mranm.setBranchName(rs.getString("BranchName"));
            mranm.setAcNo(rs.getString("acno"));
            mranm.setAcName(rs.getString("acname"));
            mranm.setIsPrimary(rs.getString("isprimary"));
            mranm.setStatus(rs.getString("AccNoMapStatus"));
            mranm.setStatusModify(rs.getString("AccNoMapStatusModify"));

            mranm.setCreatedBy(rs.getString("AccNoMapCreatedBy"));

            if (rs.getTimestamp("AccNoMapCreatedDate") != null)
            {
                mranm.setCreatedDate(rs.getString("AccNoMapCreatedDate"));
            }

            mranm.setAuthorizedBy(rs.getString("AccNoMapAuthorizedBy"));

            if (rs.getTimestamp("AccNoMapAuthorizedDate") != null)
            {
                mranm.setAuthorizedDate(rs.getString("AccNoMapAuthorizedDate"));
            }

            mranm.setModifiedBy(rs.getString("AccNoMapModifiedBy"));

            if (rs.getTimestamp("AccNoMapModifiedDate") != null)
            {
                mranm.setModifiedDate(rs.getString("AccNoMapModifiedDate"));
            }

            mranm.setModificationAuthBy(rs.getString("AccNoMapModificationAuthBy"));

            if (rs.getTimestamp("AccNoMapModificationAuthDate") != null)
            {
                mranm.setModificationAuthDate(rs.getString("AccNoMapModificationAuthDate"));
            }

        }

        return mranm;
    }

    static Collection<MerchantAccNoMap> makeMerchantAccountMapObjectCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<MerchantAccNoMap> result = new java.util.ArrayList();

        while (rs.next())
        {
            MerchantAccNoMap mranm = new MerchantAccNoMap();

            mranm.setMerchantID(rs.getString("merchantid"));
            mranm.setBank(rs.getString("bankcode"));
            mranm.setBankName(rs.getString("BankName"));
            mranm.setBankShortName(rs.getString("BankShortName"));
            mranm.setBranch(rs.getString("branchcode"));
            mranm.setBranchName(rs.getString("BranchName"));
            mranm.setAcNo(rs.getString("acno"));
            mranm.setAcName(rs.getString("acname"));
            mranm.setIsPrimary(rs.getString("isprimary"));
            mranm.setStatus(rs.getString("AccNoMapStatus"));
            mranm.setStatusModify(rs.getString("AccNoMapStatusModify"));

            mranm.setCreatedBy(rs.getString("AccNoMapCreatedBy"));

            if (rs.getTimestamp("AccNoMapCreatedDate") != null)
            {
                mranm.setCreatedDate(rs.getString("AccNoMapCreatedDate"));
            }

            mranm.setAuthorizedBy(rs.getString("AccNoMapAuthorizedBy"));

            if (rs.getTimestamp("AccNoMapAuthorizedDate") != null)
            {
                mranm.setAuthorizedDate(rs.getString("AccNoMapAuthorizedDate"));
            }

            mranm.setModifiedBy(rs.getString("AccNoMapModifiedBy"));

            if (rs.getTimestamp("AccNoMapModifiedDate") != null)
            {
                mranm.setModifiedDate(rs.getString("AccNoMapModifiedDate"));
            }

            mranm.setModificationAuthBy(rs.getString("AccNoMapModificationAuthBy"));

            if (rs.getTimestamp("AccNoMapModificationAuthDate") != null)
            {
                mranm.setModificationAuthDate(rs.getString("AccNoMapModificationAuthDate"));
            }

            result.add(mranm);
        }

        return result;
    }

}
