
"""This module enables updates to multiple databases within 
   a single transaction. It is integrated with 
   [[module ceylon.dbc]].

   First, obtain a reference to the
   [[transaction manager|TransactionManager]] by importing 
   its [[singleton instance|transactionManager]]:
   
       import ceylon.transaction.tm {
           tm=transactionManager
       }
   
   Then [[start|TransactionManager.start]] it:

       tm.start();
   
   The `TransactionManager` needs to know about every JDBC
   [[datasource|javax.sql::XADataSource]] so that it can
   intercept calls and automatically enlist the datasource 
   as an XA resource in the current transaction. Therefore, 
   the datasource must be XA-capable. If you use the method
   [[ceylon.dbc::connections]]:newConnectionFromXADataSource
   to obtain XA datasources then the TransactionManager will
   automatically ensure that work done on the returned connection
   is tranactional.
   
   Note that not all database drivers correctly support XA 
   (particularly in the area of recovering from failures), 
   so `ceylon.transaction` only explicitly supports the 
   subset of possible products that are known to behave 
   correctly with respect to recovery:
   
        org.postgresql.Driver
        oracle.jdbc.driver.OracleDriver
        com.microsoft.sqlserver.jdbc.SQLServerDriver
        com.mysql.jdbc.Driver
        com.ibm.db2.jcc.DB2Driver
        com.sybase.jdbc3.jdbc.SybDriver
   
   If you try to register any other driver then a warning 
   will be printed to the console. You may still use the 
   resource in an XA transaction but recovery may not work 
   in which case you will need to manually resolve any in 
   doubt transaction involving that datasource.


   
   Now you may use the XA datasource connection just like any other
   datasource connection:
   
       Sql sql1 = Sql(conn1);
       Sql sql2 = Sql(conn2);
   
   But to make updates to both within a single transaction 
   you must demarcate the transaction boundaries, usually
   using [[TransactionManager.transaction]]:
   
       tm.transaction {
           function do() {
               sql1.insert("insert ... ");
               sql2.insert("insert ... ");
               //This will cause a commit - return false or throw to cause rollback
               return true;
           }
       };
   
   You also have the option of manually controlling the 
   transaction boundary:

       assert (exists tx = tm.beginTransaction());
       sql1.insert("insert ... ");
       sql2.insert("insert ... ");
       tx.commit();

   Of equal importance as the transaction manager is the 
   recovery manager for managing transactions that have 
   prepared but some part of the system has failed before 
   all resources could be committed.
   
   In order to correctly recover such transactions, a 
   non-volatile log is created on the local file system 
   after the prepare phase which is later deleted when the
   transaction finishes (either after a successful commit
   or after a successful recovery attempt).
   The location of this store defaults to the directory
   from where the ceylon application was started. The default
   can be changed by setting a process property called:

       com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir

   By default, when you start the transaction manager a 
   recovery manager is not automatically started. The reason 
   for this is that there can only be a single recovery 
   service for all processes that share the same transaction
   logs. You _may_ run an in-process recovery service, 
   though this is not recommended, by passing a flag to 
   [[TransactionManager.start]]. But it's much better to run 
   the recovery service in its own 
   [[dedicated process|ceylon.transaction.recovery::run]],
   either interactively, or in the background.

   This recovery process also needs to know which datasources 
   any in doubt transaction was using prior to a failure so 
   you need to pass the location of a properties file which 
   defines the datasources via a process property called 
   `dbc.properties`.
   
   [Java properties format]: http://docs.oracle.com/javase/8/docs/api/java/util/Properties.html#load-java.io.Reader-"""
by ("Mike Musgrove", "Stéphane Épardaud", "Gavin King")
license ("Apache Software License 2.0")
module ceylon.transaction "1.1.2" {
    shared import org.jboss.narayana.jta "5.0.5.Final-SNAPSHOT";

    import java.base "7";
    shared import java.logging "7";
    import javax.naming "7";
    shared import java.jdbc "7";
    import javax.transaction.api "1.2";

    //import org.jboss.modules "1.3.3.Final";
    import ceylon.runtime "1.1.1";
    
    import ceylon.interop.java "1.1.1";
    import ceylon.file "1.1.1";
}
