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
                {label:"iPhone4 (640 x 960)", value:"640,960"},
                {label:"iPhone5 (640 x 1136)", value:"640,1136"},
                {label:"iPhone6 (750 x 1334)", value:"750,1334"},
                {label:"iPhone6+ (1080 x 1920)", value:"1080,1920"},
                {label:"iPad 2 (768 x 1024)", value:"768,1024"},
                {label:"iPad Air (1536 x 2048)", value:"1536,2048"},
                {label:"Nexus 6 (1440 x 2560)", value:"1440,2560"}
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
