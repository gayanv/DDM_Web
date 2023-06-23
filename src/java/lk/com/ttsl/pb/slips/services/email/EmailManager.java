/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.email;

import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;
import lk.com.ttsl.pb.slips.dao.DAOFactory;

/**
 *
 * @author Dinesh
 */
public class EmailManager
{

    private String emailBodyPart1 = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_p1);
    private String emailBodyPart2 = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_p2);
    private String emailBodyPart3 = DAOFactory.getParameterDAO().getParamValueById(DDM_Constants.param_id_email_p3);

}
