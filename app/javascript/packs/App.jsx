import React, {Component} from 'react';
import Autosuggest from 'react-autosuggest';
import _ from 'lodash';

import data from './data'
import topCoins from './top-coins'
import topMarkets from './top-markets'

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

class Card extends Component {

  render () {
    const item = this.props.item;
    let exchanges = item.exchanges.map((market, key) => {
      let currencies = market.markets.map((exchange, key) => {
        let separator = key < (market.markets.length-1) ? ', ' : '';
        return (
          <span key={key}>{item.symbol}/{exchange}{separator}</span>
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
              <a className="btn" href={market.url}>buy {item.name}</a>
            </div>
          </div>
        </div>
      );
    });

    return (
      <div>{exchanges}</div>
    );
  }
}

class CardList extends Component {

  render () {
    const table = this.props.items.map((item, key) => {

      return (
        <Card key={key} item={item} />
      )
    })

    return (
      <div className="cardList">{table}</div>
    );
  }
}

class Inputer extends React.Component {
  constructor() {
    super();

    this.state = {
      value: '',
      suggestions: []
    };
  }

  onChange = (event, { newValue }) => {
    this.setState({
      value: newValue
    });
    this.props.onChange(newValue);
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
    this.props.selectOption(item.suggestion.symbol);
  };

  render() {
    const { value, suggestions } = this.state;

    const inputProps = {
      placeholder: '',
      value,
      onChange: this.onChange
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
      searchTerm: '',
      data: ''
    }
    this.searchUpdated = this.searchUpdated.bind(this)
  }

  componentDidMount() {
    this.loadJSON(function(response) {
    // Parse JSON string into object
      var data = JSON.parse(response);
      this.setState((prevState, props) => ({
        searchTerm: prevState.searchTerm,
        data: data
      }))
   }.bind(this));
  }

  loadJSON = (callback) => {
      var xobj = new XMLHttpRequest();
          xobj.overrideMimeType("application/json");
      xobj.open('GET', 'src/coins.json', true); // Replace 'my_data' with the path to your file
      xobj.onreadystatechange = function () {
            if (xobj.readyState == 4 && xobj.status == "200") {
              // Required use of an anonymous callback as .open will NOT return a value but simply returns undefined in asynchronous mode
              callback(xobj.responseText);
            }
      };
      xobj.send(null);
   }

  searchUpdated (term) {
    this.setState({searchTerm: term})
  }

  render () {
    const filteredMarkets = this.state.searchTerm.length > 1
      ? getCoin(this.state.data, this.state.searchTerm)
      : [];

    const cardList = <CardList items={filteredMarkets} />

    const topTables = (
      <div className="row">
        <div className="col-md-6">
          <TopCoinsTable onClickCoin={this.searchUpdated} />
        </div>
        <div className="col-md-6">
          <TopMarketsTable />
        </div>
    </div>
    );

    const content = filteredMarkets.length > 0
      ? cardList
      : '';

    const filledClass = filteredMarkets.length > 0 ? 'filled' : '';
    const classes = `finder ${filledClass}`;

    return (
      <div className={classes}>
        <div className="d-sm-flex justify-content-center input-area">
          <h1>Where to buy </h1>
          <Inputer className="search-input" coins={this.state.data} selectOption={this.searchUpdated} onChange={this.searchUpdated}/>
        </div>
        {content}
      </div>
    )
  }
}

export default App;
