/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.user.pwd.history;

/**
 *
 * @author Dinesh
 */
public class PWD_History
{

    private String userId;
    private String pwd;
    private String createdDate;

    public PWD_History()
    {
    }

    public PWD_History(String userId, String pwd)
    {
        this.userId = userId;
        this.pwd = pwd;
    }

    public String getUserId()
    {
        return userId;
    }

    public void setUserId(String userId)
    {
        this.userId = userId;
    }

    public String getPwd()
    {
        return pwd;
    }

    public void setPwd(String pwd)
    {
        this.pwd = pwd;
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
