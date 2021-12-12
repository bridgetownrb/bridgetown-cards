---
title: Generate Repeating Events
description: Thanks to a nifty little gem called IceCube, we can determine recurring schedules for events and generate repeating content.
twitter: jaredcwhite
github: jaredcwhite
version: 1.0
tags:
- resources
- dates
---

If you wish to feature a calendar or events schedule of some kind on your site, the most obvious solution would be to create an `events` collection and store your content there. Each event could have a title, date, perhaps location, and other information.

But what if you need to create a recurring event? What if you want to specify that an event happens once a week, or once a month on the "nth day" (aka the 2nd Saturday of the month), and show those in the events list on the correct upcoming days?

You need a way of (a) determining what those upcoming dates are, and (b) duplicating the event resource with each new date.

Fortunately, there is a solution to both problems. We'll use the [IceCube gem](http://seejohncode.com/ice_cube/) to calculate the recurrence rules, and we'll utilize the benefits of Bridgetown's resource content engine to "emit" new event resources from updated model data.

First, the solution in its entirety, then we'll break down how it works. The only prerequisite is first to run `bundle add ice_cube` to add IceCub to your `Gemfile`, and to create an `events` collection with events which have `repeats: monthly`/`yearly` in the front matter.

```ruby
# plugins/builders/events_recurrence.rb

require "ice_cube"

class Builders::EventsRecurrence < SiteBuilder
  def build
    hook :site, :post_read, :emit_repeating_events
  end

  def emit_repeating_events(*)
    site.collections.events.resources.each do |event_resource|
      next if event_resource.data.recurrence || event_resource.data.repeats.nil?

      event = event_resource.model
      schedule = IceCube::Schedule.new(event.date)

      case event.repeats
      when "weekly"
        schedule.add_recurrence_rule IceCube::Rule.weekly.day(event.date.wday)

        with_event_adjustments event do
          schedule.occurrences(Date.today + 56).each do |future_date|
            emit_event event, future_date unless future_date == event_resource.date
          end
        end
      when "monthly"
        day_of_the_week = event.date.strftime("%A").downcase.to_sym
        week_of_the_month = (event.date.day - 1) / 7 + 1
        schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week({ day_of_the_week => [week_of_the_month] })

        with_event_adjustments event do
          schedule.occurrences(Date.today + 62).each do |future_date|
            emit_event event, future_date unless future_date == event_resource.date
          end
        end
      end
    end

    site.collections.events.sort_resources!
  end

  def with_event_adjustments(event)
    original_date = event.date
    yield
    event.date = original_date
    event.recurrence = false
  end

  def emit_event(event, future_date)
    event.date = future_date
    event.recurrence = true
    event.as_resource_in_collection
  end
end
```

So to start, this builder plugin adds a hook so when the site's normal `read` process concludes, it will run the additional code in the `emit_repeating_events` method.

Inside that method, we begin looping through all the resources in the events collection. We'll skip ahead if the event is itself a recurrence, or if there's no repeat specified.

Next, we obtain the model attached to the resource, and instantiate a new IceCube schedule using the event date as a starting point.

Then we run some code depending on if the event repeats weekly or monthly. For **weekly**, we use the following IceCub DSL:

```ruby
schedule.add_recurrence_rule IceCube::Rule.weekly.day(event.date.wday)
```

This means that every week on that particular day of the week (0 = Sunday, 6 = Saturday), there will be a recurrence. We then use the `occurrences` method of the IceCube schedule to loop through recurrences up to 8 weeks from now (56  / 7 = 8) and emit new events accordingly.  I'll explain what `with_event_adjustments` and `emit_event` are doing in just a moment.

For **monthly** events, we don't simply want "repeat every month" because that's rarely how people actually schedule monthly events in real life. It's typically on the "nth day of the month". For example, if an event in on December 12, 2021 and repeats monthly, we probably want "the second Sunday of each month" rather than January 12 (Wednesday), February 12 (Saturday), etc.

Thus we need to obtain two critical pieces of information: which _day name_ of the week the date is on, and which _week number_ of the month the date occurs in. We get the first variable by calling `strftime("%A")`, and because IceCube expects lowercased symbols rather than uppercase strings, we call `downcase.to_sym` so `"Sunday"` becomes `:sunday`, `"Monday"` becomes `:monday`, etc.

Next we get "which week of the month" via a simple bit of math: `(event.date.day - 1) / 7 + 1`. This will give us `1` for Tuesday the 4th, or `2` for Friday the 11th, etc.

Now we can pass those variables along to IceCube. Putting it all together, it looks like this:

```ruby
day_of_the_week = event.date.strftime("%A").downcase.to_sym
week_of_the_month = (event.date.day - 1) / 7 + 1
schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week({ day_of_the_week => [week_of_the_month] })
```

We then loop through recurrences for roughly the next couple of months (31 * 2 = 62) and emit the new events.

So what's with `with_event_adjustments` and `emit_event`? In the case of the former, it allows the "source" event's date & recurrence fields to be mutated inside of a block (executed via `yield`) and they will be reset after the block executes. For each recurrence, `emit_event` will update the event model's fields prior to a new resource being generated and added to the events collection via `as_resource_in_collection`.

Thus at the end of this whole process, the events collection will go from a simple one-to-one mapping of event models to event resources to a more complex one-to-many mapping where each event model serves as the source of multiple recurring event resources. For any of those resource objects, calling `event.model` will provide you with the original data.

Final points to ponder: what if you need to skip one of the recurrences (say, the event got canceled on one particular day)? Or what if one of the recurrences needs another specific content update? An exercise left for the reader! 😄