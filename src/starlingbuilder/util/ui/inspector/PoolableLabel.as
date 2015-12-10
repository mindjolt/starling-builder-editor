/**
 * Created by hyh on 11/23/15.
 */
package starlingbuilder.util.ui.inspector
{
    import starlingbuilder.util.pool.IPoolable;

    import feathers.controls.Label;

    public class PoolableLabel extends Label implements IPoolable
    {
        public function init(args:Array):void
        {
            text = args[0];
        }

        public function recycle():void
        {

        }

    }
}
