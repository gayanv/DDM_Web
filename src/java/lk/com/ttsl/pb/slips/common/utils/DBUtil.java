/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.common.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.PropertyResourceBundle;
import org.apache.commons.pool.ObjectPool;
import org.apache.commons.pool.impl.GenericObjectPool;
import org.apache.commons.dbcp.ConnectionFactory;
import org.apache.commons.dbcp.PoolableConnectionFactory;
import org.apache.commons.dbcp.DriverManagerConnectionFactory;
import org.apache.commons.dbcp.PoolingDriver;

/**
 *
 * @author Dinesh - ProntoIT
 */
public class DBUtil
{

    private static DBUtil util;
    private static String strDBURL;
    private static String strUser;
    private static String strPassword;
    private static ObjectPool connectionPool;

    private static String strDBURL_archival;
    private static String strUser_arcival;
    private static String strPassword_archival;
    private static ObjectPool archivalConnectionPool;

    // private static Logger icpsFileProcessorLog = GlobalFileDetails.getAdminLogInstance();
    private DBUtil()
    {
    }

    public static DBUtil getInstance()
    {
        if (util == null)
        {
            util = new DBUtil();
        }
        return util;
    }

    public Connection getConnection() throws SQLException,
            ClassNotFoundException
    {
        Connection con = null;

        if (strDBURL == null || strUser == null || strPassword == null)
        {
            FileInputStream fis = null;

            try
            {
                fis = new FileInputStream(new File(DDM_Constants.path_dbProperty));

                PropertyResourceBundle bundle = new PropertyResourceBundle(fis);
                strDBURL = bundle.getString("DB_URL");
                strUser = bundle.getString("USER");
                strPassword = bundle.getString("PWD");
            }
            catch (IOException e)
            {
                System.out.println("Error 1============> " + e.getMessage());
            }
            finally
            {
                try
                {
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        try
        {            
            //System.out.println("strDBURL ====> " + strDBURL);
            //System.out.println("strUser ====> " + strUser);
            //System.out.println("strPassword ====> " + strPassword);
            
            //Class.forName("com.mysql.jdbc.Driver");            
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            con = DriverManager.getConnection(strDBURL, strUser, strPassword);

        }
        catch (ClassNotFoundException | IllegalAccessException | InstantiationException | SQLException e)
        {
            System.out.println("Error 2============> " + e.getMessage());
        }

        return con;

    }

    public Connection getConnection2() throws SQLException,
            ClassNotFoundException
    {

        Connection con = null;

        if (strDBURL == null || strUser == null || strPassword == null)
        {
            FileInputStream fis = null;

            try
            {
                fis = new FileInputStream(new File(DDM_Constants.path_dbProperty));

                PropertyResourceBundle bundle = new PropertyResourceBundle(fis);
                strDBURL = bundle.getString("DB_URL");
                strUser = bundle.getString("USER");
                strPassword = bundle.getString("PWD");
            }
            catch (IOException e)
            {
                System.out.println("Error 1============>");
                e.printStackTrace();
            }
            finally
            {
                try
                {
                    fis.close();
                }
                catch (IOException e)
                {
                    System.out.println(e.getMessage());
                }
            }
        }

        try
        {
            //Class.forName("com.mysql.jdbc.Driver");
            Class.forName("com.mysql.cj.jdbc.Driver");

        }
        catch (ClassNotFoundException e)
        {
            System.out.println(e.getMessage());
        }

        if (connectionPool == null)
        {
            connectionPool = new GenericObjectPool(null, 100, GenericObjectPool.WHEN_EXHAUSTED_GROW, 1000, 10, false, false, 30000, 5, 10000, false);
            ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(strDBURL, strUser, strPassword);

            PoolableConnectionFactory poolableConnectionFactory = new PoolableConnectionFactory(connectionFactory, connectionPool, null, null, false, true);

            Class.forName("org.apache.commons.dbcp.PoolingDriver");
        }

        PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");

        driver.registerPool("dcis_db_con", connectionPool);

        con = DriverManager.getConnection("jdbc:apache:commons:dbcp:dcis_db_con");

        return con;

    }

    public Connection getArchivalConnection() throws SQLException,
            ClassNotFoundException
    {

        Connection con = null;

        if (strDBURL_archival == null || strUser_arcival == null || strPassword_archival == null)
        {
            FileInputStream fis = null;

            try
            {
                fis = new FileInputStream(new File(DDM_Constants.path_dbProperty));

                PropertyResourceBundle bundle = new PropertyResourceBundle(fis);
                //ResourceBundle bundle = ResourceBundle.getBundle("db_properties");

                strDBURL_archival = bundle.getString("ARCHIVAL_DB_URL");
                strUser_arcival = bundle.getString("ARCHIVAL_USER");
                strPassword_archival = bundle.getString("ARCHIVAL_PWD");

//                System.out.println("Archival DB URL : " + strDBURL_archival);
//                System.out.println("Archival Usre : " + strUser_arcival);
//                System.out.println("Archival Password : " + strPassword_archival);
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
            finally
            {
                /*
                try
                {
                    fis.close();
                }
                catch(IOException e)
                {
                    System.out.println(e.getMessage());
                }*/
            }
        }

        try
        {
            //Class.forName("com.mysql.jdbc.Driver");
            Class.forName("com.mysql.cj.jdbc.Driver");
        }
        catch (ClassNotFoundException e)
        {
            System.out.println(e.getMessage());
        }

        if (archivalConnectionPool == null)
        {
            archivalConnectionPool = new GenericObjectPool(null, 100, GenericObjectPool.WHEN_EXHAUSTED_GROW, 1000, 10, false, false, 30000, 5, 10000, false);
            ConnectionFactory archivalConnectionFactory = new DriverManagerConnectionFactory(strDBURL_archival, strUser_arcival, strPassword_archival);

            PoolableConnectionFactory archivalPoolableConnectionFactory = new PoolableConnectionFactory(archivalConnectionFactory, archivalConnectionPool, null, null, false, true);

            Class.forName("org.apache.commons.dbcp.PoolingDriver");
        }

        PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");

        driver.registerPool("ddm_archival_db_con", archivalConnectionPool);

        con = DriverManager.getConnection("jdbc:apache:commons:dbcp:ddm_archival_db_con");

        System.out.println("Connection ====> " + con.toString());

        return con;

    }

    public void closeConnection(final Connection conn)
    {
        try
        {
            if (conn != null && !conn.isClosed())
            {
                conn.close();
            }
        }
        catch (SQLException e)
        {
            //icpsFileProcessorLog.log(Level.SEVERE, e.getMessage());
            System.out.println(e.getMessage());
        }

    }

    public void closeResultSet(final ResultSet rs)
    {
        try
        {
            if (rs != null)
            {
                rs.close();
            }
        }
        catch (SQLException e)
        {
            //icpsFileProcessorLog.log(Level.SEVERE, e.getMessage());
            System.out.println(e.getMessage());
        }

    }

    public void closeStatement(final Statement stmt)
    {
        try
        {
            if (stmt != null)
            {
                stmt.close();

            }
        }
        catch (SQLException e)
        {
            //icpsFileProcessorLog.log(Level.SEVERE, e.getMessage());
            System.out.println(e.getMessage());
        }

    }

}
