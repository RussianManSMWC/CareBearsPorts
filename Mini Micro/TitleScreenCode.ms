//exclusive functions for the title screen (I could've moved MoveCursor one in HandyFunctions.ms as well if I wanted menues outside of title screen, but there's no such thing as "outside of title screen"
DisplayFileStatus = function(x,y,FileProgress)
  if FileProgress isa number then
    StringToDisplay = FileProgress + " EXITS  "
  else
    StringToDisplay = FileProgress + "      " //empty spaces to clear the stray "ITS" part of "EXITS"
  end if
  DisplayText(x,y,StringToDisplay) //call that other function. function within function... functception!!!
end function

MoveCursor = function(CursorChoice,InputUp,InputDown,NumOfOptions)
  if InputUp then
    if CursorChoice == 0 then
      CursorChoice = NumOfOptions //can't select non-file options
    else
      CursorChoice = CursorChoice-1
    end if
  else if InputDown then
    if CursorChoice == NumOfOptions then
      CursorChoice = 0
    else
      CursorChoice = CursorChoice+1
    end if
  end if
  return CursorChoice
end function

clear
text.color = color.white //default font color = white

TitleScreenOptionsBaseTextPositionX = 26
TitleScreenOptionsBaseTextPositionY = 17 //16
MaxOptions = 7

CursorOptionsBaseYPosition = TitleScreenOptionsBaseTextPositionY*24+19//403
CursorOptionsBaseXPosition = TitleScreenOptionsBaseTextPositionX*14-8 //in case I wanted to adjust TitleScreenOptionsBaseTextPositionX (which I did, it was 24 before)

CharacterChoice_CursorOnBedtimeXPos = 300
CharacterChoice_CursorOnSweetDreamsXPos = 600
CharacterChoice_CursorYPosition = 40

//constants (theoretically)
KeyPress_Right = 0
KeyPress_Left = 1
KeyPress_Down = 2
KeyPress_Up = 3
KeyPress_Start = 4
KeyPress_Select = 5
KeyPress_B = 6
KeyPress_A = 7

//keyboard keys corrsponding to these buttons
KeyAssignment_Right = "right"
KeyAssignment_Left = "left"
KeyAssignment_Down = "down"
KeyAssignment_Up = "up"
KeyAssignment_Start = "enter"
KeyAssignment_Select = "right shift"
KeyAssignment_B = "z"
KeyAssignment_A = "x"

//initialize the table of y-positions for each option
CursorOnOptionsYPositions = [CursorOptionsBaseYPosition]
i = 0
y = 0
while i != MaxOptions
  y=y+48 //offset
  CursorOnOptionsYPositions.push CursorOptionsBaseYPosition-y
  i = i+1
end while

//FilesProgress = ["EMPTY","EMPTY","EMPTY"]

CursorXPositions = [CursorOptionsBaseXPosition,CursorOptionsBaseXPosition,CursorOptionsBaseXPosition]
CursorYPositions = [CursorOptionsBaseYPosition,CursorOptionsBaseYPosition,CursorOptionsBaseYPosition]
Cursor1Choice = 0 //these also could've been turned into a list but w/e
Cursor2Choice = 0
Cursor3Choice = 0 //max 3 cursors (when file copying)
//CursorOptionExceptions = []

BlinkCounter = 0

TitleScreenTask = 0

CursorImage = "grafix/Cursor.png"

Cursor1 = SpawnSprite(CursorXPositions[0],CursorYPositions[0],CursorImage)
Cursor2 = SpawnSprite(CursorXPositions[1],CursorYPositions[1],CursorImage)
Cursor3 = SpawnSprite(CursorXPositions[2],CursorYPositions[2],CursorImage)
Cursor2.scale = 0 //hidden
Cursor3.scale = 0 //hidden

ChoseFileForCopy = false

SpawnSprite(240,42,"grafix/Bear_TheOtherOne.png") //just shows how well I know the source material
SpawnSprite(660,42,"grafix/Bear_SweetDreams.png") //also, this is NOT lavender, this is Sweet Dreams, all this time I got the name wrong because of the joke with my friend, that Sweet Dreams was "Lavender Bedtime". Like "Mario and Green Mario"

//B5EBF2 = 181,235,242
display(7).color = color.rgb(181,235,242)//color.blue
display(5).clear color.clear //idk

KeyHoldFlags = [false,false,false,false,false,false,false,false]
KeyPressFlags = [false,false,false,false,false,false,false,false]
KeyPressMaskFlags = [false,false,false,false,false,false,false,false]
//KeyHoldFlags_LastFrame = KeyHoldFlags //as it turns out this does NOT give it the same value, it basically assigns another meaning to it

//print "press A key to break out of this while loop!!"

//moved this out of the while loop, these lines aren't dynamic (don't need to redraw them)
  DisplayText(TitleScreenOptionsBaseTextPositionX,TitleScreenOptionsBaseTextPositionY-6,"COPY")
  DisplayText(TitleScreenOptionsBaseTextPositionX,TitleScreenOptionsBaseTextPositionY-8,"ERASE")
  DisplayText(TitleScreenOptionsBaseTextPositionX,TitleScreenOptionsBaseTextPositionY-10,"TEST")
  DisplayText(TitleScreenOptionsBaseTextPositionX,TitleScreenOptionsBaseTextPositionY-12,"QUIT")

TitleScreenRunningFlag = true

while TitleScreenRunningFlag == true
  //update exit count displays (displays a number + "EXITS" or "EMPTY" if the saave file is unused
  DisplayFileStatus(TitleScreenOptionsBaseTextPositionX,TitleScreenOptionsBaseTextPositionY,FilesProgress[0])
  DisplayFileStatus(TitleScreenOptionsBaseTextPositionX,TitleScreenOptionsBaseTextPositionY-2,FilesProgress[1])
  DisplayFileStatus(TitleScreenOptionsBaseTextPositionX,TitleScreenOptionsBaseTextPositionY-4,FilesProgress[2])

  //get key inputs
  if key.available then
    if key.pressed(KeyAssignment_Up) then
      KeyHoldFlags[KeyPress_Up] = true
    else
      KeyHoldFlags[KeyPress_Up] = false
      KeyPressMaskFlags[KeyPress_Up] = false //mask cleared, a press can be registered again
    end if
    
    if key.pressed(KeyAssignment_Down) then
      KeyHoldFlags[KeyPress_Down] = true
    else
      KeyHoldFlags[KeyPress_Down] = false
      KeyPressMaskFlags[KeyPress_Down] = false
    end if
    
    if key.pressed(KeyAssignment_Left) then
      KeyHoldFlags[KeyPress_Left] = true
    else
      KeyHoldFlags[KeyPress_Left] = false
      KeyPressMaskFlags[KeyPress_Left] = false
    end if
    
    if key.pressed(KeyAssignment_Right) then
      KeyHoldFlags[KeyPress_Right] = true
    else
      KeyHoldFlags[KeyPress_Right] = false
      KeyPressMaskFlags[KeyPress_Right] = false
    end if
    
    if key.pressed(KeyAssignment_B) then
      KeyHoldFlags[KeyPress_B] = true
    else
      KeyHoldFlags[KeyPress_B] = false
      KeyPressMaskFlags[KeyPress_B] = false
    end if
    
    if key.pressed(KeyAssignment_A) then
      KeyHoldFlags[KeyPress_A] = true
    else
      KeyHoldFlags[KeyPress_A] = false
      KeyPressMaskFlags[KeyPress_A] = false
    end if
    
    if key.pressed(KeyAssignment_Start) then
      KeyHoldFlags[KeyPress_Start] = true
    else
      KeyHoldFlags[KeyPress_Start] = false
      KeyPressMaskFlags[KeyPress_Start] = false
    end if
 
    if key.pressed(KeyAssignment_Select) then
      KeyHoldFlags[KeyPress_Select] = true
    else
      KeyHoldFlags[KeyPress_Select] = false
      KeyPressMaskFlags[KeyPress_Select] = false
    end if
 
    for i in range(0,KeyPressFlags.len-1)
      if KeyHoldFlags[i] and not KeyPressMaskFlags[i] then
        KeyPressFlags[i] = true
        KeyPressMaskFlags[i] = true //press ONCE PLZ
      else
        KeyPressFlags[i] = false
      end if
    end for
    
  end if

  //no switch and case? boo! similar to python
  if TitleScreenTask == 0 then
  /////////////////////////////////////////////////////////////
  //BLOCK OF CODE: CHOOSING STUFF
  /////////////////////////////////////////////////////////////
  
    CursorYPositions[0] = CursorOnOptionsYPositions[Cursor1Choice] //cursor one is always on the options
    CursorYPositions[1] = CursorOnOptionsYPositions[0] // \default currently inactive cursors to this y-pos
    CursorYPositions[2] = CursorOnOptionsYPositions[0] // /
    
    Cursor1Choice = MoveCursor(Cursor1Choice,KeyPressFlags[KeyPress_Up],KeyPressFlags[KeyPress_Down],MaxOptions-1)
  //other actions tba
    if KeyPressFlags[KeyPress_A] then //in this case it's going to z
      if Cursor1Choice <= 2 then //if the cursor was on one of 3 files
        TitleScreenTask = 1
        Cursor2.scale = 1

        //default it on Bedtime character
        CursorXPositions[1] = CharacterChoice_CursorOnBedtimeXPos
        CursorYPositions[1] = CharacterChoice_CursorYPosition
        Cursor2.rotation = 180 //x-flip by default
        CharacterChoice = 0
      else if Cursor1Choice == 3 then //if the cursor was on the copy option
        TitleScreenTask = 2
        Cursor2.scale = 1 //a wild cursor 2 appears!
      else if Cursor1Choice == 4 then //if the cursor was on the delete option
        TitleScreenTask = 3
        Cursor2.scale = 1
      else if Cursor1Choice == 5 then
        FilesProgress[0] = 33 //fill with fake progress
      else
        globals.GameRunningFlag = false //game ends just like that
        TitleScreenRunningFlag = false //title screen ends just like that
      end if
    end if
  
  else if TitleScreenTask == 1 then
  /////////////////////////////////////////////////////////////
  //BLOCK OF CODE: SELECTED FILE, CHOOSE CHARACTER
  /////////////////////////////////////////////////////////////
  
    //blink boy
    BlinkCounter = BlinkCounter+1 //original decreases until 0, but functionally the same

    if BlinkCounter == 15 then
      Cursor1.scale = not(Cursor1.scale)
      BlinkCounter = 0
    end if
    
    //B option, no A (there's no game, remember?)
    if KeyPressFlags[KeyPress_B] then
      TitleScreenTask = 0
      Cursor2.scale = 0 //second cursor disappears
      Cursor2.rotation = 0 //make sure it isn't flipped for other procedures
      
      Cursor1.scale = 1 //make sure the cursor isn't invisible from the blinking
      
      //return the second cursor on files in case we're going to do stuff with them
      CursorXPositions[1] = CursorOptionsBaseXPosition
      //CursorYPositions[1] = CursorOnOptionsYPositions[0]
      
    else
      if KeyPressFlags[KeyPress_Right] or KeyPressFlags[KeyPress_Left] then
        CharacterChoice = not CharacterChoice //either way it goes, it changes on one of the characters (can wrap around)
      end if
      
      //handle character cursor positioning and x-flip
      if CharacterChoice then
        CursorXPositions[1] = CharacterChoice_CursorOnSweetDreamsXPos
        Cursor2.rotation = 0 //no x-flip
      else
        CursorXPositions[1] = CharacterChoice_CursorOnBedtimeXPos
        Cursor2.rotation = 180 //x-flip
      end if
      
    end if
  else if TitleScreenTask == 2 then
  /////////////////////////////////////////////////////////////
  //BLOCK OF CODE: COPYING STUFF
  /////////////////////////////////////////////////////////////

    //blink cursor one every now and then
    BlinkCounter = BlinkCounter+1

    if BlinkCounter == 15 then
      Cursor1.scale = not(Cursor1.scale) //EOR, or XOR if you will
      BlinkCounter = 0
    end if
    
    CursorYPositions[1] = CursorOnOptionsYPositions[Cursor2Choice]
    CursorYPositions[2] = CursorOnOptionsYPositions[Cursor3Choice]
    
    if ChoseFileForCopy then 
      Cursor3Choice = MoveCursor(Cursor3Choice,KeyPressFlags[KeyPress_Up],KeyPressFlags[KeyPress_Down],MaxOptions-4)
      
      if Cursor3Choice == Cursor2Choice then
        if KeyPressFlags[KeyPress_Up] then
          Cursor3Choice = MoveCursor(Cursor3Choice,true,false,MaxOptions-4)
        else //assume moved it down
          Cursor3Choice = MoveCursor(Cursor3Choice,false,true,MaxOptions-4)
        end if
      end if
      
      //A and B actions for copying
      if KeyPressFlags[KeyPress_A] then
        FilesProgress[Cursor3Choice] = FilesProgress[Cursor2Choice] //copy the progress over
      else if KeyPressFlags[KeyPress_B] then
        ChoseFileForCopy = false //cancel copying the file
        Cursor3.scale = 0 //cursor 3 begone
        Cursor3Choice = 0
      end if
      
    else
      Cursor2Choice = MoveCursor(Cursor2Choice,KeyPressFlags[KeyPress_Up],KeyPressFlags[KeyPress_Down],MaxOptions-4)

      //A and B actions for choosig a file to copy
      if KeyPressFlags[KeyPress_A] then
        ChoseFileForCopy = true
        Cursor3.scale = 1 //enable third cursor
        
        if Cursor2Choice == 0 then
          Cursor3Choice = 1 //don't overlap cursors
        end if
      else if KeyPressFlags[KeyPress_B] then
        TitleScreenTask = 0  //cancelled copying
        Cursor1.scale = 1 //make sure the cursor isn't invisible from the blinking
        Cursor2.scale = 0
        
        Cursor2Choice = 0
        Cursor3Choice = 0
        
        CursorYPositions[1] = CursorOnOptionsYPositions[0]
      end if
      
    end if
  else if TitleScreenTask == 3 then
  /////////////////////////////////////////////////////////////
  //BLOCK OF CODE: DELETING STUFF
  /////////////////////////////////////////////////////////////
    
    //It's blinking time
    BlinkCounter = BlinkCounter+1

    if BlinkCounter == 15 then
      Cursor1.scale = not(Cursor1.scale)
      BlinkCounter = 0
    end if
    
    CursorYPositions[1] = CursorOnOptionsYPositions[Cursor2Choice]

    Cursor2Choice = MoveCursor(Cursor2Choice,KeyPressFlags[KeyPress_Up],KeyPressFlags[KeyPress_Down],MaxOptions-4)

    //A and B actions for choosing a file to delete
    if KeyPressFlags[KeyPress_A] then
      FilesProgress[Cursor2Choice] = "EMPTY" //delete (not even a pop-up for a warning, that's bad game design right there, amiright guys)
    else if KeyPressFlags[KeyPress_B] then
      TitleScreenTask = 0
      Cursor1.scale = 1 //make sure the cursor isn't invisible from the blinking
      Cursor2.scale = 0
        
      Cursor2Choice = 0
    end if
  end if
  
  UpdateSprite(Cursor1,CursorXPositions[0],CursorYPositions[0],CursorImage)
  UpdateSprite(Cursor2,CursorXPositions[1],CursorYPositions[1],CursorImage)
  UpdateSprite(Cursor3,CursorXPositions[2],CursorYPositions[2],CursorImage)
  
  //if key.pressed("a") then //aaa, get me out of here!
  //  globals.GameRunningFlag = false //game ends just like that
  //  TitleScreenRunningFlag = false //title screen ends just like that
    
  //  GameMode = GameMode_Cutscene
  //end if
  
  yield //I yield, I yield! ...for one frame!
  
end while

key.clear //don't spill the beans on the next action, I guess
clear //clear the screen