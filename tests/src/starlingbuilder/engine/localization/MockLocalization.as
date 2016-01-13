/**
 * Created by hyh on 1/13/16.
 */
package starlingbuilder.engine.localization
{
    import org.mock4as.Mock;

    public class MockLocalization extends Mock implements ILocalization
    {
        private var _locale:String = null;

        public function MockLocalization()
        {
            super();
        }

        public function getLocalizedText(key:String):String
        {
            record("getLocalizedText", key);
            return expectedReturnFor();
        }

        public function getLocales():Array
        {
            record("getLocales");
            return expectedReturnFor();
        }

        public function getKeys():Array
        {
            record("getKeys");
            return expectedReturnFor();
        }

        public function get locale():String
        {
            return _locale;
        }

        public function set locale(value:String):void
        {
            _locale = value;
        }
    }
}
