/**
 * Created by hyh on 1/15/16.
 */
package starlingbuilder.editor.citestutil
{
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;

    import starlingbuilder.editor.CITestUtil;

    public function findDisplayObject(options:Object, container:DisplayObjectContainer = null):DisplayObject
    {
        return CITestUtil.findDisplayObject(options, container);
    }
}
