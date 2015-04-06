package utils;

/**
 * ...
 * @author Joaquin
 */
class HelpFunction
{

	public function new() 
	{
		
	}
	public static function clear(arr:Array<Dynamic>){
        #if (cpp||php)
           arr.splice(0,arr.length);           
        #else
           untyped arr.length = 0;
        #end
    }
	
}