import React, {Component} from 'react';
import Autosuggest from 'react-autosuggest';
import _ from 'lodash';
import request from 'request';
import dotenv from 'dotenv';
import $ from 'jquery';

const HOST = process.env.NODE_ENV === 'production' ? "http://www.wheretobuycrypto.io" : "http://localhost:3000"

Number.prototype.formatMoney = function(c, d, t){
  var n = this,
  c = isNaN(c = Math.abs(c)) ? 2 : c,
  d = d == undefined ? "." : d,
  t = t == undefined ? "," : t,
  s = n < 0 ? "-" : "",
  i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
  j = (j = i.length) > 3 ? j % 3 : 0;
  return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
 };

const getSuggestions = (data, value) => {
  const inputValue = value.trim().toLowerCase();
  const inputLength = inputValue.length;

  return inputLength === 0 ? [] : data.filter(coin =>
    (coin.name.toLowerCase().slice(0, inputLength) === inputValue) ||
    (coin.symbol.toLowerCase().slice(0, inputLength) === inputValue)
  );
};

const getSuggestionValue = suggestion => suggestion.symbol;

const renderSuggestion = suggestion => (
  <div>
    {suggestion.name} ({suggestion.symbol})
  </div>
);

const getCoin = (data, symbol) => {
  return data.filter(coin =>
    (coin.symbol === symbol)
  );
};

class TopCoinsTable extends Component {

  onClickCoin = (code) => {
    this.props.onClickCoin(code);
  }

  render () {
    const coins = topCoins.map((coin, key) => {
      return (
        <tr key={key}>
          <td onClick={this.onClickCoin.bind(this, coin.code)}>{coin.name}</td>
          <td>{coin.code}</td>
        </tr>
      )
    });
    return (
      <table>
        <thead>
          <tr>
            <th colSpan="999">Top Coins</th>
          </tr>
        </thead>
        <tbody>
          {coins}
        </tbody>
      </table>
    );
  }
}

class TopMarketsTable extends Component {

  render () {
    const markets = topMarkets.map((market, key) => {
      return (
        <tr key={key} href="#">
          <td>{market.name}</td>
          <td>{market.cap}</td>
        </tr>
      )
    });
    return (
      <table>
        <thead>
          <tr>
            <th colSpan="999">Top Markets</th>
          </tr>
        </thead>
        <tbody>
          {markets}
        </tbody>
      </table>
    );
  }
}

const Card = ({ coin }) => {
  const exchanges = coin.exchanges.map((market, key) => {
    let currencies = market.markets.map((exchange, key) => {
      let separator = key < (market.markets.length-1) ? ', ' : '';
      return (
        <span key={key}>{coin.symbol}/{exchange}{separator}</span>
      );
    });

    let volume = market.volume.formatMoney(2);
    return (
      <div className="card" key={key}>
        <div className="row d-flex align-items-center">
          <div className="col-md-3">
            <h3>{market.name}</h3>
          </div>
          <div className="col-md-3">
            <div className="card-info"><span className="money">${volume}</span><br></br>(last 24h)</div>
          </div>
          <div className="col-md-3">
            <div className="card-info">{currencies}</div>
          </div>
          <div className="col-md-3 text-right">
            <a className="btn" href={market.url}>buy {coin.name}</a>
          </div>
        </div>
      </div>
    );
  });

  return (
    <div>{exchanges}</div>
  );
}

const CardList = ({ items }) => (
  <div className="cardList">
    { items.map((item, key) => <Card key={key} coin={item} />) }
  </div>
)

class Inputer extends React.Component {
  constructor() {
    super();

    this.state = {
      value: '',
      suggestions: [],
      touched: false,
    };
  }

  onChange = (event, { newValue }) => {
    this.setState({
      value: newValue,
      touched: true,
    });
  };

  onSuggestionsFetchRequested = ({ value }) => {
    this.setState({
      suggestions: getSuggestions(this.props.coins, value)
    });
  };

  onSuggestionsClearRequested = () => {
    this.setState({
      suggestions: []
    });
  };

  onSelectOption = (e, item) => {
    this.props.selectOption(item.suggestion.key);
  };

  render() {
    const { value, suggestions, touched } = this.state;
    const { selectedCoin } = this.props;
    let inputValue = value;

    if (selectedCoin) {
      inputValue = touched ? value : selectedCoin.symbol;
    }

    const inputProps = {
      placeholder: '',
      value: inputValue,
      onChange: this.onChange,
    };

    return (
      <Autosuggest
        suggestions={suggestions}
        onSuggestionsFetchRequested={this.onSuggestionsFetchRequested}
        onSuggestionsClearRequested={this.onSuggestionsClearRequested}
        getSuggestionValue={getSuggestionValue}
        renderSuggestion={renderSuggestion}
        inputProps={inputProps}
        onSuggestionSelected={this.onSelectOption}
      />
    );
  }
}

class App extends Component {
  constructor (props) {
    super(props)
    this.state = {
      coin: props.coin,
      allCoins: [],
    }
    this.selectCoin = this.selectCoin.bind(this)
  }

  componentDidMount() {
    this.loadJSON(function(response) {
      // Parse JSON string into object
      const data = JSON.parse(response);
      console.log("data loaded");
      this.setState({ allCoins: data });
    }.bind(this));
  }

  loadJSON = (callback) => {
      var xobj = new XMLHttpRequest();
          xobj.overrideMimeType("application/json");
      xobj.open('GET', '/coins.json', true); // Replace 'my_data' with the path to your file
      xobj.onreadystatechange = function () {
            if (xobj.readyState == 4 && xobj.status == "200") {
              // Required use of an anonymous callback as .open will NOT return a value but simply returns undefined in asynchronous mode
              callback(xobj.responseText);
            }
      };
      xobj.send(null);
   }

  selectCoin (key) {
    // query api and get coin based on key
    request
      .get(`${HOST}/coins/${key}.json`, (err, response, body) => {
        if (response.statusCode === 200) {
          const coin = JSON.parse(body);
          history.pushState(null, null, `/coins/${key}`);
          this.setState({ coin });
          $('.top-lists').remove();
        }
      });
  }

  render () {
    const { coin } = this.state;

    const topTables = (
      <div className="row">
        <div className="col-md-6">
          <TopCoinsTable onClickCoin={this.selectCoin} />
        </div>
        <div className="col-md-6">
          <TopMarketsTable />
        </div>
    </div>
    );

    return (
      <div className={`finder ${coin ? 'filled' : ''}`}>
        <div className="d-sm-flex justify-content-center input-area">
          <h1>Where to buy </h1>
          <Inputer className="search-input" coins={this.state.allCoins} selectOption={this.selectCoin} selectedCoin={coin} />
        </div>
        {
          coin &&
            <div>
              <p className='coin-description'>{`You can buy ${coin.name} in ${coin.exchanges.length} exchanges.`}</p>
              <CardList items={[coin]} />
            </div>
        }
      </div>
    )
  }
}

export default App;
