class App.Collections.Checklist extends Null.Collections.Base
  url: '/api/v1/checklist_item'
  model: App.Models.ChecklistItem

  comparator: (a, b) =>
    date_a = moment(a.get('created') || a.get('date') )
    date_b = moment(b.get('created') || a.get('date') )
    if date_a.isBefore(date_b)
      return 1
    else if date_a.isAfter(date_b)
      return -1
    else
      return 0
