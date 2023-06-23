/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.certificates;

import java.io.File;
import java.security.cert.X509Certificate;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Hashtable;
import lk.com.ttsl.pb.slips.common.utils.DBUtil;
import lk.com.ttsl.pb.slips.common.utils.DateFormatter;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.services.utils.CertificateReader;
import lk.com.ttsl.pb.slips.services.utils.FilePicker;
import lk.com.ttsl.pb.slips.services.utils.PropertyLoader;

/**
 *
 * @author Dinesh
 */
public class CertificateDAOImpl implements CertificateDAO
{

    static String msg;

    public String getMsg()
    {
        return msg;
    }
    
    public boolean updateCertificateValidity(Certificate cert)
    {
        Connection con = null;
        PreparedStatement psmt = null;
        boolean status = false;
        int count = 0;

        try
        {
            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("update ");
            sbQuery.append(DDM_Constants.tbl_certificateinfo + " ");
            sbQuery.append("set IsValid = ?, IsExpired = ? ");
            sbQuery.append("where FileName = ? ");

            psmt = con.prepareStatement(sbQuery.toString());

            psmt.setString(1, cert.isIsValid() ? "Y" : "N");
            psmt.setString(2, cert.isIsExpired() ? "Y" : "N");
            psmt.setString(3, cert.getFileName());

            //System.out.println("updateCertDetails:-----> " + sbQuery.toString());
            count = psmt.executeUpdate();
            if (count > 0)
            {
                status = true;
            }
            else
            {
                status = false;
            }
        }
        catch (Exception e)
        {
            System.out.println(e.toString());
        }
        finally
        {
            DBUtil.getInstance().closeStatement(psmt);
            DBUtil.getInstance().closeConnection(con);
        }

        return status;
    }

    public Hashtable<String, Collection<Certificate>> analyze(String bankCode, String status)
    {
        Hashtable<String, Collection<Certificate>> htCerts = null;
        File[] files = null;


        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return htCerts;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return htCerts;
        }

        if (bankCode.equals(DDM_Constants.status_all))
        {

            files = new FilePicker().pickFiles(PropertyLoader.getInstance().getCommonCertPath(), 4, new String[]
                    {
                        DDM_Constants.file_cert_prefix, DDM_Constants.file_ext_type_cert
                    }, null);

        }
        else
        {
            files = new FilePicker().pickFiles(PropertyLoader.getInstance().getCommonCertPath(), 4, new String[]
                    {
                        DDM_Constants.file_cert_prefix, bankCode, DDM_Constants.file_ext_type_cert
                    }, null);
        }


        if (files != null)
        {
            //System.out.println("No. of files available :- " + files.length);

            htCerts = new Hashtable<String, Collection<Certificate>>();

            for (int i = 0; i < files.length; i++)
            {
                //System.out.println("file name ----> " + files[i].getName());

                String bank = null;
                X509Certificate cert = null;

                cert = CertificateReader.readCertificate(files[i]);

                if (cert != null)
                {
                    Certificate cb = new Certificate();
                    
//                    System.out.println("files[i].getName() ---> " + files[i].getName());
//                    System.out.println("files[i].getPath() ---> " + files[i].getPath());
//                    System.out.println("files[i].getAbsolutePath() ---> " + files[i].getAbsolutePath());
//                    try
//                    {
//                        System.out.println("files[i].getCanonicalPath() ---> " + files[i].getCanonicalPath());
//                    }
//                    catch (IOException ex)
//                    {
//                        System.out.println(ex.getMessage());
//                    }

                    cb.setName(files[i].getName());
                    cb.setVersion(Integer.toString(cert.getVersion()));
                    cb.setSerialNumber(cert.getSerialNumber().toString());
                    cb.setSignatureAlgorithm(cert.getSigAlgName());

                    if (cert.getIssuerDN() != null)
                    {
                        cb.setIssuer(cert.getIssuerDN().getName().substring(cert.getIssuerDN().getName().indexOf("CN=") + 3, cert.getIssuerDN().getName().indexOf(",")));
                    }

                    if (cert.getNotBefore() != null)
                    {
                        cb.setValidFrom(DateFormatter.doFormat(cert.getNotBefore().getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));

                        Date date = new Date();

                        if (cert.getNotBefore().getTime() < date.getTime())
                        {
                            cb.setIsValid(true);
                        }
                        else
                        {
                            cb.setIsValid(false);
                        }
                    }

                    if (cert.getNotAfter() != null)
                    {
                        cb.setValidTo(DateFormatter.doFormat(cert.getNotAfter().getTime(), DDM_Constants.simple_date_format_yyyy_MM_dd_HH_mm_ss));

                        Date date = new Date();

                        if (cert.getNotAfter().getTime() < date.getTime())
                        {
                            cb.setIsExpired(true);
                        }
                        else
                        {
                            cb.setIsExpired(false);
                        }
                    }

                    if (cert.getSubjectDN() != null)
                    {
                        String subject = cert.getSubjectDN().getName();

                        if (subject != null)
                        {
                            cb.setSubject(subject);

                            int length = subject.length();
                            int index_ = subject.indexOf("_");
                            int indexId = subject.indexOf("UID=");
                            int indexIdEnd = -1;
                            int indexEmailAddress = subject.indexOf("EMAILADDRESS=");
                            int indexEmailAddressEnd = -1;
                            int indexBankName = subject.indexOf("CN=");
                            int indexBankNameEnd = -1;

                            if (index_ > -1)
                            {
                                if (length > index_ + 5)
                                {
                                    cb.setBankCode(subject.substring(index_ + 1, index_ + 5));
                                    bank = subject.substring(index_ + 1, index_ + 5);
                                }
                            }

                            if (indexId > -1)
                            {
                                indexIdEnd = subject.indexOf(",", indexId);

                                if (indexIdEnd > indexId && length > indexIdEnd)
                                {
                                    cb.setId(subject.substring(indexId + "UID=".length(), indexIdEnd));
                                }
                            }

                            if (indexEmailAddress > -1)
                            {
                                indexEmailAddressEnd = subject.indexOf(",", indexEmailAddress);

                                if (indexEmailAddressEnd > indexEmailAddress && length > indexEmailAddressEnd)
                                {
                                    cb.setEmail(subject.substring(indexEmailAddress + "EMAILADDRESS=".length(), indexEmailAddressEnd));
                                }
                            }

                            if (indexBankName > -1)
                            {
                                indexBankNameEnd = subject.indexOf(",", indexBankName);

                                if (indexBankNameEnd > indexBankName && length > indexBankNameEnd)
                                {
                                    cb.setBankName(subject.substring(indexBankName + "CN=".length(), indexBankNameEnd));
                                }
                            }
                        }
                    }

                    if (cert.getPublicKey() != null)
                    {
                        cb.setPublicKey(cert.getPublicKey().toString());
                    }

//                    System.out.println("version ----> " + cb.getVersion());
//                    System.out.println("serialNumber ----> " + cb.getSerialNumber());
//                    System.out.println("signatureAlgorithm ----> " + cb.getSignatureAlgorithm());
//                    System.out.println("issuer ----> " + cb.getIssuer());
//                    System.out.println("validFrom ----> " + cb.getValidFrom());
//                    System.out.println("isvalid ----> " + cb.isIsValid());
//                    System.out.println("validTo ----> " + cb.getValidTo());
//                    System.out.println("isExpired ----> " + cb.isIsExpired());
//                    System.out.println("subject ----> " + cb.getSubject());
//                    System.out.println("id ----> " + cb.getId());
//                    System.out.println("bank code ----> " + cb.getBankCode());
//                    System.out.println("bank name ----> " + cb.getBankName());
//                    System.out.println("email ----> " + cb.getEmail());
//                    System.out.println("publicKey ----> " + cb.getPublicKey());


                    if (status.equals(DDM_Constants.status_all))
                    {

                        if (htCerts.get(bank) != null)
                        {
                            Collection<Certificate> col = htCerts.get(bank);
                            col.add(cb);
                            htCerts.put(bank, col);
                        }
                        else
                        {
                            Collection<Certificate> col = new java.util.ArrayList();
                            col.add(cb);
                            htCerts.put(bank, col);
                        }
                    }
                    else if (status.equals(DDM_Constants.status_yes))
                    {
                        if (!cb.isIsExpired() && cb.isIsValid())
                        {
                            if (htCerts.get(bank) != null)
                            {
                                Collection<Certificate> col = htCerts.get(bank);
                                col.add(cb);
                                htCerts.put(bank, col);
                            }
                            else
                            {
                                Collection<Certificate> col = new java.util.ArrayList();
                                col.add(cb);
                                htCerts.put(bank, col);
                            }
                        }
                    }
                    else if (status.equals(DDM_Constants.status_no))
                    {
                        if (cb.isIsExpired() || !cb.isIsValid())
                        {
                            if (htCerts.get(bank) != null)
                            {
                                Collection<Certificate> col = htCerts.get(bank);
                                col.add(cb);
                                htCerts.put(bank, col);
                            }
                            else
                            {
                                Collection<Certificate> col = new java.util.ArrayList();
                                col.add(cb);
                                htCerts.put(bank, col);
                            }
                        }
                    }

                }
            }
        }

//        if (htCerts != null)
//        {
//            System.out.println("htCerts.size() --->" + htCerts.size());
//
//            Collection<Certificate> col = htCerts.get("7135");
//
//            System.out.println("col.size() ---> " + col.size());
//        }

        //files[i].renameTo(new File(files[i].getParent()+ "\\edited\\" + "CRT" + bank + underscore));

        return htCerts;
    }
    
    public Collection<Certificate> getCertDetails(String bankCode, String status)
    {
        Collection<Certificate> col = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        if (bankCode == null)
        {
            System.out.println("WARNING : Null bankCode parameter.");
            return col;
        }

        if (status == null)
        {
            System.out.println("WARNING : Null status parameter.");
            return col;
        }

        try
        {
            ArrayList<Integer> vt = new ArrayList();

            int val_bankCode = 1;
            int val_status = 2;

            con = DBUtil.getInstance().getConnection();
            StringBuilder sbQuery = new StringBuilder();

            sbQuery.append("SELECT FileName, OrginalFileName, BankCode, BankName, CertificateId, Type, "
                    + "Version, SignatureAlgorithm, Issuer, CertificateSerial, TokenSerial, "
                    + "CustomerName, CustomerLevel, Email, Locality, IsValid, IsExpired, ValidFrom, "
                    + "ValidTo, Status, CommonPath, IWDPath, TempPath, IsDefault, Remarks, UploadedBy, "
                    + "UploadedDate, ApprovalRemarks, ApprovedBy, ApprovedDate, IsDefault, "
                    + "DefaultRequestBy, DefaultRequestTime, DefaultApprovalRemarks, "
                    + "DefaultApprovedBy, DefaultApprovedTime, DATEDIFF(str_to_date(ValidTo,'%Y-%m-%d %H:%i:%s'), now()) as DaysToExpire FROM ");
            sbQuery.append(DDM_Constants.tbl_certificateinfo + " ");
            sbQuery.append("WHERE FileName = FileName ");

            if (!bankCode.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and BankCode = ? ");
                vt.add(val_bankCode);
            }

            if (!status.equals(DDM_Constants.status_all))
            {
                sbQuery.append("and Status = ? ");
                vt.add(val_status);
            }

            sbQuery.append("ORDER BY BankCode, FileName");

            //System.out.println(" sbQuery-"+ sbQuery);
            pstm = con.prepareStatement(sbQuery.toString());

            int i = 1;

            for (int val_item : vt)
            {
                if (val_item == val_bankCode)
                {
                    pstm.setString(i, bankCode);
                }
                if (val_item == val_status)
                {
                    pstm.setString(i, status);
                }

                i++;
            }

            rs = pstm.executeQuery();

            col = CertificateUtil.makeCertificateObjectsCollection(rs);

            if (col.isEmpty())
            {
                msg = DDM_Constants.msg_no_records;
            }
        }
        catch (Exception e)
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

    public static void main(String[] args)
    {

        new CertificateDAOImpl().analyze("7135", DDM_Constants.status_all);

    }
}
