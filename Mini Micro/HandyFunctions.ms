//generic functions that can be used anywhere (because they're global)

//a fairly straightforward function
globals.DisplayText = function(x,y,Text)
  text.column = x
  text.row = y
  print(Text)
end function

//a basic sprite displaying functionality (no rotation, scale or tint, just generates the image and spawns it at the coordinateses)
globals.SpawnSprite = function(x,y,ImgSource)
  Image = new Sprite
  Image.image = file.loadImage(ImgSource)
  Image.x = x
  Image.y = y
  display(4).sprites.push Image
  return Image
end function

//updates sprite position and graphics
globals.UpdateSprite = function(Image,x,y,ImgSource)
  Image.image = file.loadImage(ImgSource)
  Image.x = x
  Image.y = y
  //display(4).sprites.push Image
  //return Image
end function