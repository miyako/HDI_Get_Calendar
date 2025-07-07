//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($windowRef : Integer; $OAuth2 : Object; $calendars : Collection)

var $calendar : Object:=cs:C1710.NetKit.Office365.new($OAuth2).calendar
var $myEvent; $myCalendar; $eventsTmp : Object
var $defaultColor:="lightBlue"

// 使用する日付の範囲を計算します (本日より1週間)
var $startDate:=String:C10(Current date:C33(); ISO date GMT:K1:10; ?00:00:00?)
var $endDate:=String:C10((Current date:C33()+7); ISO date GMT:K1:10; ?23:59:59?)

// 表示するイベントのコレクション
var $events:=[]

// 選択されているカレンダーを検索します
For each ($myCalendar; $calendars)
	
	If (Bool:C1537($myCalendar.isSelected))
		
		// 選択されているカレンダーのイベントをすべて取得します
		var $timeZone : Object
		$timeZone:=$calendar.getEvents({top: 1; caldendarId: $myCalendar.id; select: "originalStartTimeZone,id"; startDateTime: $startDate; endDateTime: $endDate})
		If (($timeZone.success=False:C215) || ($timeZone.events.length=0))
			continue
		End if 
		
		// 取得するイベントプロパティを指定することもできます　select: "start,end,id,isAllDay,subject,recurrence,categories,showAs";
		$eventsTmp:=$calendar.getEvents({calendarId: $myCalendar.id; top: 100; orderBy: "start/dateTime"; startDateTime: $startDate; endDateTime: $endDate; timeZone: $timeZone.events[0].originalStartTimeZone})
		If ($eventsTmp.success=True:C214)
			var $last:=False:C215
			Repeat 
				// カレンダーの背景色をイベントコレクションにコピーします
				$eventsTmp.events.map(Formula:C1597($1.value.calendarColor:=$myCalendar.hexColor || $defaultColor))
				
				// 取得したイベントをイベントリストに追加します
				$events.combine($eventsTmp.events)
				
				/// すべてのイベントを取得したか確認します
				If ($eventsTmp.isLastPage)
					$last:=True:C214
				Else 
					// 必要に応じて次のイベントを取得します
					$eventsTmp.next()
				End if 
			Until ($last)
		End if 
	End if 
End for each 

$events:=$events.orderBy("start.dateTime asc")

var $code; $subject : Text
$code:="<!--#4dtext $1-->"

// すべてのイベントを解析して、日付と時刻の属性を計算します

For each ($myEvent; $events)
	
	$myEvent.start.date:=Date:C102($myEvent.start.dateTime)
	$myEvent.start.time:=Time:C179($myEvent.start.dateTime)
	$myEvent.end.date:=Date:C102($myEvent.end.dateTime)
	$myEvent.end.time:=Time:C179($myEvent.end.dateTime)
	
	PROCESS 4D TAGS:C816($code; $subject; $myEvent.subject)
	
	$myEvent.label:="<span style=\"font-weight:bold\">"+$subject+"</span>\n"+\
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


