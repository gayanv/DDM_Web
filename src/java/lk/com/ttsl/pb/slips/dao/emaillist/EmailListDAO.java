/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.emaillist;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface EmailListDAO
{

    public String getMsg();

    public EmailList getEmailMappingDetails(String bankCode, String notificationType);
    
    public Collection<EmailList> getEmailMappings(String bankCode, String notificationType);

    public Collection<EmailList> getEmailMappingsByBankAndStatus(String bankCode, String status);

    public Collection<EmailList> getEmailMappingsNotInStatus(String bankCode, String status);

    public Collection<EmailList> getAuthPendingEmailMappings(String bankCode, String createdUser);

    public Collection<EmailList> getAuthPendingModifiedEmailMappings(String bankCode, String createdUser);

    public boolean addEmailMapping(EmailList emailList);

    public boolean updateAllEmailMappingStatus(String bankCode, String status, String modifiedBy);

    public boolean modifyEmailMappings(EmailList emailList);

    public boolean doAuthorizeEmailMappings(EmailList emailList);

    public boolean doAuthorizeModifiedEmailMappings(EmailList emailList);

}
