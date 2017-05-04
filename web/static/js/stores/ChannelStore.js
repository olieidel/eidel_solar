import { observable, action } from 'mobx'
import { ws_url } from '../config'
import { Socket } from 'phoenix'

class ChannelStore {
  socket;
  metersChannel;
  metersStore;

  connect = () => {
    this.socket = new Socket(ws_url, {})
    this.socket.connect()
    this.metersChannel = this.socket.channel('meters:main', {})
    this.metersChannel.join()
    this.metersChannel.on('new_data', this.handleNewMeterData)
  }

  handleNewMeterData = (data) => {
    this.metersStore.update(data)
  }

  @action setMetersStore = (metersStore) => {
    this.metersStore = metersStore
  }
}

const channelStore = new ChannelStore()
export { channelStore }
