class App.Collections.Progress extends Null.Collections.Base
  url: '/api/v1/progress'
  model: App.Models.Progress

  comparator: (A, B) =>
    dateA = moment(A.get('date')).unix()
    dateB = moment(B.get('date')).unix()
    if dateA > dateB
      return -1
    else if dateA == dateB
      return 0
    else
      return 1

  parse: (response, options) ->
    if response.data
      for progress in response.data
        progress.date = new Date(progress.date)
    return response.data

  getLatestsTwoImages: =>
    got = 0
    images = []
    for model in @models
      if got == 2
        break
      else if model.get('photo') and model.get('photo').path
        images.push(model)
        got += 1
    images

  findProgresForDate: (date) =>
    date = moment(date)
    return @filter (item) =>
      item_date = moment(item.get('date'))
      return date.format('YYYY/MM/DD') == item_date.format('YYYY/MM/DD')
