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
            {name:"preset", component:"pickerList", options:[
                {label:"N/A", value:""},
                {label:"iPhone4", value:"640,960"},
                {label:"iPhone5", value:"640,1136"},
                {label:"iPhone6", value:"750,1334"},
                {label:"iPhone6+", value:"1080,1920"},
                {label:"iPad", value:"768,1024"},
                {label:"iPad Air", value:"1536,2048"}
            ]},
            {name:"rotated", component:"check"},
            {name:"fitStrategy", component:"pickerList", options:[FIT_ALL]}
                ];

        public var deviceWidth:int;

        public var deviceHeight:int;

        public var preset:String = "";

        public var rotated:Boolean = false;

        public var fitStrategy:String = FIT_ALL;
    }
}
