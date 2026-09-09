trigger DevOpsAccountTrigger on Account(after insert) {
  DevOpsAccountTriggerHandler.afterInsert(Trigger.new);
}
