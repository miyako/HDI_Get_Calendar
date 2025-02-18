//%attributes = {}
#DECLARE : Variant

If (String:C10(This:C1470.displayDate)#"")
	
	If (This:C1470.displayDate=Current date:C33)
		return "#d72631"
	Else 
		return Background color none:K23:10
	End if 
	
Else 
	return Background color none:K23:10
	
End if 
