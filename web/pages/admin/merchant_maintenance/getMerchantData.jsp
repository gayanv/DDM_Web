<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collection"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" %>
<%@page import="lk.com.ttsl.pb.slips.dao.corporatecustomer.CorporateCustomer"%>
<%


    String strCoCu = request.getParameter("q");
    
    //System.out.println("strAccountNo --> " + (strAccountNo!=null?strAccountNo:"n/a"));

    Collection<CorporateCustomer> col = DAOFactory.getCorporateCustomerDAO().findCoCu(DDM_Constants.status_all, strCoCu, DDM_Constants.status_all);

    Iterator<CorporateCustomer> iterator = col.iterator();

    while (iterator.hasNext())
    {
        CorporateCustomer cocu = (CorporateCustomer) iterator.next();
        
        out.println(cocu.getCoCuID());
    }
%>