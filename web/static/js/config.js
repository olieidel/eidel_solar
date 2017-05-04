const url = process.env.NODE_ENV == 'production' ?
            '' :
            'http://127.0.0.1:4000' // dev server
const ws_url = process.env.NODE_ENV == 'production' ?
            '/socket' :
            'ws://127.0.0.1:4000/socket' // dev server

const data_url = '' + url + '/api/data'

export { data_url, ws_url }
