var $name:="GoogleWorker"

OBJECT SET VISIBLE:C603(*; "SpinnerGoogle"; True:C214)

// 認証を開始します
CALL WORKER:C1389($name; Formula:C1597(Provider:=cs:C1710.GmailProvider.new($1)); Current form window:C827)

