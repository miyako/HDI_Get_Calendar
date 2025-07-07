//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($windowRef : Integer; $OAuth2 : Object)

// サーバーからすべてのカレンダーを取得します
var $calendars:=GetCalendars_Office($windowRef; $OAuth2)
// デフォルトカレンダーのすべてのイベントを取得します
GetEvents_Office($windowRef; $OAuth2; $calendars)

