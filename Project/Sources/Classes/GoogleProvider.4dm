property windowRef : Integer
property OAuth2 : cs:C1710.NetKit.OAuth2Provider

Class constructor($windowRef : Integer)
	
	This:C1470.windowRef:=$windowRef
	
	var $myCredentials:=ds:C1482.Credentials.get(1)
	var $credential:={}
	
	$credential.name:="Google"
	$credential.permission:="signedIn"
	$credential.clientId:=$myCredentials.ClientID
	$credential.clientSecret:=$myCredentials.ClientSecret
	$credential.redirectURI:="http://127.0.0.1:50993/authorize/"
	$credential.authenticationPage:=Folder:C1567(fk web root folder:K87:15).file("authenticate/authentication.htm")
	$credential.authenticationErrorPage:=Folder:C1567(fk web root folder:K87:15).file("authenticate/error.htm")
	$credential.scope:="https://www.googleapis.com/auth/calendar"
	
	$credential.prompt:="select_account"
	
	$credential.timeout:=120
	
	This:C1470.OAuth2:=cs:C1710.NetKit.OAuth2Provider.new($credential)
	This:C1470._UpdateFormContext()
	
	This:C1470.getToken()
	
	// *******************************************************************
Function getToken()
	
	If (Try(This:C1470.OAuth2.getToken())#Null:C1517)
		This:C1470._UpdateFormContext()
	End if 
	
	// 表示を処理するためのメソッドを呼び出します
	OntokenreceivedFromGoogle(This:C1470.windowRef; This:C1470.OAuth2)
	
	// 更新されたトークンを持つ OAuth2Provider をメインプロセスに保存します
Function _UpdateFormContext()
	
	CALL FORM:C1391(This:C1470.windowRef; Formula:C1597(Form:C1466.OAuth2OfficeProvider:=$1); This:C1470.OAuth2)
	