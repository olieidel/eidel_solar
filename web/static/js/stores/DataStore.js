import { observable, action, reaction, computed } from 'mobx'
import { TimeSeries, Event, TimeRange, sum } from 'pondjs'
import { data_url } from '../config'


class DataStore {
  @observable loading
  @observable dataSeries
  @observable events
  @observable timer
  @observable displayTimeRange

  constructor() {
    const nowplus = (days) => {
      let result = new Date(Date.now())
      result.setDate(result.getDate() + days)
      return result;
    }

    this.loading = true
    this.dataSeries = new TimeSeries({
      name: 'solar_timeseries',
      columns: ['time', 'ac1_p', 'ac2_p', 'ac3_p', 'ac_all_p'],
      points: [
        [nowplus(0), 0, 0, 0, 0],
        [nowplus(1), 0, 0, 0, 0]
        /* [nowplus(200), 4, 4, 4, 4]*/
      ]
    })
    this.displayTimeRange = this.dataSeries.timerange()
    this.dataEvents = []
    this.events = []
    this.timer = null
    this.fetchData()
  }

  @action setLoading = (value) => this.loading = value

  @action fetchData = () => {
    fetch(data_url)
      .then((response) => {
        if (response.status !== 200) {
          throw new Error("Bad response from server")
        }

        return response.json()
      })
      .then((data) => {
        this.setLoading(false)
        data.data.forEach((item) => this.addDataEvent(item))
        this.createDataSeries()
        this.setDisplayTimeRangeToSeries()
      })
      .catch((error) => {
        throw new Error(error)
      })
  }

  addDataEvent = (row) => {
    const time = new Date(row.time)
    row.ac_all_p = row.ac1_p + row.ac2_p + row.ac3_p
    const event = new Event(time, row)
    this.dataEvents.unshift(event)
  }

  createDataSeries = () => {
    const timeseries = new TimeSeries({
      name: 'EidelSolar Data',
      events: this.dataEvents,
    })
    this.setDataSeries(timeseries)
  }

  setDisplayTimeRangeToSeries = () => {
    this.setDisplayTimeRange(this.dataSeries.timerange())
  }

  @action setDataSeries = (timeseries) => {
    this.dataSeries = timeseries
  }

  @action setTimer = (time) => {
    this.timer = time
  }

  @action setDisplayTimeRange = (timerange) => {
    this.displayTimeRange = timerange
  }

  @computed get powerNow() {
    const last = this.dataSeries.atLast()
    return last.data().get('ac_all_p')
  }

  @computed get powerMax() {
    return this.dataSeries.max('ac_all_p')
  }

  @computed get energyYesterday() {
    const yesterday = this.dataSeries.crop(TimeRange.lastDay())
    const energy = this.convertTokWh(yesterday.sum('ac_all_p'))
    return isNaN(energy) ? 0 : energy
  }

  convertTokWh = (n) => (n * 0.25 / 1000)

  @computed get energyDailyMax() {
    const dailyMax = this.convertTokWh(
      this.dataSeries.fixedWindowRollup({
        windowSize: '1d',
        aggregation: {ac_all_p_sum: {ac_all_p: sum()}}
      })
          .max('ac_all_p_sum')
    )

    return isNaN(dailyMax) ? 0 : dailyMax
  }

  @computed get energyWeek() {
    const week = this.dataSeries.crop(TimeRange.lastSevenDays())
    const energy = this.convertTokWh(week.sum('ac_all_p'))
    return isNaN(energy) ? 0 : energy
  }

  @computed get energyWeeklyMax() {
    const weeklyMax = this.convertTokWh(
      this.dataSeries.fixedWindowRollup({
        windowSize: '7d',
        aggregation: {ac_all_p_sum: {ac_all_p: sum()}}
      })
          .max('ac_all_p_sum')
    )

    return isNaN(weeklyMax) ? 0 : weeklyMax
  }

  @computed get lastUpdate() {
    return this.dataSeries.atLast().timestamp()
  }
}

const dataStore = new DataStore()
export { dataStore }
