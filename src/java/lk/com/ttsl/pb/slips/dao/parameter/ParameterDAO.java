/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.dao.parameter;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Dinesh
 */
public interface ParameterDAO
{

    public String getMsg();

    public String getParamValueById(String paramId);

    public String getParamValueById_notFormatted(String paramId);

    public String getParamValue(String paramId, String paramType);
    
    public Parameter getParamDetails(String paramId);

    public Collection<Parameter> getAllParamterValues();

    public boolean update(Collection<Parameter> para);

    public boolean update(Parameter parameter);
    
    public boolean updateLastEmailSentDate(Parameter parameter);

    public int getDateTypeParameterCount();

    public HashMap<String, String> getFailQuery();

    public HashMap<String, String> getSuccessQuery();

    public HashMap<String, Parameter> getFailQuery2();

    public HashMap<String, Parameter> getSuccessQuery2();

    // add new method to get all sessions
    public Map<String, Parameter> getAllSessionParams();

    public boolean addParameter(Parameter parameter);

    public Collection<Parameter> getAuthPendingModifiedParams(String modifiedBy);

    public boolean doAuthorizeModifiedParams(Parameter parameter);

}
