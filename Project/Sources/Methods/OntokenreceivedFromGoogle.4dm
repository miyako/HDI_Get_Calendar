//%attributes = {"preemptive":"capable"}
#DECLARE($windowRef : Integer; $OAuth2 : Object)

// Gets all the calendars from the server
var $calendars:=GetCalendars_Google($windowRef; $OAuth2)
// Gets the events of the default calendar
GetEvents_Google($windowRef; $OAuth2; $calendars)
