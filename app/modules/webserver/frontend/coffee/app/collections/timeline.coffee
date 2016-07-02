class App.Collections.Timeline extends Null.Collections.Base
  comparator: (a, b) =>
    date_a = moment(a.get('created') || a.get('date') )
    date_b = moment(b.get('created') || a.get('date') )
    if date_a.isBefore(date_b)
      return 1
    else if date_a.isAfter(date_b)
      return -1
    else
      return 0
