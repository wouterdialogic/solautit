#include <File.au3>
#include <MsgBoxConstants.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>


;Local $bFileInstall = True ; Change to True and ammend the file paths accordingly.

; This will install the file C:\Test.bmp to the script location.';If $bFileInstall Then FileInstall("C:\sqlite3.dll", @ScriptDir & "\sqlite3.dll")


Func SQLite_Startup()
	_SQLite_Startup()
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "SQLite Error", "SQLite3.dll Can't be Loaded!")
		Exit -1
	EndIf
	ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)

EndFunc   ;==>_SQLite_Startup

Func SQLite_Open()
	;Local $sDbName = _TempFile()
	Local $sDbName = "autoit_db.sqlite"
	Local $hDskDb = _SQLite_Open($sDbName) ; Open a permanent disk database
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "SQLite Error", "Can't open or create a permanent Database!")
		Exit -1
	EndIf

EndFunc   ;==>_SQLite_Startup

Func SQLite_write()
	Local $hQuery, $aRow, $sMsg
	;_SQLite_Startup()
	ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
	;_SQLite_Open() ; open :memory: Database
	_SQLite_Exec(-1, "CREATE TABLE aTest (a,b,c);") ; CREATE a Table
	_SQLite_Exec(-1, "INSERT INTO aTest(a,b,c) VALUES ('c','2','World');") ; INSERT Data
	_SQLite_Exec(-1, "INSERT INTO aTest(a,b,c) VALUES ('b','3',' ');") ; INSERT Data
	_SQLite_Exec(-1, "INSERT INTO aTest(a,b,c) VALUES ('a','1','Hello');") ; INSERT Data
	_SQLite_Query(-1, "SELECT c FROM aTest ORDER BY a;", $hQuery) ; the query
	While _SQLite_FetchData($hQuery, $aRow) = $SQLITE_OK
		$sMsg &= $aRow[0]
	WEnd
	;_SQLite_Exec(-1, "DROP TABLE aTest;") ; Remove the table
	MsgBox($MB_SYSTEMMODAL, "SQLite", "Get Data using a Query : " & $sMsg)
	_SQLite_Close()
	_SQLite_Shutdown()

	EndFunc

doSomeDatabasing()
Func doSomeDatabasing()
	SQLite_Startup()
	SQLite_Open()
	SQLite_write()
EndFunc

