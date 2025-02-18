//%attributes = {"preemptive":"capable"}
#DECLARE($windowRef : Integer; $OAuth2 : Object; $calendars : Collection)

var $calendar : Object:=cs:C1710.NetKit.Google.new($OAuth2).calendar
var $myEvent; $myCalendar; $eventsTmp : Object

// calculates the date range to be used (one week from the current date)
var $startDate:=String:C10(Current date:C33(); ISO date GMT:K1:10; ?00:00:00?)
var $endDate:=String:C10((Current date:C33()+7); ISO date GMT:K1:10; ?23:59:59?)

// Collection of all the events to display
var $events:=[]

// search which calendars is selected
For each ($myCalendar; $calendars)
	
	If (Bool:C1537($myCalendar.isSelected))
		
		// Gets all the event of the selected calendars
		$eventsTmp:=$calendar.getEvents({calendarId: $myCalendar.id; top: 100; singleEvents: True:C214; startDateTime: $startDate; endDateTime: $endDate; timeZone: $myCalendar.timeZone})
		If (($eventsTmp.success=True:C214) && ($eventsTmp.events.length>0))
			var $last:=False:C215
			Repeat 
				// Copy the calendar color background in the event collection
				$eventsTmp.events.map(Formula:C1597($1.value.calendarColor:=$myCalendar.backgroundColor || Background color none:K23:10))
				
				// Add the events received to the events list
				$events.combine($eventsTmp.events)
				
				// Check if all events are retrieved
				If ($eventsTmp.isLastPage)
					$last:=True:C214
				Else 
					// Gets the next event if necessary
					$eventsTmp.next()
				End if 
			Until ($last)
		End if 
	End if 
End for each 

// Parses all the events to calculate the date and time attributes
For each ($myEvent; $events)
	If ($myEvent.status#"cancelled")
		If (String:C10($myEvent.start.date)="")
			
			$myEvent.isAllDay:=False:C215
			$myEvent.start.date:=Date:C102($myEvent.start.dateTime)
			$myEvent.start.time:=Time:C179($myEvent.start.dateTime)
			$myEvent.end.date:=Date:C102($myEvent.end.dateTime)
			$myEvent.end.time:=Time:C179($myEvent.end.dateTime)
			
		Else 
			
			$myEvent.isAllDay:=True:C214
			$myEvent.isPeriod:=($myEvent.start.date#$myEvent.end.date)
			$myEvent.start.date:=Date:C102($myEvent.start.date+"T00:00:00.0000")
			$myEvent.start.time:=?00:00:00?
			$myEvent.end.date:=Date:C102($myEvent.end.date+"T00:00:00.0000")
			$myEvent.end.time:=?00:00:00?
			
		End if 
		
		$myEvent.label:="<span style=\"font-weight:bold\">"+$myEvent.summary+"</span>\n"
		$myEvent.label+=($myEvent.isAllDay ? ($myEvent.isPeriod ? String:C10($myEvent.end.date) : "Full day") : String:C10(Time:C179($myEvent.start.time); HH MM:K7:2)+"-"+String:C10(Time:C179($myEvent.end.time); HH MM:K7:2))
		$myEvent.label+="\n"+(($myEvent.transparency=Null:C1517) || ($myEvent.transparency="opaque") ? "Busy" : "Free")
	End if 
	
End for each 

$events:=$events.orderBy("start.date asc,start.time asc")
var $dateTmp : Date
For each ($myEvent; $events)
	$myEvent.displayDate:=$dateTmp=$myEvent.start.date ? "" : $myEvent.start.date
	$dateTmp:=$myEvent.start.date
End for each 


CALL FORM:C1391($windowRef; Formula:C1597(Form:C1466.googleEvents:=$1); $events)
CALL FORM:C1391($windowRef; Formula:C1597(OBJECT SET VISIBLE:C603(*; "SpinnerGoogle"; False:C215)))


