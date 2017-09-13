import { ApolloClient, createNetworkInterface } from 'react-apollo'

const networkInterface = createNetworkInterface({ uri: '/api' })


function getCookie(name) {
  let value = "; " + document.cookie
  let parts = value.split("; " + name + "=")
  if (parts.length == 2) {
    return parts.pop().split(";").shift()
  }
}

networkInterface.use([{
  applyMiddleware(req, next) {
    if (!req.options.headers) {
      req.options.headers = {};  // Create the header object if needed.
    }
    req.options.headers['authorization'] = getCookie('token') ? "Bearer " + getCookie('token') : null;
    next();
  }
}])

export default new ApolloClient({
  networkInterface,
})
