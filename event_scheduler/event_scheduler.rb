class Schedule
  def initialize(file=nil)
    @file ||= (file || File.readlines("event_scheduler.txt").map(&:strip).reject(&:empty?))
  end

  def load_unassigned_events
    @unassigned_events = @file.map { |event_line| Event.new(event_line) }
  end

  def build
    return @schedule if defined?(@schedule) && @schedule
    @schedule = []

    loop.with_index do |_,idx|
      @schedule << {
        title: "Track #{idx+1}",
        schedule: build_track(@unassigned_events)
      }
      break unless @unassigned_events.any?
    end
    @schedule
  end

  def build_track(events)
    [
      allocate_event([], (3 * 60), @unassigned_events),
      Event.new("Lunchtime 60min"),
      allocate_event([], (4 * 60), @unassigned_events),
      Event.new("Networking Event 300min")
    ].flatten
  end

  def allocate_event(events=[], time_unallocated=180, remaining_events=[])
    events << remaining_events.pop { |ev| ev.duration <= time_unallocated }
    time_unallocated = time_unallocated - events.last.duration

    more_allocations_possible = 
      time_unallocated > 0 &&
      remaining_events.any? { |ev| ev.duration <= time_unallocated }

    if more_allocations_possible
      allocate_event(events, time_unallocated, remaining_events)
    end
    events
  end

  class Event
    attr_accessor :name, :duration, :event_type

    SESSION_EVENT_TYPES = {
      60  =>  "Session",
      5   =>  "Lightning Talk"
    }.freeze

    STATIC_EVENT_TYPES = {
      60  => "Lunchtime",
      300 => "Networking Event"
    }.freeze

    EVENT_TYPES = (
      SESSION_EVENT_TYPES.merge( STATIC_EVENT_TYPES )
    ).freeze

    def initialize(schedule_line="")
      event = schedule_line.match(/(?<name>[^0-9]*)(?<duration>lightning|[0-9]+)/)
      @name, @duration = event[:name].strip, event[:duration]
      if @duration.match(/lightning/i)
        @event_type = "Lightning Talk"
        @duration = 5
      else
        @duration = @duration.to_i
        @event_type = "Session"
      end
      @event_type = @name if STATIC_EVENT_TYPES.values.include?(@name)
    end
  end
end
