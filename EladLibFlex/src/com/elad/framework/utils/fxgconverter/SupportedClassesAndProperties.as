package com.elad.framework.utils.fxgconverter
{
	import mx.controls.Label;
	import mx.graphics.LinearGradient;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	
	import spark.components.Group;
	import spark.components.RichText;
	import spark.primitives.BitmapImage;
	import spark.primitives.Ellipse;
	import spark.primitives.Graphic;
	import spark.primitives.Line;
	import spark.primitives.Path;
	import spark.primitives.Rect;
	import spark.primitives.RectangularDropShadow;

	/**
	 * Class to handle setting the component class and properties for the FXG to String converter.
	 * 
	 * @see com.elad.framework.utils.fxgconverter.FXGStringConverter
	 * 
	 * @author Elad Elrom
	 * 
	 */	
	public final class SupportedClassesAndProperties
	{
		/**
		 * Lookup for the FXG component based on the string given
		 *  
		 * @param componentType	return a wild card since we are not sure of the type of component
		 * @param debug flag to show messages in the console
		 * @return 
		 * 
		 */	
		public static function settingComponentClass( componentType:String, debug:Boolean = false ):*
		{
			var retComponent:*;
			
			switch ( componentType )
			{
				case "Group":
					retComponent = new Group();
					break;
				case "Path":
					retComponent = new Path();
					break;				
				case "Line":
					retComponent = new Line();
					break;
				case "Rect":
					retComponent = new Rect();
					break;				
				case "Ellipse":
					retComponent = new Ellipse();
					break;
				case "Graphic":
					retComponent = new Graphic();
					break;
				case "RectangularDropShadow":
					retComponent = new RectangularDropShadow();
					break;
				case "BitmapImage":
					retComponent = new BitmapImage();
					break;				
				case "SolidColor":
					retComponent = new SolidColor();
					break;
				case "SolidColorStroke":
					retComponent = new SolidColorStroke();
					break;
				case "RichText":
					retComponent = new RichText();
					break;
				case "SimpleText" || "Label":
					retComponent = new Label();
					break;
				case "LinearGradient":
					retComponent = new LinearGradient();
					break;				
				case "strok" || "fil":
					// ignore
					break;
				default:
					if ( debug )
						trace( "WARNING: FAIL: Couldn't parse component: " + componentType );
					break;
			}
			
			return retComponent;
		}
		
		/**
		 * Method to go through the componenent properties and set the componennt with all the properties
		 *  
		 * @param splitSingleComponent	that's an array of the component containing all the properties 
		 * @param component	returns a wild card since we are not sure of the component type
		 * @return 
		 * 
		 */		
		public static function settingComponentProperties( splitSingleComponent:Array, component:*, debug:Boolean = false ):*
		{
			var len:int = splitSingleComponent.length;
			var propoerty:String;
			var value:String;
			
			for ( var i:int = 1; i < len; i++ )
			{
				var propVal:Array = (splitSingleComponent[i] as String).split( "=" );
				propoerty = propVal[0];
				value = (propVal[1] as String).replace( '"', "").replace( '"', "");
				
				// handle the data property
				if ( value == (propVal[1] as String).replace( '"', "") )
				{
					for (var ii:int = i+1; ii<len; ii++)
					{
						var stringToAdd:String = (splitSingleComponent[ii] as String);
						var valCheckLen:int = stringToAdd.length;
						var valCheck:String = stringToAdd.substr( valCheckLen-1, valCheckLen );
						
						stringToAdd = stringToAdd.replace( '"', "");
						value += " " + stringToAdd;						
						
						if ( valCheck == '"' )
						{
							i = ii;
							break;
						}
					}
				}
				
				// use case for color
				if ( propoerty == "color" )
					value = value.replace("#", "0x");
				
				// css properties
				if ( propoerty == "fontWeight" || propoerty == "fontSize" || propoerty == "tabStops" || 
					propoerty == "textDecoration" || propoerty == "fontFamily" || propoerty == "textDecoration"
					|| ( propoerty == "color" && (component is RichText || component is Label) ) )
				{
					component.setStyle( propoerty, value );					
				}
				else // properties
				{
					try {
						component[propoerty] = value;
					}
					catch (error:Error) {
						trace( "WARNING: Couldn't parse property " + propoerty );
					}
				}
			}
			
			return component;
		}
	}
}