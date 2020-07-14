# NetTime

NetTime is a small collection of data types that represent date and time:

- **LocalTime**: A time of day without relationship to date or timezone.
- **LocalDate**: A date that represent an entire day in any timezone or calendar.
- **LocalDateTime**: A time and date independent of timezones and calendars.
- **TimeOffset**: Amount of hours and minutes difference from a timezone.
- **DateTime**: A moment in time, expressed in relationship to UTC in Gregorian
  calendar, in the current era, between 0000AD and 9999AD.

Each type is capable of serializing and deserializing from strings format
specified in [RFC 3339][].

```swift
let date = DateTime(staticRFC3339String: "1979-05-27T00:32:00.999999-07:00")
// Original representation is preserved. For example:
date.time.secondFraction // [9, 9, 9, 9, 9, 9]
// Serialize back to RFC 3339 timestamp.
date.description // 1979-05-27T00:32:00.999999-07:00

// Use it with Foundation:
Foundation.Date(timeIntervalSinceReferenceDate: date.timeIntervalSince2001)
Foundation.TimeZone(secondsFromGMT: date.utcOffset.asSeconds)
```

## Why?

But why not just ues `Foundation.Date`, you ask?

Turns out, time is hard to represent if you account for different calendars
and timezones. But sometimes it's legitimate to ignore this problem. That's why
[RFC 3339][] exists: "to improve consistency and interoperability when
representing and using date and time in Internet protocols." Suffice to say,
_consistency and interoperability_ [goes beyond internet protocols][TOML Date].

Further, converting a timestamp to a in-memory object such as `TimeInterval` or
a `Foundation.Date` a destructive operation: the original time representation is
lost. Want to know what timezone offset was used? what the intended precesion
for the fraction of seconds was? Tough luck. NetTime preserves all information
in an RFC 3339-compliant timestamp.

## Installation

#### With [CocoaPods](http://cocoapods.org/)

```ruby
use_frameworks!

pod "NetTime"
```

#### With [SwiftPM](https://swift.org/package-manager)

```
.package(url: "http://github.com/dduan/NetTime", from: "0.2.3")
```

## Caution

**Do not use** NetTime's data types as direct source for time displayed to end
users. Use something like `Foundation.DateFormatter` and follow best practices.
Never assume you know enough about timezones and/or calendars to format date
string!

[RFC 3339]: https://tools.ietf.org/html/rfc3339
[TOML Date]: https://toml.io/en/v1.0.0-rc.1#offset-date-time

## License

MIT. See `LICENSE.md`.
