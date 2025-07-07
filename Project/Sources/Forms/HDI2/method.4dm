Case of 
	: (Form event code:C388=On Load:K2:1)
		
		InitInfo
		Init
		
	: (Form event code:C388=On Close Box:K2:21)
		
		CANCEL:C270
		
	: (Form event code:C388=On Unload:K2:2)
		If (Is Windows:C1573 && Application info:C1599().SDIMode)
			INVOKE ACTION:C1439(ak return to design mode:K76:62)
		End if 
		
End case 