import pyxel

#these defines are local to the title screen... i think

#X/Y
TitleScreen_BedtimeCoords = [17,154] #lists instead of topples... in case we want to move them in real time, like, I dunno... an easter egg or something.
TitleScreen_SweetDreamsCoords = [153,154]

#X/Y within sprite sheet
TitleScreen_BedtimeGFXCoords = (0,0)
TitleScreen_SweetDreamsGFXCoords = (88,0)

#Size (w/h, remember that negative values result in x/y flip)
TitleScreen_BearsDimensions = [88,87]

BaseStringsCoords = [104,72]
TitleScreenStrings = (
"FILE 1 -",
"FILE 2 -",
"FILE 3 -",
"COPY",
"ERASE",
"TEST",
"QUIT"
)

MaxOptions = len(TitleScreenStrings)-1

BaseFileStatusCoords = [176,72]

CursorOnOptionsXPosition = 0x56
CursorOnOptionsYPositions = (0x43,0x53,0x63,0x73,0x83,0x93,0xA3)
CursorGFXCoords = (176,0)

CursorOnCharactersXPositions = (0x60,0x90)
CursorOnCharactersYPosition = 0xB0


#16x16
CursorDimensions = [16,16]
CursorDimensions_DONTSHOW = [0,0] #for cursors that should not even appear. pretty please?

Cursor1XPos = CursorOnOptionsXPosition
Cursor2XPos = CursorOnOptionsXPosition
Cursor3XPos = CursorOnOptionsXPosition

Cursor1YPos = CursorOnOptionsYPositions[0]
Cursor2YPos = CursorOnOptionsYPositions[0]
Cursor3YPos = CursorOnOptionsYPositions[0]

Cursor1Dimensions = CursorDimensions[:] #cursor 1 is guaranteed to show up (except when it's blinking)
Cursor2Dimensions = CursorDimensions_DONTSHOW[:]
Cursor3Dimensions = CursorDimensions_DONTSHOW[:]

CursorOptionPositions = [0,0,0] #default to file 1

CursorBlinkCounter = 0
ShowCursorFlag = False

class TitleScreen():

    #if only these were inherited by functions so I didn't have to copy this over...
    #global Cursor1Dimensions
    #global Cursor2Dimensions
    #global Cursor3Dimensions

    def MoveCursor(CursorChoice,InputUp,InputDown,NumOfOptions):
        if InputUp:
            pyxel.play(0,0) #move cursor sfx
            if CursorChoice == 0:
                CursorChoice = NumOfOptions #can't select non-file options
            else:
                CursorChoice = CursorChoice-1
        elif InputDown:
            pyxel.play(0,0)
            if CursorChoice == NumOfOptions:
                CursorChoice = 0
            else:
                CursorChoice = CursorChoice+1
        return CursorChoice

    def BlinkCursor():
        global Cursor1Dimensions
        global CursorBlinkCounter
        global ShowCursorFlag
        
        if CursorBlinkCounter:
            CursorBlinkCounter = CursorBlinkCounter-1
        else:
            CursorBlinkCounter = 15 #with lower framerates. this is slower.... obviously. because the game is slow!
            if ShowCursorFlag == True:
                ShowCursorFlag = False
                Cursor1Dimensions = CursorDimensions_DONTSHOW[:]
            else:
                ShowCursorFlag = True
                Cursor1Dimensions = CursorDimensions[:]

######################################################
#Title Screen-specific main code 
    def run(self):
        global Cursor1Dimensions
        global Cursor2Dimensions
        global Cursor3Dimensions
        
        #global Cursor1XPos
        global Cursor2XPos #x-position of the cursor 2 is the only one that we modify
        #global Cursor3XPos
        
        global Cursor1YPos
        global Cursor2YPos
        global Cursor3YPos
    
        TitleScreenTask = self.TitleScreenTask
        match TitleScreenTask:
            case TitleScreenTask.Selecting:
                #handle cursor movement
                
                CursorOptionPositions[0] = TitleScreen.MoveCursor(CursorOptionPositions[0],pyxel.btnp(self.KeyAssignment_Up),pyxel.btnp(self.KeyAssignment_Down),MaxOptions)
                Cursor1YPos = CursorOnOptionsYPositions[CursorOptionPositions[0]]

                
                if pyxel.btnp(self.KeyAssignment_A):
                    if CursorOptionPositions[0] <= 2:
                        self.TitleScreenTask = self.TitleScreenTask.ChoseFile
                        Cursor2Dimensions = CursorDimensions[:]
                        Cursor2Dimensions[0] *= -1 #x-flip by default (negative width = image mirrored horizontally)
                        
                        #show cursor 2 on characters
                        Cursor2XPos = CursorOnCharactersXPositions[0]
                        Cursor2YPos = CursorOnCharactersYPosition
                        
                    elif CursorOptionPositions[0] == 3:
                        self.TitleScreenTask = self.TitleScreenTask.ChoseCopy
                        Cursor2Dimensions = CursorDimensions[:]
                        
                        global ChoseFileForCopy
                        ChoseFileForCopy = False
                        
                    elif CursorOptionPositions[0] == 4:
                        self.TitleScreenTask = self.TitleScreenTask.ChoseErase
                        Cursor2Dimensions = CursorDimensions[:]
                    elif CursorOptionPositions[0] == 5:
                        self.FilesProgress[0] = "33\n" #fill with fake progress
                        Cursor1XPos = 10
                    elif CursorOptionPositions[0] == 6:
                        pyxel.quit() #rage quit

            case TitleScreenTask.ChoseFile:
                TitleScreen.BlinkCursor()
                
                #move between characters (only 2 characters)
                temp = Cursor2XPos
                CursorOptionPositions[1] = TitleScreen.MoveCursor(CursorOptionPositions[1],pyxel.btnp(self.KeyAssignment_Left),pyxel.btnp(self.KeyAssignment_Right),1)
                Cursor2XPos = CursorOnCharactersXPositions[CursorOptionPositions[1]]
                
                #if we changed the position, the cursor flips
                if temp != Cursor2XPos:
                    Cursor2Dimensions[0] *= -1
                    
                if pyxel.btnp(self.KeyAssignment_B):
                    pyxel.play(1,1) #cancel sfx
                    self.TitleScreenTask = self.TitleScreenTask.Selecting
                    
                    CursorOptionPositions[1] = 0                #default on file 1 or, in case of character select, bedtime
                    Cursor2XPos = CursorOnOptionsXPosition      #\default its position
                    Cursor2YPos = CursorOnOptionsYPositions[0]  #/
                    Cursor2Dimensions[0] = 0 #cursor becomes invisible

                    Cursor1Dimensions = CursorDimensions[:] #make sure the first cursor is visible if we caught it in the moment of blinking out of existence
                
            case TitleScreenTask.ChoseCopy:
                TitleScreen.BlinkCursor()
            
                if ChoseFileForCopy:
                    CursorOptionPositions[2] = TitleScreen.MoveCursor(CursorOptionPositions[2],pyxel.btnp(self.KeyAssignment_Up),pyxel.btnp(self.KeyAssignment_Down),MaxOptions-4)
                    
                    #cursors 2 and 3 can't be on the same position
                    if CursorOptionPositions[2] == CursorOptionPositions[1]:
                        CursorOptionPositions[2] = TitleScreen.MoveCursor(CursorOptionPositions[2],pyxel.btnp(self.KeyAssignment_Up),pyxel.btnp(self.KeyAssignment_Down),MaxOptions-4)
                    
                    Cursor3YPos = CursorOnOptionsYPositions[CursorOptionPositions[2]]
                    
                    if pyxel.btnp(self.KeyAssignment_B):
                        pyxel.play(1,1) #cancel sfx
                        ChoseFileForCopy = False
                        
                        CursorOptionPositions[2] = 0                #default on file 1
                        Cursor3XPos = CursorOnOptionsXPosition      #\default its position
                        Cursor3YPos = CursorOnOptionsYPositions[0]  #/
                        Cursor3Dimensions[0] = 0 #cursor becomes invisible
                        
                    elif pyxel.btnp(self.KeyAssignment_A):
                        #copy-paste job
                        self.FilesProgress[CursorOptionPositions[2]] = self.FilesProgress[CursorOptionPositions[1]]
                else:
                    CursorOptionPositions[1] = TitleScreen.MoveCursor(CursorOptionPositions[1],pyxel.btnp(self.KeyAssignment_Up),pyxel.btnp(self.KeyAssignment_Down),MaxOptions-4)
                    Cursor2YPos = CursorOnOptionsYPositions[CursorOptionPositions[1]]
                
                    if pyxel.btnp(self.KeyAssignment_B):
                        pyxel.play(1,1) #cancel sfx
                        self.TitleScreenTask = self.TitleScreenTask.Selecting
                    
                        CursorOptionPositions[1] = 0                #default on file 1 or, in case of character select, bedtime
                        Cursor2XPos = CursorOnOptionsXPosition      #\default its position
                        Cursor2YPos = CursorOnOptionsYPositions[0]  #/
                        Cursor2Dimensions[0] = 0 #cursor becomes invisible
                        
                        Cursor1Dimensions = CursorDimensions[:] #cursor 1 MUST be on screen
                        
                    elif pyxel.btnp(self.KeyAssignment_A):
                        ChoseFileForCopy = True
                    
                        Cursor3Dimensions = CursorDimensions[:] #cursor 3 is the unexpected celebrity cameo of this episode
                        
                        #don't overlap cursors
                        if CursorOptionPositions[2] == CursorOptionPositions[1]:
                            CursorOptionPositions[2] = 1
                        else:
                            CursorOptionPositions[2] = 0

            case TitleScreenTask.ChoseErase:
                TitleScreen.BlinkCursor()
                CursorOptionPositions[1] = TitleScreen.MoveCursor(CursorOptionPositions[1],pyxel.btnp(self.KeyAssignment_Up),pyxel.btnp(self.KeyAssignment_Down),MaxOptions-4)
                Cursor2YPos = CursorOnOptionsYPositions[CursorOptionPositions[1]]
                
                if pyxel.btnp(self.KeyAssignment_B):
                    pyxel.play(1,1) #you guessed it, cancel sfx
                    self.TitleScreenTask = self.TitleScreenTask.Selecting
                    
                    CursorOptionPositions[1] = 0                #default on file 1 or, in case of character select, bedtime
                    Cursor2XPos = CursorOnOptionsXPosition      #\default its position
                    Cursor2YPos = CursorOnOptionsYPositions[0]  #/
                    Cursor2Dimensions[0] = 0 #cursor becomes invisible
                        
                    Cursor1Dimensions = CursorDimensions[:] #cursor 1 MUST be on screen
                elif pyxel.btnp(self.KeyAssignment_A):
                    self.FilesProgress[CursorOptionPositions[1]] = "EMPTY\n"


######################################################
#Title Screen-specific drawing code 
    def draw(self):
        #draw bears
        self.DrawSprite(TitleScreen_BedtimeCoords,TitleScreen_BedtimeGFXCoords,TitleScreen_BearsDimensions)
        self.DrawSprite(TitleScreen_SweetDreamsCoords,TitleScreen_SweetDreamsGFXCoords,TitleScreen_BearsDimensions)
        
        #draw text
        xy = BaseStringsCoords[:] #copy values from base coordinates list (do NOT treat xy as the same list as BaseStringsCoords and modify BaseStringsCoords indirectly)
        for i in TitleScreenStrings:
            self.DrawString(xy,i)
            xy[1]+=16 #x-pos remains the same, but the y-pos shifts 16px

        #draw file progress
        xy = BaseFileStatusCoords[:]
        #FilesProgress list MUST have all entries as string type
        for i in self.FilesProgress:
            if i == "EMPTY\n":
                self.DrawString(xy,i)
            else:
                #I just now realized that if we have 1 exit, it would print 1 exits... which is a minor silly thing that I won't fix LOL!!! not that this is a real game anyway for it to matter much.
                self.DrawString(xy,i+"EXITS") #\n is parsed as an empty space because it's a character that isn't defined in the character table
            xy[1]+=16 #yet again, offset by 16px
        
        #draw cursors (or "draw" in case they're not on-screen)
        self.DrawSprite([Cursor1XPos,Cursor1YPos],CursorGFXCoords,Cursor1Dimensions)
        self.DrawSprite([Cursor2XPos,Cursor2YPos],CursorGFXCoords,Cursor2Dimensions)
        self.DrawSprite([Cursor3XPos,Cursor3YPos],CursorGFXCoords,Cursor3Dimensions)