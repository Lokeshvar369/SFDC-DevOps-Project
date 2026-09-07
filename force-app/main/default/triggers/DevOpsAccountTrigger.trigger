trigger DevOpsAccountTrigger on Account(after insert) {
  for (Account acc : Trigger.new) {
    System.debug('TRIGGER FIRED: ' + acc.Name);
  }
}
