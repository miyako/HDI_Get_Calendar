//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($windowRef : Integer; $OAuth2 : Object) : Collection

var $calendar : Object:=cs:C1710.NetKit.Google.new($OAuth2).calendar
var $item : Object

// Gets all the calendars 
var $calendars : Collection
$calendars:=$calendar.getCalendars().calendars

// Add selected information on each calendar
// By default the default calendar is selected
For each ($item; $calendars)
	$item.isSelected:=Bool:C1537($item.primary)
End for each 

CALL FORM:C1391($windowRef; Formula:C1597(Form:C1466.googleCalendars:=$1); $calendars)
return $calendars