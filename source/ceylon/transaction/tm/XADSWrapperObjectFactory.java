/*
 * JBoss, Home of Professional Open Source.
 * Copyright 2013, Red Hat, Inc., and individual contributors
 * as indicated by the @author tags. See the copyright.txt file in the
 * distribution for a full listing of individual contributors.
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */
package ceylon.transaction.tm;

import javax.naming.*;
import javax.naming.spi.ObjectFactory;
import javax.sql.XADataSource;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.List;
import java.util.Arrays;

import org.jboss.modules.DependencySpec;
import org.jboss.modules.Module;
import org.jboss.modules.ModuleLoadException;
import org.jboss.modules.ModuleIdentifier;
import org.jboss.modules.ModuleLoader;
import org.jboss.modules.filter.PathFilters;

import ceylon.modules.jboss.runtime.CeylonModuleLoader;

/**
 * @author <a href="mailto:mmusgrov@redhat.com">Mike Musgrove</a>
 */
public class XADSWrapperObjectFactory implements ObjectFactory {

    private static class DriverSpec {
        public final String module,version,dataSource;
        DriverSpec(String module, String version, String dataSource){
            this.module = module;
            this.version = version;
            this.dataSource = dataSource;
        }
    }

    private static Map<String, DriverSpec> jdbcDrivers = new HashMap<String, DriverSpec>();

    private static List<String> supportedDrivers = Arrays.asList(
        "org.postgresql.Driver",
        "org.h2.Driver",
        "oracle.jdbc.driver.OracleDriver",
        "com.microsoft.sqlserver.jdbc.SQLServerDriver",
        "com.mysql.jdbc.Driver",
        "com.ibm.db2.jcc.DB2Driver",
        "com.sybase.jdbc3.jdbc.SybDriver",
        "org.apache.derby.jdbc.ClientDriver" // not sure if it works but adding it for testing
    );

    public static void registerDriverSpec(String driverClassName, String moduleName, String moduleVersion,
                                   String dataSourceClassName) {
        if (!supportedDrivers.contains(driverClassName))
            System.err.printf("Warning, " + driverClassName + " is an unsupported driver%n");
 //           throw new IllegalArgumentException("Unsupported driver: " + driverClassName);

        jdbcDrivers.put(driverClassName, new DriverSpec(moduleName, moduleVersion, dataSourceClassName));
    }

    @Override
    public Object getObjectInstance(Object obj, Name name, Context nameCtx, Hashtable<?, ?> environment) throws Exception {
        Reference ref = (Reference)obj;
        XADataSource xads = getXADataSource(
                getStringProperty(ref, "binding"),
                getStringProperty(ref, "driver"),
                getStringProperty(ref, "databaseName"),
                getStringProperty(ref, "host"),
                getIntegerProperty(ref, "port", 0),
                getStringProperty(ref, "username"),
                getStringProperty(ref, "password")
        );

        return xads;
    }

    public static Reference getReference(String className, String binding,
                                         String driver, String databaseName,
                                         String host, Integer port,
                                         String userName, String password)  throws NamingException {

        Reference ref = new Reference(className, XADSWrapperObjectFactory.class.getName(), null);

        ref.add(new StringRefAddr("binding", binding));
        ref.add(new StringRefAddr("driver", driver));
        ref.add(new StringRefAddr("databaseName", databaseName));
        ref.add(new StringRefAddr("host", host));
        ref.add(new StringRefAddr("port", port.toString()));

        ref.add(new StringRefAddr("username", userName));
        ref.add(new StringRefAddr("password", password));

        return ref;
    }

    public static XADSWrapper getXADataSource(String binding, String driver, String databaseName, String host, Integer port, String userName, String password)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        XADSWrapper wrapper;
        DriverSpec driverSpec = jdbcDrivers.get(driver);

        if (driverSpec == null)
            throw new RuntimeException("Please register JDBC driver " + driver + " before using it");

        if (driverSpec.dataSource == null || driverSpec.module == null)
            throw new RuntimeException("JDBC driver " + driver + " not recognised");

        // load the driver module
        ModuleIdentifier moduleIdentifier = ModuleIdentifier.create(driverSpec.module, driverSpec.version);
        ClassLoader moduleClassLoader;
        try{
            Module module = Module.getCallerModuleLoader().loadModule(moduleIdentifier);
            moduleClassLoader = module.getClassLoader();
        }catch(ModuleLoadException x){
            throw new RuntimeException("Failed to load module for driver " + driver, x);
        }
        
        // register ceylon.transaction in narnia
        ModuleLoader moduleLoader = Module.getCallerModuleLoader();
        if(moduleLoader instanceof CeylonModuleLoader){
        	Module transactionModule = Module.getCallerModule();
        	Module narniaModule = Module.forClass(com.arjuna.ats.arjuna.common.RecoveryEnvironmentBean.class);
            DependencySpec dependency = DependencySpec.createModuleDependencySpec(
                    PathFilters.acceptAll(),
                    PathFilters.rejectAll(),
                    moduleLoader,
                    transactionModule.getIdentifier(),
                    true
                );

        	try {
				((CeylonModuleLoader) moduleLoader).updateModule(narniaModule, dependency);
			} catch (ModuleLoadException e) {
	            throw new RuntimeException("Failed to add ceylon.transaction dependency to narnia", e);
			}
        }

        wrapper = new XADSWrapper(binding, driver, databaseName, host, port,
            driverSpec.dataSource, moduleClassLoader, userName, password);

        if (driver.equals("org.h2.Driver")) {
            wrapper.setProperty("URL", databaseName);
        } else if(driver.equals("org.hsqldb.jdbcDriver")) {
            wrapper.setProperty("Url", databaseName);
            wrapper.setProperty("User", userName);
            wrapper.setProperty("Password", password);
        } else {
            wrapper.setProperty("databaseName", databaseName);
            wrapper.setProperty("serverName", host);
            wrapper.setProperty("portNumber", port);
        }

        if (driver.equals("oracle.jdbc.driver.OracleDriver")) {
            wrapper.setProperty("driverType", "thin");
        } else if( driver.equals("com.microsoft.sqlserver.jdbc.SQLServerDriver")) {
            wrapper.setProperty("sendStringParametersAsUnicode", false);
        } else if( driver.equals("com.mysql.jdbc.Driver")) {

            // Note: MySQL XA only works on InnoDB tables.
            // set 'default-storage-engine=innodb' in e.g. /etc/my.cnf
            // so that the 'CREATE TABLE ...' statments behave correctly.
            // doing this config on a per connection basis instead is
            // possible but would require lots of code changes :-(

            wrapper.setProperty("pinGlobalTxToPhysicalConnection", true); // Bad Things happen if you forget this bit.
        } else if( driver.equals("com.ibm.db2.jcc.DB2Driver")) {
            wrapper.setProperty("driverType", 4);
        } else if( driver.equals("org.h2.Driver")) {
            wrapper.setProperty("URL", databaseName);
        }

        return wrapper;
    }

    private String getStringProperty(Reference ref, String propName) {

        RefAddr addr = ref.get(propName);

        return (addr == null ? null : (String)addr.getContent());
    }

    private Integer getIntegerProperty(Reference ref, String propName, int defValue) {

        RefAddr addr = ref.get(propName);

        if (addr ==  null)
            return defValue;

        Object content =  addr.getContent();

        return (content == null ? defValue : Integer.parseInt(content.toString()));
    }
}
