/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.userLevel;

import java.util.Collection;

/**
 *
 * @author Dinesh - ProntoIT
 */
public interface UserLevelDAO
{

    public UserLevel getUserLevel(String id);

    public Collection<UserLevel> getUserLevelDetails();
}
