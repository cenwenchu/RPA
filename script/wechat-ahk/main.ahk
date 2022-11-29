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
res_dir := A_ScriptDir
resultFile := A_ScriptDir
    
if (InStr(A_ScriptDir, "\") > 0)
{
   WechatConfig.RES_PATH := res_dir . "\res\" 
   resultFile := resultFile . "\微信分析结果文件.txt" 
}
else
{
   WechatConfig.RES_PATH := res_dir . "/res/" 
   resultFile := resultFile . "/微信分析结果文件.txt" 
}

;应用的一些基础配置填入
Menu, WechatMenu, Add, &发送聊天消息, SendWechatMessage
Menu, WechatMenu, Add, &分析聊天记录, AnalysisWechatMessage

Menu, AboutMenu, Add, &帮助, help
Menu, AboutMenu, Add, &关于, about

Menu, MyMenuBar, Add, 【微信操作菜单】, :WechatMenu
Menu, MyMenuBar, Add, 【帮助】, :AboutMenu

; 添加菜单栏到窗口:
Gui, Menu, MyMenuBar

Gui, +Resize  ; 让用户可以调整窗口的大小.
Gui, Add, Text,section R1, 请输入-好友或者群名称:
Gui, Add, Text,R3, 请输入-自动发送的聊天内容（文字）:
Gui, Add, Text,R1, 自动发送的聊天附件（文件）:
Gui, Add, Button,R1, 选择聊天附件
Gui, Add, Text,R1, 请输入-分析聊天的数量:
Gui, Add, Text,R2, 请输入-分析聊天包含的关键词:

Gui, Add, Edit,ys w200 vchatId
Gui, Add, Edit,R3 w300 vchatMessage,欢迎你来杭州~
Gui, Add, Edit, R2 w300 ReadOnly vattachment
Gui, Add, Edit,w100 vmessageProcessCount,10
Gui, Add, Edit,R2 w300 vmessageKeyWords,手机号码

Gui, Show

^x::ExitApp

return 

help:
    MsgBox, 该软件是模拟微信操作的机器人，首先必须启动并登录微信。当前模拟支持3种操作：`n`t(1)自动发消息，填写微信好友名称或者群名称，输入想要发送的文字、选择需要发送的附件，然后点击【微信操作菜单】-【发送聊天消息】开始发消息;`n`t(2)自动分析消息，填写微信好友名称或者群名称，输入想要分析的聊天数量（选的越多，分析的越多），填入分析聊天包含的关键词（”手机号码“作为特殊规则，代表聊天记录中带有手机号码;其他文字就代表聊天中包含这些文字），最终分析结果会保存到目录中的"微信分析结果文件.txt"，点击【微信操作菜单】-【分析聊天记录】开始分析;
return 

about:
    MsgBox, 作者:cenwenchu 版本信息:0.1 version.
return

; 关于选择聊天附件
Button选择聊天附件:

FileSelectFile,select_file,,3, 选择附件文件地址

if (select_file != "")
{
    GuiControl,, attachment, %select_file%
}  

return 


AnalysisWechatMessage:

GuiControlGet, chatId
GuiControlGet, messageProcessCount
GuiControlGet, messageKeyWords 

if(!chatId)
{
    MsgBox, 请输入需要自动化的好友或者群名称！
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

BlockInput, MouseMove 
BlockInput, Mouse

findAndClickElement("max.png",20,20,50) 
totalCount := ParseWechatContent(chatId,messageKeyWords,resultFile,messageProcessCount) 
findAndClickElement("recovery.png",20,20,50)
findAndClickElement("close.png",20,20,50)

BlockInput, MouseMoveOff
BlockInput, Default
   
TempTip := "分析聊天记录结束,符合结果 " . totalCount . " 条,已保存到:微信分析结果文件.txt"

TrayTip 消息,%TempTip%
Sleep 1000   ; 让它显示 1 秒钟.

return

SendWechatMessage:

GuiControlGet, chatId
GuiControlGet, chatMessage 
GuiControlGet, attachment

if(!chatId)
{
    MsgBox, 请输入需要自动化的好友或者群名称！
    return
}

if(!chatMessage)
{
    MsgBox, 请输入需要发送的聊天内容！
    return
}

initWechatApp("chat")

BlockInput, MouseMove
BlockInput, Mouse

findAndClickElement("max.png",20,20,50) 
SendMessage(chatId,chatMessage,attachment) 
findAndClickElement("recovery.png",20,20,50)
sleep 300
findAndClickElement("close.png",20,20,50)

BlockInput, MouseMoveOff
BlockInput, Default
    
TrayTip 消息, 自动发消息结束
Sleep 1000   ; 让它显示 1 秒钟.  
    
return


GuiClose:  ; 用户关闭了窗口.
ExitApp

