// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import React from 'react'
import { ApolloProvider } from 'react-apollo'
import ReactDOM from 'react-dom';
import client from './lib/apollo_client'
import KChart from './components/k_chart'
import StockDetailCN from './components/stock_detail.cn'
import StockDetailHK from './components/stock_detail.hk'
import StockDetailUS from './components/stock_detail.us'
import FutureDetailI from './components/future_detail.i'
import FutureDetailG from './components/future_detail.g'


if (document.getElementById('k-chart')) {
  ReactDOM.render(
    <ApolloProvider client={client}>
      <KChart />
    </ApolloProvider>,
    document.getElementById('k-chart'),
  )
}

if (document.getElementById('stock-detail-cn')) {
  ReactDOM.render(
    <ApolloProvider client={client}>
      <StockDetailCN />
    </ApolloProvider>,
    document.getElementById('stock-detail-cn'),
  )
}

if (document.getElementById('stock-detail-hk')) {
  ReactDOM.render(
    <ApolloProvider client={client}>
      <StockDetailHK />
    </ApolloProvider>,
    document.getElementById('stock-detail-hk'),
  )
}

if (document.getElementById('stock-detail-us')) {
  ReactDOM.render(
    <ApolloProvider client={client}>
      <StockDetailUS />
    </ApolloProvider>,
    document.getElementById('stock-detail-us'),
  )
}

if (document.getElementById('future-detail-i')) {
  ReactDOM.render(
    <ApolloProvider client={client}>
      <FutureDetailI />
    </ApolloProvider>,
    document.getElementById('future-detail-i'),
  )
}

if (document.getElementById('future-detail-g')) {
  ReactDOM.render(
    <ApolloProvider client={client}>
      <FutureDetailG />
    </ApolloProvider>,
    document.getElementById('future-detail-g'),
  )
}