// Event types enum
enum EventTypeEnum { EXHIBITION, CONCERT, OPENING, UNDEFINED }

/// Returns the enum value given a string
EventTypeEnum getEventTypeEnum(String eventType) {
  for (EventTypeEnum current in EventTypeEnum.values) {
    if (eventType == getEventTypeText(current)) {
      return current;
    }
  }
  return EventTypeEnum.UNDEFINED;
}

/// Returns the String value of an EventTypeEnum object
String getEventTypeText(EventTypeEnum eventType) {
  switch (eventType) {
    case EventTypeEnum.EXHIBITION:
      return "exhibition";
    case EventTypeEnum.CONCERT:
      return "concert";
    case EventTypeEnum.OPENING:
      return "opening";
    case EventTypeEnum.UNDEFINED:
      return "undefined";
  }
}
