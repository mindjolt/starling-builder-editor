/**
 * Created by hyh on 1/3/16.
 */
package starlingbuilder.editor
{
    import org.flexunit.asserts.assertEquals;

    public class UIEditorScreenCI extends UIEditorScreen
    {
        public function UIEditorScreenCI()
        {
            super();
        }

        override protected function initTests():void
        {
            trace("TestCI");
            assertEquals(2, 2);
        }
    }
}
