// react & redux
import React, { Component, Fragment } from 'react';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import { connect } from 'react-redux';

// components
import BottomNavigation from './bottom-navigation';
import Map from './map';
import Point from './point';
import Puzzle from './puzzle';
import Upload from './upload';
import PostInfo from './post-info';
import AlertModal from 'react-modal';

// css
import '../scss/style.scss';

AlertModal.setAppElement('#app');
AlertModal.defaultStyles.content = {};
AlertModal.defaultStyles.overlay.backgroundColor = '';
class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      alertModal: {
        isOpen: false,
        somethingWrong: false,
        header: '',
        body: '',
        onPositive: false,
        onNegative: false
      }
    }
    this.openAlertModal = this.openAlertModal.bind(this);
    this.closeAlertModal = this.closeAlertModal.bind(this);
    this.renderAlertModal = this.renderAlertModal.bind(this);
  }

  openAlertModal(somethingWrong=false, header=false, body=false, onPositive=false, onNegative=false) {
    const alertModalState = {
      isOpen: true,
      somethingWrong,
      header,
      body,
      onPositive,
      onNegative
    };
    this.setState({alertModal: alertModalState});
  }

  closeAlertModal() {
    const alertModalState = {...this.state.alertModal};
    alertModalState.isOpen = false;
    this.setState({alertModal: alertModalState});
  }

  renderAlertModal() {
    let header = '';
    if ( this.state.alertModal.header ) {
      const className = this.state.alertModal.somethingWrong ? 'alertModal__header alertModal__header--error' : 'alertModal__header';
      header = <h3 className={className}>{this.state.alertModal.header}</h3>;
    }
    const body = this.state.alertModal.body ? <p>{this.state.alertModal.body}</p> : '';
    const positiveBtn = this.state.alertModal.onPositive ? <button className="alertModal__positiveBtn" onClick={this.state.alertModal.onPositive}>확인</button> : '';
    const negativeBtn = this.state.alertModal.onNegative ? <button className="alertModal__negativeBtn" onClick={this.state.alertModal.onNegative}>취소</button> : '';

    return (
      <AlertModal
        isOpen={this.state.alertModal.isOpen}>
        <div className="alertModal">
          {header}
          {body}
          <div className="alertModal__btnContainer">
            {positiveBtn}
            {negativeBtn}
          </div>
        </div>
      </AlertModal>
    );
  }

  render() {
    return (
      <BrowserRouter>
        <div className="container">
          <div className="l-top">
            <Switch>
              <Route exact path={"/user"} component={Map} />
              <Route path={"/user/page/map"} component={Map} />
              <Route path="/user/page/point" render={(props) => <Point {...props} openAlertModal={this.openAlertModal} closeAlertModal={this.closeAlertModal} chartData={[]}></Point>} />
              <Route path="/user/page/puzzle" render={(props) => <Puzzle {...props} openAlertModal={this.openAlertModal} closeAlertModal={this.closeAlertModal}></Puzzle>} />
              <Route path="/user/page/upload" render={(props) => <Upload {...props} openAlertModal={this.openAlertModal} closeAlertModal={this.closeAlertModal}></Upload>} />
              <Route path="/user/page/post-info" component={PostInfo} />
            </Switch>
          </div>
          <div className="l-bottom">
            <BottomNavigation 
              puzzleBoxCount={this.props.puzzleBoxCount}
              showPointNav={this.props.showPointNav}
              showPuzzleNav={this.props.showPuzzleNav}
            ></BottomNavigation>
          </div>
          {this.renderAlertModal()}
        </div>
      </BrowserRouter>
    );
  }

}

function mapStateToProps(state, ownProps) {
  console.log( 'state : ', state );
  return {
    puzzleBoxCount: state.puzzleBoxCount,
    showPointNav: state.showPointNav,
    showPuzzleNav: state.showPuzzleNav
  };
}

export default connect(mapStateToProps, null)(App);