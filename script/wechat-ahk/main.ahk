#Include WechatSuite.ahk
#Include config.ahk

; 异常记录日志的配置
OnError("LogError")
LogError(exception) {
    
    error_log := A_ScriptDir
    
    if (InStr(error_log, "\") > 0)
        error_log := error_log . "\errorlog.txt"
    else
        error_log := error_log . "/errorlog.txt"     
    
    FileAppend % "Error on line " exception.Line ": " exception.Message "`n"
        , error_log 
        
        
    return true
}

;配置资源目录、聊天记录分析后的存储文件
resultFile := A_ScriptDir
resultFile_addressBook := A_ScriptDir
    
if (InStr(A_ScriptDir, "\") > 0)
{
   resultFile := resultFile . "\微信分析结果文件.txt" 
   resultFile_addressBook := A_ScriptDir . "\微信通讯录结果文件" 
}
else
{
   resultFile := resultFile . "/微信分析结果文件.txt" 
   resultFile_addressBook := A_ScriptDir . "/微信通讯录结果文件" 
}

;应用的一些基础配置填入

#SingleInstance, Force
;Gui, Color, cWhite
Gui, Font, cBlack
Gui, Margin, 10, 10

;Menu, WechatMenu, Add, &发送聊天消息, SendWechatMessage
;Menu, WechatMenu, Add, &分析聊天记录, AnalysisWechatMessage
;Menu, WechatMenu, Add, &分析并保存通讯簿, AnalysisWechatAddressBook

Menu, AboutMenu, Add, &功能介绍, help
Menu, AboutMenu, Add, &系统信息, systemInfo
Menu, AboutMenu, Add, &打开或关闭debug, openOrcloseDebug
Menu, AboutMenu, Add, &关于, about

;Menu, MyMenuBar, Add, 【微信操作菜单】, :WechatMenu
Menu, MyMenuBar, Add, 【功能介绍和帮助】, :AboutMenu

; 添加菜单栏到窗口:
Gui, Menu, MyMenuBar

Gui, +Resize  ; 让用户可以调整窗口的大小.

groupBoxX1 := 10
groupBoxY1 := 5

Gui, Add, GroupBox,x%groupBoxX1% y%groupBoxY1% w600 h190, 自动发消息（无安全风险和隐患，仅仅给指定的用户发送指定的内容）
Gui, Add, Text,xp+10 yp+30, 发送好友或者群名称:
Gui, Add, Text, yp+40, 发送聊天的内容（文字）:
Gui, Add, Text, yp+40, 发送聊天的附件（文件）:
Gui, Add, Button,yp+20, 清理附件
Gui, Add, Button,xp+80, 选择附件

Gui, Add, Edit,xp+120 yp-100 R1 w200 vchatId
Gui, Add, Edit, yp+40 R2 w300 vchatMessage,欢迎你来杭州~
Gui, Add, Edit, yp+40 R2 w300 ReadOnly vattachment

Gui, Add, Button,xp+220 yp+40 w60 h30, 发送消息

Gui, Add, GroupBox,x%groupBoxX1% yp+50 w600 h210, 聊天分析（无安全风险和隐患，仅仅本地保存非敏感信息）
Gui, Add, Text,xp+10 yp+30, 分析的好友或者群名称:
Gui, Add, Text,yp+40 R1, 分析记录的数量:
Gui, Add, Text,yp+40 R2, 哪些关键词的记录需要分析:
Gui, Add, Edit,xp+200 yp-80 R1 w200 vanalysisChatId
Gui, Add, Edit,yp+40 w100 vmessageProcessCount,10
Gui, Add, Edit,yp+40 R3 w300 vmessageKeyWords,手机号码

Gui, Add, Button,xp+220 yp+60 w60 h30, 开始分析

Gui, Add, GroupBox,x%groupBoxX1% yp+60 w600 h180, 读取并保存通讯录到本地（无安全风险和隐患，仅仅本地保存非敏感信息）
Gui, Add, Text,xp+10 yp+30 R1, 分析通讯录的类型:
Gui, Add, Text,yp+40 R1, 通讯录分析的开始位置:
Gui, Add, Text,yp+40 R1, 通讯录分析的记录条数:

Gui, Add, DropDownList,xp+200 yp-80 vaddressBookTypeChoice, 联系人|群|标签
Gui, Add, Edit,yp+40 w100 vaddressBookProcessStartPos,0
Gui, Add, Edit,yp+40 w100 vaddressBookProcessCount,10

Gui, Add, Button,xp+220 yp+30 w120 h30, 读取并保存到本地

Gui, Show

^x::ExitApp

return 

help:
    MsgBox, 该软件是模拟微信操作的机器人，首先必须启动并登录微信。当前模拟支持3种操作：`n`t(1)自动发消息，填写微信好友名称或者群名称，输入想要发送的文字、选择需要发送的附件，然后点击【发送消息】开始发消息;`n`t(2)自动分析消息，填写微信好友名称或者群名称，输入想要分析的聊天数量（选的越多，分析的越多），填入分析聊天包含的关键词（”手机号码“作为特殊规则，代表聊天记录中带有手机号码;其他文字就代表聊天中包含这些文字），最终分析结果会保存到目录中的"微信分析结果文件.txt"，点击【开始分析】;`n`t(2)自动读取并保存通讯录到本地，选择通讯录类型（联系人、群）,选择分析开始的位置（0代表从头开始），选择分析的记录条数（选择越大，分析的越多），点击【开始分析】，放心只保存在本地，无任何安全风险;
return 

systemInfo:
    SysGet, MonitorName, MonitorName
    SysGet, Monitor, Monitor
    SysGet, MonitorWorkArea, MonitorWorkArea
    MsgBox, 显示器信息:`nName:`t%MonitorName%`nLeft:`t%MonitorLeft% (%MonitorWorkAreaLeft% work)`nTop:`t%MonitorTop% (%MonitorWorkAreaTop% work)`nRight:`t%MonitorRight% (%MonitorWorkAreaRight% work)`nBottom:`t%MonitorBottom% (%MonitorWorkAreaBottom% work)`n显示器DPI:%A_ScreenDPI%
return 

about:
    MsgBox, 作者:cenwenchu 版本信息:0.1 version.
return

openOrcloseDebug:

    if (WechatConfig.IS_DEBUG == true)
    {
        WechatConfig.IS_DEBUG := false
        MsgBox, Debug 被关闭~
    }
    else
    {
        WechatConfig.IS_DEBUG := true
        MsgBox, Debug 被打开~
    }
    
return 

; 关于选择聊天附件
Button选择附件:

FileSelectFile,select_file,,3, 选择附件文件地址

if (select_file != "")
{
    GuiControl,, attachment, %select_file%
}  

return 

; 关于选择聊天附件
Button清理附件:

GuiControl,, attachment,  

return 

Button读取并保存到本地:
AnalysisWechatAddressBook:

    GuiControlGet, addressBookTypeChoice
    GuiControlGet, addressBookProcessStartPos
    GuiControlGet, addressBookProcessCount

    if(!addressBookTypeChoice)
    {
        MsgBox, 请选择分析通讯录的类型！
        return
    }

    initWechatApp("address_book")  

    WinGetTitle, chatTitle, A

    if (WinExist(chatTitle))
        WinMaximize

    if (WechatConfig.ADDRESS_BOOK_TYPE[addressBookTypeChoice] == "friend")
    {
        resultFile_addressBook := A_ScriptDir . "\微信通讯录结果文件_好友.txt" 
    }
   
    if (WechatConfig.ADDRESS_BOOK_TYPE[addressBookTypeChoice] == "group")
    {
        resultFile_addressBook := A_ScriptDir . "\微信通讯录结果文件_群.txt"
    }
       
    totalCount := ParseWechatAddressBook(WechatConfig.ADDRESS_BOOK_TYPE[addressBookTypeChoice],resultFile_addressBook,addressBookProcessStartPos,addressBookProcessCount) 

    if (WinExist(chatTitle))
    {
        WinActivate
        WinRestore
        WinMinimize   
    }

    TempTip := "分析通讯录结束,符合结果 " . totalCount . " 条,已保存到:微信通讯录结果文件.txt"

    MsgBox, %TempTip%

return

Button开始分析:
AnalysisWechatMessage:

    GuiControlGet, analysisChatId
    GuiControlGet, messageProcessCount
    GuiControlGet, messageKeyWords 

    if(!analysisChatId)
    {
        MsgBox, 请输入需要分析的好友或者群名称！
        return
    }

    if(!messageProcessCount)
        messageProcessCount := 10
        
    if (!messageKeyWords)
    {
       messageKeyWords := ""
    }
       
    if (messageKeyWords != "")
        if(messageKeyWords == "手机号码")
        {
            messageKeyWords := "(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}"
        }
        else
        {
            messageKeyWords := ".*" . messageKeyWords . ".*"
        }
     
    initWechatApp("chat")  

    ;BlockInput, MouseMove 
    ;BlockInput, Mouse

    WinGetTitle, chatTitle, A

    if (WinExist(chatTitle))
        WinMaximize

    totalCount := ParseWechatContent(analysisChatId,messageKeyWords,resultFile,messageProcessCount) 

    if (WinExist(chatTitle))
    {
        WinActivate
        WinRestore
        WinMinimize   
    }

    ;BlockInput, MouseMoveOff
    ;BlockInput, Default
       
    TempTip := "分析聊天记录结束,符合结果 " . totalCount . " 条,已保存到:微信分析结果文件.txt"

    MsgBox, %TempTip%

    return

Button发送消息:
SendWechatMessage:

    GuiControlGet, chatId
    GuiControlGet, chatMessage 
    GuiControlGet, attachment

    if(!chatId)
    {
        MsgBox, 请输入需要发送消息的好友或者群名称！
        return
    }

    if(!chatMessage)
    {
        MsgBox, 请输入需要发送的聊天内容！
        return
    }

    initWechatApp("chat")

    ;BlockInput, MouseMove
    ;BlockInput, Mouse

    WinGetTitle, chatTitle, A

    if (WinExist(chatTitle))
        WinMaximize

    SendMessage(chatId,chatMessage,attachment) 

    if (WinExist(chatTitle))
    {
        WinActivate
        WinRestore
        WinMinimize   
    }

    ;BlockInput, MouseMoveOff
    ;BlockInput, Default
        
    MsgBox, 自动发消息结束  
        
    return


GuiClose:  ; 用户关闭了窗口.
ExitApp

