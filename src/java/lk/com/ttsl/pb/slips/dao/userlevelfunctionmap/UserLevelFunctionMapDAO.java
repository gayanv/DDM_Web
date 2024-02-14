/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.userlevelfunctionmap;

import java.util.Collection;

/**
 *
 * @author Dinesh
 */
public interface UserLevelFunctionMapDAO
{
    public String getMsg();
    
    public UserLevelFunctionMap getUserLevelFunctionMap(String usrLevel, int functionID);
    
    public Collection<UserLevelFunctionMap> getUserLevelFunctionMapDetails(String usrLevel);
    
    public Collection<UserLevelFunctionMap> getUserLevelFunctionMapDetails(String usrLevel, String status);
    
    public Collection<UserLevelFunctionMap> getFunctionMapForMenuCreation(String usrLevel, String status);
    
    public boolean isAccessOK(String usrLevel, String path);
    
    public boolean modifyUserLevelFunctionMap(UserLevelFunctionMap ulfm);
    
    public Collection<UserLevelFunctionMap> getAuthPendingModifiedFunctionMap(String usrLevel, String modifiedBy);
    
    public boolean doAuthorizeModifiedParams(UserLevelFunctionMap ulfm);
}
