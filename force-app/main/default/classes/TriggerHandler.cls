/**
 * @description       : 
 * @author            : William Aldana
 * @group             : 
 * @last modified on  : 09-10-2020
 * @last modified by  : William Aldana
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-09-2020   William Aldana   Initial Version
**/
public virtual class TriggerHandler {

    // static map of handlername, times run() was invoked
    private static String handlerName;
    private static String oldHandlerName;
    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;
    private static List<TriggerConfig__mdt> getTrConfigs;
    private static List<TriggerConfig__mdt> trConfigs{
      get{
        if(oldHandlerName != handlerName) {
          oldHandlerName = handlerName;
          getTrConfigs = [Select IsActive__c, MaxLoopCount__c, ThrowException__c from TriggerConfig__mdt where DeveloperName = :handlerName];
          return getTrConfigs;
        }
        return getTrConfigs;
      }
    }

  
    // the current context of the trigger, overridable in tests
    @TestVisible
    private TriggerContext context;
  
    // the current context of the trigger, overridable in tests
    @TestVisible
    private Boolean isTriggerExecuting;
  
    // static initialization
    static {
      loopCountMap = new Map<String, LoopCount>();
      bypassedHandlers = new Set<String>();
    }
    
    // constructor
    public TriggerHandler() {
      this.setTriggerContext();
    }
  
    /***************************************
     * public instance methods
     ***************************************/
  
    // main method that will be called during execution
    public void run(String triggerName) {
      handlerName = triggerName; 
      if(!validateRun()) {
        return;
      }
  
      if (addToLoopCount()) return;
  
      // dispatch to the correct handler method
        if (TriggerContext.BEFORE_INSERT == this.context) {
          this.beforeInsert();
        } else if (TriggerContext.BEFORE_UPDATE == this.context){
          this.beforeUpdate();
        } else if (TriggerContext.BEFORE_DELETE == this.context){
          this.beforeDelete();
        } else if (TriggerContext.AFTER_INSERT == this.context){
          this.afterInsert();
        } else if (TriggerContext.AFTER_UPDATE == this.context){
          this.afterUpdate();
        } else if (TriggerContext.AFTER_DELETE == this.context){
          this.afterDelete();
        } else if (TriggerContext.AFTER_UNDELETE == this.context){
          this.afterUndelete();
        }
    }

    public void setMaxLoopCount(Integer max, Boolean tEx) {
        if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
            TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max,tEx));
        } else {
            TriggerHandler.loopCountMap.get(handlerName).setMax(max);
            TriggerHandler.loopCountMap.get(handlerName).setThrowException(tEx);
        }
    }    
  
    public void clearMaxLoopCount() {
      this.setMaxLoopCount(-1, false);
    }
  
    /***************************************
     * public static methods
     ***************************************/
  
    public static void bypass(String handlerName) {
      TriggerHandler.bypassedHandlers.add(handlerName);
    }
  
    public static void clearBypass(String handlerName) {
      TriggerHandler.bypassedHandlers.remove(handlerName);
    }
  
    public static Boolean isBypassed(String handlerName) {
      return TriggerHandler.bypassedHandlers.contains(handlerName);
    }
  
    public static void clearAllBypasses() {
      TriggerHandler.bypassedHandlers.clear();
    }
  
    /***************************************
     * private instancemethods
     ***************************************/
  
    @TestVisible
    private void setTriggerContext() {
      this.setTriggerContext(null, false);
    }
  
    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {
      if(!Trigger.isExecuting && !testMode) {
        this.isTriggerExecuting = false;
        return;
      } else {
        this.isTriggerExecuting = true;
      }
      
      if((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
          (ctx != null && ctx == 'before insert')) {
        this.context = TriggerContext.BEFORE_INSERT;
      } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
          (ctx != null && ctx == 'before update')){
        this.context = TriggerContext.BEFORE_UPDATE;
      } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
          (ctx != null && ctx == 'before delete')) {
        this.context = TriggerContext.BEFORE_DELETE;
      } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
          (ctx != null && ctx == 'after insert')) {
        this.context = TriggerContext.AFTER_INSERT;
      } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
          (ctx != null && ctx == 'after update')) {
        this.context = TriggerContext.AFTER_UPDATE;
      } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
          (ctx != null && ctx == 'after delete')) {
        this.context = TriggerContext.AFTER_DELETE;
      } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
          (ctx != null && ctx == 'after undelete')) {
        this.context = TriggerContext.AFTER_UNDELETE;
      }
    }
  
    // increment the loop count
    @TestVisible
    private Boolean addToLoopCount() {
      //String handlerName = getHandlerName();
      Boolean endLoop = false;
      if(TriggerHandler.loopCountMap.containsKey(handlerName)) {
        Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
        if(exceeded) {
          Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
          if(TriggerHandler.loopCountMap.get(handlerName).throwException){
            throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
          }else{
            endLoop = true;
          }
        }
      }
      return endLoop;
    }
  
    // make sure this trigger should continue to run
    @TestVisible
    private Boolean validateRun() {
      if(!this.isTriggerExecuting || this.context == null) {
        throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
      }

      if (TriggerHandler.bypassedHandlers.contains(handlerName)) {
        System.debug('[TriggerHandler] '+handlerName+' bypass');
        return false;
      }

      //List<TriggerConfig__mdt> trConfigs = [Select IsActive__c, MaxLoopCount__c, ThrowException__c from TriggerConfig__mdt where DeveloperName = :handlerName];
      if(!trConfigs.isEmpty()){
        if(trConfigs[0].MaxLoopCount__c != null && trConfigs[0].MaxLoopCount__c > 0){
            if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
                TriggerHandler.loopCountMap.put(handlerName, new LoopCount(trConfigs[0].MaxLoopCount__c.intValue(), trConfigs[0].ThrowException__c));
            } else {
                TriggerHandler.loopCountMap.get(handlerName).setMax(trConfigs[0].MaxLoopCount__c.intValue());
                TriggerHandler.loopCountMap.get(handlerName).setThrowException(trConfigs[0].ThrowException__c);
            }
        }        
           
        //activate/deactivate triggers based on the custom setting
        if(!trConfigs[0].IsActive__c){
            System.debug('[TriggerHandler] '+handlerName+' inactive');
            return false;
        }

       }
       return true;
    }
  
    @TestVisible
    private String getHandlerName() {
      //return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
      return handlerName;
    }
  
    /***************************************
     * context methods
     ***************************************/
  
    // context-specific methods for override
    @TestVisible
    protected virtual void beforeInsert(){}
    @TestVisible
    protected virtual void beforeUpdate(){}
    @TestVisible
    protected virtual void beforeDelete(){}
    @TestVisible
    protected virtual void afterInsert(){}
    @TestVisible
    protected virtual void afterUpdate(){}
    @TestVisible
    protected virtual void afterDelete(){}
    @TestVisible
    protected virtual void afterUndelete(){}
  
    /***************************************
     * inner classes
     ***************************************/
  
    // inner class for managing the loop count per handler
    @TestVisible
    private class LoopCount {
      private Integer max;
      private Integer count;
      private Boolean throwException;
  
      public LoopCount() {
        this.max = 5;
        this.count = 0;
      }
  
      public LoopCount(Integer max) {
        this.max = max;
        this.count = 0;
      }

      public LoopCount(Integer max, Boolean tEx) {
        this.max = max;
        this.count = 0;
        this.throwException = tEx;
    }
  
      public Boolean increment() {
        this.count++;
        return this.exceeded();
      }
  
      public Boolean exceeded() {
        if (this.max< 0) return false;
        if (this.count> this.max) {
            return true;
        }
        return false;
      }
  
      public Integer getMax() {
        return this.max;
      }
  
      public Integer getCount() {
        return this.count;
      }
  
      public void setMax(Integer max) {
        this.max = max;
      }

      public void setThrowException(Boolean tex) {
        this.throwException = tex;
      }
    }
  
    // possible trigger contexts
    @TestVisible
    private enum TriggerContext {
      BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
      AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
      AFTER_UNDELETE
    }
  
    // exception class
    public class TriggerHandlerException extends Exception {}
  
  }