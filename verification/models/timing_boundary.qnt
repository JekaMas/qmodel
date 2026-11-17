// Two 11-slot jobs plus a correlated two-slot outage: final decision by height 14.
// The exclusive decision deadline therefore needs D>=15 in this configuration.
module sufficient_boundary {import timing(SLACK=15,SLOW=1,FAULT=0).* from "./timing"}
module insufficient_boundary {import timing(SLACK=14,SLOW=1,FAULT=0).* from "./timing"}
