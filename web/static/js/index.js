import React from 'react'
import { render } from 'react-dom'
import { AppContainer } from 'react-hot-loader'
import { useStrict } from 'mobx'
import { Provider } from 'mobx-react'

import App from './components/App'
import { dataStore } from './stores/DataStore'
import { metersStore } from './stores/MetersStore'
import { channelStore } from './stores/ChannelStore'

// MobX strict mode
useStrict(true)

const stores = { dataStore, metersStore, channelStore }
channelStore.setMetersStore(metersStore)
channelStore.connect()


render(<AppContainer>
  <Provider {...stores}>
  <App/>
  </Provider>
  </AppContainer>, document.querySelector("#app"))

if (module && module.hot) {
  module.hot.accept('./components/App.js', () => {
    const App = require('./components/App.js').default

    render(
      <AppContainer>
      <Provider {...stores}>
      <App/>
      </Provider>
      </AppContainer>,
      document.querySelector("#app")
    )
  })
}
