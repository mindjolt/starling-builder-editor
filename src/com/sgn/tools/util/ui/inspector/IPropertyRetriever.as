/**
 * Created by hyh on 5/15/15.
 */
package com.sgn.tools.util.ui.inspector
{
    public interface IPropertyRetriever
    {
        function set(name:String, value:Object):void;

        function get(name:String):Object;

        function get target():Object;
    }
}
