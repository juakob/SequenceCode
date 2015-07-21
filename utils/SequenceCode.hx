package utils;

/**
 * ...
 * @author Joaquin
 */

typedef Function = Dynamic -> Bool;
class SequenceCode 
{
	private var mFunctions:Array<Function>;
	private var mWaitTimes:Array<Float>;
	private var mDoForFunctions:Array<Function>;
	private var mInstant:Array<Bool>;
	private var mCondition:Array<Function>;
private var mAnyFunctions:Array < Void->Void>;
	private var mCurrentFunction:Function;
	
	
	public function new() 
	{
		mFunctions = new Array();
		mWaitTimes = new Array();
		mDoForFunctions = new Array();
		mCondition = new Array();
		mInstant = new Array();
		mAnyFunctions = new Array();
	}
	public function pushInstantFunction(func:Function, instant:Bool = false):Void
	{
		if (mCurrentFunction!=null)
		{
			mFunctions.unshift(mCurrentFunction);
			mInstant.unshift(instant);
		}
		mCurrentFunction = func;
	}
	public function addFunction(func:Function,instant:Bool=false):Void
	{
		mFunctions.push(func);
		mInstant.push(instant);
	}
	public function addFunctionSingle(func:Void->Void, instant:Bool = false):Void
	{
		mAnyFunctions.push(func);
		addFunction(executeFunctionSingle,instant);
	}
	private function executeFunctionSingle(aDt:Float):Bool
	{
		mAnyFunctions.shift()();
		return true;
	}
	public function addDoFor(func:Function, time:Float):Void
	{
		mWaitTimes.push(time);
		mDoForFunctions.push(func);
		addFunction(doFor);
	}
	private function doFor(aDt:Float):Bool
	{
		mWaitTimes[0] -= aDt;
		if (mWaitTimes[0] <= 0)
		{
			mWaitTimes.shift();
			mDoForFunctions.shift();
			return true;
		}
		mDoForFunctions[0](aDt);
		return false;
	}
	public function addWaitCondition(aCondition:Function):Void 
	{
		mCondition.push(aCondition);
		addFunction(doWhileCondition);
	}
	private function doWhileCondition(aDt:Float):Bool
	{
		if (!mCondition[0](aDt))
		{
			return false;
		}
		mCondition.shift();
		return true;
	}
	public function addWhile(aWhile:Function, aDo:Function):Void
	{
		mDoForFunctions.push(aDo);
		mCondition.push(aWhile);
		addFunction(doWhile);
	}
	private function doWhile(aDt:Float):Bool
	{
		if (mCondition[0](aDt))
		{
			mDoForFunctions[0](aDt);
			return false;
		}
		mCondition.shift();
		mDoForFunctions.shift();
		return true;
	}
	public static var execute:Bool;
	public function update(aDt:Float):Void
	{
		do
		{
			execute = false;
			if ((mCurrentFunction==null&&mFunctions.length>0)||(mCurrentFunction!=null && mCurrentFunction(aDt)))
			{
				mCurrentFunction = null;
				if (mFunctions.length > 0)
				{
					mCurrentFunction = mFunctions.shift();
					execute = mInstant.shift();
				}
			}
		}
		while (execute);
		
	}
	public function addIf(aCondition:Function, aDo:Function,aInstant:Bool=false):Void
	{
		mCondition.push(aCondition);
		addFunction(_if, true);
		addFunction(aDo, aInstant);
	}
	public function addIfelse(aCondition:Function, aDo:Function,aElse:Function,aInstant:Bool=false,aInstantElse:Bool=false):Void
	{
		mCondition.push(aCondition);
		addFunction(_if_else, true);
		addFunction(aDo, aInstant);
		addFunction(aElse, aInstantElse);
	}
	public function addWait(time:Float,breakCond:Function=null):Void
	{
		if (breakCond == null)
		{
		mWaitTimes.push(time);
		addFunction(wait);
		}else {
			mWaitTimes.push(time);
			mCondition.push(breakCond);
			addFunction(waitBrak);
		}
	}
	private function _if(aDt:Float):Bool
	{
		if (mCondition[0](aDt))
		{
			mCondition.shift();
			return true;
		}
		mCondition.shift();
		mFunctions.shift();//delete if
		mInstant.shift();
		return true;
	}
	private function _if_else(aDt:Float):Bool
	{
		if (mCondition[0](aDt))
		{
			mCondition.shift();
			mFunctions.splice(1, 1);//delete else
			mInstant.splice(1, 1);
			return true;
		}
		mCondition.shift();
		mFunctions.shift();//delete if 
		mInstant.shift();
		return true;
	}
	private function waitBrak(aDt:Float):Bool
	{
		mWaitTimes[0] -= aDt;
		if (mWaitTimes[0] <= 0||mCondition[0](aDt))
		{
			mWaitTimes.shift();
			mCondition.shift();
			return true;
		}
		return false;
	}
	private function wait(aDt:Float):Bool
	{
		mWaitTimes[0] -= aDt;
		if (mWaitTimes[0] <= 0)
		{
			mWaitTimes.shift();
			return true;
		}
		return false;
	}
	
	public function dispose():Void 
	{
		HelpFunction.clear(mWaitTimes);
		HelpFunction.clear(mFunctions);
		HelpFunction.clear(mDoForFunctions);
		HelpFunction.clear(mCondition);
		HelpFunction.clear(mAnyFunctions);
		mCurrentFunction = null;
	}
	
	public function flush():Void 
	{
		HelpFunction.clear(mFunctions);
		HelpFunction.clear(mWaitTimes);
		HelpFunction.clear(mDoForFunctions);
		HelpFunction.clear(mInstant);
		HelpFunction.clear(mCondition);
		HelpFunction.clear(mAnyFunctions);
		mCurrentFunction=null;
	}
	
	public function active():Bool
	{
		return mFunctions.length > 0;
	}
	
	
}

