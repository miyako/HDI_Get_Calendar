//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($windowRef : Integer; $OAuth2 : Object)

// Gets all the calendars from the server
var $calendars:=GetCalendars_Office($windowRef; $OAuth2)
// Gets the events of the default calendar
GetEvents_Office($windowRef; $OAuth2; $calendars)

