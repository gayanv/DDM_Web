/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.user.pwd.history;

/**
 *
 * @author Dinesh
 */
public interface PWD_HistoryDAO
{
    public String getMsg();
    
    public  boolean isPWDNotAvailableInHistory(String userId, String pwd, int lastPwdCount);
    
    public  boolean addPWD_History(PWD_History pwdHis);    
}
