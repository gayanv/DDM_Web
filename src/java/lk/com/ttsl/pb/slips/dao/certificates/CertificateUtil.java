/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.certificates;

import java.io.File;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Collection;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;


/**
 *
 * @author Dinesh
 */
class CertificateUtil
{

    static Collection<Certificate> makeCertificateObjectsCollection(ResultSet rs) throws SQLException, ParseException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<Certificate> result = new java.util.ArrayList();

        while (rs.next())
        {
            Certificate cert = new Certificate();

            cert.setFileName(rs.getString("FileName"));
            cert.setOriginalFileName(rs.getString("OrginalFileName"));
            cert.setBankCode(rs.getString("BankCode"));
            cert.setBankName(rs.getString("BankName"));
            cert.setId(rs.getString("CertificateId"));
            cert.setType(rs.getString("Type"));
            cert.setVersion(rs.getString("Version"));
            cert.setSignatureAlgorithm(rs.getString("SignatureAlgorithm"));
            cert.setIssuer(rs.getString("Issuer"));
            cert.setSerialNumber("" + rs.getInt("CertificateSerial"));
            cert.setTokenSerial(rs.getString("TokenSerial"));
            cert.setCustomerName(rs.getString("CustomerName"));
            cert.setCustomerLevel(rs.getString("CustomerLevel"));
            cert.setEmail(rs.getString("Email"));
            cert.setLocality(rs.getString("Locality"));

//            cert.setIsValid(rs.getString("IsValid") != null ? rs.getString("IsValid").equals(DDM_Constants.status_yes) : false);
//            cert.setIsExpired(rs.getString("IsExpired") != null ? rs.getString("IsExpired").equals(DDM_Constants.status_yes) : false);
            cert.setValidFrom(rs.getString("ValidFrom"));
            cert.setValidTo(rs.getString("ValidTo"));

            if (rs.getString("ValidFrom") != null)
            {
                Date date = new Date();

                if (DateFormatter.getTime(rs.getString("ValidFrom"), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss) < date.getTime())
                {
                    cert.setIsValid(true);
                }
                else
                {
                    cert.setIsValid(false);
                }

            }
            else
            {
                cert.setIsValid(false);
            }

            if (rs.getString("ValidTo") != null)
            {
                Date date = new Date();

                if (DateFormatter.getTime(rs.getString("ValidTo"), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss) < date.getTime())
                {
                    cert.setIsExpired(true);
                    cert.setIsValid(false);
                }
                else
                {
                    cert.setIsExpired(false);
                }

            }
            else
            {
                cert.setIsExpired(true);
                cert.setIsValid(false);
            }

            new CertificateDAOImpl().updateCertificateValidity(new Certificate(cert.isIsExpired(), cert.isIsValid(), cert.getFileName()));

            cert.setStatus(rs.getString("Status"));
            cert.setCommonPath(rs.getString("CommonPath"));
            cert.setIwdPath(rs.getString("IWDPath"));
            cert.setTempPath(rs.getString("TempPath"));
            cert.setIsDefault(rs.getString("IsDefault"));
            cert.setRemarks(rs.getString("Remarks"));
            cert.setUploadedBy(rs.getString("UploadedBy"));

            if (rs.getTimestamp("UploadedDate") != null)
            {
                cert.setUploadedDate(DateFormatter.doFormat(rs.getTimestamp("UploadedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            cert.setApprovalRemarks(rs.getString("ApprovalRemarks"));
            cert.setApprovedBy(rs.getString("ApprovedBy"));

            if (rs.getTimestamp("ApprovedDate") != null)
            {
                cert.setApprovedDate(DateFormatter.doFormat(rs.getTimestamp("ApprovedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            cert.setDefaultRequestBy(rs.getString("DefaultRequestBy"));

            if (rs.getTimestamp("DefaultRequestTime") != null)
            {
                cert.setDefaultRequestTime(DateFormatter.doFormat(rs.getTimestamp("DefaultRequestTime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            cert.setDefaultApprovalRemarks(rs.getString("DefaultApprovalRemarks"));
            cert.setDefaultApprovedBy(rs.getString("DefaultApprovedBy"));

            if (rs.getTimestamp("DefaultApprovedTime") != null)
            {
                cert.setDefaultApprovedTime(DateFormatter.doFormat(rs.getTimestamp("DefaultApprovedTime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            
            cert.setNoOfDaysToExpire(rs.getInt("DaysToExpire"));

            result.add(cert);
        }

        return result;
    }

    static Certificate makeCertificateObject(ResultSet rs) throws SQLException
    {
        Certificate cert = null;

        if (rs != null && rs.isBeforeFirst())
        {
            rs.next();

            cert = new Certificate();

            cert.setFileName(rs.getString("FileName"));
            cert.setOriginalFileName(rs.getString("OrginalFileName"));
            cert.setBankCode(rs.getString("BankCode"));
            cert.setBankName(rs.getString("BankName"));
            cert.setId(rs.getString("CertificateId"));
            cert.setType(rs.getString("Type"));
            cert.setVersion(rs.getString("Version"));
            cert.setSignatureAlgorithm(rs.getString("SignatureAlgorithm"));
            cert.setIssuer(rs.getString("Issuer"));
            cert.setSerialNumber("" + rs.getInt("CertificateSerial"));
            cert.setTokenSerial(rs.getString("TokenSerial"));
            cert.setCustomerName(rs.getString("CustomerName"));
            cert.setCustomerLevel(rs.getString("CustomerLevel"));
            cert.setEmail(rs.getString("Email"));
            cert.setLocality(rs.getString("Locality"));

//            cert.setIsValid(rs.getString("IsValid") != null ? rs.getString("IsValid").equals(DDM_Constants.status_yes) : false);
//            cert.setIsExpired(rs.getString("IsExpired") != null ? rs.getString("IsExpired").equals(DDM_Constants.status_yes) : false);
            cert.setValidFrom(rs.getString("ValidFrom"));
            cert.setValidTo(rs.getString("ValidTo"));

            if (rs.getString("ValidFrom") != null)
            {
                Date date = new Date();

                try
                {
                    if (DateFormatter.getTime(rs.getString("ValidFrom"), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss) < date.getTime())
                    {
                        cert.setIsValid(true);
                    }
                    else
                    {
                        cert.setIsValid(false);
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
            }

            if (rs.getString("ValidTo") != null)
            {
                Date date = new Date();

                try
                {
                    if (DateFormatter.getTime(rs.getString("ValidTo"), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss) < date.getTime())
                    {
                        cert.setIsExpired(true);
                        cert.setIsValid(false);
                    }
                    else
                    {
                        cert.setIsExpired(false);
                    }
                }
                catch (ParseException ex)
                {
                    System.out.println("Error----->" + ex.getMessage());
                    cert.setIsExpired(true);
                    cert.setIsValid(false);
                }

            }
            else
            {
                cert.setIsExpired(true);
                cert.setIsValid(false);
            }

            new CertificateDAOImpl().updateCertificateValidity(new Certificate(cert.isIsExpired(), cert.isIsValid(), cert.getFileName()));

            cert.setStatus(rs.getString("Status"));
            cert.setCommonPath(rs.getString("CommonPath"));
            cert.setIwdPath(rs.getString("IWDPath"));
            cert.setTempPath(rs.getString("TempPath"));
            cert.setIsDefault(rs.getString("IsDefault"));
            cert.setRemarks(rs.getString("Remarks"));
            cert.setUploadedBy(rs.getString("UploadedBy"));

            if (rs.getTimestamp("UploadedDate") != null)
            {
                cert.setUploadedDate(DateFormatter.doFormat(rs.getTimestamp("UploadedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            cert.setApprovalRemarks(rs.getString("ApprovalRemarks"));
            cert.setApprovedBy(rs.getString("ApprovedBy"));

            if (rs.getTimestamp("ApprovedDate") != null)
            {
                cert.setApprovedDate(DateFormatter.doFormat(rs.getTimestamp("ApprovedDate").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            cert.setDefaultRequestBy(rs.getString("DefaultRequestBy"));

            if (rs.getTimestamp("DefaultRequestTime") != null)
            {
                cert.setDefaultRequestTime(DateFormatter.doFormat(rs.getTimestamp("DefaultRequestTime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }

            cert.setDefaultApprovalRemarks(rs.getString("DefaultApprovalRemarks"));
            cert.setDefaultApprovedBy(rs.getString("DefaultApprovedBy"));

            if (rs.getTimestamp("DefaultApprovedTime") != null)
            {
                cert.setDefaultApprovedTime(DateFormatter.doFormat(rs.getTimestamp("DefaultApprovedTime").getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));
            }
            
            cert.setNoOfDaysToExpire(rs.getInt("DaysToExpire"));

        }

        return cert;
    }

}
