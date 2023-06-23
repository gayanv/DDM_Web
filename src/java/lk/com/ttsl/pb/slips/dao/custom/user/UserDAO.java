/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.custom.user;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface UserDAO
{

    public String getMsg();
    
    public void setMsg(String message);

    public boolean isAuthorized(User usr);
    
    public boolean isAuthorized(User usr, String statusIn);

    public boolean isAuthorizedDualUser(User usr, String usrLevel, String curUser);

    public boolean isCurrentlyLoggedin(String userId, int sessionExpTimeInMinutes);

    public boolean isAuthorizedForWeb(User usr, String remoteIP);

    public boolean isInitialLogin(String userId, String status);

    public Collection<User> getUserDetails(String status);

    public Collection<User> getUsers(User usr, String statusNotIn);

    public User getUserDetails(String userId, String status);

    public boolean setUserLoggingAttempts(String userId, String status);

    public boolean changeUserPassword(User usr, String curPwd, boolean isInitial);

    public boolean resetUserPassword(User usr, boolean resetUnSuccessfulLoggingAttempts);

    public Collection<User> getUserList(String UserLevel);

    public Collection<User> getUserList(String bank, String userLevel, String status);

    public int getPasswordValidityPeriod(String userId);

    public User getUnSuccessfulLoggingAttemptsDetails(String userId);

    public boolean isOkToChangePassword(String userId, int iMinPwdResetDays);

    public boolean addUser(User usr);

    public boolean setUserStatus(String userId, String status, boolean resetUnSuccessfulLoggingAttempts);

    public boolean setUserStatusManual(String userId, String status, boolean resetUnSuccessfulLoggingAttempts, String modifiedBy);

    public Collection<User> getAuthPendingUsers(String createdUser, String sessionUserType);

    public boolean doAuthorizedNewUser(String userId, String authBy);

    public boolean updateUser(User usr);

    public Collection<User> getAuthPendingModifiedUser(String modifiedBy, String modifyType, String sessionUserType);

    public boolean doAuthorizeModifiedUser(User usr);

    public boolean updateUserVisitStat(String userId, String isCurrentlyLoggedIn);

    public boolean deactivateAllUsers(String bank);

    public boolean updateExpriedUserStatus();

    public boolean deactivateLongTimeInactiveUsers();

    public boolean autoUnlockLockedUsers();
    
    public boolean updateOTP(String userId, String otp, int otpExpMinutes);
    
    public boolean isValidOTP(String userId, String otp);

}
