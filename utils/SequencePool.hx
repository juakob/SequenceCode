package utils;
import utils.SequenceCode.Function;

/**
 * ...
 * @author Joaquin
 */

class SequencePool
{
	private var mPool:Array<SequenceCode>;
	private var mCurrentSequence:SequenceCode;
	
	public function new() 
	{
		mPool = new Array();
	}
	public function startPool():Void
	{
		for (sequence in mPool) 
		{
			if (!sequence.active())
			{
				mCurrentSequence = sequence;
				break;
			}
		}
		if (mCurrentSequence == null)
		{
			mCurrentSequence = new SequenceCode();
			mPool.push(mCurrentSequence);
		}
	}
	public function endPool():Void
	{
		mCurrentSequence = null;
	}
	public function update(aDt:Float):Void
	{
		for (sequence in mPool) 
		{
			sequence.update(aDt);
		}
	}
	
	public function addIfelse(aCondition:Function, aDo:Function, aElse:Function, aInstant:Bool = false, aInstantElse:Bool = false):Void
	{
		mCurrentSequence.addIfelse(aCondition, aDo, aElse, aInstant, aInstantElse);
	}
	public function addIf(aCondition:Function, aDo:Function, aInstant:Bool = false):Void
	{
		mCurrentSequence.addIf(aCondition, aDo, aInstant);
	}
	public function addWhile(aWhile:Function, aDo:Function):Void
	{
		mCurrentSequence.addWhile(aWhile, aDo);
	}
	public function addWait(time:Float,breakCond:Function=null):Void
	{
		mCurrentSequence.addWait(time, breakCond);
	}
	public function addDoFor(func:Function, time:Float):Void
	{
		mCurrentSequence.addDoFor(func, time);
	}
	public function addFunction(func:Function, instant:Bool = false):Void
	{
		mCurrentSequence.addFunction(func, instant);
	}
	public function addFunctionSingle(func:Void->Void, instant:Bool = false):Void
	{
		mCurrentSequence.addFunctionSingle(func, instant);
	}
	
	public function flush() 
	{
		for (sequence in mPool) 
		{
			sequence.flush();
		}
	}
}