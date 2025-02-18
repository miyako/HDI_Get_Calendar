//%attributes = {"preemptive":"capable"}
#DECLARE($windowRef : Integer; $OAuth2 : Object)

var $name:="OfficeWorker"

// Gets all the calendars from the server
var $calendars:=GetCalendars_Office($windowRef; $OAuth2)
// Gets the events of the default calendar
GetEvents_Office($windowRef; $OAuth2; $calendars)

