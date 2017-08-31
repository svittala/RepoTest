trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    if ( UserInfo.getUserName().startsWith('integration@enersys.com') || TEST.isRunningTest() ) {
        if ( Trigger.isBefore ) {
            AccountUtil.EmeaBefore( Trigger.new );
            AccountUtil.fixAccount(Trigger.new);
        }
        if ( Trigger.isAfter ) {
            AccountUtil.EmeaAfter( Trigger.new );
        }
    }
}