<%@page import="lk.com.ttsl.pb.slips.common.utils.DDM_Constants"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collection"%>
<%@page import="lk.com.ttsl.pb.slips.dao.DAOFactory" %>
<%@page import="lk.com.ttsl.pb.slips.dao.account.Account"%>
<%


    String strAccountNo = request.getParameter("q");
    
    //System.out.println("strAccountNo --> " + (strAccountNo!=null?strAccountNo:"n/a"));

    Collection<Account> col = DAOFactory.getAccountDAO().findAccounts(DDM_Constants.status_all, DDM_Constants.status_all, strAccountNo, DDM_Constants.status_all, DDM_Constants.status_active);

    Iterator<Account> iterator = col.iterator();

    while (iterator.hasNext())
    {
        Account act = (Account) iterator.next();
        
        out.println(act.getAccountNo());
    }
%>