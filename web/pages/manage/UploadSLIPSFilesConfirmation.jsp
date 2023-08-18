<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.sql.*" errorPage="../../error.jsp" %>
<%@page import="java.sql.*,java.util.*,java.io.*,java.text.DecimalFormat" errorPage="../../error.jsp"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" errorPage="../../error.jsp" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" errorPage="../../error.jsp" %>
<%@page import="org.apache.commons.fileupload.*" errorPage="../../error.jsp" %>

<%@page import="com.pronto.lcpl.filereader.processor.OWDFileUploader" errorPage="../../error.jsp"%>
<%@page import="com.pronto.lcpl.filereader.validationflow.FlowOrganizer" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.services.utils.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.account.Account" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.Bank" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.bank.BankDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.Branch" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.branch.BranchDAO" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.corporatecustomer.CorporateCustomer" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.file.FileInfo" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.CustomDate" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.parameter.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.userLevel.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.custom.user.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.user.pwd.history.*" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.common.utils.DateFormatter" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.window.Window" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.Log" errorPage="../../error.jsp"%>
<%@page import="lk.com.ttsl.pb.slips.dao.log.LogDAO" errorPage="../../error.jsp"%>

<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>
<%
    String session_userName = null;
    String session_userType = null;
    String session_userTypeDesc = null;
    String session_pw = null;
    String session_bankCode = null;
    String session_bankName = null;
    String session_sbCode = null;
    String session_sbType = null;
    String session_branchId = null;
    String session_branchName = null;
    String session_cocuId = null;
    String session_cocuName = null;
    String session_menuId = null;
    String session_menuName = null;
    String session_OTP = null;

    session_userName = (String) session.getAttribute("session_userName");

    if (session_userName == null || session_userName.equals("null"))
    {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/sessionExpired.jsp");
    }
    else
    {
        session_userType = (String) session.getAttribute("session_userType");
        session_userTypeDesc = (String) session.getAttribute("session_userTypeDesc");
        session_pw = (String) session.getAttribute("session_password");
        session_bankCode = (String) session.getAttribute("session_bankCode");
        session_bankName = (String) session.getAttribute("session_bankName");
        session_sbCode = (String) session.getAttribute("session_sbCode");
        session_sbType = (String) session.getAttribute("session_sbType");
        session_branchId = (String) session.getAttribute("session_branchId");
        session_branchName = (String) session.getAttribute("session_branchName");
        session_cocuId = (String) session.getAttribute("session_cocuId");
        session_cocuName = (String) session.getAttribute("session_cocuName");
        session_menuId = (String) session.getAttribute("session_menuId");
        session_menuName = (String) session.getAttribute("session_menuName");
        session_OTP = (String) session.getAttribute("session_OTP");

%>

<%    String webBusinessDate = DateFormatter.doFormat(DateFormatter.getTime(DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate), DDM_Constants.simple_date_format_yyyyMMdd), DDM_Constants.simple_date_format_yyyy_MM_dd);
    String winSession = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_session);
    Window window = DAOFactory.getWindowDAO().getWindow(session_bankCode, winSession);
    String currentDate = DAOFactory.getCustomDAO().getCurrentDate();
    long serverTime = DAOFactory.getCustomDAO().getServerTime();
    CustomDate customDate = DAOFactory.getCustomDAO().getServerTimeDetails();
    DAOFactory.getUserDAO().updateUserVisitStat(session_userName, DDM_Constants.status_yes);
%>


<%
    String GetFileName = null;
    String newFileName = null;
    String newFileFullPath = null;
    String msg = null;
    String slipsFileType = null;
    String vsFile = null;
    String vsFilePath = null;
    boolean fileUploadStatus = false;
    long initialfileSize = 0;

    String orgCoCU_ID = null;
    String orgAccNo = null;
    String orgAccName = null;
    String orgAccBranch = null;
    String afvd = null;
    String cavd = null;

    List<String> fc_AFVD = null;

    String businessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_businessdate);
    String lcplBusinessDate = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_batch_businessdate);

    boolean isMultipart = ServletFileUpload.isMultipartContent(request);

    System.out.println("Inside UploadSLIPSFilesConfirmation.jsp ----> start");

    if (!isMultipart)
    {
        System.out.println("Not Multipart");
    }
    else
    {
        try
        {
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            List items = null;
            items = upload.parseRequest(request);

            Iterator itr = items.iterator();

            while (itr.hasNext())
            {
                FileItem item = (FileItem) itr.next();
                initialfileSize = item.getSize();

                if (item.isFormField())
                {
                    if (item.getFieldName().equals("cmbCoCuID"))
                    {
                        orgCoCU_ID = item.getString();
                    }
                    if (item.getFieldName().equals("cmbAccountNo"))
                    {
                        orgAccNo = item.getString();
                    }
                    if (item.getFieldName().equals("hdnOrgAccName"))
                    {
                        orgAccName = item.getString();
                    }
                    if (item.getFieldName().equals("hdnOrgAccBranch"))
                    {
                        orgAccBranch = item.getString();
                    }
                    if (item.getFieldName().equals("cmbAFVD"))
                    {
                        afvd = item.getString();
                    }
                    if (item.getFieldName().equals("cmbCAVD"))
                    {
                        cavd = item.getString();
                    }
                }
                else
                {
                    String itemName = item.getName();

                    System.out.println("itemName ------>" + itemName);

                    int pos = itemName.lastIndexOf(File.separator);
                    GetFileName = itemName.substring(pos + 1);

                    if (itemName.toUpperCase().endsWith(DDM_Constants.ddm_cust1_file_suffix.toUpperCase()))
                    {
                        slipsFileType = DDM_Constants.ddm_cust1_file_Type;
                    }
                    else if (itemName.toUpperCase().endsWith(DDM_Constants.ddm_dddm_file_suffix.toUpperCase()))
                    {
                        slipsFileType = DDM_Constants.ddm_dddm_file_Type;
                    }
                    else if (itemName.toUpperCase().endsWith(DDM_Constants.ddm_fddm_file_suffix.toUpperCase()))
                    {
                        slipsFileType = DDM_Constants.ddm_fddm_file_Type;
                    }
                    else if (itemName.toUpperCase().endsWith(DDM_Constants.ddm_custout_file_suffix1.toUpperCase()))
                    {
                        slipsFileType = DDM_Constants.ddm_custout_file_Type;
                    }
                    else if (itemName.toUpperCase().indexOf(DDM_Constants.ddm_custout_file_suffix2.toUpperCase()) >= 0)
                    {
                        slipsFileType = DDM_Constants.ddm_custout_file_Type;
                    }
//                    else if (itemName.toUpperCase().startsWith(DDM_Constants.ddm_iwd_file_perfix.toUpperCase()))
//                    {
//                        slipsFileType = DDM_Constants.ddm_iwd_file_Type;
//                    }
                    else
                    {
                        slipsFileType = "";
                    }

                    System.out.println("slipsFileType ------> " + slipsFileType);

                    //System.out.println("file uploading path ------> " + config.getServletContext().getRealPath(ICPS_Constants.directory_onrm_uploaded_files));
                    //String tmpSlipsDataFilePath = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_ddm_data_tmp_file_path);
                    String tmpSlipsDataFilePath = PropertyLoader.getInstance().getSLIPS_DataFileTempUploadPath() + businessDate;

                    System.out.println("tmpSlipsDataFilePath ------> " + tmpSlipsDataFilePath);

                    File fileTmpSLIPSDataFilePath = new File(tmpSlipsDataFilePath);

                    if (!fileTmpSLIPSDataFilePath.exists())
                    {
                        System.out.println("fileTmpSLIPSDataFilePath not available and create the directory ------> " + tmpSlipsDataFilePath);

                        fileTmpSLIPSDataFilePath.mkdirs();
                    }

                    //int nextFileSeqId = DAOFactory.getUploadedLogFilesDAO().getNextFileSeqId(businessDate, session_bankCode);
                    //newFileName = businessDate + session_bankCode + "_" + nextFileSeqId + fileExtension;
                    if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
                    {
                        newFileName = orgCoCU_ID + "_" + orgAccNo + "_" + businessDate + "_" + GetFileName.replaceFirst("enc_", "");
                    }
                    else
                    {
                        newFileName = orgCoCU_ID + "_" + orgAccNo + "_" + businessDate + "_" + GetFileName;
                    }

                    if (DAOFactory.getFileInfoDAO().isFileAlreadyUploaded(newFileName, businessDate))
                    {
                        msg = "Already uploaded SLIPS data file!";
                        fileUploadStatus = false;
                    }
                    else
                    {
                        if (DAOFactory.getFileInfoDAO().isFileCurrentlyProcessing(newFileName, businessDate))
                        {
                            msg = "Data related to Same-named SLIPS file which in processing status will be deleted and upload the new file to the system!";

                            if (DAOFactory.getSlipsTransactionDAO().deleteSlipsTransactions(newFileName, businessDate.substring(2)))
                            {
                                if (DAOFactory.getCustomBatchDAO().deleteSlipsBatch(newFileName))
                                {
                                    if (DAOFactory.getFileInfoDAO().deleteSlipsFile(newFileName, businessDate))
                                    {
                                        System.out.println("Previous Slips Data Successfily Deleted------> " + newFileName + ", " + businessDate);
                                    }
                                }
                            }
                        }

                        if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
                        {
                            newFileFullPath = tmpSlipsDataFilePath + DDM_Constants.directory_separator + GetFileName;
                        }
                        else
                        {
                            newFileFullPath = tmpSlipsDataFilePath + DDM_Constants.directory_separator + newFileName;
                        }
                        
                        System.out.println("newFileFullPath ------> " + newFileFullPath);

                        File savedFile = new File(newFileFullPath);

                        if (savedFile.exists())
                        {
                            savedFile.delete();
                        }

                        item.write(savedFile);

                        if (savedFile.exists() && savedFile.canRead() && initialfileSize == savedFile.length())
                        {
                            //dataSec.decrypt(dataSec.getKeyAES(key.getBytes()), fOut, fOutDec); 
                            if (session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op))
                            {
                                String decFileName = newFileName;

                                String decFileFullPath = tmpSlipsDataFilePath + DDM_Constants.directory_separator + decFileName;

                                System.out.println("decFileFullPath ------> " + decFileFullPath);

                                File decFile = new File(decFileFullPath);

                                String key = "";

                                key = session_OTP + session_userName;

                                if (key.length() != 32)
                                {
                                    if (key.length() > 32)
                                    {
                                        key = key.substring(0, 32);
                                    }
                                    else
                                    {
                                        key = session_OTP + DDM_Constants.sec_key.substring(0, (32 - key.length())) + session_userName;
                                    }
                                }
                                
                                System.out.println("key---->" + key);

                                DataSecurity dataSec = new DataSecurity();

                                try
                                {
                                    dataSec.decryptDes_Ede(dataSec.getKeyDES_Ede(key.trim().getBytes()), savedFile, decFile);
                                    
                                    if (new FileManager().clean(savedFile))
                                    {
                                        System.out.println("Encrypted file successfuly deleted ------> " + newFileFullPath);
                                    }
                                    
                                    newFileFullPath = tmpSlipsDataFilePath + DDM_Constants.directory_separator + newFileName;
                                    
                                    fileUploadStatus = true;
                                }
                                catch (Exception ex)
                                {
                                    msg = "Sorry! Error occured while decrypting the file.<br/>Please try again. If the issue remains please contact the System Administrator.<br/>" + ex.getMessage();
                                                                        
                                    if (new FileManager().clean(savedFile))
                                    {
                                        System.out.println("Encrypted file successfuly deleted ------> " + newFileFullPath);
                                    }
                                    
                                    fileUploadStatus = false;
                                }

                            }
                            else
                            {
                                fileUploadStatus = true;
                            }
                        }
                        else
                        {
                            msg = "Sorry! Error occured while transmitting the file. <br/> Please try again. If the issue remains please contact the System Administrator.";
                            fileUploadStatus = false;
                        }
                    }
                }
            }
        }
        catch (Exception e)
        {
            msg = "Sorry! Error occured while transmitting the file. <br/> Please try again. If the issue remains please contact the System Administrator.";
            fileUploadStatus = false;
            System.out.println(e.getMessage());
        }

        FlowOrganizer flowOrg = null;

        if (fileUploadStatus)
        {
            System.out.println("orgAccName 1 ------> " + orgAccName);

            CorporateCustomer cocu = DAOFactory.getCorporateCustomerDAO().getCorporateCustomerDetails(orgCoCU_ID);

            if (cocu != null)
            {
                orgAccName = cocu.getCoCuName();
            }

            System.out.println("fileUploadStatus ------> " + fileUploadStatus);
            System.out.println("orgAccNo ------> " + orgAccNo);
            System.out.println("orgAccName 2 ------> " + orgAccName);
            System.out.println("orgAccBranch ------> " + orgAccBranch);

            if (slipsFileType.equals(DDM_Constants.ddm_cust1_file_Type))
            {
                System.out.println("Start slipsFileType CUST1 ------> ");

                File fileSLIPS_Data = new File(newFileFullPath);

                FileReader fr = null;
                BufferedReader br = null;

                if ((afvd != null && afvd.length() == 10) || (cavd != null && cavd.length() == 10))
                {
                    fc_AFVD = new ArrayList();
                }

                String accNos = "," + orgAccNo;

                try
                {
                    fr = new FileReader(fileSLIPS_Data);
                    br = new BufferedReader(fr);
                    String strLine = null;
                    //String strValueDate = null;

                    while ((strLine = br.readLine()) != null)
                    {
                        if (strLine != null && strLine.length() > 22)
                        {
                            if (strLine.substring(0, 4).equals(DDM_Constants.default_bank_code))
                            {
                                accNos = accNos + "," + strLine.substring(4, 7).replaceAll(" ", "0") + strLine.substring(10, 22).replaceAll(" ", "0");
                            }

                            if (strLine.length() > 93)
                            {
                                if (afvd != null && afvd.length() == 10)
                                {
                                    String newValueDate = afvd.replaceAll("-", "").substring(2);
                                    String checkDate = "20" + strLine.substring(87, 93);

                                    if (DAOFactory.getBCMCalendarDAO().getCalendar(checkDate) != null)
                                    {
                                        if (strLine.substring(0, 4).equals(DDM_Constants.default_bank_code))
                                        {
                                            if (!DAOFactory.getBCMCalendarDAO().isValidFutureBusinessDate(checkDate, businessDate))
                                            {
                                                String newLine = strLine.substring(0, 87) + newValueDate + strLine.substring(93);
                                                fc_AFVD.add(newLine);
                                            }
                                            else
                                            {
                                                fc_AFVD.add(strLine);
                                            }
                                        }
                                        else
                                        {
                                            if (!DAOFactory.getBCMCalendarDAO().isValidFutureBusinessDate(checkDate, lcplBusinessDate))
                                            {
                                                String newLine = strLine.substring(0, 87) + newValueDate + strLine.substring(93);
                                                fc_AFVD.add(newLine);
                                            }
                                            else
                                            {
                                                fc_AFVD.add(strLine);
                                            }

                                        }

                                    }
                                    else
                                    {
                                        fc_AFVD.add(strLine);
                                    }
                                }
                                else if (cavd != null && cavd.length() == 10)
                                {
                                    String newValueDate = cavd.replaceAll("-", "").substring(2);
                                    String newLine = strLine.substring(0, 87) + newValueDate + strLine.substring(93);

                                    fc_AFVD.add(newLine);
                                }
                            }
                            else
                            {
                                if ((afvd != null && afvd.length() == 10) || (cavd != null && cavd.length() == 10))
                                {
                                    fc_AFVD.add(strLine);
                                }
                            }

                        }
                    }
                }
                catch (Exception e)
                {
                    System.out.println("Error reading file - " + fileSLIPS_Data + "(" + e.getMessage() + ")");
                }
                finally
                {
                    if (br != null)
                    {
                        br.close();
                    }

                    if (fr != null)
                    {
                        fr.close();
                    }
                }

                //System.out.println("accNos ------> " + accNos);
                Collection<Account> colResultAddBulkAccNo = DAOFactory.getAccountDAO().getBulkAccountDetailsFromWebService(accNos.replaceFirst(",", ""));

                if (colResultAddBulkAccNo != null)
                {
                    System.out.println("getBulkAccountDetailsFromWebService() is success ------> " + colResultAddBulkAccNo.size());
                }
                else
                {
                    System.out.println("getBulkAccountDetailsFromWebService() is failed ------> ");
                }

                //this.wait(3000);
                if (((afvd != null && afvd.length() == 10) || (cavd != null && cavd.length() == 10)) && (fc_AFVD != null && fc_AFVD.size() > 0))
                {
                    PrintWriter writer = new PrintWriter(fileSLIPS_Data);
                    writer.print("");
                    writer.close();

                    FileWriter fw = null;
                    BufferedWriter bw = null;

                    try
                    {
                        fw = new FileWriter(fileSLIPS_Data, true);
                        bw = new BufferedWriter(fw);

                        for (String line : fc_AFVD)
                        {
                            bw.write(line);
                            bw.newLine();
                        }

                        bw.flush();
                        fw.flush();
                    }
                    catch (IOException e)
                    {
                        fileUploadStatus = false;
                        msg = "Error While Rewriting the SLIPS CUST1 Data file with New Value Dates! - (" + e.getMessage() + ")";
                    }
                    finally
                    {
                        if (bw != null)
                        {
                            try
                            {
                                bw.close();
                            }
                            catch (IOException e2)
                            {
                                System.out.println("Error (while close BufferedWriter) - " + e2.getMessage());
                            }
                        }

                        if (fw != null)
                        {
                            try
                            {
                                fw.close();
                            }
                            catch (IOException e2)
                            {
                                System.out.println("Error (while close FileWriter) - " + e2.getMessage());
                            }
                        }
                    }
                }

                OWDFileUploader objOWDFleUpldr = SLIPS_FileProcessor.getInstance().getObjSLIPS_FileProcessor();

                flowOrg = objOWDFleUpldr.UploadFilleCust1(fileSLIPS_Data, orgAccBranch, orgAccNo.substring(3), orgAccName, slipsFileType);

                vsFile = fileSLIPS_Data.getName().substring(0, fileSLIPS_Data.getName().lastIndexOf(".")) + "_ValidationSummary.txt";
                vsFilePath = fileSLIPS_Data.getAbsolutePath().substring(0, fileSLIPS_Data.getAbsolutePath().lastIndexOf(".")) + "_ValidationSummary.txt";

                System.out.println("End slipsFileType CUST1 ------> ");
            }
            else if (slipsFileType.equals(DDM_Constants.ddm_dddm_file_Type) || slipsFileType.equals(DDM_Constants.ddm_fddm_file_Type))
            {
                System.out.println("Start slipsFileType " + slipsFileType + " ------> ");

                File fileSLIPS_Data = new File(newFileFullPath);

                FileReader fr = null;
                BufferedReader br = null;

                if ((afvd != null && afvd.length() == 10) || (cavd != null && cavd.length() == 10))
                {
                    fc_AFVD = new ArrayList();
                }

                String accNos = "," + orgAccNo;

                try
                {
                    fr = new FileReader(fileSLIPS_Data);
                    br = new BufferedReader(fr);
                    String strLine = null;

                    while ((strLine = br.readLine()) != null)
                    {
                        if (strLine != null && strLine.length() > 23)
                        {
                            if (strLine.substring(4, 8).equals(DDM_Constants.default_bank_code))
                            {
                                accNos = accNos + "," + strLine.substring(8, 23).replaceAll(" ", "0");
                            }
                        }

                        if (strLine != null && strLine.length() > 88)
                        {
                            if (strLine.substring(69, 73).equals(DDM_Constants.default_bank_code))
                            {
                                accNos = accNos + "," + strLine.substring(73, 88).replaceAll(" ", "0");
                            }
                        }

                        if (strLine.length() > 144)
                        {
                            if (afvd != null && (afvd.length() == 10))
                            {
                                String newValueDate = afvd.replaceAll("-", "").substring(2);
                                String checkDate = "20" + strLine.substring(138, 144);

                                if (DAOFactory.getBCMCalendarDAO().getCalendar(checkDate) != null)
                                {
                                    if (strLine.substring(4, 8).equals(DDM_Constants.default_bank_code))
                                    {
                                        if (!DAOFactory.getBCMCalendarDAO().isValidFutureBusinessDate(checkDate, businessDate))
                                        {
                                            String newLine = strLine.substring(0, 138) + newValueDate + strLine.substring(144);
                                            fc_AFVD.add(newLine);
                                        }
                                        else
                                        {
                                            fc_AFVD.add(strLine);
                                        }
                                    }
                                    else
                                    {
                                        if (!DAOFactory.getBCMCalendarDAO().isValidFutureBusinessDate(checkDate, lcplBusinessDate))
                                        {
                                            String newLine = strLine.substring(0, 138) + newValueDate + strLine.substring(144);
                                            fc_AFVD.add(newLine);
                                        }
                                        else
                                        {
                                            fc_AFVD.add(strLine);
                                        }
                                    }
                                }
                                else
                                {
                                    fc_AFVD.add(strLine);
                                }
                            }
                            else if (cavd != null && cavd.length() == 10)
                            {
                                String newValueDate = cavd.replaceAll("-", "").substring(2);
                                String newLine = strLine.substring(0, 138) + newValueDate + strLine.substring(144);

                                fc_AFVD.add(newLine);
                            }
                        }
                        else
                        {
                            if ((afvd != null && afvd.length() == 10) || (cavd != null && cavd.length() == 10))
                            {
                                fc_AFVD.add(strLine);
                            }
                        }

                    }
                }
                catch (Exception e)
                {
                    System.out.println("Error reading file - " + fileSLIPS_Data + "(" + e.getMessage() + ")");
                }
                finally
                {
                    if (br != null)
                    {
                        br.close();
                    }

                    if (fr != null)
                    {
                        fr.close();
                    }
                }

                //System.out.println("accNos ------> " + accNos);
                Collection<Account> colResultAddBulkAccNo = DAOFactory.getAccountDAO().getBulkAccountDetailsFromWebService(accNos.replaceFirst(",", ""));

                if (colResultAddBulkAccNo != null)
                {
                    System.out.println("getBulkAccountDetailsFromWebService() is success ------> " + colResultAddBulkAccNo.size());
                }
                else
                {
                    System.out.println("getBulkAccountDetailsFromWebService() is failed ------> ");
                }

                //this.wait(3000);
                if (((afvd != null && afvd.length() == 10) || (cavd != null && cavd.length() == 10)) && (fc_AFVD != null && fc_AFVD.size() > 0))
                {
                    PrintWriter writer = new PrintWriter(fileSLIPS_Data);
                    writer.print("");
                    writer.close();

                    FileWriter fw = null;
                    BufferedWriter bw = null;

                    try
                    {
                        fw = new FileWriter(fileSLIPS_Data, true);
                        bw = new BufferedWriter(fw);

                        for (String line : fc_AFVD)
                        {
                            bw.write(line);
                            bw.newLine();
                        }

                        bw.flush();
                        fw.flush();
                    }
                    catch (IOException e)
                    {
                        fileUploadStatus = false;
                        msg = "Error While Rewriting the SLIPS " + slipsFileType + " Data file with New Value Dates! - (" + e.getMessage() + ")";
                    }
                    finally
                    {
                        if (bw != null)
                        {
                            try
                            {
                                bw.close();
                            }
                            catch (IOException e2)
                            {
                                System.out.println("Error (while close BufferedWriter) - " + e2.getMessage());
                            }
                        }

                        if (fw != null)
                        {
                            try
                            {
                                fw.close();
                            }
                            catch (IOException e2)
                            {
                                System.out.println("Error (while close FileWriter) - " + e2.getMessage());
                            }
                        }
                    }
                }

                OWDFileUploader objOWDFleUpldr = SLIPS_FileProcessor.getInstance().getObjSLIPS_FileProcessor();

                flowOrg = objOWDFleUpldr.UploadFilleDFSLips(fileSLIPS_Data, orgAccBranch, orgAccNo.substring(3), orgAccName, slipsFileType);

                vsFile = fileSLIPS_Data.getName().substring(0, fileSLIPS_Data.getName().lastIndexOf(".")) + "_ValidationSummary.txt";
                vsFilePath = fileSLIPS_Data.getAbsolutePath().substring(0, fileSLIPS_Data.getAbsolutePath().lastIndexOf(".")) + "_ValidationSummary.txt";

                System.out.println("End slipsFileType " + slipsFileType + " ------> ");
            }
            else if (slipsFileType.equals(DDM_Constants.ddm_custout_file_Type))
            {
                System.out.println("Start slipsFileType CUSTOUT ------> ");

                File fileSLIPS_Data = new File(newFileFullPath);

                FileReader fr = null;
                BufferedReader br = null;

                if ((afvd != null && afvd.length() == 10) || (cavd != null && cavd.length() == 10))
                {
                    fc_AFVD = new ArrayList();
                }

                String accNos = "," + orgAccNo;

                try
                {
                    fr = new FileReader(fileSLIPS_Data);
                    br = new BufferedReader(fr);
                    String headerLine = br.readLine();

                    if ((afvd != null && afvd.length() == 10) || (cavd != null && cavd.length() == 10))
                    {
                        fc_AFVD.add(headerLine);
                    }

                    String strLine = null;

                    if (headerLine != null && headerLine.length() < 128)
                    {
                        slipsFileType = DDM_Constants.ddm_custout_1_file_Type;
                    }
                    else
                    {
                        if (headerLine.endsWith("                N") || headerLine.endsWith("0000000000000000N"))
                        {
                            slipsFileType = DDM_Constants.ddm_custout_2_file_Type;
                        }
                        else
                        {
                            slipsFileType = DDM_Constants.ddm_custout_1_file_Type;
                        }
                    }

                    System.out.println("slipsFileType ------> " + slipsFileType);

                    while ((strLine = br.readLine()) != null)
                    {
                        if (strLine != null && strLine.length() > 22)
                        {
                            if (strLine.substring(0, 4).equals(DDM_Constants.default_bank_code))
                            {
                                accNos = accNos + "," + strLine.substring(4, 7).replaceAll(" ", "0") + strLine.substring(10, 22).replaceAll(" ", "0");
                            }
                        }

                        if (strLine.length() > 93)
                        {
                            if (afvd != null && (afvd.length() == 10))
                            {
                                String newValueDate = afvd.replaceAll("-", "").substring(2);
                                String checkDate = "20" + strLine.substring(87, 93);

                                if (DAOFactory.getBCMCalendarDAO().getCalendar(checkDate) != null)
                                {
                                    if (strLine.substring(0, 4).equals(DDM_Constants.default_bank_code))
                                    {
                                        if (!DAOFactory.getBCMCalendarDAO().isValidFutureBusinessDate(checkDate, businessDate))
                                        {
                                            String newLine = strLine.substring(0, 87) + newValueDate + strLine.substring(93);
                                            fc_AFVD.add(newLine);
                                        }
                                        else
                                        {
                                            fc_AFVD.add(strLine);
                                        }
                                    }
                                    else
                                    {
                                        if (!DAOFactory.getBCMCalendarDAO().isValidFutureBusinessDate(checkDate, lcplBusinessDate))
                                        {
                                            String newLine = strLine.substring(0, 87) + newValueDate + strLine.substring(93);
                                            fc_AFVD.add(newLine);
                                        }
                                        else
                                        {
                                            fc_AFVD.add(strLine);
                                        }
                                    }
                                }
                                else
                                {
                                    fc_AFVD.add(strLine);
                                }
                            }
                            else if (cavd != null && cavd.length() == 10)
                            {
                                String newValueDate = cavd.replaceAll("-", "").substring(2);
                                String newLine = strLine.substring(0, 87) + newValueDate + strLine.substring(93);

                                fc_AFVD.add(newLine);
                            }
                        }
                        else
                        {
                            if ((afvd != null && afvd.length() == 10) || (cavd != null && cavd.length() == 10))
                            {
                                fc_AFVD.add(strLine);
                            }
                        }

                    }

                }
                catch (Exception e)
                {
                    System.out.println("Error reading file - " + fileSLIPS_Data + "(" + e.getMessage() + ")");
                }
                finally
                {
                    if (br != null)
                    {
                        br.close();
                    }

                    if (fr != null)
                    {
                        fr.close();
                    }
                }

                System.out.println("accNos ------> " + accNos);

                if (accNos.startsWith(","))
                {
                    accNos = accNos.replaceFirst(",", "");
                }

                Collection<Account> colResultAddBulkAccNo = DAOFactory.getAccountDAO().getBulkAccountDetailsFromWebService(accNos);

                if (colResultAddBulkAccNo != null)
                {
                    System.out.println("getBulkAccountDetailsFromWebService() is success ------> " + colResultAddBulkAccNo.size());
                }
                else
                {
                    System.out.println("getBulkAccountDetailsFromWebService() is failed ------> ");
                }

                //this.wait(3000);
                if (((afvd != null && afvd.length() == 10) || (cavd != null && cavd.length() == 10)) && (fc_AFVD != null && fc_AFVD.size() > 1))
                {
                    PrintWriter writer = new PrintWriter(fileSLIPS_Data);
                    writer.print("");
                    writer.close();

                    FileWriter fw = null;
                    BufferedWriter bw = null;

                    try
                    {
                        fw = new FileWriter(fileSLIPS_Data, true);
                        bw = new BufferedWriter(fw);

                        for (String line : fc_AFVD)
                        {
                            bw.write(line);
                            bw.newLine();
                        }

                        bw.flush();
                        fw.flush();
                    }
                    catch (IOException e)
                    {
                        fileUploadStatus = false;
                        msg = "Error While Rewriting the SLIPS " + slipsFileType + " Data file with New Value Dates! - (" + e.getMessage() + ")";
                    }
                    finally
                    {
                        if (bw != null)
                        {
                            try
                            {
                                bw.close();
                            }
                            catch (IOException e2)
                            {
                                System.out.println("Error (while close BufferedWriter) - " + e2.getMessage());
                            }
                        }

                        if (fw != null)
                        {
                            try
                            {
                                fw.close();
                            }
                            catch (IOException e2)
                            {
                                System.out.println("Error (while close FileWriter) - " + e2.getMessage());
                            }
                        }
                    }
                }

                System.out.println("Start SLIPS File Processing ########## ------> " + slipsFileType);

                OWDFileUploader objOWDFleUpldr = SLIPS_FileProcessor.getInstance().getObjSLIPS_FileProcessor();

                flowOrg = objOWDFleUpldr.UploadFillCusOut(new File(newFileFullPath), orgAccBranch, orgAccNo.substring(3), orgAccName, slipsFileType);

                System.out.println("End SLIPS File Processing ##########@@@@@@@ ------> " + slipsFileType);

                vsFile = fileSLIPS_Data.getName().substring(0, fileSLIPS_Data.getName().lastIndexOf(".")) + "_ValidationSummary.txt";
                vsFilePath = fileSLIPS_Data.getAbsolutePath().substring(0, fileSLIPS_Data.getAbsolutePath().lastIndexOf(".")) + "_ValidationSummary.txt";

                System.out.println("End slipsFileType " + slipsFileType + " ------> ");
            }
            else
            {
                msg = "Invalid SLIPS Data file type!";
                fileUploadStatus = false;
            }

            if (fileUploadStatus)
            {
                if (flowOrg != null)
                {
                    DAOFactory.getFileInfoDAO().updateCOCuIdAndOtherFileInfo(newFileName, slipsFileType, businessDate, orgCoCU_ID, newFileFullPath, GetFileName, vsFile, session_userName);
                    DAOFactory.getReportDAO().addReportDetails(businessDate, winSession, session_bankCode, orgAccBranch, orgCoCU_ID, vsFile, vsFilePath, DDM_Constants.report_type_owd_vl1_report, session_userName);
                }

                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_upload_ddm_file_confirmation, "|Business Date - " + businessDate + ", Bank - " + session_bankCode + ", Uploded SLIPS File Name : (Original - " + GetFileName + ", System Assigned - " + newFileName + "), File Size - " + initialfileSize + " bytes, Originator Acc. No - " + (orgAccNo != null ? orgAccNo : "N/A") + " | Upload SLIPS data file Status - Success | Uploaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));
            }
            else
            {
                DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_upload_ddm_file_confirmation, "|Business Date - " + businessDate + ", Bank - " + session_bankCode + ", Uploded SLIPS File Name : " + GetFileName + ", System Assigned - " + newFileName + "), File Size - " + initialfileSize + " bytes, Originator Acc. No - " + (orgAccNo != null ? orgAccNo : "N/A") + " | Upload SLIPS data file Status - Unsuccess (" + msg + ") | Uploaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));
            }
        }
        else
        {
            DAOFactory.getLogDAO().addLog(new Log(DDM_Constants.log_type_user_upload_ddm_file_confirmation, "|Business Date - " + businessDate + ", Bank - " + session_bankCode + ", Uploded SLIPS File Name : (Original - " + GetFileName + ", System Assigned - " + newFileName + "), File Size - " + initialfileSize + " bytes, Originator Acc. No - " + (orgAccNo != null ? orgAccNo : "N/A") + " | Upload SLIPS data file Status - Unsuccess (" + msg + ") | Uploaded By - " + session_userName + " (" + session_userTypeDesc + ") |"));
        }
    }

%>

<html>
    <head><title>LankaPay Direct Debit Mandate Exchange System - SLIPS Data File Upload Summary</title>
        <link href="<%=request.getContextPath()%>/css/ddm.css" rel="stylesheet" type="text/css" />
        <link href="../../css/ddm.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/fade.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/digitalClock.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/js/datetimepicker.js"></script>

        <script language="javascript" type="text/JavaScript">




            function showClock(type)
            {            
            if(type==1)
            {
            clock(document.getElementById('showText'),type,null);
            }
            else if(type==2)
            {
            var val = new Array(<%=serverTime%>);
            clock(document.getElementById('showText'),type,val);
            }
            else if (type == 3)
            {
            var val = new Array(<%=customDate.getYear()%>, <%=customDate.getMonth()%>, <%=customDate.getDay()%>, <%=customDate.getHour()%>, <%=customDate.getMinitue()%>, <%=customDate.getSecond()%>, <%=customDate.getMilisecond()%>, document.getElementById('actWindowOW'), document.getElementById('expWindowOW'), <%=window != null ? window.getOW_cutontimeHour() : null%>, <%=window != null ? window.getOW_cutontimeMinutes() : null%>, <%=window != null ? window.getOW_cutofftimeHour() : null%>, <%=window != null ? window.getOW_cutofftimeMinutes() : null%>, document.getElementById('actWindowIW'), document.getElementById('expWindowIW'), <%=window != null ? window.getIW_cutontimeHour() : null%>, <%=window != null ? window.getIW_cutontimeMinutes() : null%>, <%=window != null ? window.getIW_cutofftimeHour() : null%>, <%=window != null ? window.getIW_cutofftimeMinutes() : null%>);
            clock(document.getElementById('showText'), type, val);
            }
            }



            function isRequest(status)
            {
            if(status)
            {
            document.getElementById('hdnReq').value = "1";
            }
            else
            {
            document.getElementById('hdnReq').value = "0";                    
            }
            }

            function doSubmit(val)
            { 
            if(val==1)
            {				
            document.frmFileUploadingSummary.action="<%=request.getContextPath()%>/pages/file/ViewDetailsAndConfirm.jsp";
            document.frmFileUploadingSummary.submit();
            }
            else if(val==2)
            {				
            document.frmFileUploadingSummary.action="<%=request.getContextPath()%>/pages/file/UploadSLIPSFiles.jsp";
            document.frmFileUploadingSummary.submit();
            }
            else
            {
            document.frmFileUploadingSummary.action="<%=request.getContextPath()%>/pages/homepage.jsp";
            document.frmFileUploadingSummary.submit();
            }
            }

            function downloadFile()
            {
            document.frmDownload.action="DownloadValidationSummary.jsp";
            document.frmDownload.submit();			
            }


            function isempty(Value)
            {
            if(Value.length < 1)
            {
            return true;
            }
            else
            {
            var str = Value;

            while(str.indexOf(" ") != -1)
            {
            str = str.replace(" ","");
            }

            if(str.length < 1)
            {
            return true;
            }
            else
            {
            return false;
            }
            }
            }

            function findSpaces(str)
            {               
            var status = false;
            var strTrimed = this.trim(str);

            for (var i=0;i<strTrimed.length;i++)
            {
            if(strTrimed[i]== " ")
            {
            status = true;
            break;
            }
            }

            return status;                
            }

            function trim(str) 
            {
            return str.replace(/^\s+|\s+$/g,"");
            }

        </script>
    </head>

    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="ddm_body" onLoad="showClock(3)">
        <table width="100%" style="min-width:900;min-height:600" height="100%" align="center" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td align="center" valign="top" class="ddm_bgRepeat_center">
                    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="ddm_bgRepeat_left">
                        <tr>
                            <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="ddm_bgRepeat_right">
                                    <tr>
                                        <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td height="102" valign="top" class="ddm_header_center">

                                                        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="ddm_header_left">
                                                            <tr>
                                                                <td valign="top"><table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0" class="ddm_header_right">
                                                                        <tr>
                                                                            <td><table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr>
                                                                                        <td height="75"><table width="900" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="22"><table width="100%" height="22" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td width="15">&nbsp;</td>
                                                                                                    <td>

                                                                                                        <div style="padding:1;height:100%;width:100%;">
                                                                                                            <div id="layer" style="position:absolute;visibility:hidden;">**** LankaPay DDM ****</div>
                                                                                                            <script language="JavaScript" vqptag="doc_level_settings" is_vqp_html=1 vqp_datafile0="<%=request.getContextPath()%>/js/<%=session_menuName%>" vqp_uid0=<%=session_menuId%>>cdd__codebase = "<%=request.getContextPath()%>/js/";
                                                                                                                cdd__codebase<%=session_menuId%> = "<%=request.getContextPath()%>/js/";</script>
                                                                                                            <script language="JavaScript" vqptag="datafile" src="<%=request.getContextPath()%>/js/<%=session_menuName%>"></script>
                                                                                                            <script vqptag="placement" vqp_menuid="<%=session_menuId%>" language="JavaScript">create_menu(<%=session_menuId%>)</script>
                                                                                                        </div></td>
                                                                                                    <td>&nbsp;</td>
                                                                                                    <td align="right" valign="bottom"><table height="22" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr>
                                                                                                                <td class="ddm_menubar_text">Welcome :</td>
                                                                                                                <td width="5"></td>
                                                                                                                <td class="ddm_menubar_text"><b><%=session_userName%></b> - <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_cocuId : session_branchId%> <%=(session_userType.equals(DDM_Constants.user_type_merchant_su) || session_userType.equals(DDM_Constants.user_type_merchant_op)) ? session_cocuName : session_branchName%></td>
                                                                                                                <td width="15">&nbsp;</td>
                                                                                                                <td valign="middle"><a href="<%=request.getContextPath()%>/pages/user/userProfile.jsp" title=" My Profile "><img src="<%=request.getContextPath()%>/images/user.png" width="18"
                                                                                                                                                                                                        height="22" border="0" align="middle" ></a></td>
                                                                                                                <td width="10"></td>
                                                                                                                <td class="ddm_menubar_text">[ <a href="<%=request.getContextPath()%>/pages/logout.jsp" class="ddm_menubar_link"><u>Logout</u></a> ]</td>
                                                                                                                <td width="5"></td>
                                                                                                            </tr>
                                                                                                        </table></td>
                                                                                                    <td width="15">&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="5">                                        </td>
                                                                                    </tr>
                                                                                </table></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="min-height:400" align="center" valign="top" class="ddm_bgCommon">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td height="24" align="right" valign="top"><table width="100%" height="24" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td width="15"></td>
                                                                            <td align="right" valign="top"><table height="24" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td valign="top" nowrap class="ddm_menubar_text_dark">Business Date : <%=webBusinessDate%></td>
                                                                                        <td width="10" valign="middle"></td>
                                                                                        <td valign="top" nowrap class="ddm_menubar_text_dark">|&nbsp; Now : [ <%=currentDate%></td>
                                                                                        <td width="5" valign="middle">&nbsp;</td>
                                                                                        <td valign="top" class="ddm_menubar_text_dark"><div id="showText" class="ddm_menubar_text_dark"></div></td>
                                                                                        <td width="5" valign="top" nowrap class="ddm_menubar_text_dark">&nbsp;]</td>

                                                                                        <td width="10" valign="middle"></td>
                                                                                        <%
                                                                                            String owWindowStartTime = window.getOW_cutontime() != null ? window.getOW_cutontime().substring(0, 2) + ":" + window.getOW_cutontime().substring(2) : "00:00";
                                                                                            String owWindowEndTime = window.getOW_cutofftime() != null ? window.getOW_cutofftime().substring(0, 2) + ":" + window.getOW_cutofftime().substring(2) : "00:00";

                                                                                            String iwWindowStartTime = window.getIW_cutontime() != null ? window.getIW_cutontime().substring(0, 2) + ":" + window.getIW_cutontime().substring(2) : "00:00";
                                                                                            String iwWindowEndTime = window.getIW_cutofftime() != null ? window.getIW_cutofftime().substring(0, 2) + ":" + window.getIW_cutofftime().substring(2) : "00:00";
                                                                                        %>

                                                                                        <td valign="top" nowrap class="ddm_menubar_text_dark">| &nbsp; Session : <%=winSession%></td>
                                                                                        <td width="5" valign="middle"></td>

                                                                                        <td valign="top" nowrap class="ddm_menubar_text_dark"><table border="0" cellspacing="0">
                                                                                                <tr height="12">
                                                                                                    <td valign="middle" nowrap class="ddm_menubar_text_dark">[</td>
                                                                                                    <td valign="middle" nowrap class="ddm_menubar_text_dark"><span class="ddm_menubar_text_dark" title="Outward (OWNM) Window Start and End Time">OW (<%=owWindowStartTime%>-<%=owWindowEndTime%>)</span></td>
                                                                                                    <td width="3" valign="middle"></td>
                                                                                                    <td valign="middle"><div id="actWindowOW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Outward (OWNM) Window is active!" ></div>
                                                                                                        <div id="expWindowOW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Outward (OWNM) Window is expired!" ></div></td>
                                                                                                    <td valign="middle" nowrap class="ddm_menubar_text_dark">| <span class="ddm_menubar_text_dark" title="Inward (IWNM) Window Start and End Time">IW (<%=iwWindowStartTime%>-<%=iwWindowEndTime%>)</span>                                                                                          </td>
                                                                                                    <td width="3" valign="middle"></td>
                                                                                                    <td valign="middle" class="ddm_menubar_text"><div id="actWindowIW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animGreen.gif" name="imgWindowActive" id="imgWindowActive" width="11" height="11" title="Intward (IWNM) Window is active!" ></div>
                                                                                                        <div id="expWindowIW" align="center" style="display:none"><img src="<%=request.getContextPath()%>/images/animRed.gif" name="imgWindowExpired" id="imgWindowExpired" width="11" height="11" title="Inward (IWNM) Window is expired!" ></div></td>
                                                                                                    <td valign="middle" class="ddm_menubar_text_dark">]&nbsp;</td>
                                                                                                </tr>
                                                                                            </table></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15"></td>
                                                                        </tr>
                                                                    </table></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="center" valign="middle"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td height="5"></td>
                                                                            <td align="left" valign="top" ></td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td width="15">&nbsp;</td>
                                                                            <td align="left" valign="top" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="10">&nbsp;</td>
                                                                                        <td align="left" valign="top" class="ddm_header_text">SLIPS Data  File Uploading Summary</td>
                                                                                        <td width="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td height="20"></td>
                                                                                        <td align="left" valign="top" class="ddm_header_text"></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td align="center" valign="top">
                                                                                            <form method="post" name="frmFileUploadingSummary" id="frmFileUploadingSummary" >


                                                                                                <table border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td align="center" class="ddm_Display_Error_msg">

                                                                                                            <%=fileUploadStatus == true ? "<span class=\"ddm_Display_Success_msg\">SLIPS Data file uploading process is completed.<br/>First please make sure to check the validation summary file inorder to identify transaction level validation details and status.</span>" : (msg != null ? msg : "")%></td>



                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="10"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center" valign="middle"><table width="" border="0" cellspacing="0" cellpadding="0" class="ddm_table_boder">
                                                                                                                <tr>
                                                                                                                    <td><table border="0" cellpadding="6" cellspacing="1" bgcolor="#FFFFFF" >
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Corporate Customer ID :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=orgCoCU_ID != null ? orgCoCU_ID : ""%><input name="hdnCoCuID" id="hdnCoCuID" type="hidden" value="<%=orgCoCU_ID%>"  ></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Originator Acc. No  :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=orgAccNo != null ? orgAccNo : ""%><input name="hdnOrgAccNo" id="hdnOrgAccNo" type="hidden" value="<%=orgAccNo%>"  ></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Automatically Fixed Value Date :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=afvd != null ? afvd : ""%><input name="hdnAFVD" id="hdnAFVD" type="hidden" value="<%=afvd != null ? afvd : DDM_Constants.status_all%>"  ></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">
                                                                                                                                    Original SLIPS Data File  :        </td>

                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=GetFileName%></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">System Assigned File  Name :</td>
                                                                                                                                <td valign="middle" class="ddm_tbl_common_text"><%=newFileName%><input name="hdnFileName" id="hdnFileName" type="hidden" value="<%=newFileName%>"  ></td>
                                                                                                                            </tr>


                                                                                                                            <tr>
                                                                                                                                <td valign="middle" class="ddm_tbl_header_text">Validation Summary :</td>


                                                                                                                                <td valign="middle" class="ddm_tbl_common_text">
                                                                                                                                    <%
                                                                                                                                        if (fileUploadStatus)
                                                                                                                                        {
                                                                                                                                    %>


                                                                                                                                    <input type="button" name="btnDwnReport" id="btnDwnReport" value="Download - <%=vsFile%>" class="ddm_custom_button_small" onClick="downloadFile()">
                                                                                                                                    <%
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    N/A
                                                                                                                                    <%
                                                                                                                                        }
                                                                                                                                    %>                                                                                                                                </td>
                                                                                                                            </tr>


                                                                                                                            <tr>
                                                                                                                                <td colspan="2" align="center" class="ddm_tbl_footer_text"><table border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td>
                                                                                                                                                <%
                                                                                                                                                    FileInfo fileInfo = DAOFactory.getFileInfoDAO().getFileDetails(newFileName, webBusinessDate, DDM_Constants.status_all, DDM_Constants.status_all);

                                                                                                                                                %>
                                                                                                                                                <input type="button" value="View Details and Confirm" name="btnUpload1" id="btnUpload1" class="ddm_custom_button"  onclick="doSubmit(1)" <%=(fileUploadStatus && (fileInfo != null)) ? "" : "disabled"%> />
                                                                                                                                                <%

                                                                                                                                                %>

                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td><input type="button" value="Go To Upload Page" name="btnUpload2" id="btnUpload2" class="ddm_custom_button"  onclick="doSubmit(2)" /></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                </table>


                                                                                            </form>

                                                                                            <form id="frmDownload" name="frmDownload" method="post" target="_blank"><input type="hidden" id="hdnFileName" name="hdnFileName" value="<%=vsFile%>"  />
                                                                                                <input type="hidden" id="hdnFilePath" name="hdnFilePath" value="<%=vsFilePath%>"  /></form>

                                                                                        </td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                </table></td>
                                                                            <td width="15">&nbsp;</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td height="50">&nbsp;</td>
                                                                            <td align="left" valign="top" >&nbsp;</td>
                                                                            <td>&nbsp;</td>
                                                                        </tr>
                                                                    </table></td>
                                                            </tr>
                                                        </table>                          </td>
                                                </tr>


                                            </table></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                </td></tr>
            <tr>
                <td height="32" class="ddm_footter_center">                  
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="ddm_footter_left">
                        <tr>
                            <td height="32">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="ddm_footter_right">
                                    <tr>
                                        <td height="32" valign="bottom">
                                            <table width="100%" height="32" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td height="10"></td>
                                                    <td valign="middle" class="ddm_copyRight"></td>
                                                    <td align="right" valign="middle" class="ddm_copyRight"></td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td width="25"></td>
                                                    <td valign="middle" class="ddm_copyRight">&copy; 2023 LankaPay (Pvt) Ltd. All rights reserved. | Tel: 011 2334455 | Mail: helpdesk.ddm@lankapay.net</td>
                                                    <td align="right" valign="middle" class="ddm_copyRight">Developed By - Transnational Technology Solutions Lanka (Pvt) Ltd.</td>
                                                    <td width="25"></td>
                                                </tr>
                                            </table></td>
                                    </tr>
                                </table></td>
                        </tr>
                    </table>




                </td>
            </tr>
        </table>

    </body>
</html>
<%
        // }
    }
%>