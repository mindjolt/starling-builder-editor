/**
 * Created by hyh on 1/15/16.
 */
package starlingbuilder.editor.citestutil
{
    import starling.display.DisplayObject;
    import starlingbuilder.editor.CITestUtil;

    public function simulateTouch(target:DisplayObject, offsetX:Number = 0, offsetY:Number = 0, dx:Number = 0, dy:Number = 0):void
    {
        CITestUtil.simulateTouch(target, offsetX, offsetY, dx, dy);
    }

}
