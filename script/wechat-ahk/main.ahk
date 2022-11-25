#Include \\Mac\Home\Documents\GitHub\RPA\script\wechat-ahk\WechatSuite.ahk
#Include \\Mac\Home\Documents\GitHub\RPA\script\wechat-ahk\config.ahk


; 异常记录日志的配置
OnError("LogError")
LogError(exception) {
    FileAppend % "Error on line " exception.Line ": " exception.Message "`n"
        , "\\Mac\Home\Documents\GitHub\RPA\script\wechat-ahk\errorlog.txt"
    return true
}

;应用的一些基础配置填入
Menu, WechatMenu, Add, &发送聊天消息, SendWechatMessage
Menu, WechatMenu, Add, &分析聊天记录, AnalysisWechatMessage

Menu, DingTalkMenu, Add, &发送聊天消息, SendWechatMessage
Menu, DingTalkMenu, Add, &分析聊天记录, AnalysisWechatMessage

Menu, MyMenuBar, Add, 【微信自动化】, :WechatMenu
Menu, MyMenuBar, Add, 【钉订自动化】, :DingTalkMenu

; 添加菜单栏到窗口:
Gui, Menu, MyMenuBar

Gui, +Resize  ; 让用户可以调整窗口的大小.
Gui, Add, Text,section R1, 请输入需要自动化的好友或者群名称:
Gui, Add, Text,R1, 请输入需要处理的聊天记录数量:
Gui, Add, Text,R1, 请输入聊天记录保存文件地址:
Gui, Add, Button,R1, 选择保存地址
Gui, Add, Text,R1, 请输入资源文件地址:
Gui, Add, Button, R1, 选择资源文件地址
Gui, Add, Edit,ys w100 vchatId,测试群
Gui, Add, Edit,w100 vMessageProcessCount,10
Gui, Add, Edit, R3 ReadOnly vSaveFile 
Gui, Add, Edit, R3 ReadOnly vResFile 


Gui, Add, Button, Default w80 R1, 保存配置 
Gui, Show

return 

;确定配置后，启动分析微信聊天记录处理
Button保存配置:
GuiControlGet, MessageProcessCount
GuiControlGet, chatId
if(CheckInput(chatId,MessageProcessCount,SelectedFile,RES_PATH))
    MsgBox,配置已经保存好，可以点击【菜单】-【微信自动化】执行微信自动化
;initWechatApp("chat")
return

AnalysisWechatMessage:

if (CheckInput(chatId,MessageProcessCount,SelectedFile,RES_PATH))
{  
   initWechatApp("chat")
   findAndClickElement("max.png",20,20,50) 
   ParseWechatContent(chatId,"(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}",SelectedFile,MessageProcessCount) 
   findAndClickElement("recovery.png",20,20,50)
   findAndClickElement("close.png",20,20,50)
}
return

SendWechatMessage:
if(CheckInput(chatId,MessageProcessCount,SelectedFile,RES_PATH))
{
    initWechatApp("chat")
    SendMessage(chatId,"你好，欢迎来到杭州~")   
}
return

; 关于文件保存的配置选择
Button选择保存地址:

FileSelectFile, SelectedFile, S8, , 选择微信聊天记录保存文件, Text Documents (*.txt; *.doc)

if (SelectedFile == "")
    SelectedFile := "\\Mac\Home\Documents\GitHub\RPA\script\wechat-ahk\wechatInfo.txt"
else
{
    StringGetPos, pos, SelectedFile, .txt
    ; pos := InStr(SelectedFile,".txt")
    
    if (pos < 0) 
    {
        SelectedFile := SelectedFile . ".txt"
    }
}

GuiControl,, SaveFile, %SelectedFile%

return 

; 关于资源文件的配置选择
Button选择资源文件地址:

FileSelectFolder,RES_PATH,,3, 选择资源文件地址


if (RES_PATH != "")
{
    WechatConfig.RES_PATH := RES_PATH
    
    if (InStr(RES_PATH, "\") > 0)
        WechatConfig.RES_PATH :=  WechatConfig.RES_PATH . "\"
    else
        WechatConfig.RES_PATH :=  WechatConfig.RES_PATH . "/"
}  
else
    RES_PATH := WechatConfig.RES_PATH

GuiControl,, ResFile, %RES_PATH%

return 

GuiClose:  ; 用户关闭了窗口.
ExitApp


CheckInput(chatId,MessageProcessCount,SelectedFile,RES_PATH)
{
    
    if(!chatId)
    {
        MsgBox,请输入需要自动化的好友或者群名称
        return false
    }


    if(!MessageProcessCount)
    {
        MsgBox,请输入需要处理的聊天记录数量
        return false
    }

    if(!SelectedFile)
    {
        MsgBox,请选择聊天记录保存文件地址
        return false
    }

    if(!RES_PATH)
    {
        MsgBox,请选择资源文件地址
        return false
    }
    
    return true
}

