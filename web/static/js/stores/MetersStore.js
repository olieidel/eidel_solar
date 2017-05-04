import { observable, action } from 'mobx'


class MetersStore {
  @observable loading = true
  @observable power_now = 0
  @observable energy_total = 0
  @observable energy_today = 0
  @observable dc1_u = 0
  @observable dc1_i = 0
  @observable dc2_u = 0
  @observable dc2_i = 0
  @observable ac1_u = 0
  @observable ac1_p = 0
  @observable ac2_u = 0
  @observable ac2_p = 0
  @observable ac3_u = 0
  @observable ac3_p = 0

  @action update = (data) => {
    this.loading = false
    this.power_now = data.power_now
    this.energy_total = data.energy_total
    this.energy_today = data.energy_today
    this.dc1_u = data.dc1_u || 0
    this.dc1_i = data.dc1_i || 0
    this.dc2_u = data.dc2_u || 0
    this.dc2_i = data.dc2_i || 0
    this.ac1_u = data.ac1_u || 0
    this.ac1_p = data.ac1_p || 0
    this.ac2_u = data.ac2_u || 0
    this.ac2_p = data.ac2_p || 0
    this.ac3_u = data.ac3_u || 0
    this.ac3_p = data.ac3_p || 0
  }
}

const metersStore = new MetersStore()
export { metersStore }
