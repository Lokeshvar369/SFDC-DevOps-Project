/**
 * Handles Account trigger processing.
 */
public with sharing class DevOpsAccountTriggerHandler {
  /**
   * Processes Accounts after insertion.
   *
   * @param accounts Accounts inserted by the trigger.
   */
  public static void afterInsert(List<Account> accounts) {
    for (Account acc : accounts) {
      System.debug('TRIGGER FIRED: ' + acc.Name);
    }
  }
}
