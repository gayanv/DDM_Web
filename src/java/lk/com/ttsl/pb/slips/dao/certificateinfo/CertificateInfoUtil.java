/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.certificateinfo;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Collection;
import java.util.Date;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;

/**
 *
 * @author Dinesh
 */
class CertificateInfoUtil
{

    static Collection<CertificateInfo> makeCertificateObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<CertificateInfo> result = new java.util.ArrayList();

        while (rs.next())
        {
            CertificateInfo cert = new CertificateInfo();

            cert.setUserID(rs.getString("userid"));
            cert.setBankCode(rs.getString("bankcode"));
            cert.setBankName(rs.getString("FullName"));
            cert.setCertificateserial(rs.getString("certificateserial"));
            cert.setTokenserial(rs.getString("tokenserial"));
            cert.setValidFrom(rs.getString("validfrom"));
            cert.setValidTo(rs.getString("validto"));
            cert.setDeviceId(rs.getString("deviceid"));

            if (rs.getString("validfrom") != null)
            {
                Date date = new Date();

                try
                {
                    if (DateFormatter.getTime(rs.getString("validfrom"), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss_2) < date.getTime())
                    {
                        cert.setIsValid(true);
                        cert.setStrIsValid(DDM_Constants.status_yes);
                    }
                    else
                    {
                        cert.setIsValid(false);
                        cert.setStrIsValid(DDM_Constants.status_no);
                    }
                }
                catch (ParseException ex)
                {
                    System.out.println("Error----->" + ex.getMessage());
                    cert.setIsValid(false);
                }
            }
            else
            {
                cert.setIsValid(false);
                cert.setStrIsValid(DDM_Constants.status_no);
            }

            if (rs.getString("validto") != null)
            {
                Date date = new Date();

                try
                {
                    if (DateFormatter.getTime(rs.getString("validto"), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss_2) < date.getTime())
                    {
                        cert.setIsExpired(true);
                        cert.setIsValid(false);

                        cert.setStrIsExpired(DDM_Constants.status_yes);
                        cert.setStrIsValid(DDM_Constants.status_no);

                    }
                    else
                    {
                        cert.setIsExpired(false);

                        cert.setStrIsExpired(DDM_Constants.status_no);
                        //cert.setStrIsValid(DDM_Constants.status_no);

                    }
                }
                catch (ParseException ex)
                {
                    System.out.println("Error----->" + ex.getMessage());
                    cert.setIsExpired(true);
                    cert.setIsValid(false);

                    cert.setStrIsExpired(DDM_Constants.status_yes);
                    cert.setStrIsValid(DDM_Constants.status_no);
                }
            }
            else
            {
                cert.setIsExpired(true);
                cert.setIsValid(false);

                cert.setStrIsExpired(DDM_Constants.status_yes);
                cert.setStrIsValid(DDM_Constants.status_no);
            }

            cert.setNoOfDaysToExpire(rs.getInt("DaysToExpire"));

            new CertificateInfoDAOImpl().updateCertificateValidity(new CertificateInfo(cert.isIsExpired(), cert.isIsValid(), cert.getUserID(), cert.getNoOfDaysToExpire()));

            result.add(cert);
        }

        return result;
    }

    static CertificateInfo makeCertificateObject(ResultSet rs) throws SQLException
    {
        CertificateInfo cert = null;

        if (rs != null && rs.isBeforeFirst())
        {
            rs.next();

            cert = new CertificateInfo();

            cert.setUserID(rs.getString("userid"));
            cert.setBankCode(rs.getString("bankcode"));
            cert.setBankName(rs.getString("FullName"));
            cert.setCertificateserial(rs.getString("certificateserial"));
            cert.setTokenserial(rs.getString("tokenserial"));
            cert.setValidFrom(rs.getString("validfrom"));
            cert.setValidTo(rs.getString("validto"));
            cert.setDeviceId(rs.getString("deviceid"));

            if (rs.getString("validfrom") != null)
            {
                Date date = new Date();

                try
                {
                    if (DateFormatter.getTime(rs.getString("validfrom"), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss_2) < date.getTime())
                    {
                        cert.setIsValid(true);
                        cert.setStrIsValid(DDM_Constants.status_yes);
                    }
                    else
                    {
                        cert.setIsValid(false);
                        cert.setStrIsValid(DDM_Constants.status_no);
                    }
                }
                catch (ParseException ex)
                {
                    System.out.println("Error----->" + ex.getMessage());
                    cert.setIsValid(false);
                }
            }
            else
            {
                cert.setIsValid(false);
                cert.setStrIsValid(DDM_Constants.status_no);
            }

            if (rs.getString("validto") != null)
            {
                Date date = new Date();

                try
                {
                    if (DateFormatter.getTime(rs.getString("validto"), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss_2) < date.getTime())
                    {
                        cert.setIsExpired(true);
                        cert.setIsValid(false);

                        cert.setStrIsExpired(DDM_Constants.status_yes);
                        cert.setStrIsValid(DDM_Constants.status_no);

                    }
                    else
                    {
                        cert.setIsExpired(false);

                        cert.setStrIsExpired(DDM_Constants.status_no);
                        //cert.setStrIsValid(DDM_Constants.status_no);

                    }
                }
                catch (ParseException ex)
                {
                    System.out.println("Error----->" + ex.getMessage());
                    cert.setIsExpired(true);
                    cert.setIsValid(false);

                    cert.setStrIsExpired(DDM_Constants.status_yes);
                    cert.setStrIsValid(DDM_Constants.status_no);
                }
            }
            else
            {
                cert.setIsExpired(true);
                cert.setIsValid(false);

                cert.setStrIsExpired(DDM_Constants.status_yes);
                cert.setStrIsValid(DDM_Constants.status_no);
            }

            cert.setNoOfDaysToExpire(rs.getInt("DaysToExpire"));

            new CertificateInfoDAOImpl().updateCertificateValidity(new CertificateInfo(cert.isIsExpired(), cert.isIsValid(), cert.getUserID(), cert.getNoOfDaysToExpire()));

        }

        return cert;
    }

}
