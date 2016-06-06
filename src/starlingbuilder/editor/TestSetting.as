/**
 * Created by hyh on 6/5/16.
 */
package starlingbuilder.editor
{
    public class TestSetting
    {
        public static const FIT_ALL:String = "fitAll";

        public static const PARAMS:Array = [
            {name:"deviceWidth"},
            {name:"deviceHeight"},
            {name:"fitStrategy", component:"pickerList", options:[FIT_ALL]}
                ]

        public var deviceWidth:int;

        public var deviceHeight:int;

        public var fitStrategy:String = FIT_ALL;
    }
}
