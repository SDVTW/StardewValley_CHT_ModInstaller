# ================================================================================================================================================
# 載入需要的 nsh 檔
# ================================================================================================================================================

!include	"MUI2.nsh"		# 現代風格安裝程式
!include	"x64.nsh"		# 處理 64 位元系統安裝時的一些問題
!include	"WordFunc.nsh"	# 用來比對版本號碼
!include	"nsProcess.nsh"	# 判斷遊戲是否正在執行
#!include	"nsResize.nsh"	# 調整安裝程式大小

# ================================================================================================================================================
# 定義資訊
# ================================================================================================================================================

# === 基本資訊 ===
!define	APPNAME			"《星露谷物語》正體中文模組"	# 名稱
!define	CompanyName		"公司名"						# 公司名
!define	LegalCopyright	"著作權"						# 著作權
!define	Description		"《星露谷物語》正體中文模組"	# 檔案描述
!define	Version			"1.0.0.0"						# 檔案版本，一定要四位數（X.X.X.X）
!define	ProdVer			"1.0.0.0"						# 產品版本，寫什麼都可以
!define	WEBSITE			"https://vhlqg.github.io/"		# 相關網址

# === 相關檔案位置 ===
!define	Icon			"assets\Images\Icon.ico"		# 安裝圖示
!define	UIcon			"assets\Images\Icon.ico"		# 解除安裝圖示
!define	Welcome			"assets\Images\welcome.bmp"		# 安裝程式的圖片
!define	License			"assets\License\License.txt"	# 授權條款

# === 其他 ===
!define	BackupFile		"SDV_CHT_MOD_BACKUP" 			# 備份檔名稱
!define	Uninstaller		"解除安裝${APPNAME}"			# 解除安裝程式名稱

# === 遊戲 ID ===
# GOG 和 STEAM 遊戲 ID（偵測路徑用）
!define	GOGID			"1453375253"	# GOG
!define	STEAMID			"413150"		# Steam

# ================================================================================================================================================
# 安裝程式的名稱和輸出位置
# ================================================================================================================================================

Name		"${APPNAME}"						# 安裝程式的名稱
OutFile		"${APPNAME}_v${ProdVer}.exe"		# 輸出檔案的名稱和位置

# ================================================================================================================================================
# 設定版本資訊
# ================================================================================================================================================

# 基本上不用改，1028 是台灣正體的編號
VIProductVersion	"${Version}"
VIFileVersion		"${Version}"
VIAddVersionKey	/LANG=1028	"ProductName"		"${APPNAME}"
VIAddVersionKey	/LANG=1028	"CompanyName"		"${CompanyName}"
VIAddVersionKey	/LANG=1028	"LegalCopyright"	"${LegalCopyright}"
VIAddVersionKey	/LANG=1028	"FileDescription"	"${Description}"
VIAddVersionKey	/LANG=1028	"FileVersion"		"${Version}"
VIAddVersionKey	/LANG=1028	"ProductVersion"	"${ProdVer}"

# ================================================================================================================================================
# 基本設定
# ================================================================================================================================================

Unicode					true		# 使用 Unicode
AllowRootDirInstall		true		# 允許安裝在根目錄
ManifestDPIAware		true		# 設為 DPI aware，避免不同的 DPI 設定造成文字模糊
SetDateSave				off			# 不記錄檔案修改日期
SetCompressor			lzma		# 使用 lzma 壓縮。很慢，測試時不要開
RequestExecutionLevel	user		# 設定權限

ShowInstDetails			nevershow	# 不顯示詳細安裝資訊
ShowUninstDetails		nevershow	# 不顯示詳細解除安裝資訊

# ================================================================================================================================================
# 頁面設定
# ================================================================================================================================================

BrandingText	"${APPNAME}"	# 左下的文字

!define	MUI_BGCOLOR F2D70C	# 背景顏色

!define	MUI_LICENSEPAGE_RADIOBUTTONS	# 將授權協議的選項改為按鈕樣式

# === 提醒視窗 ===
!define	MUI_ABORTWARNING													# 使用者取消安裝時顯示提醒視窗
!define	MUI_UNABORTWARNING													# 使用者取消解除安裝時顯示提醒視窗
!define	MUI_TEXT_ABORTWARNING	"確定要結束 ${APPNAME} 安裝程式嗎？"		# 提醒視窗的文字
!define	MUI_UNTEXT_ABORTWARNING	"確定要結束 ${APPNAME} 解除安裝程式嗎？"	# 提醒視窗的文字
!define	MUI_ABORTWARNING_CANCEL_DEFAULT										# 提醒視窗預設選擇「取消」
!define	MUI_UNABORTWARNING_CANCEL_DEFAULT									# 提醒視窗預設選擇「取消」

# === 設定安裝程式圖示 ===
!define	MUI_ICON			${Icon}
!define	MUI_UNICON			${UIcon}
!define	APPLICATION_ICON	${Icon}

/* 在不同 DPI 設定下圖片可能無法填滿視窗，改用自訂頁面
# === 安裝頁面的圖片 ===
!define	MUI_WELCOMEFINISHPAGE_BITMAP	${Welcome}				# 設定圖片，預設圖片大小：164x314 px
!define	MUI_WELCOMEFINISHPAGE_BITMAP_STRETCH AspectFitHeight	# 將圖片縮放至適合的高度，只要符合長寬比就能正常顯示。長寬比：538:314。總之放一張 538x314 px 的圖一定能全部顯示就對了（但是如果設為 DPI aware 可能無法填滿視窗）

# === 解除安裝頁面的圖片 ===
!define	MUI_UNWELCOMEFINISHPAGE_BITMAP	${Welcome}
!define	MUI_UNWELCOMEFINISHPAGE_BITMAP_STRETCH AspectFitHeight
*/

# ================================================================================================================================================
# 頁面 Pages
# ================================================================================================================================================

# === 安裝程式頁面 ===
/* 在不同 DPI 設定下圖片可能無法填滿視窗，改用自訂頁面
!insertmacro	MUI_PAGE_WELCOME									# 歡迎頁面
*/
Page			custom	"Welcome"	"WelcomeLeave"					# 自訂頁面（歡迎頁面）
Page			custom	"RepairRemove"	"RepairRemoveLeave"			# 自訂頁面（重新安裝或解除安裝選項頁面）
!define			MUI_PAGE_CUSTOMFUNCTION_PRE	"CheckInst"				# 授權條款頁面設定（載入頁面時）：呼叫 CheckInst 函數檢查是否安裝過模組，有安裝過就不顯示此頁
!insertmacro	MUI_PAGE_LICENSE	"${License}"					# 授權條款頁面

!define			MUI_PAGE_CUSTOMFUNCTION_PRE	"CheckInst"				# 安裝路徑頁面設定（載入頁面時）：呼叫 CheckInst 函數檢查是否安裝過模組，有安裝過就不顯示此頁
!define			MUI_PAGE_CUSTOMFUNCTION_LEAVE	"NoExe"				# 安裝路徑頁面設定（離開頁面時）：呼叫 NoExe 函數詢問是否要安裝在沒有執行檔的路徑
!insertmacro	MUI_PAGE_DIRECTORY									# 安裝路徑頁面

Page			custom	"Fonts"	"FontsLeave"						# 自訂頁面（字型選擇頁面）
#!insertmacro	MUI_PAGE_COMPONENTS									# 選擇安裝元件頁面
!insertmacro	MUI_PAGE_INSTFILES									# 安裝中頁面
Page			custom	"Finish"	"FinishLeave"					# 自訂頁面（結束頁面）

/* 在不同 DPI 設定下圖片可能無法填滿視窗，改用自訂頁面
!define			MUI_PAGE_CUSTOMFUNCTION_LEAVE	"RunGame"			# 結束頁面設定：呼叫 RunGame 函數詢問是否開啟遊戲
!insertmacro	MUI_PAGE_FINISH										# 結束頁面
*/

# === 解除安裝程式頁面 ===
/* 在不同 DPI 設定下圖片可能無法填滿視窗，改用自訂頁面
#!insertmacro	MUI_UNPAGE_WELCOME									# 歡迎頁面
*/
UninstPage		custom	"un.Welcome"	"un.WelcomeLeave"			# 自訂頁面（歡迎頁面）
!define			MUI_PAGE_CUSTOMFUNCTION_LEAVE	"un.CheckProcess"	# 確認頁面設定（離開頁面時）：呼叫 un.CheckProcess 函數確認遊戲是否正在執行
!insertmacro	MUI_UNPAGE_CONFIRM									# 確認頁面
!insertmacro	MUI_UNPAGE_INSTFILES								# 解除安裝中頁面
UninstPage		custom	"un.Finish"									# 自訂頁面（結束頁面）
/* 在不同 DPI 設定下圖片可能無法填滿視窗，改用自訂頁面
!insertmacro	MUI_UNPAGE_FINISH									# 結束頁面
*/

# ================================================================================================================================================
# 安裝程式的語言
# ================================================================================================================================================

!insertmacro	MUI_LANGUAGE	"TradChinese"	# 正體中文

# ================================================================================================================================================
# 內容（安裝用）Installer Sections
# ================================================================================================================================================

# === 一些設定 ===
Section
	SetAutoClose	true		# 安裝完成時自動關閉安裝中頁面（使用自訂頁面才需要設定）
	SetDetailsPrint	none		# 完全隱藏解除安裝資訊
SectionEnd

# === 寫入登錄檔以及建立解除安裝程式 ===
Section
	# 宣告變數，用來儲存選擇的字型。要寫在要用到的地方之前，不然編譯時會有警告
	Var /GLOBAL SelectedFont

	# 寫入登錄檔
	WriteRegStr	HKCU	"Software\${APPNAME}"	"InstallLocation"	"$INSTDIR"			# 安裝路徑
	WriteRegStr	HKCU	"Software\${APPNAME}"	"Version"			"${Version}"		# 版本
	WriteRegStr	HKCU	"Software\${APPNAME}"	"Font"				"$SelectedFont"		# 字型

	WriteUninstaller	"$INSTDIR\${Uninstaller}.exe"	# 建立解除安裝程式
SectionEnd

# === 新增移除程式 Add/Remove Programs ===
Section
	# 定義
	!define	/date	InstallDate	"%Y%m%d"															# 安裝日期
	!define	REGPATH_WINUNINST	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"	# 路徑

	# 寫入相關登錄檔
	WriteRegStr	HKCU	"${REGPATH_WINUNINST}"	"DisplayName"		"${APPNAME} v${Version}"		# 名稱
	WriteRegStr	HKCU	"${REGPATH_WINUNINST}"	"DisplayVersion"	"${Version}"					# 版本
	WriteRegStr	HKCU	"${REGPATH_WINUNINST}"	"DisplayIcon"		"$INSTDIR\${Uninstaller}.exe"	# Icon
	WriteRegStr	HKCU	"${REGPATH_WINUNINST}"	"Publisher"			"${LegalCopyright}"				# 發行者
	WriteRegStr	HKCU	"${REGPATH_WINUNINST}"	"InstallDate"		"${InstallDate}"				# 安裝日期
	WriteRegStr	HKCU	"${REGPATH_WINUNINST}"	"HelpLink"			"${WEBSITE}"					# 說明連結
	WriteRegStr	HKCU	"${REGPATH_WINUNINST}"	"URLInfoAbout"		"${WEBSITE}"					# 支援連結
	WriteRegStr	HKCU	"${REGPATH_WINUNINST}"	"URLUpdateInfo"		"${WEBSITE}"					# 更新資訊
	WriteRegStr	HKCU	"${REGPATH_WINUNINST}"	"UninstallString"	'"$INSTDIR\${Uninstaller}.exe"'	# 解除安裝程式路徑
SectionEnd

# === 備份 ===
Section /o "備份" Backup
	SetOutPath	"$PLUGINSDIR"					# 安裝位置
	File "C:\Program Files (x86)\7-Zip\7z.exe"	# 載入檔案
	# 使用 7-Zip 的命令列指令製作備份檔案，最後的反斜線（\）是為了讓指令不要太長
	nsExec::Exec '7z.exe a "$INSTDIR\${BackupFile}." -r \
	"$INSTDIR\*.zh-CN.xnb" \
	"$INSTDIR\Chinese*.xnb" \
	"$INSTDIR\LanguageButtons.xnb"'
SectionEnd

# === 文本 ===
Section "文本"
	SetOutPath	"$INSTDIR"				# 安裝位置
#	File /nonfatal /r "assets\Content"	# 載入檔案
SectionEnd

# === 思源黑體 ===
Section "思源黑體" Font1
	SetOutPath "$INSTDIR\Content\Fonts"
#	File /nonfatal /r "assets\Fonts\思源黑體\"
SectionEnd

# === 源泉圓體 ===
Section /o "源泉圓體" Font2
	SetOutPath "$INSTDIR\Content\Fonts"
#	File /nonfatal /r "assets\Fonts\源泉圓體\"
SectionEnd

# === 內海字體 ===
Section /o "內海字體" Font3
	SetOutPath "$INSTDIR\Content\Fonts"
#	File /nonfatal /r "assets\Fonts\內海字體\"
SectionEnd

# === 清松手寫體 ===
Section /o "清松手寫體" Font4
	SetOutPath "$INSTDIR\Content\Fonts"
#	File /nonfatal /r "assets\Fonts\清松手寫體\"
SectionEnd

# === 最像素 Zpix ===
Section /o "最像素 Zpix" Font5
	SetOutPath "$INSTDIR\Content\Fonts"
#	File /nonfatal /r "assets\Fonts\Zpix\"
SectionEnd

# ================================================================================================================================================
# 函數（安裝用）Installer Functions
# ================================================================================================================================================

# 安裝程式啟動時會先執行此函數
Function .onInit
	Call VersionCheck	# 呼叫 VersionCheck 函數比對版本號碼，確認是否安裝了舊版
	Call SetINSTDIR		# 呼叫 SetINSTDIR 函數設定安裝路徑
	InitPluginsDir		# 初始化 $PLUGINSDIR，$PLUGINSDIR 預設路徑是使用者的 temp 目錄，用來存放安裝時需要的檔案
FunctionEnd

# === 比對版本 ===
Function VersionCheck
	ReadRegStr $R3 HKCU "Software\${APPNAME}" "Version" # 搜尋登錄檔，將版本號碼儲存至變數
	${VersionCompare} "${Version}" "$R3" $R4 # 比對已安裝的版本及準備安裝的版本（要 WordFunc.nsh 才能用）
	${If} $R4 = 2 # 如果已安裝的版本比較新，就詢問是否要安裝
		MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "已安裝較新的版本，確定要安裝舊版本嗎？" IDYES Yes IDNO No
		No:
			Quit # 關閉安裝程式
		Yes:
	${EndIf}
FunctionEnd

# === 設定安裝路徑 ===
Function SetINSTDIR
	ReadRegStr $INSTDIR HKCU "Software\${APPNAME}" "InstallLocation" # 搜尋登錄檔，判斷是否安裝過模組。如果有，就將安裝路徑設定成登錄檔記錄的路徑
	${If} ${Errors} # 如果沒有安裝過，就執行路徑偵測
		# GOG 路徑偵測 
		${If} ${RunningX64} # 判斷是否用 64 位元 Windows 執行
			SetRegView 64
			ReadRegStr $INSTDIR HKLM "SOFTWARE\WOW6432Node\GOG.com\Games\${GOGID}" "path" # 搜尋登錄檔，取得安裝路徑
			SetRegView LastUsed
		${Else}
			ReadRegStr $INSTDIR HKLM "SOFTWARE\WOW6432Node\GOG.com\Games\${GOGID}" "path" # 搜尋登錄檔，取得安裝路徑
		${EndIf}
		${If} ${Errors} # 如果沒有找到 GOG 路徑，則搜尋 Steam 路徑
			# Steam 路徑偵測
			${If} ${RunningX64} # 判斷是否用 64 位元 Windows 執行
				SetRegView 64
				ReadRegStr $INSTDIR HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App ${STEAMID}" "InstallLocation" # 搜尋登錄檔，取得安裝路徑
				SetRegView LastUsed
			${Else}
				ReadRegStr $INSTDIR HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App ${STEAMID}" "InstallLocation" # 搜尋登錄檔，取得安裝路徑
			${EndIf}
			${If} ${Errors} # 如果都沒有找到，則設定成安裝程式所在的路徑
				StrCpy $INSTDIR $EXEDIR
			${EndIf}
		${EndIf}
	${EndIf}
FunctionEnd

# === 確認遊戲是否正在執行 ===
Function CheckProcess
	${nsProcess::FindProcess} "Stardew Valley.exe" $R0 # 查詢程序的狀態並儲存至變數
	${nsProcess::FindProcess} "StardewModdingAPI.exe" $R1
	${If} $R0 != 0 # 如果原版沒在執行（0 等於正在執行）
	${AndIf} $R1 != 0 # 如果 SMAPI 和原版都沒在執行
	${Else} # 如果原版或 SMAPI 正在執行就顯示警告
		MessageBox MB_OK|MB_ICONEXCLAMATION|MB_DEFBUTTON1 "遊戲正在執行，請先關閉遊戲再安裝模組。"
		Abort # 終止 Function
	${EndIf}
	${nsProcess::Unload}
FunctionEnd

# === 如果安裝過模組就不顯示頁面 ===
Function CheckInst
	ReadRegStr $R0 HKCU "Software\${APPNAME}" "InstallLocation" # 搜尋登錄檔，確認是否安裝有模組
	${IfNot} ${Errors}
		Abort # 不顯示頁面
	${EndIf}
FunctionEnd

# === 詢問是否要安裝在沒有執行檔的路徑 ===
Function NoExe
	${IfNot} ${FileExists} "$INSTDIR\Stardew Valley.exe" # 如果遊戲主程式不存在，就詢問是否要安裝在指定的安裝路徑
		MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "未偵測到遊戲主程式，確定要安裝在此處嗎？" IDYES Yes IDNO No
		No:
			Abort # 終止 Function
		Yes:
	${EndIf}
FunctionEnd

# === 詢問是否備份遊戲檔案 ===
Function WannaBackup
	ReadRegStr $R0 HKCU "Software\${APPNAME}" "InstallLocation" # 搜尋登錄檔，確認是否安裝有模組
	${If} ${Errors} # 如果沒有安裝就詢問是否備份
		MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 "要備份遊戲檔案嗎？" IDYES Yes IDNO No
		Yes:
			SectionSetFlags ${Backup} ${SF_SELECTED} # 將 Backup Section 選取
		No:
	${EndIf}
FunctionEnd

# === 詢問是否開啟遊戲 ===
Function RunGame
	MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 "要開啟遊戲嗎？" IDYES Yes IDNO No
	Yes:
		${If} ${FileExists} "$INSTDIR\StardewModdingAPI.exe"	# 判斷是否有安裝 SMAPI
			ExecShell open "$INSTDIR\StardewModdingAPI.exe"		# 開啟 SMAPI
		${ElseIf} ${FileExists} "$INSTDIR\Stardew Valley.exe"	# 判斷是否有遊戲主程式
			ExecShell open "$INSTDIR\Stardew Valley.exe"		# 開啟原版遊戲
		${Else}
			MessageBox MB_OK|MB_ICONINFORMATION|MB_DEFBUTTON1 "安裝路徑無遊戲主程式。"
		${EndIf}
		goto End # 跳到 End，避免執行後續程式碼
	No:
		ExecShell open "${WEBSITE}" # 開啟網頁
	End:
FunctionEnd

# === 詢問是否安裝已安裝的字型 ===
Function InstalledFont
	ReadRegStr $R5 HKCU "Software\${APPNAME}" "Font" # 搜尋登錄檔，取得已安裝的字型名稱
	${If} $R5 == $SelectedFont # 如果和選擇中的字型相同就詢問是否要安裝
		MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "已安裝此字型，要再次安裝嗎？" IDYES Yes IDNO No
		No:
			Abort # 終止 Function
		Yes:
	${EndIf}
FunctionEnd

# ================================================================================================================================================
# 自訂頁面（歡迎頁面）
# ================================================================================================================================================

# === 宣告變數 ===
Var WelcomeDialog
Var Welcome
Var Welcome_hImage

# === 頁面設定 ===
Function Welcome
	# 以下五行是自訂頁面必須的，1044 代表 welcome/Finish 頁面（相對於 1018 代表一般頁面）
	nsDialogs::Create 1044
	Pop $WelcomeDialog
	${If} $WelcomeDialog == error
		Abort
	${EndIf}

	# 隱藏底下的線條和文字（BrandingText）
	GetDlgItem $R1 $HWNDPARENT 1028	# 取得文字的狀態並儲存在變數裡，1028 是文字的 ID
	GetDlgItem $R2 $HWNDPARENT 1035	# 取得線條的狀態並儲存在變數裡，1035 是線條的 ID
	ShowWindow $R1 ${SW_HIDE}		# 隱藏文字
	ShowWindow $R2 ${SW_HIDE}		# 隱藏線條

	# 設定圖片
	${NSD_CreateBitmap} 0u 0u 331u 193u ""
	Pop $Welcome
	File "/oname=$PLUGINSDIR\Welcome.bmp" "assets\Images\Welcome.bmp"
	${NSD_SetStretchedImage} $Welcome "$PLUGINSDIR\Welcome.bmp" $Welcome_hImage

	nsDialogs::Show # 沒有這行頁面就不會顯示，一定要放最後
FunctionEnd

# === 離開頁面時 ===
Function WelcomeLeave
	ShowWindow $R1 ${SW_SHOW}		# 顯示文字
	ShowWindow $R2 ${SW_SHOW}		# 顯示線條
FunctionEnd

# ================================================================================================================================================
# 自訂頁面（結束頁面）
# ================================================================================================================================================

# === 宣告變數 ===
Var FinishDialog
Var Finish
Var Finish_hImage

# === 頁面設定 ===
Function Finish
	# 以下五行是自訂頁面必須的，1044 代表 welcome/Finish 頁面（相對於 1018 代表一般頁面）
	nsDialogs::Create 1044
	Pop $FinishDialog
	${If} $FinishDialog == error
		Abort
	${EndIf}

	# 隱藏底下的線條和文字（BrandingText）
	GetDlgItem $R1 $HWNDPARENT 1028	# 取得文字的狀態並儲存在變數裡，1028 是文字的 ID
	GetDlgItem $R2 $HWNDPARENT 1035	# 取得線條的狀態並儲存在變數裡，1035 是線條的 ID
	ShowWindow $R1 ${SW_HIDE}		# 隱藏文字
	ShowWindow $R2 ${SW_HIDE}		# 隱藏線條

	# 設定圖片
	${NSD_CreateBitmap} 0u 0u 331u 193u ""
	Pop $Finish
	File "/oname=$PLUGINSDIR\Welcome.bmp" "assets\Images\Welcome.bmp"
	${NSD_SetStretchedImage} $Finish "$PLUGINSDIR\Welcome.bmp" $Finish_hImage

	nsDialogs::Show # 沒有這行頁面就不會顯示，一定要放最後
FunctionEnd

# === 離開頁面時 ===
Function FinishLeave
	Call RunGame # 呼叫 RunGame 函數詢問是否開啟遊戲
FunctionEnd

# ================================================================================================================================================
# 自訂頁面（重新安裝或解除安裝選項頁面）
# ================================================================================================================================================

# === 宣告變數 ===
Var RRDialog
Var Repair
Var Remove
Var Button
Var GroupBox

# === 頁面設定 ===
Function RepairRemove
	ReadRegStr $R0 HKCU "Software\${APPNAME}" "InstallLocation" # 搜尋登錄檔，確認是否安裝有模組
	${If} ${Errors}
		Abort # 如果沒安裝過就不顯示頁面
	${EndIf}

	# 以下五行是自訂頁面必須的，1018 代表一般頁面（相對於 1044 代表 Welcome/Finish 頁面）
	nsDialogs::Create 1018
	Pop $RRDialog
	${If} $RRDialog == error
		Abort
	${EndIf}

	# 頁面的文字
	!insertmacro MUI_HEADER_TEXT "重新安裝或移除" "已安裝模組，請選擇要執行的動作。"

	# 用 box 裝起來
	${NSD_CreateGroupBox} 0 10u 100% 120u "選項"
		Pop $GroupBox

	# 重新安裝選項
	${NSD_CreateRadioButton} 120u 40u 15% 10u "重新安裝"
		Pop $Repair
		${NSD_OnClick} $Repair RepairRemoveAction

	# 解除安裝選項
	${NSD_CreateRadioButton} 120u 80u 15% 10u "解除安裝"
		Pop $Remove
		${NSD_OnClick} $Remove RepairRemoveAction

	# 返回頁面時將使用者的選項選取（使用者的選擇在 RepairRemoveLeave 函數紀錄）
	${Select} ${BST_CHECKED}
		${Case} $6
			${NSD_Check} $Repair
		${Case} $7
			${NSD_Check} $Remove
		${Default} # 如果所有選項都沒有被選取，則將「下一步」按鈕停用
			GetDlgItem $Button $HWNDPARENT 1
			EnableWindow $Button 0
	${EndSelect}

	nsDialogs::Show # 沒有這行頁面就不會顯示，一定要放最後
FunctionEnd

# === 選項的動作 ===
Function RepairRemoveAction
	EnableWindow $Button 1 # 如果其中一個選項被選取就將「下一步」按鈕啟用
FunctionEnd

# === 離開頁面時 ===
Function RepairRemoveLeave
	# 紀錄使用者的選擇，並儲存在變數裡
	${NSD_GetState} $Repair $6
	${NSD_GetState} $Remove $7

	# 如果 Repair 選項被選取就繼續執行安裝程式（什麼都不用做）
	# 如果 Remove 選項被選取就執行解除安裝程式
	${If} $7 == ${BST_CHECKED}
		${If} ${FileExists} "$INSTDIR\${Uninstaller}.exe" # 判斷解除安裝程式是否存在
			ExecShell open "$INSTDIR\${Uninstaller}.exe" # 如果存在，就執行解除安裝程式
		${Else} # 如果不存在，就跳出警告視窗
			MessageBox MB_OK|MB_ICONSTOP|MB_DEFBUTTON1 "解除安裝程式不存在，請手動移除模組。"
		${EndIf}
		Quit # 關閉安裝程式
	${EndIf}
FunctionEnd

# ================================================================================================================================================
# 自訂頁面（字型選擇頁面）
# ================================================================================================================================================

# === 宣告變數 ===
# 字型編號順序：思源黑體、源泉圓體、內海字體、清松手寫體、最像素 Zpix
Var FontDialog
Var Label
Var RadioButton1
Var RadioButton2
Var RadioButton3
Var RadioButton4
Var RadioButton5
Var Bitmap1
Var Bitmap1_hImage
Var Bitmap2
Var Bitmap2_hImage
Var Bitmap3
Var Bitmap3_hImage
Var Bitmap4
Var Bitmap4_hImage
Var Bitmap5
Var Bitmap5_hImage

# === 頁面設定 ===
Function Fonts
	# 以下五行是自訂頁面必須的，1018 代表一般頁面（相對於 1044 代表 Welcome/Finish 頁面）
	nsDialogs::Create 1018
	Pop $FontDialog
	${If} $FontDialog == error
		Abort
	${EndIf}

	# 頁面的文字
	!insertmacro MUI_HEADER_TEXT "安裝模組" "安裝程式將會自動安裝正體中文模組，請選擇字型。"

	# 頁面的文字
	${NSD_CreateLabel} 0u 0u 281u 19u "使用其他模組可能會缺字。如果有缺字，請使用「思源黑體」、「源泉圓體」或「最像素 Zpix」。重新安裝不須刪除模組，再次執行安裝程式即可。"
	Pop $Label

	# 選項
	# 思源黑體
	${NSD_CreateRadioButton} 47u 27u 19u 19u ""
		Pop $RadioButton1
		${NSD_OnClick} $RadioButton1 FontsAction

	# 源泉圓體
	${NSD_CreateRadioButton} 138u 27u 19u 19u ""
		Pop $RadioButton2
		${NSD_OnClick} $RadioButton2 FontsAction

	# 內海字體
	${NSD_CreateRadioButton} 232u 27u 19u 19u ""
		Pop $RadioButton3
		${NSD_OnClick} $RadioButton3 FontsAction

	# 清松手寫體
	${NSD_CreateRadioButton} 47u 73u 19u 19u ""
		Pop $RadioButton4
		${NSD_OnClick} $RadioButton4 FontsAction

	# 最像素 Zpix
	${NSD_CreateRadioButton} 138u 73u 19u 19u ""
		Pop $RadioButton5
		${NSD_OnClick} $RadioButton5 FontsAction

	# 選項的圖片
	# 思源黑體
	${NSD_CreateBitmap} 8u 46u 89u 23u ""
		Pop $Bitmap1
		File "/oname=$PLUGINSDIR\思源黑體.bmp" "assets\Images\思源黑體.bmp"
		${NSD_SetStretchedImage} $Bitmap1 "$PLUGINSDIR\思源黑體.bmp" $Bitmap1_hImage

	# 源泉圓體
	${NSD_CreateBitmap} 100u 46u 89u 23u ""
		Pop $Bitmap2
		File "/oname=$PLUGINSDIR\源泉圓體.bmp" "assets\Images\源泉圓體.bmp"
		${NSD_SetStretchedImage} $Bitmap2 "$PLUGINSDIR\源泉圓體.bmp" $Bitmap2_hImage

	# 內海字體
	${NSD_CreateBitmap} 192u 46u 89u 23u ""
		Pop $Bitmap3
		File "/oname=$PLUGINSDIR\內海字體.bmp" "assets\Images\內海字體.bmp"
		${NSD_SetStretchedImage} $Bitmap3 "$PLUGINSDIR\內海字體.bmp" $Bitmap3_hImage

	# 清松手寫體
	${NSD_CreateBitmap} 8u 93u 89u 23u ""
		Pop $Bitmap4
		File "/oname=$PLUGINSDIR\清松手寫體.bmp" "assets\Images\清松手寫體.bmp"
		${NSD_SetStretchedImage} $Bitmap4 "$PLUGINSDIR\清松手寫體.bmp" $Bitmap4_hImage

	# 最像素 Zpix
	${NSD_CreateBitmap} 100u 93u 89u 23u ""
		Pop $Bitmap5
		File "/oname=$PLUGINSDIR\ZPIX.bmp" "assets\Images\ZPIX.bmp"
		${NSD_SetStretchedImage} $Bitmap5 "$PLUGINSDIR\ZPIX.bmp" $Bitmap5_hImage

	# 返回頁面時將使用者的選項選取（使用者的選擇在 FontsAction 函數紀錄）
	${Select} ${BST_CHECKED}
		${Case} $1
			${NSD_Check} $RadioButton1
		${Case} $2
			${NSD_Check} $RadioButton2
		${Case} $3
			${NSD_Check} $RadioButton3
		${Case} $4
			${NSD_Check} $RadioButton4
		${Case} $5
			${NSD_Check} $RadioButton5
		${Default} # 如果所有選項都沒有被選取，則將「下一步」按鈕停用
			GetDlgItem $Button $HWNDPARENT 1
			EnableWindow $Button 0
	${EndSelect}

	nsDialogs::Show # 沒有這行頁面就不會顯示，一定要放最後
FunctionEnd

# === 選項的動作 ===
Function FontsAction
	# 如果其中一個選項被選取就將「下一步」按鈕啟用
	EnableWindow $Button 1

	# 紀錄使用者的選擇，並儲存在變數裡
	${NSD_GetState} $RadioButton1 $1
	${NSD_GetState} $RadioButton2 $2
	${NSD_GetState} $RadioButton3 $3
	${NSD_GetState} $RadioButton4 $4
	${NSD_GetState} $RadioButton5 $5

	# 當選項被選取就將對應的 Section 選取（反之清除）
	SectionSetFlags ${Font1} $1
	SectionSetFlags ${Font2} $2
	SectionSetFlags ${Font3} $3
	SectionSetFlags ${Font4} $4
	SectionSetFlags ${Font5} $5

	# 將選擇的字型名稱儲存至變數 SelectedFont 裡
	${Select} ${BST_CHECKED}
		${Case} $1
			StrCpy $SelectedFont "思源黑體"
		${Case} $2
			StrCpy $SelectedFont "源泉圓體"
		${Case} $3
			StrCpy $SelectedFont "內海字體"
		${Case} $4
			StrCpy $SelectedFont "清松手寫體"
		${Case} $5
			StrCpy $SelectedFont "最像素 Zpix"
	${EndSelect}
FunctionEnd

# === 離開頁面時 ===
Function FontsLeave
	Call CheckProcess		# 呼叫 CheckProcess 函數確認遊戲是否正在執行
	Call WannaBackup		# 呼叫 WannaBackup 函數詢問是否備份
	Call InstalledFont		# 呼叫 InstalledFont 函數詢問是否安裝已安裝的字型
FunctionEnd

# ================================================================================================================================================
# 內容（解除安裝用）Uninstaller Sections
# ================================================================================================================================================

Section "Uninstall"
	SetAutoClose	true						# 安裝完成時自動關閉安裝中頁面（使用自訂頁面才需要設定）
	SetDetailsPrint	none						# 完全隱藏解除安裝資訊
	SetOutPath "$PLUGINSDIR"					# 安裝位置
	File "C:\Program Files (x86)\7-Zip\7z.exe"	# 載入檔案

	# 使用 7-Zip 的命令列指令解壓縮備份檔案
	nsExec::Exec '7z.exe x "$INSTDIR\${BackupFile}" -o"$INSTDIR" -aoa'

	DeleteRegKey	HKCU	"Software\${APPNAME}"		# 刪除登錄檔
	DeleteRegKey	HKCU	"${REGPATH_WINUNINST}"		# 刪除登錄檔
	Delete	"$INSTDIR\${BackupFile}"					# 刪除備份
	Delete	"$R9\${Uninstaller}.exe"					# 刪除解除安裝程式

	MessageBox MB_OK|MB_ICONINFORMATION|MB_DEFBUTTON1 "解除安裝完成。" # 解除安裝完成視窗
SectionEnd

# ================================================================================================================================================
# 函數（解除安裝用）Uninstaller Functions
# ================================================================================================================================================

# 解除安裝程式啟動時會先執行此函數
Function un.onInit
	${IfNot} ${FileExists} "$INSTDIR\${BackupFile}" # 如果備份檔案不存在，就跳出警告視窗
		MessageBox MB_OK|MB_ICONEXCLAMATION|MB_DEFBUTTON1 "沒有備份檔案，將僅移除安裝程式相關檔案，請手動移除模組。"
	${EndIf}

	InitPluginsDir # 初始化 $PLUGINSDIR，$PLUGINSDIR 預設路徑是使用者的 temp 目錄，用來存放安裝時需要的檔案

	StrCpy $R9 $INSTDIR # 將 $INSTDIR 儲存至變數 $R9（$INSTDIR 是解除安裝程式所在的路徑，用來刪除解除安裝程式）

	ReadRegStr $INSTDIR HKCU "Software\${APPNAME}" "InstallLocation" # 搜尋登錄檔，將安裝路徑儲存至 $INSTDIR（不寫的話解除安裝路徑會跟解除安裝程式所在的路徑一樣，避免有人移動解除安裝程式）
FunctionEnd

# === 確認遊戲是否正在執行 ===
Function un.CheckProcess
	${nsProcess::FindProcess} "Stardew Valley.exe" $R0 # 查詢程序的狀態並儲存至變數
	${nsProcess::FindProcess} "StardewModdingAPI.exe" $R1
	${If} $R0 != 0 # 如果原版沒在執行（0 等於正在執行）
	${AndIf} $R1 != 0 # 如果 SMAPI 和原版都沒在執行
	${Else} # 如果原版或 SMAPI 正在執行就顯示警告
		MessageBox MB_OK|MB_ICONEXCLAMATION|MB_DEFBUTTON1 "遊戲正在執行，請先關閉遊戲再解除安裝。"
		Abort # 終止 Function
	${EndIf}
	${nsProcess::Unload}
FunctionEnd

# ================================================================================================================================================
# 自訂頁面（解除安裝歡迎頁面）
# ================================================================================================================================================

# === 宣告變數 ===
Var un.WelcomeDialog
Var un.Welcome
Var un.Welcome_hImage

# === 頁面設定 ===
Function un.Welcome
	# 以下五行是自訂頁面必須的，1044 代表 welcome/Finish 頁面（相對於 1018 代表一般頁面）
	nsDialogs::Create 1044
		Pop $un.WelcomeDialog
	${If} $un.WelcomeDialog == error
		Abort
	${EndIf}

	# 隱藏底下的線條和文字（BrandingText）
	GetDlgItem $R1 $HWNDPARENT 1028	# 取得文字的狀態並儲存在變數裡，1028 是文字的 ID
	GetDlgItem $R2 $HWNDPARENT 1035	# 取得線條的狀態並儲存在變數裡，1035 是線條的 ID
	ShowWindow $R1 ${SW_HIDE}		# 隱藏文字
	ShowWindow $R2 ${SW_HIDE}		# 隱藏線條

	# 設定圖片
	${NSD_CreateBitmap} 0u 0u 331u 193u ""
	Pop $un.Welcome
	File "/oname=$PLUGINSDIR\Welcome.bmp" "assets\Images\Welcome.bmp"
	${NSD_SetStretchedImage} $un.Welcome "$PLUGINSDIR\Welcome.bmp" $un.Welcome_hImage

	nsDialogs::Show # 沒有這行頁面就不會顯示，一定要放最後
FunctionEnd

# === 離開頁面時 ===
Function un.WelcomeLeave
	ShowWindow $R1 ${SW_SHOW}		# 顯示文字
	ShowWindow $R2 ${SW_SHOW}		# 顯示線條
FunctionEnd

# ================================================================================================================================================
# 自訂頁面（解除安裝結束頁面）
# ================================================================================================================================================

# === 宣告變數 ===
Var un.FinishDialog
Var un.Finish
Var un.Finish_hImage

# === 頁面設定 ===
Function un.Finish
	# 以下五行是自訂頁面必須的，1044 代表 welcome/Finish 頁面（相對於 1018 代表一般頁面）
	nsDialogs::Create 1044
		Pop $un.FinishDialog
	${If} $un.FinishDialog == error
		Abort
	${EndIf}

	# 隱藏底下的線條和文字（BrandingText）
	GetDlgItem $R1 $HWNDPARENT 1028	# 取得文字的狀態並儲存在變數裡，1028 是文字的 ID
	GetDlgItem $R2 $HWNDPARENT 1035	# 取得線條的狀態並儲存在變數裡，1035 是線條的 ID
	ShowWindow $R1 ${SW_HIDE}		# 隱藏文字
	ShowWindow $R2 ${SW_HIDE}		# 隱藏線條

	# 設定圖片
	${NSD_CreateBitmap} 0u 0u 331u 193u ""
	Pop $un.Finish
	File "/oname=$PLUGINSDIR\Welcome.bmp" "assets\Images\Welcome.bmp"
	${NSD_SetStretchedImage} $un.Finish "$PLUGINSDIR\Welcome.bmp" $un.Finish_hImage

	nsDialogs::Show # 沒有這行頁面就不會顯示，一定要放最後
FunctionEnd