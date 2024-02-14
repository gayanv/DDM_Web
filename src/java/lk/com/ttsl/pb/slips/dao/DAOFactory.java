/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao;

import lk.com.ttsl.pb.slips.dao.account.AccountDAO;
import lk.com.ttsl.pb.slips.dao.account.AccountDAOImpl;
import lk.com.ttsl.pb.slips.dao.bank.BankDAO;
import lk.com.ttsl.pb.slips.dao.bank.BankDAOImpl;
import lk.com.ttsl.pb.slips.dao.branch.BranchDAO;
import lk.com.ttsl.pb.slips.dao.branch.BranchDAOImpl;
import lk.com.ttsl.pb.slips.dao.calendar.BCMCalendarDAO;
import lk.com.ttsl.pb.slips.dao.calendar.BCMCalendarDAOImpl;
import lk.com.ttsl.pb.slips.dao.certificateinfo.CertificateInfoDAO;
import lk.com.ttsl.pb.slips.dao.certificateinfo.CertificateInfoDAOImpl;
import lk.com.ttsl.pb.slips.dao.certificates.CertificateDAO;
import lk.com.ttsl.pb.slips.dao.certificates.CertificateDAOImpl;
import lk.com.ttsl.pb.slips.dao.confirmstatus.ConfirmStatusDAO;
import lk.com.ttsl.pb.slips.dao.confirmstatus.ConfirmStatusDAOImpl;
import lk.com.ttsl.pb.slips.dao.corporatecustomer.CorporateCustomerDAO;
import lk.com.ttsl.pb.slips.dao.corporatecustomer.CorporateCustomerDAOImpl;
import lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap.CorporateCustomerAccNoMapDAO;
import lk.com.ttsl.pb.slips.dao.corporatecustomer.accnomap.CorporateCustomerAccNoMapDAOImpl;
import lk.com.ttsl.pb.slips.dao.custom.CustomDAO;
import lk.com.ttsl.pb.slips.dao.custom.CustomDAOImpl;
import lk.com.ttsl.pb.slips.dao.custom.message.CustomMsgDAO;
import lk.com.ttsl.pb.slips.dao.custom.message.CustomMsgDAOImpl;
import lk.com.ttsl.pb.slips.dao.report.ReportDAO;
import lk.com.ttsl.pb.slips.dao.report.ReportDAOImpl;
import lk.com.ttsl.pb.slips.dao.custom.user.UserDAO;
import lk.com.ttsl.pb.slips.dao.custom.user.UserDAOImpl;
import lk.com.ttsl.pb.slips.dao.ddmrequest.DDMRequestDAO;
import lk.com.ttsl.pb.slips.dao.ddmrequest.DDMRequestDAOImpl;
import lk.com.ttsl.pb.slips.dao.ddmrequeststatus.DDMRequestStatusDAO;
import lk.com.ttsl.pb.slips.dao.ddmrequeststatus.DDMRequestStatusDAOImpl;
import lk.com.ttsl.pb.slips.dao.emaillist.EmailListDAO;
import lk.com.ttsl.pb.slips.dao.emaillist.EmailListDAOImpl;
import lk.com.ttsl.pb.slips.dao.emailnotificationtype.EmailNotificationTypeDAO;
import lk.com.ttsl.pb.slips.dao.emailnotificationtype.EmailNotificationTypeDAOImpl;
import lk.com.ttsl.pb.slips.dao.executionBatch.ExecutionBatchDAO;
import lk.com.ttsl.pb.slips.dao.executionBatch.ExecutionBatchDAOImpl;
import lk.com.ttsl.pb.slips.dao.executionBatchHistory.ExecutionBatchHistoryDAO;
import lk.com.ttsl.pb.slips.dao.executionBatchHistory.ExecutionBatchHistoryDAOImpl;
import lk.com.ttsl.pb.slips.dao.executionBatchStatus.ExecutionBatchStatusDAO;
import lk.com.ttsl.pb.slips.dao.executionBatchStatus.ExecutionBatchStatusDAOImpl;
import lk.com.ttsl.pb.slips.dao.requeststatus.RequestStatusDAOImpl;
import lk.com.ttsl.pb.slips.dao.log.LogDAO;
import lk.com.ttsl.pb.slips.dao.log.LogDAOImpl;
import lk.com.ttsl.pb.slips.dao.logType.LogTypeDAO;
import lk.com.ttsl.pb.slips.dao.logType.LogTypeDAOImpl;
import lk.com.ttsl.pb.slips.dao.merchant.MerchantDAO;
import lk.com.ttsl.pb.slips.dao.merchant.MerchantDAOImpl;
import lk.com.ttsl.pb.slips.dao.merchant.accnomap.MerchantAccNoMapDAO;
import lk.com.ttsl.pb.slips.dao.merchant.accnomap.MerchantAccNoMapDAOImpl;
import lk.com.ttsl.pb.slips.dao.message.body.MsgBodyDAO;
import lk.com.ttsl.pb.slips.dao.message.body.MsgBodyDAOImpl;
import lk.com.ttsl.pb.slips.dao.message.header.MsgHeaderDAO;
import lk.com.ttsl.pb.slips.dao.message.header.MsgHeaderDAOImpl;
import lk.com.ttsl.pb.slips.dao.message.priority.MsgPriorityDAO;
import lk.com.ttsl.pb.slips.dao.message.priority.MsgPriorityDAOImpl;
import lk.com.ttsl.pb.slips.dao.parameter.ParameterDAO;
import lk.com.ttsl.pb.slips.dao.parameter.ParameterDAOImpl;
import lk.com.ttsl.pb.slips.dao.reportmap.ReportMapDAO;
import lk.com.ttsl.pb.slips.dao.reportmap.ReportMapDAOImpl;
import lk.com.ttsl.pb.slips.dao.reporttype.ReportTypeDAO;
import lk.com.ttsl.pb.slips.dao.reporttype.ReportTypeDAOImpl;
import lk.com.ttsl.pb.slips.dao.user.pwd.history.PWD_HistoryDAO;
import lk.com.ttsl.pb.slips.dao.user.pwd.history.PWD_HistoryDAOImpl;
import lk.com.ttsl.pb.slips.dao.userLevel.UserLevelDAO;
import lk.com.ttsl.pb.slips.dao.userLevel.UserLevelDAOImpl;
import lk.com.ttsl.pb.slips.dao.userlevelfunctionmap.UserLevelFunctionMapDAO;
import lk.com.ttsl.pb.slips.dao.userlevelfunctionmap.UserLevelFunctionMapDAOImpl;
import lk.com.ttsl.pb.slips.dao.requeststatus.RequestStatusDAO;
import lk.com.ttsl.pb.slips.dda.DDARequestDAO;
import lk.com.ttsl.pb.slips.dda.DDARequestDAOImpl;

/**
 *
 * @author Dinesh
 */
public class DAOFactory
{

    private DAOFactory()
    {
    }

    public static AccountDAO getAccountDAO()
    {
        return new AccountDAOImpl();
    }

    public static BankDAO getBankDAO()
    {
        return new BankDAOImpl();
    }
    
    public static BranchDAO getBranchDAO()
    {
        return new BranchDAOImpl();
    }

    public static BCMCalendarDAO getBCMCalendarDAO()
    {
        return new BCMCalendarDAOImpl();
    }

    public static CertificateDAO getCertificateDAO()
    {
        return new CertificateDAOImpl();
    }

    public static CertificateInfoDAO getCertificateInfoDAO()
    {
        return new CertificateInfoDAOImpl();
    }

    public static ConfirmStatusDAO getConfirmStatusDAO()
    {
        return new ConfirmStatusDAOImpl();
    }

    public static CorporateCustomerDAO getCorporateCustomerDAO()
    {
        return new CorporateCustomerDAOImpl();
    }

    public static CorporateCustomerAccNoMapDAO getCorporateCustomerAccNoMapDAO()
    {
        return new CorporateCustomerAccNoMapDAOImpl();
    }

    public static CustomDAO getCustomDAO()
    {
        return new CustomDAOImpl();
    }

    public static CustomMsgDAO getCustomMsgDAO()
    {
        return new CustomMsgDAOImpl();
    }

    public static DDMRequestDAO getDDMRequestDAO()
    {
        return new DDMRequestDAOImpl();
    }

    public static DDMRequestStatusDAO getDDMRequestStatusDAO()
    {
        return new DDMRequestStatusDAOImpl();
    }

    public static EmailListDAO getEmailListDAO()
    {
        return new EmailListDAOImpl();
    }

    public static EmailNotificationTypeDAO getEmailNotificationTypeDAO()
    {
        return new EmailNotificationTypeDAOImpl();
    }

    public static ExecutionBatchDAO getExecutionBatchDAO()
    {
        return new ExecutionBatchDAOImpl();
    }

    public static ExecutionBatchHistoryDAO getExecutionBatchHistoryDAO()
    {
        return new ExecutionBatchHistoryDAOImpl();
    }

    public static ExecutionBatchStatusDAO getExecutionBatchStatusDAO()
    {
        return new ExecutionBatchStatusDAOImpl();
    }

    public static LogTypeDAO getLogTypeDAO()
    {
        return new LogTypeDAOImpl();
    }

    public static LogDAO getLogDAO()
    {
        return new LogDAOImpl();
    }

    public static MerchantDAO getMerchantDAO()
    {
        return new MerchantDAOImpl();
    }
    
    public static MerchantAccNoMapDAO getMerchantAccNoMapDAO()
    {
        return new MerchantAccNoMapDAOImpl();
    }

    public static MsgBodyDAO getMsgBodyDAO()
    {
        return new MsgBodyDAOImpl();
    }

    public static MsgHeaderDAO getMsgHeaderDAO()
    {
        return new MsgHeaderDAOImpl();
    }

    public static MsgPriorityDAO getMsgPriorityDAO()
    {
        return new MsgPriorityDAOImpl();
    }

    public static PWD_HistoryDAO getPWD_HistoryDAO()
    {
        return new PWD_HistoryDAOImpl();
    }

    public static ParameterDAO getParameterDAO()
    {
        return new ParameterDAOImpl();
    }

    public static ReportDAO getReportDAO()
    {
        return new ReportDAOImpl();
    }

    public static ReportMapDAO getReportMapDAO()
    {
        return new ReportMapDAOImpl();
    }
    
    public static ReportTypeDAO getReportTypeDAO()
    {
        return new ReportTypeDAOImpl();
    }
    
    public static RequestStatusDAO getFileStatusDAO()
    {
        return new RequestStatusDAOImpl();
    }

    public static UserDAO getUserDAO()
    {
        return new UserDAOImpl();
    }

    public static UserLevelDAO getUserLevelDAO()
    {
        return new UserLevelDAOImpl();
    }

    public static UserLevelFunctionMapDAO getUserLevelFunctionMapDAO()
    {
        return new UserLevelFunctionMapDAOImpl();
    }
    
    public static DDARequestDAO getDDARequestDAO() {
        return new DDARequestDAOImpl();
    }

}
