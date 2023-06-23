/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.userLevel;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

/**
 *
 * @author Dinesh - ProntoIT
 */
public class UserLevelUtil
{

    private UserLevelUtil()
    {
    }

    static UserLevel makeUserLevelObject(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        UserLevel userLevel = null;

        if (rs.isBeforeFirst())
        {
            rs.next();

            userLevel = new UserLevel();

            userLevel.setUserLevelDesc(rs.getString("UserLevelDesc"));
            userLevel.setUserLevelId(rs.getString("UserLevelId"));
        }

        return userLevel;
    }

    static Collection<UserLevel> makeUserLevelObjectsCollection(ResultSet rs) throws SQLException
    {
        if (rs == null)
        {
            throw new NullPointerException("resultset parameter");
        }

        Collection<UserLevel> result = new java.util.ArrayList();

        while (rs.next())
        {
            UserLevel user = new UserLevel();



            user.setUserLevelDesc(rs.getString("UserLevelDesc"));
            user.setUserLevelId(rs.getString("UserLevelId"));


            result.add(user);
        }

        return result;
    }
}
