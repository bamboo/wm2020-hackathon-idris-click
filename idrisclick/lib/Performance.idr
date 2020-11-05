module Performance

public export
Bpm : Type
Bpm = Int

public export
Time : Type
Time = Int

public export
record Click where
  constructor MkClick
  deadline : Time
  increment : Time

export
startPerformance : Bpm -> Time -> Click
startPerformance bpm time = MkClick (time + 150) (cast (60.0 * 1000 / cast bpm))

export
step : Time -> Click -> Maybe Click
step currentTime click = if currentTime >= click.deadline
  then Just (record {deadline = click.deadline + click.increment} click)
  else Nothing
