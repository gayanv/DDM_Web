/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public class CorporateCustomerAccNoMapUtil
{

    static Collection<CorporateCustomerAccNoMap> makeCorporateCustomerAccountMapObjectCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<CorporateCustomerAccNoMap> result = new java.util.ArrayList();

        while (rs.next())
        {
            CorporateCustomerAccNoMap ccanm = new CorporateCustomerAccNoMap();

            ccanm.setCoCuID(rs.getString("CoCuID"));
            ccanm.setAccNo(rs.getString("AccNo"));
            ccanm.setAccName(rs.getString("AccountHolderName"));
            ccanm.setAccAddress(rs.getString("AccAddress"));
            ccanm.setAccBranch(rs.getString("AccBranch"));
            ccanm.setAccType(rs.getString("AccountSubType"));
            //ccanm.setAccTypeDesc(rs.getString("SubAccDesc"));
            ccanm.setAccStatus(rs.getString("AccountStatus"));
            ccanm.setAccStatusDesc(rs.getString("AccStatusDesc"));
            ccanm.setStatus(rs.getString("AccNoMapStatus"));
            ccanm.setStatusModify(rs.getString("AccNoMapStatusModify"));

            ccanm.setCreatedBy(rs.getString("AccNoMapCreatedBy"));

            if (rs.getTimestamp("AccNoMapCreatedDate") != null)
            {
                ccanm.setCreatedDate(rs.getString("AccNoMapCreatedDate"));
            }

            ccanm.setAuthorizedBy(rs.getString("AccNoMapAuthorizedBy"));

            if (rs.getTimestamp("AccNoMapAuthorizedDate") != null)
            {
                ccanm.setAuthorizedDate(rs.getString("AccNoMapAuthorizedDate"));
            }

            ccanm.setModifiedBy(rs.getString("AccNoMapModifiedBy"));

            if (rs.getTimestamp("AccNoMapModifiedDate") != null)
            {
                ccanm.setModifiedDate(rs.getString("AccNoMapModifiedDate"));
            }

            ccanm.setModificationAuthBy(rs.getString("AccNoMapModificationAuthBy"));

            if (rs.getTimestamp("AccNoMapModificationAuthDate") != null)
            {
                ccanm.setModificationAuthDate(rs.getString("AccNoMapModificationAuthDate"));
            }

            result.add(ccanm);
        }

        return result;
    }

}
