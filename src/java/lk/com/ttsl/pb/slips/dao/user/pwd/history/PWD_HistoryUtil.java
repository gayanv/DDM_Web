/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.user.pwd.history;

/**
 *
 * @author Dinesh
 */
public class PWD_HistoryUtil
{

    private String userId;
    private String password;
    private String createdDate;

    public PWD_HistoryUtil()
    {
    }

    public PWD_HistoryUtil(String userId, String password)
    {
        this.userId = userId;
        this.password = password;
    }

    public String getUserId()
    {
        return userId;
    }

    public void setUserId(String userId)
    {
        this.userId = userId;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }

    public String getCreatedDate()
    {
        return createdDate;
    }

    public void setCreatedDate(String createdDate)
    {
        this.createdDate = createdDate;
    }
}
