module Performance

Bpm : Type
Bpm = Int

Time : Type
Time = Double

record Click where
  constructor MkClick
  deadline : Time
  increment : Time

startPerformance : Bpm -> Time -> Click
startPerformance bpm time = MkClick time 1000

step : Time -> Click -> Maybe Click
step currentTime click = if currentTime >= click.deadline
  then Just (record {deadline = click.deadline + click.increment} click)
  else Nothing
