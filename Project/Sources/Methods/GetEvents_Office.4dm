//%attributes = {"preemptive":"capable"}
#DECLARE($windowRef : Integer; $OAuth2 : Object; $calendars : Collection)

var $calendar : Object:=cs:C1710.NetKit.Office365.new($OAuth2).calendar
var $myEvent; $myCalendar; $eventsTmp : Object
var $defaultColor:="lightBlue"

// calculates the date range to be used
var $startDate:=String:C10(Current date:C33(); ISO date GMT:K1:10; ?00:00:00?)
var $endDate:=String:C10((Current date:C33()+7); ISO date GMT:K1:10; ?23:59:59?)

// Collection of all the events to display
var $events:=[]

// search which calendars is selected
For each ($myCalendar; $calendars)
	
	If (Bool:C1537($myCalendar.isSelected))
		
		// Gets all the event of the selected calendars
		var $timeZone:=$calendar.getEvents({top: 1; caldendarId: $myCalendar.id; select: "originalStartTimeZone,id"; startDateTime: $startDate; endDateTime: $endDate})
		If (($timeZone.success=False:C215) || ($timeZone.events.length=0))
			continue
		End if 
		
		// select: "start,end,id,isAllDay,subject,recurrence,categories,showAs";
		$eventsTmp:=$calendar.getEvents({calendarId: $myCalendar.id; top: 100; orderBy: "start/dateTime"; startDateTime: $startDate; endDateTime: $endDate; timeZone: $timeZone.events[0].originalStartTimeZone})
		If ($eventsTmp.success=True:C214)
			var $last:=False:C215
			Repeat 
				// Copy the calendar color background in the event collection
				$eventsTmp.events.map(Formula:C1597($1.value.calendarColor:=$myCalendar.hexColor || $defaultColor))
				
				// Add the events received to the events list
				$events.combine($eventsTmp.events)
				
				// Check if all events are retrieved
				If ($eventsTmp.isLastPage)
					$last:=True:C214
				Else 
					$eventsTmp.next()
				End if 
			Until ($last)
		End if 
	End if 
End for each 

$events:=$events.orderBy("start.dateTime asc")

For each ($myEvent; $events)
	
	$myEvent.start.date:=Date:C102($myEvent.start.dateTime)
	$myEvent.start.time:=Time:C179($myEvent.start.dateTime)
	$myEvent.end.date:=Date:C102($myEvent.start.dateTime)
	$myEvent.end.time:=Time:C179($myEvent.start.dateTime)
	
	$myEvent.label:="<span style=\"font-weight:bold\">"+$myEvent.subject+"</span>\n"+\
		($myEvent.isAllDay ? "Full day" : String:C10(Time:C179($myEvent.start.time); HH MM:K7:2)+"-"+String:C10(Time:C179($myEvent.end.time); HH MM:K7:2))+\
		"\n"+String:C10($myEvent.showAs)
	
End for each 

var $dateTmp : Date
For each ($myEvent; $events)
	$myEvent.displayDate:=$dateTmp=$myEvent.start.date ? "" : $myEvent.start.date
	$dateTmp:=$myEvent.start.date
End for each 


CALL FORM:C1391($windowRef; Formula:C1597(Form:C1466.officeEvents:=$1); $events)
CALL FORM:C1391($windowRef; Formula:C1597(OBJECT SET VISIBLE:C603(*; "SpinnerMicrosoft"; False:C215)))


