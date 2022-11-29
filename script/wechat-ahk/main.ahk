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

Menu, MyMenuBar, Add, 【微信自动化】, :WechatMenu

; 添加菜单栏到窗口:
Gui, Menu, MyMenuBar

Gui, +Resize  ; 让用户可以调整窗口的大小.
Gui, Add, Text,section R1, 请输入-好友或者群名称:
Gui, Add, Text,R3, 请输入-自动发送的聊天内容（文字）:
Gui, Add, Text,R1, 请输入-分析聊天的数量:
Gui, Add, Text,R2, 请输入-分析聊天包含的关键词:

Gui, Add, Edit,ys w200 vchatId
Gui, Add, Edit,R3 w300 vchatMessage,欢迎你来杭州~
Gui, Add, Edit,w100 vMessageProcessCount,10
Gui, Add, Edit,R2 w300 vMessageKeyWords,手机号码

Gui, Show

^x::ExitApp

return 


AnalysisWechatMessage:

GuiControlGet, chatId
GuiControlGet, MessageProcessCount
GuiControlGet, MessageKeyWords 

if(!chatId)
{
    MsgBox, 请输入需要自动化的好友或者群名称！
    return
}

if(!MessageProcessCount)
    MessageProcessCount := 10
    
if (!MessageKeyWords)
{
   MessageKeyWords := ""
}
   
if (MessageKeyWords != "")
    if(MessageKeyWords == "手机号码")
    {
        MessageKeyWords := "(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}"
    }
    else
    {
        MessageKeyWords := ".*" . MessageKeyWords . ".*"
    }
 
initWechatApp("chat")  

BlockInput, MouseMove 
BlockInput, SendAndMouse

findAndClickElement("max.png",20,20,50) 
totalCount := ParseWechatContent(chatId,MessageKeyWords,resultFile,MessageProcessCount) 
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

findAndClickElement("max.png",20,20,50) 
SendMessage(chatId,chatMessage) 
findAndClickElement("recovery.png",20,20,50)
findAndClickElement("close.png",20,20,50)

BlockInput, MouseMoveOff
    
TrayTip 消息, 自动发消息结束
Sleep 1000   ; 让它显示 1 秒钟.  
    
return


GuiClose:  ; 用户关闭了窗口.
ExitApp

