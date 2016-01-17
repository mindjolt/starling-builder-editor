/**
 * Created by hyh on 1/15/16.
 */
package starlingbuilder.editor.citestcase
{
    import org.flexunit.asserts.assertEquals;

    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.editor.UIEditorApp;

    public class LocalizationTest extends AbstractTest
    {
        public function LocalizationTest()
        {
        }

        public static const LOCALIZE:Array = [
            function():void{
                documentManager.clear();
                selectTab("text");
                selectList(0);
            },

            function():void{
                selectTab("custom");
                changeInspectorProperty({localizeKey:"hello"});
            },

            function():void{
                UIEditorApp.instance.localizationManager.onLocale(new Event("en_US"));
                var textField:TextField = selectedObject as TextField;
                assertEquals(textField.text, "hello");
            },

            function():void{
                UIEditorApp.instance.localizationManager.onLocale(new Event("es_ES"));
                var textField:TextField = selectedObject as TextField;
                assertEquals(textField.text, "hola");
            },

        ]
    }
}
