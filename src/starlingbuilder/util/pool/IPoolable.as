/**
 * Created by hyh on 11/23/15.
 */
package starlingbuilder.util.pool
{
    public interface IPoolable
    {
        /**
         *  Called when the object checks out from pool
         * @param args
         */
        function init(args:Array):void;

        /**
         *  Called when the object returns to pool
         */
        function recycle():void

        /**
         *  Called when the object disposes
         */
        function dispose():void
    }
}