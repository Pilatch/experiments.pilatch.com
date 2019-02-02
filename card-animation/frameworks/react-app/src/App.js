import React, { Component } from 'react';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <pilatch-card suit="rock" rank="1" up></pilatch-card>
        <pilatch-card suit="rock" rank="2" up></pilatch-card>
        <pilatch-card suit="rock" rank="3" up></pilatch-card>
        <pilatch-card suit="rock" rank="4" up></pilatch-card>
        <pilatch-card suit="rock" rank="5" up></pilatch-card>
      </div>
    );
  }
}

export default App;
