#Include config.ahk
#Include FindText.ahk

; 激活微信App
initWechatApp(element)
{

    Loop, Reg, HKEY_CURRENT_USER\Software\Tencent\WeChat, KV
    {
        if (A_LoopRegType = "key")
            value := ""
        else
        {
            RegRead, value
            if ErrorLevel
                value := "*error*"
        }
        
        if (A_LoopRegName == "InstallPath")
            break
     }
     
    wechatPath:= value . "\Wechat.exe"
    
    TrayTip 消息, 启动微信
    
    Run %wechatPath%   
    
    Sleep 1000
    
    WinGetPos, X, Y, W, H,ahk_class WeChatMainWndForPC

    if !(W && H)
    {
        X:= 0
        Y:= 0
        W:= A_ScreenWidth
        H:= A_ScreenHeight
    }
    
    
    switch element
    {
        case "chat": 
        {        
           findAndClickElementWithResDic("chat-not-select",0,0)   
        }
        case "address_book":  
        {
           findAndClickElementWithResDic("address-book-not-select",0,0)        
        }  
    } 
      
}

findAndClickElementWithResDic(res_id,move_x,move_y,x1:=0,y1:=0,x2:=0,y2:=0,fault2text:=0.1,fault2background:=0.1)
{
    ;SysGet, MonitorName, MonitorName
    SysGet, Monitor, Monitor
    ;SysGet, MonitorWorkArea, MonitorWorkArea
    ;MsgBox, Monitor:`tName:`t%MonitorName%`nLeft:`t%MonitorLeft% (%MonitorWorkAreaLeft% work)`nTop:`t%MonitorTop% (%MonitorWorkAreaTop% work)`nRight:`t%MonitorRight% (%MonitorWorkAreaRight% work)`nBottom:`t%MonitorBottom% (%MonitorWorkAreaBottom% work)
    
    if (MonitorRight >= 3000)
    {
        element := WechatConfig.RES_Dic_3000[res_id]
    }
    else
    {
        element := WechatConfig.RES_Dic_1000[res_id]
    }

    
    if (element && element != "")
    {
        resultArray := findAndClickElementV2(element,move_x,move_y,x1,y1,x2,y2,fault2text,fault2background)
        
        if (!resultArray)
        {
            TrayTip 消息, 没有找到对应的操作元素： + %res_id%
    
            return false
        }
        else
            return true
    }
    Else
    {
        MsgBox, res_id:%res_id% not correct!
    }
}


findAndClickElementV2(element,move_x,move_y,x1:=0,y1:=0,x2:=0,y2:=0,fault2text:=0,fault2background:=0)
{
    if (x2 == 0)
        x2 := A_ScreenWidth
        
    if (y2 == 0)
        y2 := A_ScreenHeight
    
    sleep 1000
  
    resultArray := FindText(X, Y, x1, y1, x2, y2, fault2text, fault2background, element)

    
    if (resultArray = 0)
    {
        ;TrayTip 消息, 没有找到对应的操作元素： + %element%
    
        return false
    }
    else
    {
        FindText().Click(X+move_x, Y+move_y, "L")
        sleep 1000
        
        return true
    }
}

; 定位到对应微信组件
findAndClickElement(element,move_x,move_y,colorValue,x1:=0,y1:=0,x2:=0,y2:=0)
{
    
    if (x2 == 0)
        x2 := A_ScreenWidth
        
    if (y2 == 0)
        y2 := A_ScreenHeight
    
    sleep 1000
    
    tempStr := WechatConfig.RES_PATH . element    
    ImageSearch,FoundX, FoundY,x1,y1,x2,y2,*%colorValue% %tempStr%

    if (ErrorLevel = 2)
    {
        TrayTip 消息, 定位的图片文件地址不对.
        
        return false
    }
    else if (ErrorLevel = 1)
    {
        TrayTip 消息, 没有找到微信对应的操作界面： + %element%
    
        return false
    }
    else
    {
        MouseClick , Left, % FoundX+move_x,FoundY+move_y 
        sleep 1000
        
        return true
    }
}

;定向给客户发消息
SendMessage(chatid,message,attachment)
{
   if !findAndClickElementWithResDic("search",20,0)
   {
        return
   }
        
   Send %chatid%
   Sleep 1000
   Send {Enter}
   Sleep 1000
   Send %message%
   Sleep 500
   Send {Enter}
   
   ;if findAndClickElementWithResDic("emoji",0,0)
   ;    findAndClickElementWithResDic("smile",0,0)
   
   ;Send {Enter}
   Sleep 500
   
   if(attachment && attachment != "")
   {
        findAndClickElementWithResDic("input-chinese",0,0) 
        
        if findAndClickElementWithResDic("attachment",0,0)
        {
            Sleep 500
            
            Send %attachment%{Enter}
            Sleep 500
            Send {Enter}
            ;findAndClickElementWithResDic("save-file-open.png",0,0) 
            
        }
   }
   
   return
}

;解析微信聊天记录
ParseWechatContent(chatid,reg_rule,save_filepath,max_process_line_count)
{
    if !findAndClickElementWithResDic("search",20,0)
        return

    Send %chatid%
    Sleep 2000
    Send {Enter}

    if !findAndClickElementWithResDic("chat-more",0,0)
        return 
        
    if !findAndClickElementWithResDic("chat-record",0,0)
        return 

    TrayTip 消息, 分析微信聊天记录开始
    sleep 1000
    
    WinGet, active_id, ID, A
    WinGetPos, X, Y, width, height, A  ; "A" 表示获取活动窗口的位置.
    WinGetActiveTitle, Title ; 后续用于比对是否打开了新窗口
    ;MsgBox, The active window is at %X%,%Y%,%width%,%height%

    ; cursor start position 
    newPosX := (width/1100) * 230 
    newPosY := height-5


    ; reg_rule = (13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8} ;正则表达式电话号码
    ; save_filepath := "\\Mac\Home\Desktop\脚本\统计数据\wechatInfo.txt"
    pre_found_index := 0
    pre_found_text := ""
    current_found_index := 0
    current_found_text := ""
    empty_rounds := 0
    chatContentsList := Array()
    remain_process_line_count := 10
    skip_record := false


    if (max_process_line_count)
    {
        remain_process_line_count := max_process_line_count  ;还剩多少条要处理,-1 代表不控制
    }

    Sleep 1000

    Loop
    { 
     ; init vars and position
     current_found_index := 0
     current_found_text := ""
     step := 0
     text := ""
     clipboard := "" 
     skip_record := false
     isfound := false
     
     if !WinActive(Title) 
     {
        WinActivate, Title
        Sleep 1000
     }

     MouseClick, left, newPosX, newPosY
     
     
     ; inner loop to search chat content 
     Loop, 10
     {

        MouseClick, left, newPosX, newPosY+step, 2
         
        ;MsgBox, contents before: %text%
        Send ^c
        Sleep 500
        text := clipboard
        clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
        
        ;处理文件类型对话
        WinGetTitle, TempTitle, A
        
        if (TempTitle <> Title)
        {
          ;MsgBox % "TempTitle:" . TempTitle . "Title:" Title
          
          waitTimes := 2000
          
          empty_rounds := 0
          isfound := true
     
          while(waitTimes > 0)
          {
            if WinExist(TempTitle) 
                WinKill, %TempTitle%
          
            WinGetTitle, TempTitle, A
          
            if (TempTitle <> Title)
            {
                Sleep 200
                waitTimes :=  waitTimes - 200             
            }
            else
            {
                break
            } 
          }

          break
        }
       
        ; process text content, can use RegExMatch 
        if (text <> "")
        {
          empty_rounds := 0
          isfound := true
       
         ; skip common line readin
         if (pre_found_text != "" and pre_found_text == text and A_Index == 0)
         {
           skip_record := true
         }
         
       
         if (!skip_record)
         {
          if (reg_rule <> "")
          {
             foundPos := RegExMatch(text, reg_rule)
        
             if (foundPos >= 1)
             {
               chatContentsList.Insert(text)
             }
          }
          else
          {
             chatContentsList.Insert(text)
          }
         }
         
         current_found_index := A_Index
         current_found_text := text
        
        
         MouseClick, left, newPosX, newPosY+step  ;reset double click
        
         break
        }
        else
        {
         step := step - 10
        }
     }
     
     ; check to end loop 
     if (pre_found_text <> "")
     {
       if (pre_found_text == current_found_text and pre_found_index == current_found_index)
       {
         ; MsgBox % "LoopEnd now - totalcount: " + chatContentsList.MaxIndex()
         break
       }
     }
     
     if(!isfound)
     {
        empty_rounds := empty_rounds + 1
     
         if (empty_rounds >= 2)
         {
             ; MsgBox % "LoopEnd now - totalcount: " + chatContentsList.MaxIndex()
           break
         }
     }
     

     pre_found_text := current_found_text
     pre_found_index := current_found_index
     
      
     if (remain_process_line_count > 0)
     {
       remain_process_line_count := remain_process_line_count - 1
     }
     
     if (remain_process_line_count = 0) 
     {
      ; MsgBox % "LoopEnd now - totalcount: " + chatContentsList.MaxIndex()
      break
     }
     
     if !WinActive(Title) 
     {
        WinActivate, Title
        Sleep 1000
     }
     
     MouseClick, WheelUP
     
    }

    ; 处理一下最后一屏幕的数据


    step := 0

    if (remain_process_line_count > 0)
    {
        Loop
        {
            MouseClick, left, newPosX, newPosY+step, 2
             
            ; MsgBox, contents before: %text%
            Send ^c
            Sleep 500
            text := clipboard
            clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
            skip_record := false
            
            ; process image content 
            ;处理文件类型对话
            WinGetTitle, TempTitle, A
            
            if (TempTitle <> Title)
            {
              TrayTip 消息, TempTitle:%TempTitle% . Title: %Title%
              
              waitTimes := 2000

              
              while(waitTimes > 0)
              {
                if WinExist(TempTitle) 
                    WinKill, %TempTitle%
              
                WinGetTitle, TempTitle, A
              
                if (TempTitle <> Title)
                {
                    Sleep 200
                    waitTimes :=  waitTimes - 200             
                }
                else
                {
                    break
                } 
              }

            }
            else
            {
                    ; process text content, can use RegExMatch 
                if (text <> "")
                {
               
                     ; skip common line readin
                     if (pre_found_text != "" and pre_found_text == text)
                     {
                       skip_record := true
                     }
                     
                   
                     if (!skip_record)
                     {
                          if (reg_rule <> "")
                          {
                             foundPos := RegExMatch(text, reg_rule)
                        
                             if (foundPos >= 1)
                             {
                               chatContentsList.Insert(text)
                               pre_found_text := text
                             }
                          }
                          else
                          {
                             chatContentsList.Insert(text)
                             pre_found_text := text
                          }
                     }
                     
                     MouseClick, left, newPosX, newPosY+step  ;reset double click
                }
            }
            
            step := step - 20
            
            if (newPosY+step <= 0)
             break
             
            if (remain_process_line_count > 0)
             {
               remain_process_line_count := remain_process_line_count - 1
             }
             
             if (remain_process_line_count = 0) 
             {
              ; MsgBox % "LoopEnd now - totalcount: " + chatContentsList.MaxIndex()
                break
             }
         }
    }

    Sleep 5000

    totalCount := 0

    ; 保存到文件里面 
    if (save_filepath && chatContentsList.MaxIndex() && chatContentsList.MaxIndex() >0 )
    {
    
     totalCount := chatContentsList.MaxIndex()
     
     file := FileOpen(save_filepath, "w")
     
     if !IsObject(file)
     {
       MsgBox Can't open "%save_filepath%" for writing.
     }
     else
     {
      Loop % chatContentsList.MaxIndex()
      {
          file.WriteLine(chatContentsList[A_Index])
         }
     
      file.Close()
      
      Sleep 1000
     }
    }
    
    WinKill, %Title%
    Sleep 1000

    return totalCount
}