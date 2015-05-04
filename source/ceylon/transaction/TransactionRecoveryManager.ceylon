
import javax.sql {
    XADataSource
}

shared interface TransactionRecoveryManager {
    
    "Start and initialize an instance of the transaction 
     recovery manager.
     
     There must be exactly one recovery service per set of
     transaction logs, so it is recommended that the recovery
     service be run in a
     [[dedicated process|ceylon.transaction.recovery::run]]
     whenever multiple processes share the same set of 
     transaction logs."
    shared formal void start(
            "The directory name of the location of the
             transaction logs. If null then directory from
             where the recovery manager was started is used"
            String? logLocation = null);
    
    "Stop this transaction recovery manager."
    shared formal void stop();

    "Run a recovery scan. A recovery scan attempts recovery
     on each entry in the transaction logs managed by this
     recovery manager instance"
    shared formal void recoveryScan();

    "Register a given JDBC XA [[dataSource]] that can be used
     by the recovery system for recovering pending transaction branches"
    throws (`class AssertionError`,
            "if the recovery manager has not been started")
    shared formal void registerXAResourceRecoveryDataSource(XADataSource dataSource);

    "Return a list of XA capable JDBC drivers that are known to work
     correctly with the transaction manager. Some drivers, even though
     they support XA, are not fully compliant so recovery is not guaranteed
     under all scenarios. If an unsupported driver is used then we
     recommend exhaustive testing."
    shared formal [String*] supportedDrivers();
}

shared TransactionRecoveryManager transactionRecoveryManager
        => concreteRecoveryManager;
