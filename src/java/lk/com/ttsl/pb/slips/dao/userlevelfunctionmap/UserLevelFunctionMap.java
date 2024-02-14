/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.userlevelfunctionmap;

/**
 *
 * @author Dinesh
 */
public class UserLevelFunctionMap
{

    private String userLevel;
    private String userLevelDesc;
    private int functionID;
    private String functionPath;
    private String menuLevel1;
    private int widthMenuLevel1;
    private String menuLevel2;
    private int widthMenuLevel2;
    private String menuLevel3;
    private int widthMenuLevel3;
    private String menuLevel4;
    private int widthMenuLevel4;
    private String status;
    private String statusModify;
    private String modifiedBy;
    private String modifiedDate;
    private String modificationAuthBy;
    private String modificationAuthDate;

    public UserLevelFunctionMap()
    {
    }

    public UserLevelFunctionMap(String userLevel, int functionID, String modificationAuthBy)
    {
        this.userLevel = userLevel;
        this.functionID = functionID;
        this.modificationAuthBy = modificationAuthBy;
    }

    public UserLevelFunctionMap(String userLevel, int functionID, String status, String modifiedBy)
    {
        this.userLevel = userLevel;
        this.functionID = functionID;
        this.status = status;
        this.modifiedBy = modifiedBy;
    }

    public String getUserLevel()
    {
        return userLevel;
    }

    public void setUserLevel(String userLevel)
    {
        this.userLevel = userLevel;
    }

    public String getUserLevelDesc()
    {
        return userLevelDesc;
    }

    public void setUserLevelDesc(String userLevelDesc)
    {
        this.userLevelDesc = userLevelDesc;
    }

    public int getFunctionID()
    {
        return functionID;
    }

    public void setFunctionID(int functionID)
    {
        this.functionID = functionID;
    }

    public String getFunctionPath()
    {
        return functionPath;
    }

    public void setFunctionPath(String functionPath)
    {
        this.functionPath = functionPath;
    }

    public String getMenuLevel1()
    {
        return menuLevel1;
    }

    public void setMenuLevel1(String menuLevel1)
    {
        this.menuLevel1 = menuLevel1;
    }

    public int getWidthMenuLevel1()
    {
        return widthMenuLevel1;
    }

    public void setWidthMenuLevel1(int widthMenuLevel1)
    {
        this.widthMenuLevel1 = widthMenuLevel1;
    }

    public String getMenuLevel2()
    {
        return menuLevel2;
    }

    public void setMenuLevel2(String menuLevel2)
    {
        this.menuLevel2 = menuLevel2;
    }

    public int getWidthMenuLevel2()
    {
        return widthMenuLevel2;
    }

    public void setWidthMenuLevel2(int widthMenuLevel2)
    {
        this.widthMenuLevel2 = widthMenuLevel2;
    }

    public String getMenuLevel3()
    {
        return menuLevel3;
    }

    public void setMenuLevel3(String menuLevel3)
    {
        this.menuLevel3 = menuLevel3;
    }

    public int getWidthMenuLevel3()
    {
        return widthMenuLevel3;
    }

    public void setWidthMenuLevel3(int widthMenuLevel3)
    {
        this.widthMenuLevel3 = widthMenuLevel3;
    }

    public String getMenuLevel4()
    {
        return menuLevel4;
    }

    public void setMenuLevel4(String menuLevel4)
    {
        this.menuLevel4 = menuLevel4;
    }

    public int getWidthMenuLevel4()
    {
        return widthMenuLevel4;
    }

    public void setWidthMenuLevel4(int widthMenuLevel4)
    {
        this.widthMenuLevel4 = widthMenuLevel4;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getStatusModify()
    {
        return statusModify;
    }

    public void setStatusModify(String statusModify)
    {
        this.statusModify = statusModify;
    }

    public String getModifiedBy()
    {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy)
    {
        this.modifiedBy = modifiedBy;
    }

    public String getModifiedDate()
    {
        return modifiedDate;
    }

    public void setModifiedDate(String modifiedDate)
    {
        this.modifiedDate = modifiedDate;
    }

    public String getModificationAuthBy()
    {
        return modificationAuthBy;
    }

    public void setModificationAuthBy(String modificationAuthBy)
    {
        this.modificationAuthBy = modificationAuthBy;
    }

    public String getModificationAuthDate()
    {
        return modificationAuthDate;
    }

    public void setModificationAuthDate(String modificationAuthDate)
    {
        this.modificationAuthDate = modificationAuthDate;
    }

}
