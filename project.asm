[org 0x0100]

jmp start

orignalsalt: db 'salt', 0
orignaldam: db 'dam', 0
orignallap: db 'lap', 0
orignalbean: db 'bean', 0
orignalvain: db 'vain', 0
orignalcalm: db 'calm', 0
salt : dw 0
bean : dw 0
calm : dw 0
vain : dw 0
lap : dw 0
dam : dw 0
userinput: db '0'
inputMessege1 : db 'Word Searched : ', 0
inputMessege2 : db 'Word Searched : ', 0
progress : db 'LEVEL PROGRESS REPORT', 0
poor : db 'Vocabulary : Poor', 0
good : db 'Vocabulary : Good', 0
vgood : db 'Vocabulary : Very Good', 0
excellent : db 'Vocabulary : Excellent', 0
compiling : db 'Compiling results for this level...', 0
thanks : db '--------------------- Thanks for Playing ---------------------', 0
gussed : db 'Successfully hunted', 0
failed : db 'Failed to hunt', 0
level1 : db 'Level : 1', 0
level2 : db 'Level : 2', 0
level3 : db 'Level : 3', 0
scoreLabel : db 'Score : ', 0
score : db 'Score : 0', 0
score0 : db '0', 0
score1 : db '1', 0
score2 : db '2', 0
score3 : db '3', 0
scoreCount : dw 0
scoreCount1 : dw 0
scoreCount2 : dw 0

welcome : db ' Welcome to Word Hunt ', 0 
topic : db 'W O R D   H U N T', 0
topun : db '=================', 0
vocab : db 'Come and test your vocabulary with fun and joy!!!', 0
proceed : db 'Press any key to continue >>>', 0
nextLevel : db 'Press any key to continue to next level >>>', 0
instr : db 'Instructions', 0
insun : db '============', 0
instr1 : db '-> Find the word in sequence.', 0
instr2 : db '-> Word should be from an English language.', 0
instr3 : db '-> You can look horizontal, vertical or diagonal.', 0
instr4 : db '-> Grid is of 4x4, so the max word length can be four.', 0
instr5 : db '-> The word which is already hunted will not be appreciated.', 0
instr6 : db ' After hunting a word hit on space bar.', 0
wordarr1 : db ' |  T  |  O  |  V  |  W  | ', 0
wordarr2 : db ' |  E  |  L  |  D  |  P  | ', 0
wordarr3 : db ' |  Z  |  U  |  A  |  H  | ', 0
wordarr4 : db ' |  I  |  L  |  M  |  S  | ', 0
underarr : db ' ------------------------- ', 0
level_1_arr1 : db ' |  N  |  D  |  S  |  T  | ', 0
level_1_arr2 : db ' |  R  |  A  |  X  |  K  | ', 0
level_1_arr3 : db ' |  Q  |  K  |  E  |  G  | ', 0
level_1_arr4 : db ' |  W  |  V  |  F  |  B  | ', 0
level_2_arr1 : db ' |  N  |  Q  |  U  |  T  | ', 0
level_2_arr2 : db ' |  O  |  I  |  F  |  Z  | ', 0
level_2_arr3 : db ' |  M  |  L  |  A  |  C  | ', 0
level_2_arr4 : db ' |  J  |  R  |  K  |  V  | ', 0

;------------------------------------------- CLEAR SCREEN ------------------------------------------------
clrscr:
   push es
   push ax
   push cx
   push di
   mov ax, 0xb800
   mov es, ax           ; point es to video base
   xor di, di           ; point di to top left column
   mov ax, 0x0720       ; space char in normal attribute
   mov cx, 2000         ; number of screen locations
   cld                  ; auto increment mode
   rep stosw            ; clear the whole screen
   pop di
   pop cx
   pop ax
   pop es
   ret

;------------------------------------------- DELAY FUNCTIONS -----------------------------------------------
delay:       ; delay function
   push cx
   mov cx, 25
delay_loop1:
   push cx
   mov cx, 0xFFFF
delay_loop2:   
   loop delay_loop2
   pop cx
   loop delay_loop1
   pop cx
   ret   

delay2:       ; delay function for border
   push cx
   mov cx, 4
delay2_loop1:
   push cx
   mov cx, 0x9FFF
delay2_loop2:   
   loop delay2_loop2
   pop cx
   loop delay2_loop1
   pop cx
   ret 

;------------------------------------------- STRING LENGTH ------------------------------------------------
strlen: 
   push bp
   mov bp,sp
   push es
   push cx
   push di
   les di, [bp+4]         ; point es:di to string
   mov cx, 0xffff         ; load maximum number in cx
   xor al, al             ; load a zero in al
   repne scasb            ; find zero in the string
   mov ax, 0xffff         ; load maximum number in ax
   sub ax, cx             ; find change in cx
   dec ax                 ; exclude null from length
   pop di
   pop cx
   pop es
   pop bp
   ret 4

;------------------------------------------- STRING PRINTING ------------------------------------------------
printstr: 
   push bp
   mov bp, sp
   push es
   push ax
   push cx
   push si
   push di
   push ds              ; push segment of string
   mov ax, [bp+4]
   push ax              ; push offset of string
   call strlen          ; calculate string length
   cmp ax, 0            ; is the string empty
   jz exit              ; no printing if string is empty
   mov cx, ax           ; save length in cx
   mov ax, 0xb800
   mov es, ax           ; point es to video base
   mov al, 80           ; load al with columns per row
   mul byte [bp+8]      ; multiply with y position
   add ax, [bp+10]      ; add x position
   shl ax, 1            ; turn into byte offset
   mov di,ax            ; point di to required location
   mov si, [bp+4]       ; point si to string
   mov ah, [bp+6]       ; load attribute in ah
   cld                  ; auto increment mode
nextchar: 
   lodsb           ; load next char in al
   stosw           ; print char/attribute pair
   loop nextchar   ; repeat for the whole string
exit: 
   pop di
   pop si
   pop cx
   pop ax
   pop es
   pop bp
   ret 8

;--------------------------------------- STRING COMPARISON ------------------------------------------------
strcmp: 
   push bp
   mov bp,sp
   push cx
   push si
   push di
   push es
   push ds
   lds si, [bp+4]             ; point ds:si to first string
   les di, [bp+8]             ; point es:di to second string
   push ds             ; push segment of first string
   push si             ; push offset of first string
   call strlen 
   mov cx, ax          ; save length in cx
   push es 
   push di 
   call strlen 
   cmp cx, ax          ; compare length of both strings
   jne exitfalse
   mov ax, 1           ; store 1 in ax to be returned
   repe cmpsb          ; compare both strings
   jcxz exitsimple     ; are they successfully compared
exitfalse: 
   mov ax, 0           ; store 0 to mark unequal
exitsimple: 
   pop ds
   pop es
   pop di
   pop si
   pop cx
   pop bp
   ret 8

;--------------------------------------- WELCOME MESSEGE --------------------------------------------------
welcomeMessege:
   mov ax, 30
   push ax 
   mov ax, 9
   push ax    
   mov ax, 0x1E
   push ax    
   mov ax, welcome
   push ax      
   call printstr
   ret
;--------------------------------------- VOCABULARY TESTING ---------------------------------------------------
vocabtest:
   mov ax, 17
   push ax    
   mov ax, 12
   push ax  
   mov ax, 0x0D
   push ax   
   mov ax, vocab
   push ax    
   call printstr
   ret 
;--------------------------------------- ANY KEY TO CONTINUE --------------------------------------------------   
continueKey:
   mov ax, 45
   push ax  
   mov ax, 21
   push ax   
   mov ax, 0x83
   push ax     
   mov ax, proceed
   push ax     
   call printstr
   ret
;--------------------------------------- Compile Result Instruction --------------------------------------------------   
compilingResult:
   mov ax, 20
   push ax  
   mov ax, 21
   push ax   
   mov ax, 0x74
   push ax     
   mov ax, compiling
   push ax     
   call printstr
   ret
;--------------------------------------- ANY KEY FOR Next Level --------------------------------------------------   
nextLevelKey:
   mov ax, 20
   push ax      
   mov ax, 19
   push ax     
   mov ax, 0x0E
   push ax      
   mov ax, nextLevel
   push ax         
   call printstr
   ret
;--------------------------------------- CREDENTIALS ------------------------------------------------------------  
mainCred:       
   call border
   call gridback
   call delay
   call gameHead
   call delay
   ret
 
inputCred:
   mov ax, 52    ;----------------- Printing initial score 0
   push ax  
   mov ax, 11
   push ax  
   mov ax, 0x70
   push ax   
   mov ax, score
   push ax    
   call printstr
   mov ax, 20   ;------------- after enter word press space-bar 
   push ax
   mov ax, 16    
   push ax
   mov ax, 0x74     
   push ax
   mov ax, instr6   
   push ax
   call printstr  
   ret
;--------------------------------------- BORDER PRINTING -------------------------------------------------------
border:
   push es
   push ax
   push cx
   push di 

   call clrscr
   
   mov ax, 0xb800
   mov es, ax            ; loading video mem in es 
   mov ah, 0x02          ; print in green atribute
   mov al, 0x2A          ; print * on borders

   mov di, 160             ; point di to screen start
   mov cx, 80
   call delay2
   cld
   rep stosw             ; border is printed on whole upper row
   
   mov cx, 22            ; printing borders at the both ends of row alternatively 
   cld
again:   
   stosw                 ; as the previous stos incremented di so it is pointing at first box of next line
   add di, 156           ; adding 156 to di to point at last box of row
   stosw 
   call delay2
   loop again            ; rep the loop for  2 to 24 rows i.e from row 1 to row 23

   cld
   mov di, 3680          ; start of 25 row
   mov cx, 80
   rep stosw             ; border is printed on whole lower row

   call delay2
   call delay2      

   pop di
   pop cx
   pop ax
   pop es
   ret

;--------------------------------------- RULES PAGE BACKCOLOR --------------------------------------------------     
ruleback:
   push es
   push ax
   push cx
   push di
   mov ax, 0xb800
   mov es, ax           ; point es to video base

   mov di, 326          ; point di to top left column
   mov ax, 0x5020       ; space char in normal attribute
   
   mov cx, 18

ruleAgain:
   push cx
   push di

   mov cx, 74           ; number of screen locations
   cld                  ; auto increment mode
   rep stosw            ; clear the whole screen

   pop di
   add di, 160

   pop cx
   loop ruleAgain

   pop di
   pop cx
   pop ax
   pop es
   ret

;-------------------------------------------- GRID BACK -----------------------------------------------------   
gridback:
   push es
   push ax
   push cx
   push di
   mov ax, 0xb800
   mov es, ax           ; point es to video base

   mov di, 324          ; point di to top left column
   mov ax, 0x7020       ; space char in normal attribute
   
   mov cx, 21

gridAgain:
   push cx
   push di

   mov cx, 76      ; col no. to be printed of each row
   cld             ; auto increment mode
   rep stosw       ; clear the whole screen

   pop di
   add di, 160

   pop cx
   loop gridAgain

   pop di
   pop cx
   pop ax
   pop es
   ret

;--------------------------------------- INSTRUCTIONS ----------------------------------------------------
instruction:
   mov ax, 35
   push ax 
   mov ax, 4
   push ax   
   mov ax, 0x5E
   push ax   
   mov ax, instr
   push ax           ; push address of instruction heading 
   call printstr

   mov ax, 35
   push ax  
   mov ax, 5
   push ax       
   mov ax, 0x5E
   push ax     
   mov ax, insun
   push ax       ; push address of topic underline
   call printstr

   mov ax, 5
   push ax    
   mov ax, 8
   push ax   
   mov ax, 0x5E
   push ax   
   mov ax, instr1
   push ax           ; push address of instruction 1
   call printstr
   call delay

   mov ax, 5
   push ax  
   mov ax, 10
   push ax  
   mov ax, 0x5E
   push ax  
   mov ax, instr2
   push ax           ; push address of instruction 2
   call printstr
   call delay

   mov ax, 5
   push ax   
   mov ax, 12
   push ax   
   mov ax, 0x5E
   push ax  
   mov ax, instr3
   push ax           ; push address of instruction 3
   call printstr
   call delay

   mov ax, 5
   push ax  
   mov ax, 14
   push ax   
   mov ax, 0x5E
   push ax  
   mov ax, instr4
   push ax           ; push address of instruction 4
   call printstr
   call delay

   mov ax, 5
   push ax   
   mov ax, 16
   push ax   
   mov ax, 0x5E
   push ax   
   mov ax, instr5
   push ax           ; push address of instruction 5
   call printstr

   ret

;---------------------------------- GAME NAME PRINTING DURING GRID ---------------------------------------
gameHead:
   mov ax, 29
   push ax   
   mov ax, 3
   push ax  
   mov ax, 0x76
   push ax     
   mov ax, topic
   push ax           ; push address of topic
   call printstr

   mov ax, 29
   push ax  
   mov ax, 4
   push ax       
   mov ax, 0x76
   push ax     
   mov ax, topun
   push ax           ; push address of underline 
   call printstr

   ret

;--------------------------------------- GAME BOARD -------------------------------------------------------
printboard:
   push bp
   mov bp, sp

   mov ax, 10
   push ax     
   mov ax, 6
   push ax     
   mov ax, 0x34
   push ax     
   mov ax, underarr
   push ax           ; push address of (------), which will seperate each row of grid
   call printstr
   
   mov ax, 10
   push ax       ; push col number
   mov ax, 7
   push ax       ; push row number
   mov ax, 0x34
   push ax       ; red on cyan background 
   mov ax, [bp + 10]
   push ax           ; push address of first row of grid
   call printstr
   
   mov ax, 10
   push ax       ; push col number
   mov ax, 8
   push ax       ; push row number
   mov ax, 0x34
   push ax       ; red on cyan background 
   mov ax, underarr
   push ax           ; push address of (------), which will seperate each row of grid
   call printstr
   
   mov ax, 10
   push ax       ; push col number
   mov ax, 9
   push ax       ; push row number
   mov ax, 0x34
   push ax       ; red on cyan background 
   mov ax, [bp + 8]
   push ax           ; push address of second row of grid
   call printstr
   
   mov ax, 10
   push ax       ; push col number
   mov ax, 10
   push ax       ; push row number
   mov ax, 0x34
   push ax       ; red on cyan background 
   mov ax, underarr
   push ax           ; push address of (------), which will seperate each row of grid
   call printstr   
   
   mov ax, 10
   push ax       ; push col number
   mov ax, 11
   push ax       ; push row number
   mov ax, 0x34
   push ax       ; red on cyan background 
   mov ax, [bp + 6]
   push ax           ; push address of third row of grid
   call printstr
   
   mov ax, 10
   push ax       ; push col number
   mov ax, 12
   push ax       ; push row number
   mov ax, 0x34
   push ax       ; red on cyan background 
   mov ax, underarr
   push ax           ; push address of (------), which will seperate each row of grid
   call printstr
    
   mov ax, 10
   push ax       ; push col number
   mov ax, 13
   push ax       ; push row number
   mov ax, 0x34
   push ax       ; red on cyan background 
   mov ax, [bp + 4]
   push ax           ; push address of third row of grid
   call printstr
   
   mov ax, 10
   push ax       ; push col number
   mov ax, 14
   push ax       ; push row number
   mov ax, 0x34
   push ax       ; red on cyan background 
   mov ax, underarr
   push ax           ; push address of (------), which will seperate each row of grid
   call printstr
   
   pop bp
   ret 8

;--------------------------------------- LEVEL PROGRESS -------------------------------------------------------
levelProgress:
   push bp
   mov bp, sp

   call compilingResult
   call delay
   call delay
   call delay
   call border

   mov ax, 30     ;--------- progress report messege
   push ax   
   mov ax, 4
   push ax  
   mov ax, 0x0E
   push ax     
   mov ax, progress
   push ax           
   call printstr
   mov ax, 35      ;------- level no. messege
   push ax   
   mov ax, 8
   push ax  
   mov ax, 0x0D
   push ax     
   mov ax, [bp + 6]
   push ax          
   call printstr
   mov ax, 35     ;------- print score label only
   push ax   
   mov ax, 10
   push ax  
   mov ax, 0x0D 
   push ax     
   mov ax, scoreLabel
   push ax        
   call printstr

   mov ax, [bp + 4]
   cmp ax, 1
   jl poorVocab
   je goodVocab
   jg compareTwo

compareTwo:
   mov ax, [bp + 4]
   cmp ax, 2
   je VgoodVocab
   jg excellentVocab

poorVocab:
   mov ax, 43     ;------- print player score
   push ax   
   mov ax, 10
   push ax  
   mov ax, 0x0D 
   push ax     
   mov ax, score0
   push ax        
   call printstr
   mov ax, 32   ;----------- printing vocab 
   push ax   
   mov ax, 12
   push ax  
   mov ax, 0x03 
   push ax     
   mov ax, poor
   push ax        
   call printstr
   jmp completeReport

goodVocab:
   mov ax, 43     ;------- print player score
   push ax   
   mov ax, 10
   push ax  
   mov ax, 0x0D 
   push ax     
   mov ax, score1
   push ax        
   call printstr
   mov ax, 32    ;-------- print vocab
   push ax   
   mov ax, 12
   push ax  
   mov ax, 0x03 
   push ax     
   mov ax, good
   push ax        
   call printstr
   jmp completeReport

VgoodVocab:
   mov ax, 43     ;------- print player score
   push ax   
   mov ax, 10
   push ax  
   mov ax, 0x0D 
   push ax     
   mov ax, score2
   push ax        
   call printstr
   mov ax, 31   ;------- print vocab 
   push ax   
   mov ax, 12
   push ax  
   mov ax, 0x03 
   push ax     
   mov ax, vgood
   push ax        
   call printstr
   jmp completeReport

excellentVocab:
   mov ax, 43     ;------- print player score
   push ax   
   mov ax, 10
   push ax  
   mov ax, 0x0D 
   push ax     
   mov ax, score3
   push ax        
   call printstr
   mov ax, 28    ;-------- print vocab   
   push ax   
   mov ax, 12
   push ax  
   mov ax, 0x03 
   push ax     
   mov ax, excellent
   push ax        
   call printstr

completeReport:
   pop bp
   ret 4
;--------------------------------------- Taking Inputs -------------------------------------------------------
takeinput:
   push bp
   mov bp, sp
   push ax
   push bx
   push cx
   push si

   ;-------------- calculate di, to print user input 
   mov ax, 0xb800
   mov es, ax           ; point es to video base
   mov al, 80           ; load al with columns per row
   mul byte [bp + 4]    ; multiply with y position
   add ax, [bp + 6]     ; add x position
   shl ax, 1            ; turn into byte offset
   mov di,ax            ; point di to required location

   
   mov si, 0     ; initiallize si to feed input in memory 

againInput:

   mov ah, 1
   int 0x21
   
   mov ah, 0x75
   push ax

   cmp al, 0x20       ; check if user has pressed enter to finish input or not
   je finishInput     ; user pressed enter, and searched word

   pop ax

   mov [userinput + si], al
   inc si

   cld
   stosw          ; displaying input
   
   jmp againInput

finishInput:
   pop ax
   mov al, 0
   mov [userinput + si], al       ; making it a null terminated string

   pop si
   pop cx
   pop bx
   pop ax
   pop bp
   ret 4

;--------------------------------------- Verifying Inputs -------------------------------------------------------
verifyInput:   ; ---- for level 3
   push bp
   mov bp, sp 

   push ds   ;---------- compare with orignal word 1
   mov ax, orignalsalt
   push ax
   push ds
   mov ax, userinput
   push ax
   call strcmp
   cmp ax, 1
   je endsalt
   
   push ds   ;---------- compare with orignal word 2
   mov ax, orignaldam
   push ax
   push ds
   mov ax, userinput
   push ax
   call strcmp
   cmp ax, 1
   je enddam
   
   push ds   ;---------- compare with orignal word 3
   mov ax, orignallap
   push ax
   push ds
   mov ax, userinput
   push ax
   call strcmp
   cmp ax, 1
   je endlap
   jmp falseEnd
   
endsalt:
   mov ax, [salt]
   cmp ax, 0
   jne falseEnd
   inc ax
   mov [salt], ax
   jmp trueEnd
   
endlap:
   mov ax, [lap]
   cmp ax, 0
   jne falseEnd
   inc ax
   mov [lap], ax
   jmp trueEnd
   
enddam:
   mov ax, [dam]
   cmp ax, 0
   jne falseEnd
   inc ax
   mov [dam], ax
   jmp trueEnd

trueEnd:
   mov ax, 45    ; push col number
   push ax
   mov ax, [bp + 4]   ; push row no.
   push ax
   mov ax, 0x73       ; push attribute 
   push ax
   mov ax, gussed
   push ax
   call printstr
   xor ax, ax
   mov ax, [scoreCount]
   inc ax
   mov [scoreCount], ax
   jmp updateScore

falseEnd:
   mov ax, 45    ; push col number
   push ax
   mov ax, [bp + 4]   ; push row no.
   push ax
   mov ax, 0x73       ; push attribute 
   push ax
   mov ax, failed
   push ax
   call printstr  

terminateVerifyInput:
   pop bp
   ret 2

updateScore:             ; --------- updating current score
   mov ax, [scoreCount]
   cmp ax, 2
   jl one_score
   je two_score
   jg three_score
   
one_score:
   mov ax, 60 
   push ax  
   mov ax, 11
   push ax  
   mov ax, 0x70
   push ax       ; black on gray background 
   mov ax, score1
   push ax    
   call printstr
   jmp terminateVerifyInput
two_score:
   mov ax, 60 
   push ax  
   mov ax, 11
   push ax  
   mov ax, 0x70
   push ax       ; black on gray background 
   mov ax, score2
   push ax    
   call printstr
   jmp terminateVerifyInput
three_score:
   mov ax, 60 
   push ax  
   mov ax, 11
   push ax  
   mov ax, 0x70
   push ax       ; black on gray background 
   mov ax, score3
   push ax    
   call printstr
   jmp terminateVerifyInput

verifyInput1: ;-------------------------------- for level 1
   push bp
   mov bp, sp 

   push ds   ;---------- compare with orignal word bean
   mov ax, orignalbean
   push ax
   push ds
   mov ax, userinput
   push ax
   call strcmp
   cmp ax, 1
   je endbean
   jmp falseEnd1
   
endbean:
   mov ax, [bean]
   cmp ax, 0
   jne falseEnd1
   inc ax
   mov [bean], ax
   jmp trueEnd1

trueEnd1:
   mov ax, 45    ; push col number
   push ax
   mov ax, [bp + 4]   ; push row no.
   push ax
   mov ax, 0x73       ; push attribute 
   push ax
   mov ax, gussed
   push ax
   call printstr
   xor ax, ax
   mov ax, [scoreCount1]
   inc ax
   mov [scoreCount1], ax
   jmp updateScore1

falseEnd1:
   mov ax, 45    ; push col number
   push ax
   mov ax, [bp + 4]   ; push row no.
   push ax
   mov ax, 0x73       ; push attribute 
   push ax
   mov ax, failed
   push ax
   call printstr  

terminateVerifyInput1:
   pop bp
   ret 2

updateScore1:   ; --------- updating current score
   mov ax, 60 
   push ax  
   mov ax, 11
   push ax  
   mov ax, 0x70
   push ax       ; black on gray background 
   mov ax, score1
   push ax    
   call printstr
   jmp terminateVerifyInput1

verifyInput2:   ; ------------------------------------ for level 2
   push bp
   mov bp, sp 

   push ds   ;---------- compare with orignal word 1
   mov ax, orignalvain
   push ax
   push ds
   mov ax, userinput
   push ax
   call strcmp
   cmp ax, 1
   je endvain
   
   push ds   ;---------- compare with orignal word 2
   mov ax, orignalcalm
   push ax
   push ds
   mov ax, userinput
   push ax
   call strcmp
   cmp ax, 1
   je endcalm
   jmp falseEnd
   
endvain:
   mov ax, [vain]
   cmp ax, 0
   jne falseEnd2
   inc ax
   mov [vain], ax
   jmp trueEnd2
   
endcalm:
   mov ax, [calm]
   cmp ax, 0
   jne falseEnd2
   inc ax
   mov [calm], ax
   jmp trueEnd2
   
trueEnd2:
   mov ax, 45    ; push col number
   push ax
   mov ax, [bp + 4]   ; push row no.
   push ax
   mov ax, 0x73       ; push attribute 
   push ax
   mov ax, gussed
   push ax
   call printstr
   xor ax, ax
   mov ax, [scoreCount2]
   inc ax
   mov [scoreCount2], ax
   jmp updateScore2

falseEnd2:
   mov ax, 45    ; push col number
   push ax
   mov ax, [bp + 4]   ; push row no.
   push ax
   mov ax, 0x73       ; push attribute 
   push ax
   mov ax, failed
   push ax
   call printstr  

terminateVerifyInput2:
   pop bp
   ret 2

updateScore2:             ; ----------- updating current score
   mov al, [scoreCount2]
   cmp al, 2
   jl one_score2
   je two_score2
   
one_score2:
   mov ax, 60 
   push ax  
   mov ax, 11
   push ax  
   mov ax, 0x70
   push ax 
   mov ax, score1
   push ax    
   call printstr
   jmp terminateVerifyInput2
two_score2:
   mov ax, 60 
   push ax  
   mov ax, 11
   push ax  
   mov ax, 0x70
   push ax  
   mov ax, score2
   push ax    
   call printstr
   jmp terminateVerifyInput2
   
;----------------------------------------------- Input Procedures of all levels -------------------------------------------------------   
inputProcedure:    ; for level 3
   push ax
   push bx
   push cx

   mov ax, 52    ;----------------- Printing level no.
   push ax  
   mov ax, 9
   push ax  
   mov ax, 0x70
   push ax     
   mov ax, level3
   push ax    
   call printstr

   call inputCred

   mov bx, 18
   mov cx, 3

againSearchLabel:     ;------------- Searched word label printing
   mov ax, 18  
   push ax  
   mov ax, bx
   push ax  
   mov ax, 0x71
   push ax      
   mov ax, inputMessege2
   push ax    
   call printstr
   inc bx
   loop againSearchLabel

   mov bx, 18
   mov cx, 3

oneMoreInput:       ;--------------- Printing user input and score side by side
   mov ax, 36   
   push ax    
   mov ax, bx
   push ax
   call takeinput  
   
   push bx
   call verifyInput
   
   inc bx   ; heading to next row
   loop oneMoreInput

   pop cx
   pop bx
   pop ax
   ret

inputProcedure1:      ;-------------------------------- for level 1
   push ax
   push bx
   push cx

   mov ax, 52    ;----------------- Printing level no.
   push ax  
   mov ax, 9
   push ax  
   mov ax, 0x70
   push ax    
   mov ax, level1
   push ax    
   call printstr

   call inputCred

   mov ax, 18   ;--------------- Searched word label printing
   push ax  
   mov ax, 18
   push ax  
   mov ax, 0x71
   push ax      
   mov ax, inputMessege2
   push ax    
   call printstr

   mov ax, 36  ;------------------ Printing user input and score side by side
   push ax    
   mov ax, 18
   push ax
   call takeinput
   mov bx, 18
   push bx
   call verifyInput1

   pop cx
   pop bx
   pop ax
   ret

inputProcedure2:    ;-------------------------------- for level 2
   push ax
   push bx
   push cx

   mov ax, 52    ;----------------- Printing level no.
   push ax  
   mov ax, 9
   push ax  
   mov ax, 0x70
   push ax     
   mov ax, level2
   push ax    
   call printstr 

   call inputCred

   mov bx, 18
   mov cx, 2

againSearchLabel2:     ;------------- Searched word label printing
   mov ax, 18  
   push ax  
   mov ax, bx
   push ax  
   mov ax, 0x71
   push ax     
   mov ax, inputMessege2
   push ax    
   call printstr
   inc bx
   loop againSearchLabel2

   mov bx, 18
   mov cx, 2

oneMoreInput2:       ;--------------- Printing user input and score
   mov ax, 36   
   push ax    
   mov ax, bx
   push ax
   call takeinput  
   
   push bx
   call verifyInput2
   
   inc bx   ; heading to next row
   loop oneMoreInput2

   pop cx
   pop bx
   pop ax
   ret
   
;--------------------------------------- START OF MAIN ----------------------------------------------------
start:

;jmp starter
call border
call welcomeMessege
call delay2
call vocabtest
call delay2
call continueKey
mov ax, 0
int 0X16

call border
call ruleback
call continueKey
call instruction
mov ax, 0
int 0X16

;starter:
call mainCred        ;-------------------- LEVEL # 1
mov ax, level_1_arr1
push ax
mov ax, level_1_arr2
push ax
mov ax, level_1_arr3
push ax
mov ax, level_1_arr4
push ax
call printboard
call inputProcedure1
mov ax, level1
push ax
push word[scoreCount1]
call levelProgress
call nextLevelKey
mov ax, 0
int 0x16

call mainCred        ;-------------------- LEVEL # 2
mov ax, level_2_arr1
push ax
mov ax, level_2_arr2
push ax
mov ax, level_2_arr3
push ax
mov ax, level_2_arr4
push ax
call printboard
call inputProcedure2
mov ax, level2
push ax
push word[scoreCount2]
call levelProgress
call nextLevelKey
mov ax, 0
int 0x16

call mainCred        ;-------------------- LEVEL # 3
mov ax, wordarr1
push ax
mov ax, wordarr2
push ax
mov ax, wordarr3
push ax
mov ax, wordarr4
push ax
call printboard
call inputProcedure
mov ax, level3
push ax
push word[scoreCount]
call levelProgress
mov ax, 9
push ax      
mov ax, 19
push ax     
mov ax, 0x0E
push ax      
mov ax, thanks
push ax         
call printstr

mov ax, 0x4c00
int 0x21