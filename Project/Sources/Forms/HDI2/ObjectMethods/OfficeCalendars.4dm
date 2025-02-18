If (FORM Event:C1606.code=On Data Change:K2:15)
	var $name:="OfficeWorker"
	OBJECT SET VISIBLE:C603(*; "SpinnerMicrosoft"; True:C214)
	CALL WORKER:C1389($name; Formula:C1597(GetEvents_Office($1; Provider.OAuth2; $2)); Current form window:C827; Form:C1466.officeCalendars)
End if 