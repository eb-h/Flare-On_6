
num = 0

RIGHTWALL = 23;
BOTTOMWALL = 21;
STARTING_Y = 11;
DIRECTION = {
  UP = 2,
  DOWN = 3,
  LEFT = 1,
  RIGHT = 0,
};

-- 5 is intended direction
-- 4 is current direction

-- emu.speedmode("turbo");

while (true) do

  time_counter = memory.readbyte(0xC)

  currentDirection = memory.readbyte(4)
  currentLength = memory.readbyte(0xA);
  currentX = memory.readbyte(0x7)
  currentY = memory.readbyte(0x8)
  
  -- handle very first move in game
  if currentX == RIGHTWALL - 1 and currentY == STARTING_Y and currentDirection == DIRECTION.RIGHT then
    memory.writebyte(0x5, DIRECTION.DOWN)
  end
  -- handle very first move in loop
  if currentX == RIGHTWALL - 1 and currentY == 0 and currentDirection == DIRECTION.RIGHT then
    memory.writebyte(0x5, DIRECTION.DOWN)
  end

  -- handle going left and back up
  if currentY == BOTTOMWALL - 1 and currentDirection == DIRECTION.DOWN then
    memory.writebyte(0x5, DIRECTION.LEFT)
  end
  if currentY == BOTTOMWALL and currentDirection == DIRECTION.LEFT then
    if currentX ~= 2 then    -- hopefully saviour if there's a bug, input lag
      memory.writebyte(0x5, DIRECTION.UP)
    end
  end

  -- handle going left and back down
  if currentY == 2 and currentDirection == DIRECTION.UP and currentX ~= 0 then
    memory.writebyte(0x5, DIRECTION.LEFT)
  end
  if currentY == 1 and currentDirection == DIRECTION.LEFT then
    memory.writebyte(0x5, DIRECTION.DOWN)
  end


  -- handle going across the roof
  if currentX == 0 and currentY == 1 and currentDirection == DIRECTION.UP then
    memory.writebyte(0x5, DIRECTION.RIGHT)
  end  

  emu.frameadvance();
end;