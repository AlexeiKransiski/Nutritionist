class App.Models.FoodLogStat extends Null.Models.Base
  urlRoot: '/api/v1/food_log_stats'
  defaults:
    date: moment(),
    breakfast:  0,
    early_snack: 0,
    lunch: 0,
    afternoon_snack: 0,
    dinner:  0,
    late_snack: 0
