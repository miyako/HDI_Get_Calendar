//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($windowRef : Integer; $OAuth2 : Object)

// サーバーからすべてのカレンダーを取得します
var $calendars:=GetCalendars_Google($windowRef; $OAuth2)
// デフォルトカレンダーのすべてのイベントを取得します
GetEvents_Google($windowRef; $OAuth2; $calendars)
