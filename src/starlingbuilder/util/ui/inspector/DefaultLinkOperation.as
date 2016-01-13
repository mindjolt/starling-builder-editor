/**
 * Created by hyh on 1/10/16.
 */
package starlingbuilder.util.ui.inspector
{
    import starling.display.DisplayObject;

    public class DefaultLinkOperation implements ILinkOperation
    {
        public function update(target:Object, changedPropertyName:String, propertyName:String):void
        {
            //rule for locking width/height ratio
            if (shouldUpdate(target))
            {
                if (changedPropertyName == "width" && propertyName == "height")
                {
                    target["scaleY"] = target["scaleX"];
                }
                else if (changedPropertyName == "height" && propertyName == "width")
                {
                    target["scaleX"] = target["scaleY"];
                }
            }
        }

        private function shouldUpdate(target:Object):Boolean
        {
            //special case for rotation/size race condition
            return target is DisplayObject && target.rotation == 0;
        }
    }
}
