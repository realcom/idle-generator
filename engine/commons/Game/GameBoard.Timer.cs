using System;
using Commons.Game.Events;
using Commons.Types;

namespace Commons.Game
{
    public partial class GameBoard
    {
        public uint TimerRemainingTicks
        {
            get
            {
                var endTick = timerEndTick_;
                if (timerPauseTick_ > 0)
                    endTick += tick_ - timerPauseTick_;
                return endTick > tick_ ? endTick - tick_ : 0u;
            }
        }
        public FixedFloat TimerRemaining => TicksToTime(TimerRemainingTicks);
        public FixedFloat TimerDuration => TicksToTime(timerEndTick_ - timerStartTick_);
        
        public void StartTimer(FixedFloat duration)
        {
            ResumeTimer();
            if (duration <= FixedFloat.Zero)
                return;
            timerStartTick_ = tick_;
            timerEndTick_ = tick_ + TimeToTicksDuration(duration);
            
            QueueEvent(new TimerUpdatedEvent
            {
                StartTimer = true,
                StartTimerDuration = (float)duration,
            });
        }
        
        public void AddTimer(FixedFloat duration)
        {
            if (duration <= FixedFloat.Zero)
                return;
            timerEndTick_ += TimeToTicksDuration(duration);
            
            QueueEvent(new TimerUpdatedEvent
            {
                AddTimer = true,
                AddTimerDuration = (float)duration,
            });
        }
        
        public void PauseTimer()
        {
            if (timerPauseTick_ > 0u)
                return;
            timerPauseTick_ = tick_;
            
            QueueEvent(new TimerUpdatedEvent
            {
                PauseTimer = true,
            });
        }
        
        public void ResumeTimer()
        {
            if (timerPauseTick_ == 0u)
                return;
            timerStartTick_ += tick_ - timerPauseTick_;
            timerEndTick_ += tick_ - timerPauseTick_;
            timerPauseTick_ = 0u;
            
            QueueEvent(new TimerUpdatedEvent
            {
                ResumeTimer = true,
            });
        }
        
        public void StopTimer()
        {
            timerPauseTick_ = 0u;
            timerEndTick_ = 0u;
            
            QueueEvent(new TimerUpdatedEvent
            {
                StopTimer = true,
            });
        }
    }
}
