class App.Collections.Metrics extends Null.Collections.Base
  url: '/api/v1/metrics'
  model: App.Models.Metric

  round: (values) =>
    value_map = _.map values, (num) =>
      return Math.round(num * 100) / 100
    return value_map

  getUnit: (key, values) =>
    value_map = _.map values, (num) =>
      return num unless Config.units.progress[key]
      return parseInt Helpers.getValuesPerMeassurement(num, Config.units.progress[key], app.me.get("widgets").meassure)

    return value_map


  getWeekData: (key, date) =>
    values = (0 for day in [0..6])
    start = moment(date).day(0)
    end = moment(date).day(6)
    is_same_month = start.isSame(end, 'month')
    if is_same_month
      week_days = [start.date()..end.date()]
    else
      start_end = moment(date).day(0).endOf('month')
      end_start = moment(date).day(6).startOf('month')
      start_week_days = [start.date()..start_end.date()]
      end_week_days = [end_start.date()..end.date()]

    metrics_start_date = moment(moment(start).format('YYYY/MM'), 'YYYY/MM')
    metrics_end_date = moment(moment(end).format('YYYY/MM'), 'YYYY/MM')
    @each (item) =>
      item_date = moment("#{item.get('year')}/#{item.get('month')}", 'YYYY/MM')
      if is_same_month
        if item.get('year') == start.year() and item.get('month') == parseInt(start.format('MM'))
          start_date = start.date()
          end_date = end.date()
          _.each week_days, (w_day, index) =>
            if item.get('days')[w_day]?[key]?
              values[index] = item.get('days')[w_day][key]
      else
        if item.get('year') == start.year() and item.get('month') == parseInt(start.format('MM'))
          _.each start_week_days, (w_day, index) =>
            if item.get('days')[w_day]?[key]?
              values[index] = item.get('days')[w_day][key]

        else if item.get('year') == end.year() and item.get('month') == parseInt(end.format('MM'))
          _.each end_week_days, (w_day, index) =>
            if item.get('days')[w_day]?[key]?
              values[index] = item.get('days')[w_day][key]

    rounded = @round(values)


    return @getUnit(key, rounded)

  getMonthData: (key, date) =>
    values = []
    weeks = []

    date = moment(date).date(1)
    month = date.month()
    week = date.week()
    while date.month() == month
      weeks.push @getWeekData(key, date)
      date.add(1, 'week')
      week = date.week()
      values.push 0

    for value, index in weeks
      values[index] = _.reduce(value, (memo, num) =>
        return memo + num
      , 0)/value.length

    return @round(values)

  getYearData: (key, date) =>
    values = []
    months = []

    date = moment(date).month(0).date(1)
    year = date.year()
    month = date.month()

    while date.year() == year
      months.push @getMonthData(key, date)
      date.add(1, 'month')
      month = date.month()
      values.push 0

    for value, index in months
      values[index] = _.reduce(value, (memo, num) =>
        return memo + num
      , 0)/value.length

    return @round(values)
