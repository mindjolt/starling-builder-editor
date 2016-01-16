/**
 * Created by hyh on 1/14/16.
 */
package starlingbuilder.engine.localization
{
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertNull;

    public class DefaultLocalizationTest
    {
        private static const data:Object = {
            "hello":{"en_US":"hello", "de_DE":"hallo", "es_ES":"hola", "fr_FR":"bonjour"},
            "world":{"en_US":"world", "de_DE":"wereld", "es_ES":"mundo", "fr_FR":"monde"}
        }

        private var _localization:DefaultLocalization;

        public function DefaultLocalizationTest()
        {

        }

        [Before]
        public function setup():void
        {
            _localization = new DefaultLocalization(data, "es_ES");
        }

        [Test]
        public function shouldReturnLocalizedText():void
        {
            assertEquals(_localization.getLocalizedText("hello"), "hola");
            assertNull(_localization.getLocalizedText("nothing"));
        }

        [Test]
        public function shouldReturnLocales():void
        {
            var locales:Array = _localization.getLocales();
            assertEquals(locales.length, 4);
        }

        [Test]
        public function shouldReturnKeys():void
        {
            var keys:Array = _localization.getKeys();
            assertEquals(keys.length, 2);
        }

        [Test]
        public function shouldNotReturnLocalizedText():void
        {
            _localization.locale = null;
            assertNull(_localization.getLocalizedText("hello"));
            _localization.locale = "N/A";
            assertNull(_localization.getLocalizedText("hello"));
        }
    }
}
