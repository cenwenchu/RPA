#Include WechatSuite.ahk
#Include config.ahk
#Include FindText.ahk

;配置资源目录、聊天记录分析后的存储文件
resultFile := A_ScriptDir
    
if (InStr(A_ScriptDir, "\") > 0)
{
   resultFile := resultFile . "\微信分析结果文件.txt" 
}
else
{
   resultFile := resultFile . "/微信分析结果文件.txt" 
}

reg_rule := ".*欢迎.*"

Sleep 3000

;totalCount := ParseWechatContent("放翁","",resultFile,4) 


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
    remain_process_line_count := 20
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
    Sleep 2000
    
    tt := chatContentsList.MaxIndex()
    TrayTip 消息,%tt% 条记录
    TrayTip 消息,结束分析

ExitApp